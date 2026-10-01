"""Compile the real grace timer and check countdown/pause transitions."""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile

from test_gear_generation import extract


PREFIX = r'''
#include <chrono>
#include <cstdint>
#include <iostream>
#include <stdexcept>
using uint8 = uint8_t; using uint32 = uint32_t; using uint64 = uint64_t;
using Clock = std::chrono::steady_clock;
struct EquipmentItemLevelTarget {};
constexpr uint8 INVALID_SPEC_TAB = 255;
using BotRoles = int;
constexpr BotRoles BOT_ROLE_DPS = 0;
uint32 allowance = 600;
uint32 GraceSeconds() { return allowance; }
Clock::time_point RestoreDeadline(uint64 value) {
    return Clock::time_point(std::chrono::seconds(value));
}
void check(bool ok, char const* message) {
    if (!ok) throw std::runtime_error(message);
}
'''

CHECKS = r'''
int main() {
    try {
        CompanionContract c;
        check(UpdateContractGrace(c, 1000, false), "Grace start must persist");
        check(c.graceExpiresAtUnix == 1600, "Initial allowance wrong");
        check(!UpdateContractGrace(c, 1300, false), "Outside ticks must not refresh");
        check(c.graceExpiresAtUnix - 1300 == 300, "Outside time did not count down");
        check(UpdateContractGrace(c, 1300, true), "Pause transition must persist");
        check(!UpdateContractGrace(c, 1360, true), "Checkpoint written too soon");
        check(UpdateContractGrace(c, 1361, true), "Paused deadline checkpoint missing");
        UpdateContractGrace(c, 1900, true);
        check(c.graceExpiresAtUnix - 1900 == 300, "Instance reset or consumed grace");
        check(UpdateContractGrace(c, 2000, false), "Resume transition must persist");
        check(c.graceExpiresAtUnix - 2000 == 300, "Exit lost remaining grace");
        UpdateContractGrace(c, 2120, false);
        UpdateContractGrace(c, 2120, true);
        allowance = 1200;
        UpdateContractGrace(c, 2420, true);
        UpdateContractGrace(c, 2480, false);
        check(c.graceExpiresAtUnix - 2480 == 180, "Re-entry/config change reset grace");
        UpdateContractGrace(c, 2660, false);
        check(c.graceExpiresAtUnix == 2660, "Grace did not expire at the boundary");
        UpdateContractGrace(c, 2700, true);
        UpdateContractGrace(c, 2800, false);
        check(c.graceExpiresAtUnix <= 2800, "Protection revived exhausted grace");

        allowance = 600;
        CompanionContract inside;
        UpdateContractGrace(inside, 1000, true);
        UpdateContractGrace(inside, 2000, true);
        UpdateContractGrace(inside, 2000, false);
        check(inside.graceExpiresAtUnix - 2000 == 600, "Expiry inside consumed grace");
        UpdateContractGrace(inside, 2300, false);
        check(inside.graceExpiresAtUnix - 2300 == 300, "Offline time must count down");

        // Restore the persisted deadline exactly as LoadTemporaryContracts does.
        CompanionContract restored;
        restored.graceExpiresAtUnix = inside.persistedGraceExpiresAtUnix;
        restored.persistedGraceExpiresAtUnix = restored.graceExpiresAtUnix;
        UpdateContractGrace(restored, 2400, false);
        check(restored.graceExpiresAtUnix - 2400 == 200, "Restart reset grace");

        allowance = 0;
        CompanionContract zero;
        UpdateContractGrace(zero, 1000, true);
        UpdateContractGrace(zero, 1100, true);
        UpdateContractGrace(zero, 1200, false);
        check(zero.graceExpiresAtUnix == 1200, "Zero grace must expire on exit");
        std::cout << "PASS: countdown, repeated pauses, persistence, expiry, offline/restart, zero grace\n";
    } catch (std::exception const& error) {
        std::cerr << "FAIL: " << error.what() << '\n'; return 1;
    }
}
'''


def run():
    module = Path(__file__).resolve().parents[1]
    cpp = (module / "src/CompanionRecruiter.cpp").read_text(encoding="utf-8")
    source = PREFIX + extract(cpp, "struct CompanionContract", ";")
    source += extract(cpp, "bool UpdateContractGrace(") + CHECKS
    with tempfile.TemporaryDirectory(prefix="companion-grace-test-") as directory:
        work = Path(directory)
        (work / "checks.cpp").write_text(source, encoding="utf-8")
        if os.name == "nt":
            vswhere = Path(os.environ["ProgramFiles(x86)"]) / "Microsoft Visual Studio/Installer/vswhere.exe"
            install = subprocess.check_output([str(vswhere), "-latest", "-products", "*", "-requires",
                "Microsoft.VisualStudio.Component.VC.Tools.x86.x64", "-property", "installationPath"], text=True).strip()
            if not install:
                raise RuntimeError("No MSVC compiler found")
            vcvars = Path(install) / "VC/Auxiliary/Build/vcvars64.bat"
            script = work / "build.cmd"
            script.write_text(f'@echo off\ncall "{vcvars}" >nul\nif errorlevel 1 exit /b 1\n'
                              'cl /nologo /EHsc /std:c++17 /W3 checks.cpp /Fe:checks.exe\n')
            command = [os.environ.get("COMSPEC", "cmd.exe"), "/d", "/c", str(script)]
        else:
            command = [shutil.which("c++") or "c++", "-std=c++17", "checks.cpp", "-o", "checks.exe"]
        subprocess.run(command, cwd=work, check=True)
        subprocess.run([str(work / "checks.exe")], cwd=work, check=True)


if __name__ == "__main__":
    run()
