if(NOT BUILD_PLAYERBOTS)
  message(FATAL_ERROR "mod-companion-recruiter requires BUILD_PLAYERBOTS=ON")
endif()

if(TORTOISE_MODULE_CMAKE_PHASE STREQUAL "POST_TARGETS")
  if(TORTOISE_CURRENT_MODULE_LINKAGE STREQUAL "dynamic")
    set(COMPANION_RECRUITER_TARGET mod_mod_companion_recruiter)
  else()
    set(COMPANION_RECRUITER_TARGET modules)
  endif()

  target_include_directories(${COMPANION_RECRUITER_TARGET}
    PRIVATE
      ${CMAKE_SOURCE_DIR}/src/modules/PlayerBots
      ${CMAKE_SOURCE_DIR}/src/modules/PlayerBots/playerbot
      ${CMAKE_SOURCE_DIR}/src/modules/PlayerBots/playerbot/strategy)
  target_link_libraries(${COMPANION_RECRUITER_TARGET} PUBLIC playerbots)
endif()
