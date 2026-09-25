-- 1,000 original, level- and faction-gated companion party conversations.
-- Hand-curated party banter; tools/generate_companion_banter.py validates and writes the docs.
CREATE TABLE IF NOT EXISTS `companion_banter_script` (
  `id` INT NOT NULL, `min_level` TINYINT UNSIGNED NOT NULL,
  `faction` TINYINT UNSIGNED NOT NULL DEFAULT 0, `speaker_count` TINYINT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `companion_banter_line` (
  `script_id` INT NOT NULL, `line_index` TINYINT UNSIGNED NOT NULL,
  `speaker_slot` TINYINT UNSIGNED NOT NULL, `text` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`script_id`, `line_index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
DELETE FROM `companion_banter_line` WHERE `script_id` BETWEEN 1 AND 1000;
DELETE FROM `companion_banter_script` WHERE `id` BETWEEN 1 AND 1000;
INSERT INTO `companion_banter_script` (`id`,`min_level`,`faction`,`speaker_count`) VALUES
(1,60,0,3),
(2,48,0,3),
(3,58,0,2),
(4,16,2,3),
(5,52,0,2),
(6,36,0,2),
(7,18,0,3),
(8,58,0,3),
(9,58,0,3),
(10,28,0,3),
(11,18,0,3),
(12,56,0,2),
(13,42,0,3),
(14,20,0,3),
(15,34,2,2),
(16,18,0,3),
(17,34,2,3),
(18,48,0,3),
(19,5,0,4),
(20,58,0,4),
(21,34,0,3),
(22,30,0,3),
(23,28,0,4),
(24,58,0,3),
(25,20,0,4),
(26,60,0,3),
(27,60,0,2),
(28,24,0,2),
(29,40,0,3),
(30,60,0,3),
(31,20,0,3),
(32,20,0,2),
(33,58,0,3),
(34,20,0,3),
(35,42,0,3),
(36,56,0,3),
(37,12,1,3),
(38,54,0,3),
(39,28,0,3),
(40,46,0,3),
(41,58,0,2),
(42,34,0,2),
(43,18,0,4),
(44,58,0,2),
(45,26,0,4),
(46,20,0,3),
(47,14,1,3),
(48,5,2,3),
(49,28,0,3),
(50,60,0,2),
(51,58,0,3),
(52,10,0,3),
(53,50,0,3),
(54,5,2,4),
(55,52,0,4),
(56,60,0,2),
(57,60,0,3),
(58,46,0,3),
(59,36,0,3),
(60,56,0,3),
(61,12,1,4),
(62,34,2,2),
(63,60,0,3),
(64,60,0,4),
(65,20,0,2),
(66,58,0,3),
(67,14,1,3),
(68,34,0,3),
(69,26,0,3),
(70,58,0,3),
(71,46,0,3),
(72,58,0,3),
(73,42,0,3),
(74,50,2,2),
(75,46,0,3),
(76,60,0,4),
(77,46,0,2),
(78,46,0,3),
(79,16,2,3),
(80,5,2,3),
(81,5,2,3),
(82,46,0,2),
(83,32,0,3),
(84,30,0,3),
(85,60,0,3),
(86,40,0,2),
(87,56,0,3),
(88,40,0,3),
(89,18,0,2),
(90,50,2,3),
(91,50,0,3),
(92,44,0,2),
(93,60,0,3),
(94,60,0,3),
(95,24,0,3),
(96,14,1,4),
(97,24,0,3),
(98,58,0,3),
(99,18,0,3),
(100,32,0,4);
INSERT INTO `companion_banter_script` (`id`,`min_level`,`faction`,`speaker_count`) VALUES
(101,52,0,3),
(102,54,0,3),
(103,44,0,3),
(104,60,0,3),
(105,44,0,2),
(106,46,0,3),
(107,34,0,3),
(108,28,0,2),
(109,46,0,3),
(110,48,0,3),
(111,60,0,2),
(112,48,0,3),
(113,48,0,4),
(114,5,2,3),
(115,42,0,3),
(116,34,0,2),
(117,60,0,2),
(118,13,2,3),
(119,10,0,4),
(120,60,0,3),
(121,22,1,4),
(122,48,0,3),
(123,28,0,3),
(124,24,0,3),
(125,60,0,3),
(126,5,2,2),
(127,24,1,2),
(128,20,0,2),
(129,5,0,2),
(130,60,0,3),
(131,24,0,4),
(132,60,0,3),
(133,26,0,3),
(134,32,0,3),
(135,14,1,3),
(136,12,1,3),
(137,26,0,3),
(138,60,0,2),
(139,60,0,4),
(140,20,0,3),
(141,58,0,3),
(142,60,0,4),
(143,20,0,4),
(144,48,0,2),
(145,32,0,3),
(146,60,0,2),
(147,5,1,4),
(148,12,2,3),
(149,42,2,3),
(150,30,0,3),
(151,56,0,3),
(152,5,0,3),
(153,26,0,3),
(154,40,0,3),
(155,12,1,2),
(156,10,0,2),
(157,60,0,2),
(158,40,0,3),
(159,44,0,2),
(160,58,0,2),
(161,34,2,2),
(162,20,0,3),
(163,24,1,3),
(164,18,0,3),
(165,24,0,3),
(166,20,0,3),
(167,22,0,3),
(168,13,2,2),
(169,5,1,2),
(170,20,0,2),
(171,60,0,2),
(172,60,0,2),
(173,28,0,2),
(174,5,1,3),
(175,10,0,2),
(176,24,0,2),
(177,48,0,3),
(178,26,0,2),
(179,58,0,2),
(180,5,2,2),
(181,32,0,2),
(182,20,0,2),
(183,36,0,2),
(184,16,2,2),
(185,58,0,2),
(186,28,0,2),
(187,40,0,2),
(188,18,0,2),
(189,12,2,2),
(190,18,0,2),
(191,58,0,2),
(192,8,1,2),
(193,50,0,2),
(194,60,0,3),
(195,50,0,2),
(196,42,2,3),
(197,60,0,2),
(198,56,0,2),
(199,48,0,3),
(200,30,0,2);
INSERT INTO `companion_banter_script` (`id`,`min_level`,`faction`,`speaker_count`) VALUES
(201,34,2,3),
(202,60,0,3),
(203,58,0,4),
(204,28,0,4),
(205,30,0,3),
(206,56,0,3),
(207,5,0,4),
(208,32,0,4),
(209,20,0,4),
(210,40,0,3),
(211,60,0,3),
(212,30,0,3),
(213,26,0,3),
(214,50,0,3),
(215,38,0,3),
(216,54,0,2),
(217,16,2,2),
(218,26,0,3),
(219,40,0,3),
(220,48,0,4),
(221,20,0,4),
(222,38,0,2),
(223,60,0,2),
(224,20,0,3),
(225,46,0,3),
(226,20,0,4),
(227,40,0,3),
(228,60,0,3),
(229,54,0,3),
(230,46,0,3),
(231,40,0,2),
(232,34,2,4),
(233,58,0,2),
(234,18,0,4),
(235,60,0,3),
(236,44,0,3),
(237,52,0,3),
(238,56,0,3),
(239,12,1,3),
(240,5,2,2),
(241,20,0,4),
(242,60,0,3),
(243,36,0,3),
(244,42,0,4),
(245,5,2,2),
(246,26,0,3),
(247,50,0,4),
(248,18,0,3),
(249,48,0,3),
(250,52,0,3),
(251,22,0,3),
(252,52,0,2),
(253,48,0,3),
(254,12,1,3),
(255,60,0,3),
(256,52,0,3),
(257,60,0,3),
(258,22,1,3),
(259,52,0,3),
(260,26,0,2),
(261,12,1,3),
(262,32,0,3),
(263,60,0,2),
(264,50,2,3),
(265,22,0,3),
(266,28,0,3),
(267,12,1,3),
(268,12,1,2),
(269,30,0,3),
(270,48,0,4),
(271,20,0,3),
(272,48,0,3),
(273,60,0,3),
(274,36,0,2),
(275,28,0,3),
(276,58,0,3),
(277,60,0,3),
(278,46,0,2),
(279,14,1,3),
(280,52,0,4),
(281,60,0,2),
(282,18,0,2),
(283,24,0,3),
(284,13,2,3),
(285,60,0,2),
(286,34,0,3),
(287,5,1,3),
(288,5,0,3),
(289,60,0,4),
(290,8,1,4),
(291,20,0,3),
(292,58,0,4),
(293,60,0,2),
(294,34,0,4),
(295,52,0,3),
(296,60,0,4),
(297,34,0,3),
(298,40,0,2),
(299,18,0,2),
(300,60,0,3);
INSERT INTO `companion_banter_script` (`id`,`min_level`,`faction`,`speaker_count`) VALUES
(301,46,0,2),
(302,5,0,4),
(303,60,0,3),
(304,46,0,3),
(305,12,2,4),
(306,42,0,3),
(307,20,0,4),
(308,60,0,2),
(309,32,0,3),
(310,28,0,3),
(311,50,2,3),
(312,60,0,2),
(313,40,0,3),
(314,20,0,2),
(315,34,0,2),
(316,40,0,4),
(317,52,0,3),
(318,30,0,2),
(319,60,0,2),
(320,28,0,3),
(321,44,0,3),
(322,34,0,3),
(323,18,0,3),
(324,18,0,3),
(325,18,0,3),
(326,46,0,3),
(327,60,0,4),
(328,22,1,3),
(329,10,0,4),
(330,36,0,4),
(331,48,0,2),
(332,28,0,2),
(333,48,0,2),
(334,20,0,2),
(335,5,1,3),
(336,44,0,4),
(337,5,1,3),
(338,42,2,3),
(339,60,0,3),
(340,12,1,2),
(341,60,0,3),
(342,36,0,3),
(343,40,0,3),
(344,60,0,3),
(345,50,2,4),
(346,50,0,2),
(347,56,0,3),
(348,18,0,4),
(349,12,1,3),
(350,40,0,3),
(351,48,0,3),
(352,60,0,3),
(353,26,0,3),
(354,28,0,3),
(355,48,0,2),
(356,42,2,3),
(357,8,1,3),
(358,40,0,4),
(359,60,0,3),
(360,46,0,3),
(361,26,0,2),
(362,32,0,3),
(363,26,0,4),
(364,26,0,3),
(365,20,0,3),
(366,32,0,2),
(367,14,1,4),
(368,40,0,2),
(369,40,0,3),
(370,56,0,2),
(371,20,0,3),
(372,58,0,3),
(373,42,0,4),
(374,24,0,3),
(375,8,1,3),
(376,40,0,3),
(377,56,0,2),
(378,18,0,3),
(379,10,0,2),
(380,46,0,3),
(381,12,1,2),
(382,18,0,3),
(383,50,2,3),
(384,20,0,3),
(385,60,0,3),
(386,42,2,3),
(387,34,2,3),
(388,42,0,3),
(389,42,2,2),
(390,48,0,3),
(391,28,0,2),
(392,20,0,3),
(393,60,0,3),
(394,60,0,3),
(395,48,0,2),
(396,60,0,2),
(397,50,0,3),
(398,56,0,2),
(399,5,1,2),
(400,48,0,2);
INSERT INTO `companion_banter_script` (`id`,`min_level`,`faction`,`speaker_count`) VALUES
(401,28,0,2),
(402,28,0,2),
(403,44,0,3),
(404,8,1,4),
(405,20,0,2),
(406,60,0,3),
(407,44,0,3),
(408,48,0,3),
(409,42,0,3),
(410,30,0,3),
(411,32,0,3),
(412,36,0,4),
(413,24,0,2),
(414,40,0,2),
(415,60,0,2),
(416,28,0,3),
(417,60,0,3),
(418,60,0,3),
(419,28,0,2),
(420,48,0,2),
(421,26,0,3),
(422,60,0,3),
(423,34,0,3),
(424,60,0,2),
(425,60,0,4),
(426,28,0,3),
(427,24,0,2),
(428,58,0,3),
(429,24,0,3),
(430,18,0,2),
(431,54,0,3),
(432,26,0,2),
(433,18,0,3),
(434,46,0,3),
(435,20,0,4),
(436,46,0,3),
(437,48,0,2),
(438,24,1,2),
(439,28,0,2),
(440,60,0,3),
(441,60,0,3),
(442,50,2,2),
(443,60,0,2),
(444,28,0,2),
(445,60,0,3),
(446,22,1,3),
(447,40,0,3),
(448,12,1,2),
(449,60,0,2),
(450,26,0,2),
(451,5,2,3),
(452,60,0,4),
(453,40,0,2),
(454,28,0,2),
(455,50,0,3),
(456,48,0,3),
(457,24,1,2),
(458,60,0,2),
(459,36,0,2),
(460,18,0,2),
(461,52,0,3),
(462,28,0,2),
(463,24,1,2),
(464,42,0,2),
(465,48,0,2),
(466,18,0,2),
(467,60,0,2),
(468,60,0,2),
(469,40,0,2),
(470,5,0,3),
(471,8,1,2),
(472,60,0,2),
(473,12,2,2),
(474,26,0,3),
(475,60,0,2),
(476,42,2,2),
(477,10,0,3),
(478,60,0,3),
(479,52,0,3),
(480,46,0,2),
(481,5,2,2),
(482,28,0,2),
(483,52,0,2),
(484,16,2,3),
(485,18,0,2),
(486,60,0,2),
(487,44,0,2),
(488,60,0,2),
(489,5,1,2),
(490,10,0,2),
(491,20,0,3),
(492,60,0,2),
(493,40,0,2),
(494,60,0,2),
(495,24,1,3),
(496,42,0,3),
(497,12,2,2),
(498,14,1,2),
(499,56,0,4),
(500,42,2,2);
INSERT INTO `companion_banter_script` (`id`,`min_level`,`faction`,`speaker_count`) VALUES
(501,18,0,3),
(502,20,0,2),
(503,32,0,2),
(504,48,0,3),
(505,24,1,3),
(506,26,0,2),
(507,28,0,3),
(508,28,0,2),
(509,40,0,3),
(510,60,0,4),
(511,42,0,2),
(512,38,0,4),
(513,60,0,3),
(514,26,0,2),
(515,26,0,2),
(516,44,0,3),
(517,36,0,2),
(518,24,1,2),
(519,5,1,2),
(520,60,0,3),
(521,40,0,3),
(522,60,0,3),
(523,28,0,3),
(524,60,0,3),
(525,5,1,3),
(526,5,0,3),
(527,20,0,2),
(528,36,0,2),
(529,52,0,2),
(530,38,0,2),
(531,5,2,3),
(532,30,0,3),
(533,40,0,2),
(534,12,1,2),
(535,56,0,2),
(536,60,0,2),
(537,60,0,1),
(538,5,1,4),
(539,24,0,3),
(540,12,1,3),
(541,28,0,3),
(542,52,0,2),
(543,12,1,3),
(544,36,0,2),
(545,5,2,2),
(546,48,0,3),
(547,12,2,2),
(548,20,0,3),
(549,40,0,3),
(550,40,0,2),
(551,48,0,3),
(552,50,0,3),
(553,10,0,3),
(554,36,0,3),
(555,58,0,1),
(556,32,0,3),
(557,36,0,3),
(558,8,1,2),
(559,46,0,3),
(560,60,0,2),
(561,5,1,3),
(562,60,0,1),
(563,20,0,2),
(564,52,0,3),
(565,20,0,3),
(566,34,0,2),
(567,10,0,2),
(568,28,0,3),
(569,26,0,3),
(570,54,0,4),
(571,58,0,3),
(572,42,2,2),
(573,52,0,3),
(574,26,0,2),
(575,20,0,3),
(576,30,0,2),
(577,24,0,3),
(578,60,0,3),
(579,38,0,2),
(580,60,0,2),
(581,22,0,3),
(582,18,0,3),
(583,60,0,2),
(584,24,1,3),
(585,32,0,2),
(586,28,0,2),
(587,5,0,3),
(588,36,0,2),
(589,18,0,3),
(590,40,0,1),
(591,58,0,2),
(592,22,1,2),
(593,34,0,1),
(594,8,1,3),
(595,60,0,2),
(596,52,0,3),
(597,5,1,3),
(598,20,0,2),
(599,40,0,3),
(600,48,0,2);
INSERT INTO `companion_banter_script` (`id`,`min_level`,`faction`,`speaker_count`) VALUES
(601,26,0,2),
(602,24,1,2),
(603,60,0,3),
(604,46,0,2),
(605,28,0,2),
(606,24,0,2),
(607,18,0,1),
(608,20,0,2),
(609,20,0,3),
(610,20,0,2),
(611,40,0,3),
(612,5,1,4),
(613,10,0,2),
(614,22,0,3),
(615,28,0,2),
(616,40,0,1),
(617,48,0,3),
(618,28,0,2),
(619,28,0,2),
(620,48,0,2),
(621,60,0,3),
(622,34,2,3),
(623,36,0,1),
(624,58,0,2),
(625,50,0,2),
(626,5,1,2),
(627,28,0,3),
(628,40,0,3),
(629,36,0,3),
(630,60,0,3),
(631,12,2,2),
(632,18,0,3),
(633,5,2,4),
(634,36,0,2),
(635,18,0,2),
(636,58,0,2),
(637,12,2,2),
(638,44,0,1),
(639,18,0,1),
(640,40,0,3),
(641,60,0,3),
(642,5,0,2),
(643,60,0,2),
(644,5,2,3),
(645,30,0,2),
(646,16,2,2),
(647,12,1,2),
(648,42,0,1),
(649,5,1,2),
(650,58,0,2),
(651,32,0,3),
(652,10,0,2),
(653,26,0,3),
(654,60,0,2),
(655,26,0,4),
(656,28,0,2),
(657,10,0,2),
(658,60,0,3),
(659,26,0,2),
(660,42,2,2),
(661,60,0,2),
(662,36,0,3),
(663,26,0,2),
(664,50,0,1),
(665,10,0,2),
(666,52,0,2),
(667,5,2,2),
(668,32,0,1),
(669,38,0,2),
(670,24,1,2),
(671,58,0,1),
(672,36,0,1),
(673,46,0,1),
(674,52,0,1),
(675,52,0,3),
(676,58,0,1),
(677,50,0,1),
(678,60,0,2),
(679,44,0,3),
(680,14,1,2),
(681,36,0,1),
(682,44,0,2),
(683,40,0,3),
(684,40,0,3),
(685,5,2,2),
(686,40,0,2),
(687,28,0,3),
(688,60,0,3),
(689,48,0,3),
(690,18,0,2),
(691,46,0,1),
(692,5,2,2),
(693,38,0,3),
(694,5,2,1),
(695,50,0,2),
(696,12,2,2),
(697,60,0,2),
(698,58,0,2),
(699,20,0,2),
(700,50,2,3);
INSERT INTO `companion_banter_script` (`id`,`min_level`,`faction`,`speaker_count`) VALUES
(701,5,2,4),
(702,10,0,2),
(703,28,0,3),
(704,58,0,3),
(705,20,0,2),
(706,60,0,2),
(707,18,0,2),
(708,48,0,2),
(709,14,1,2),
(710,52,0,2),
(711,26,0,2),
(712,26,0,3),
(713,60,0,3),
(714,5,1,2),
(715,20,0,1),
(716,28,0,2),
(717,54,0,3),
(718,60,0,1),
(719,30,0,2),
(720,56,0,2),
(721,18,0,3),
(722,48,0,1),
(723,5,2,2),
(724,34,2,3),
(725,24,0,2),
(726,48,0,2),
(727,58,0,1),
(728,26,0,2),
(729,5,1,3),
(730,56,0,2),
(731,5,2,4),
(732,44,0,2),
(733,50,0,1),
(734,56,0,2),
(735,60,0,1),
(736,44,0,3),
(737,24,0,2),
(738,54,0,1),
(739,22,1,3),
(740,46,0,1),
(741,10,0,2),
(742,52,0,1),
(743,18,0,2),
(744,12,2,2),
(745,40,0,1),
(746,44,0,2),
(747,48,0,1),
(748,10,0,2),
(749,5,2,2),
(750,36,0,3),
(751,20,0,2),
(752,58,0,1),
(753,26,0,2),
(754,30,0,2),
(755,60,0,2),
(756,8,1,2),
(757,52,0,2),
(758,44,0,2),
(759,18,0,2),
(760,24,1,2),
(761,28,0,2),
(762,56,0,2),
(763,60,0,2),
(764,54,0,2),
(765,60,0,2),
(766,16,2,2),
(767,16,2,1),
(768,60,0,2),
(769,60,0,2),
(770,8,1,2),
(771,38,0,2),
(772,30,0,2),
(773,18,0,3),
(774,5,1,1),
(775,60,0,2),
(776,22,0,2),
(777,30,0,2),
(778,5,2,2),
(779,18,0,2),
(780,58,0,2),
(781,12,1,2),
(782,24,0,2),
(783,32,0,2),
(784,60,0,2),
(785,46,0,2),
(786,26,0,2),
(787,52,0,1),
(788,60,0,1),
(789,60,0,2),
(790,24,0,1),
(791,36,0,1),
(792,54,0,1),
(793,12,1,2),
(794,52,0,1),
(795,48,0,2),
(796,12,1,2),
(797,40,0,1),
(798,60,0,1),
(799,24,0,2),
(800,46,0,1);
INSERT INTO `companion_banter_script` (`id`,`min_level`,`faction`,`speaker_count`) VALUES
(801,20,0,2),
(802,44,0,1),
(803,52,0,1),
(804,20,0,2),
(805,58,0,2),
(806,56,0,2),
(807,38,0,2),
(808,24,0,2),
(809,12,1,2),
(810,58,0,2),
(811,60,0,2),
(812,22,1,2),
(813,20,0,2),
(814,18,0,2),
(815,44,0,2),
(816,60,0,1),
(817,28,0,1),
(818,14,1,2),
(819,12,2,2),
(820,58,0,2),
(821,56,0,2),
(822,20,0,2),
(823,32,0,2),
(824,54,0,2),
(825,56,0,2),
(826,52,0,2),
(827,60,0,2),
(828,24,0,2),
(829,12,2,2),
(830,44,0,2),
(831,8,1,1),
(832,22,0,2),
(833,5,1,1),
(834,36,0,2),
(835,60,0,2),
(836,10,0,2),
(837,26,0,2),
(838,22,1,2),
(839,50,0,2),
(840,42,0,2),
(841,20,0,2),
(842,60,0,2),
(843,5,2,2),
(844,42,2,2),
(845,28,0,2),
(846,60,0,2),
(847,52,0,2),
(848,20,0,2),
(849,52,0,2),
(850,38,0,2),
(851,5,2,2),
(852,38,0,2),
(853,60,0,2),
(854,60,0,2),
(855,60,0,2),
(856,60,0,2),
(857,60,0,2),
(858,30,0,2),
(859,58,0,2),
(860,26,0,2),
(861,12,1,2),
(862,56,0,2),
(863,58,0,2),
(864,34,2,2),
(865,60,0,2),
(866,10,0,2),
(867,36,0,2),
(868,20,0,2),
(869,28,0,2),
(870,12,1,2),
(871,10,0,2),
(872,40,0,2),
(873,24,1,2),
(874,34,2,2),
(875,26,0,2),
(876,48,0,2),
(877,50,0,2),
(878,40,0,2),
(879,56,0,2),
(880,5,0,2),
(881,10,0,2),
(882,48,0,2),
(883,20,0,2),
(884,24,1,2),
(885,42,2,2),
(886,52,0,2),
(887,60,0,2),
(888,8,1,1),
(889,38,0,2),
(890,60,0,2),
(891,26,0,2),
(892,42,0,2),
(893,28,0,2),
(894,24,0,2),
(895,60,0,2),
(896,40,0,1),
(897,28,0,1),
(898,10,0,2),
(899,56,0,1),
(900,38,0,1);
INSERT INTO `companion_banter_script` (`id`,`min_level`,`faction`,`speaker_count`) VALUES
(901,14,1,4),
(902,56,0,3),
(903,46,0,4),
(904,26,0,3),
(905,18,0,3),
(906,30,0,3),
(907,10,0,2),
(908,44,0,3),
(909,5,2,3),
(910,48,0,3),
(911,50,0,3),
(912,60,0,4),
(913,44,0,2),
(914,56,0,1),
(915,52,0,3),
(916,36,0,3),
(917,60,0,2),
(918,48,0,3),
(919,12,1,3),
(920,42,2,3),
(921,60,0,2),
(922,60,0,2),
(923,60,0,2),
(924,60,0,3),
(925,24,0,3),
(926,18,0,3),
(927,60,0,3),
(928,36,0,2),
(929,5,2,3),
(930,60,0,2),
(931,28,0,3),
(932,60,0,3),
(933,52,0,3),
(934,5,0,2),
(935,36,0,3),
(936,60,0,4),
(937,52,0,3),
(938,56,0,3),
(939,52,0,3),
(940,30,0,3),
(941,60,0,3),
(942,58,0,3),
(943,40,0,1),
(944,50,2,2),
(945,60,0,3),
(946,40,0,3),
(947,60,0,4),
(948,60,0,1),
(949,28,0,3),
(950,58,0,3),
(951,26,0,3),
(952,58,0,3),
(953,18,0,3),
(954,60,0,4),
(955,60,0,3),
(956,60,0,3),
(957,5,2,3),
(958,30,0,4),
(959,5,0,3),
(960,60,0,3),
(961,20,0,2),
(962,32,0,3),
(963,60,0,3),
(964,28,0,3),
(965,26,0,3),
(966,44,0,3),
(967,60,0,4),
(968,40,0,3),
(969,46,0,4),
(970,52,0,3),
(971,60,0,3),
(972,56,0,4),
(973,16,2,3),
(974,24,0,3),
(975,60,0,3),
(976,60,0,3),
(977,42,0,3),
(978,60,0,3),
(979,52,0,3),
(980,30,0,4),
(981,42,0,3),
(982,52,0,2),
(983,5,2,4),
(984,40,0,3),
(985,38,0,3),
(986,10,0,3),
(987,30,0,2),
(988,42,2,1),
(989,12,1,2),
(990,20,0,3),
(991,56,0,4),
(992,58,0,4),
(993,30,0,3),
(994,40,0,3),
(995,24,1,2),
(996,24,0,2),
(997,36,0,3),
(998,20,0,3),
(999,12,1,3),
(1000,22,1,2);

INSERT INTO `companion_banter_line` (`script_id`,`line_index`,`speaker_slot`,`text`) VALUES
-- 1 (60, neutral, 3) AQ war effort
(1,0,0,'How much did you donate to the war effort?'),
(1,1,1,'Enough.'),
(1,2,0,'That''s not a number.'),
(1,3,1,'It''s enough of a number.'),
(1,4,2,'I gave them linen. They seemed disappointed.'),
(1,5,0,'Everyone gives linen.'),
(1,6,1,'Linen is the currency of good intentions.'),

-- 2 (48, neutral, 3) Onyxia / Lady Prestor
(2,0,0,'You think the king knows?'),
(2,1,1,'Knows what?'),
(2,2,0,'About Lady Prestor.'),
(2,3,1,'Everyone knows. Nobody says it.'),
(2,4,2,'That''s how courts work.'),
(2,5,0,'That''s how kingdoms fall.'),
(2,6,1,'Same thing, usually.'),

-- 3 (58, neutral, 2) Blackrock
(3,0,0,'I''ve been through Blackrock more times than I can count.'),
(3,1,1,'You can''t count that high?'),
(3,2,0,'I can''t count that many trips. There''s a difference.'),
(3,3,1,'Is there?'),
(3,4,0,'No.'),
(3,5,1,'Didn''t think so.'),

-- 4 (16, Horde, 3) Crossroads raids
(4,0,0,'The Alliance hit the Crossroads again.'),
(4,1,1,'They always hit the Crossroads.'),
(4,2,0,'Maybe they just like the Barrens.'),
(4,3,1,'Nobody likes the Barrens.'),
(4,4,2,'The quillboar like the Barrens.'),
(4,5,0,'The quillboar like being angry.'),
(4,6,1,'That''s not the same thing.'),
(4,7,2,'It''s close enough.'),

-- 5 (52, neutral, 2) Molten Core
(5,0,0,'I knew someone who went into Molten Core.'),
(5,1,1,'What happened?'),
(5,2,0,'He came back with a belt.'),
(5,3,1,'Just a belt?'),
(5,4,0,'Just a belt.'),
(5,5,1,'Was it a good belt?'),
(5,6,0,'It was a very good belt.'),

-- 6 (36, neutral, 2) Scholomance
(6,0,0,'Have you been to Scholomance?'),
(6,1,1,'Once.'),
(6,2,0,'What did you think?'),
(6,3,1,'I think some libraries should be burned.'),
(6,4,0,'That''s the opposite of what you''re supposed to think in a library.'),
(6,5,1,'That library is the exception.'),

-- 7 (18, neutral, 3) Defias
(7,0,0,'The Defias Brotherhood is getting bolder.'),
(7,1,1,'They''re just farmers with red masks.'),
(7,2,0,'Farmers with red masks and a grudge.'),
(7,3,1,'And a very good tailor.'),
(7,4,2,'What?'),
(7,5,1,'Have you seen the stitching on those masks? Excellent work.'),
(7,6,2,'He''s not wrong.'),

-- 8 (58, neutral, 3) Plague
(8,0,0,'The plague''s getting worse.'),
(8,1,1,'It''s been getting worse for years.'),
(8,2,0,'It''s been getting worse since it started.'),
(8,3,1,'That''s what getting worse means.'),
(8,4,2,'Can we talk about something else?'),
(8,5,0,'Sure. The plague of hunger. I''m starving.'),
(8,6,1,'That''s not better.'),

-- 9 (58, neutral, 3) Cold / dungeons
(9,0,0,'It''s cold.'),
(9,1,1,'It''s a cave.'),
(9,2,0,'Caves are cold.'),
(9,3,1,'Why are caves cold?'),
(9,4,2,'Because they''re underground.'),
(9,5,1,'And because they''re full of skeletons.'),
(9,6,0,'Skeletons don''t make things cold.'),
(9,7,2,'Then why is it cold?'),

-- 10 (28, neutral, 3) Gnomeregan
(10,0,0,'You ever wonder what happened to Gnomeregan?'),
(10,1,1,'Radiation happened.'),
(10,2,0,'And troggs.'),
(10,3,1,'And bad decisions.'),
(10,4,2,'Mostly bad decisions.'),
(10,5,0,'The radiation was a decision?'),
(10,6,2,'Everything''s a decision if you''re gnome enough.'),

-- 11 (18, neutral, 3) Barrens
(11,0,0,'I hate the Barrens.'),
(11,1,1,'Everyone hates the Barrens.'),
(11,2,0,'I like the Barrens.'),
(11,3,1,'You would.'),
(11,4,2,'What''s that supposed to mean?'),
(11,5,0,'It means you''d like anything mostly empty and full of bugs.'),
(11,6,2,'That''s fair.'),
(11,7,1,'It''s not a compliment.'),

-- 12 (56, neutral, 2) Onyxia attune
(12,0,0,'The letter said Drakefire.'),
(12,1,1,'Don''t say it on the road.'),
(12,2,0,'It''s a piece of paper.'),
(12,3,1,'It''s a piece of paper that starts wars. Fold it.'),

-- 13 (42, neutral, 3) Dark Portal
(13,0,0,'You think we''ll ever see the other side of the Dark Portal?'),
(13,1,1,'The portal''s closed.'),
(13,2,0,'I know it''s closed. I''m asking if it''ll open.'),
(13,3,1,'And I''m asking what''s on the other side.'),
(13,4,2,'Orcs.'),
(13,5,1,'Orcs are already here.'),
(13,6,2,'More orcs.'),

-- 14 (20, neutral, 3) Low level general
(14,0,0,'I think I''m lost.'),
(14,1,1,'You''re not lost. You''re exploring.'),
(14,2,0,'He''s lost.'),
(14,3,1,'Thank you.'),
(14,4,2,'You''re welcome.'),
(14,5,0,'I hate both of you.'),

-- 15 (34, Horde, 2) Thrall
(15,0,0,'You think Thrall''s doing a good job?'),
(15,1,1,'Compared to who?'),
(15,2,0,'Anyone.'),
(15,3,1,'Then yes.'),
(15,4,0,'That''s a low bar.'),
(15,5,1,'It''s the bar we''ve got.'),

-- 16 (18, neutral, 3) Barrens
(16,0,0,'You ever notice how everything in the Barrens looks the same?'),
(16,1,1,'It doesn''t look the same.'),
(16,2,0,'It looks the same.'),
(16,3,2,'It looks the same because you''re always lost.'),
(16,4,0,'That might be it.'),
(16,5,1,'It''s definitely it.'),

-- 17 (34, Horde, 3) Forsaken
(17,0,0,'I don''t trust the Forsaken.'),
(17,1,1,'Nobody trusts the Forsaken.'),
(17,2,0,'The Forsaken don''t trust the Forsaken.'),
(17,3,1,'Then why are they in the Horde?'),
(17,4,2,'Because Thrall''s too polite to say no.'),
(17,5,0,'That''s not it.'),
(17,6,2,'Then what is it?'),
(17,7,0,'They have very good alchemists.'),

-- 18 (48, neutral, 3) Felwood / paranoia
(18,0,0,'You ever feel like the trees are watching you?'),
(18,1,1,'In Felwood?'),
(18,2,0,'Anywhere.'),
(18,3,1,'That''s just paranoia.'),
(18,4,2,'It''s not paranoia if the trees are actually watching.'),
(18,5,1,'In Felwood they actually are.'),
(18,6,2,'That''s Felwood, though.'),
(18,7,0,'I''m not in Felwood.'),
(18,8,1,'Then it''s paranoia.'),

-- 19 (5, neutral, 4) Fresh adventurers
(19,0,0,'What''s a dungeon?'),
(19,1,1,'It''s like a cave but with better loot.'),
(19,2,0,'And worse people.'),
(19,3,1,'And more death.'),
(19,4,0,'That sounds terrible.'),
(19,5,1,'It''s great.'),
(19,6,2,'It''s terrible and great.'),
(19,7,3,'That''s the whole game.'),

-- 20 (58, neutral, 4) Naxxramas
(20,0,0,'You hear about Naxxramas?'),
(20,1,1,'The floating necropolis?'),
(20,2,0,'The floating necropolis.'),
(20,3,1,'It''s not floating. It''s just... there.'),
(20,4,2,'It''s floating.'),
(20,5,1,'It''s a very large thing that is above the ground.'),
(20,6,2,'That''s floating.'),
(20,7,3,'That''s flying.'),

-- 21 (34, neutral, 3) Loot
(21,0,0,'What do you do with all the stuff you loot?'),
(21,1,1,'Sell it.'),
(21,2,0,'All of it?'),
(21,3,1,'The good stuff I keep. The rest I sell.'),
(21,4,2,'You keep a lot.'),
(21,5,1,'I keep what matters.'),
(21,6,2,'You have six swords in your pack.'),
(21,7,1,'They all matter.'),

-- 22 (30, neutral, 3) Why we do this
(22,0,0,'You ever stop and think about why we do this?'),
(22,1,1,'Money.'),
(22,2,0,'Besides money.'),
(22,3,1,'Better money.'),
(22,4,2,'Glory?'),
(22,5,0,'Glory''s nice.'),
(22,6,1,'Glory doesn''t pay for repairs.'),
(22,7,2,'Money does.'),
(22,8,0,'Money and glory.'),

-- 23 (28, neutral, 4) Hungry
(23,0,0,'Anyone else hungry?'),
(23,1,1,'We''re in a dungeon.'),
(23,2,0,'I know where we are. I''m asking if anyone''s hungry.'),
(23,3,1,'I could eat.'),
(23,4,2,'You could always eat.'),
(23,5,3,'That''s true.'),
(23,6,1,'Focus.'),
(23,7,0,'I''m focused on food.'),

-- 24 (58, neutral, 3) War effort
(24,0,0,'You think the war effort will actually work?'),
(24,1,1,'It has to.'),
(24,2,0,'Does it?'),
(24,3,1,'No.'),
(24,4,2,'Then why are we doing it?'),
(24,5,0,'Because the alternative is worse.'),
(24,6,1,'That''s the answer to most questions.'),

-- 25 (20, neutral, 4) Falling off cliffs
(25,0,0,'I fell off a cliff yesterday.'),
(25,1,1,'Are you okay?'),
(25,2,0,'I''m fine. The cliff''s not.'),
(25,3,1,'The cliff is fine.'),
(25,4,0,'The cliff is not fine.'),
(25,5,2,'What did you do to the cliff?'),
(25,6,0,'I landed on it.'),
(25,7,3,'That''s not how cliffs work.'),
(25,8,0,'It is now.'),

-- 26 (60, neutral, 3) Qiraji
(26,0,0,'How long have we been fighting the Qiraji?'),
(26,1,1,'Too long.'),
(26,2,0,'Not long enough.'),
(26,3,1,'What does that mean?'),
(26,4,2,'It means we haven''t won yet.'),
(26,5,0,'That''s what ''too long'' means.'),
(26,6,1,'I hate both of you.'),

-- 27 (60, neutral, 2) Onyxia
(27,0,0,'You think Onyxia''s really dead?'),
(27,1,1,'I think she''s really dead.'),
(27,2,0,'You thought the king was really a king.'),
(27,3,1,'That''s different.'),
(27,4,0,'Is it?'),
(27,5,1,'...No.'),

-- 28 (24, neutral, 2) The ocean
(28,0,0,'You ever wonder what''s in the ocean?'),
(28,1,1,'Fish.'),
(28,2,0,'Besides fish.'),
(28,3,1,'Bigger fish.'),
(28,4,0,'You''re no fun.'),
(28,5,1,'I''m practical.'),

-- 29 (40, neutral, 3) Dwarf traveler
(29,0,0,'I met a dwarf who claimed he''d been to every continent.'),
(29,1,1,'Even Kalimdor?'),
(29,2,0,'Especially Kalimdor.'),
(29,3,1,'That''s not that impressive.'),
(29,4,2,'He said he walked.'),
(29,5,1,'He didn''t walk.'),
(29,6,2,'Dwarves don''t walk. They ride.'),
(29,7,0,'He walked.'),

-- 30 (60, neutral, 3) Tired
(30,0,0,'I''m tired.'),
(30,1,1,'We all are.'),
(30,2,0,'Rest when we''re dead.'),
(30,3,1,'That''s not comforting.'),
(30,4,2,'It wasn''t meant to be.'),
(30,5,1,'It was a little comforting.'),
(30,6,2,'Then I failed.'),

-- 31 (20, neutral, 3) Pirates in caves
(31,0,0,'Why are there so many pirates in caves?'),
(31,1,1,'Where else would they be?'),
(31,2,0,'The sea.'),
(31,3,1,'The sea''s dangerous.'),
(31,4,2,'Caves are dangerous.'),
(31,5,0,'Everything''s dangerous.'),
(31,6,2,'That''s why we''re adventurers.'),

-- 32 (20, neutral, 2) Auction house
(32,0,0,'Someone bid against me on a cheap dagger.'),
(32,1,1,'That''s the auction house. It''s a duel with gold.'),
(32,2,0,'I won.'),
(32,3,1,'Then you paid too much. That''s how you know.'),

-- 33 (58, neutral, 3) Rocks
(33,0,0,'I don''t like the look of those clouds.'),
(33,1,1,'We''re underground.'),
(33,2,0,'I don''t like the look of those rocks.'),
(33,3,1,'Rocks don''t have looks.'),
(33,4,2,'These rocks do.'),
(33,5,1,'You''re being dramatic.'),
(33,6,0,'I''m being observant.'),

-- 34 (20, neutral, 3) Getting better
(34,0,0,'I think I''m getting better at this.'),
(34,1,1,'Better at what?'),
(34,2,0,'Fighting.'),
(34,3,1,'You almost hit me last fight.'),
(34,4,0,'Almost. That''s the key word.'),
(34,5,2,'Almost is not a good key word.'),
(34,6,1,'It''s better than ''did.'''),

-- 35 (42, neutral, 3) Worst place
(35,0,0,'What''s the worst place you''ve ever been?'),
(35,1,1,'Duskwood.'),
(35,2,0,'Duskwood''s not that bad.'),
(35,3,1,'Duskwood at night.'),
(35,4,2,'Duskwood at night with no torch.'),
(35,5,0,'Okay, that''s bad.'),
(35,6,1,'I still have nightmares.'),
(35,7,2,'About Duskwood?'),
(35,8,1,'About the tree.'),

-- 36 (56, neutral, 3) Blackrock volcano
(36,0,0,'You ever notice how Blackrock Mountain is always on fire?'),
(36,1,1,'It''s a volcano.'),
(36,2,0,'But always?'),
(36,3,1,'It''s a very committed volcano.'),
(36,4,2,'That''s one way to put it.'),
(36,5,0,'It''s the only way.'),

-- 37 (12, Alliance, 3) Boy king
(37,0,0,'You think the king''s okay?'),
(37,1,1,'He''s a kid.'),
(37,2,0,'He''s a kid king.'),
(37,3,1,'That''s a lot of pressure.'),
(37,4,2,'That''s an understatement.'),
(37,5,1,'That''s the whole kingdom.'),

-- 38 (54, neutral, 3) Dinosaurs
(38,0,0,'You ever see a dinosaur up close?'),
(38,1,1,'I''ve seen one very up close.'),
(38,2,0,'How close?'),
(38,3,1,'It stepped on my pack.'),
(38,4,2,'That''s not close. That''s nearly dead.'),
(38,5,1,'Same thing.'),

-- 39 (28, neutral, 3) Mages
(39,0,0,'I don''t trust mages.'),
(39,1,1,'Why not?'),
(39,2,0,'They can turn you into a sheep.'),
(39,3,1,'That''s not the worst thing.'),
(39,4,2,'It''s pretty bad.'),
(39,5,0,'It''s temporary.'),
(39,6,2,'Being a sheep is temporary. The memory isn''t.'),

-- 40 (46, neutral, 3) Deserts
(40,0,0,'It''s hot.'),
(40,1,1,'It''s a desert.'),
(40,2,0,'Why are there so many deserts?'),
(40,3,1,'So there can be so many oases.'),
(40,4,2,'That''s poetic.'),
(40,5,0,'I''m thirsty.'),
(40,6,1,'That''s not poetic.'),

-- 41 (58, neutral, 2) Bells
(41,0,0,'You ever hear the bells?'),
(41,1,1,'What bells?'),
(41,2,0,'Exactly.'),
(41,3,1,'That''s not an answer.'),
(41,4,0,'That''s the problem.'),

-- 42 (34, neutral, 2) Scarlet halls
(42,0,0,'They''re very clean for zealots.'),
(42,1,1,'Zealots have time. That''s the problem.'),
(42,2,0,'The floors shine.'),
(42,3,1,'Don''t slip. Dying on a clean floor is embarrassing.'),

-- 43 (18, neutral, 4) Barrens size
(43,0,0,'You ever wonder why the Barrens is so big?'),
(43,1,1,'It''s not that big.'),
(43,2,0,'It''s enormous.'),
(43,3,1,'It''s just empty.'),
(43,4,2,'Empty takes up a lot of space.'),
(43,5,0,'That''s a good point.'),
(43,6,3,'Thank you.'),
(43,7,1,'It''s not a good point.'),
(43,8,3,'It''s a point.'),

-- 44 (58, neutral, 2) Going in circles
(44,0,0,'You ever feel like we''re just... going in circles?'),
(44,1,1,'We are going in circles.'),
(44,2,0,'That''s what I mean.'),
(44,3,1,'Then why did you ask?'),
(44,4,0,'I was hoping you''d say no.'),
(44,5,1,'I''m not going to lie to you.'),

-- 45 (26, neutral, 4) Thinking
(45,0,0,'I''ve been thinking.'),
(45,1,1,'That''s dangerous.'),
(45,2,0,'Everything''s dangerous to you.'),
(45,3,1,'That''s because everything''s dangerous.'),
(45,4,2,'What were you thinking about?'),
(45,5,0,'Food.'),
(45,6,3,'That''s not thinking. That''s craving.'),
(45,7,0,'It''s both.'),

-- 46 (20, neutral, 3) Getting rich
(46,0,0,'You think we''ll ever be rich?'),
(46,1,1,'No.'),
(46,2,0,'That was fast.'),
(46,3,1,'I''ve had time to think about it.'),
(46,4,2,'You could be rich.'),
(46,5,0,'How?'),
(46,6,2,'Loot something expensive.'),
(46,7,1,'That''s not a plan. That''s a wish.'),

-- 47 (14, Alliance, 3) Westfall
(47,0,0,'I don''t like Westfall.'),
(47,1,1,'What''s wrong with Westfall?'),
(47,2,0,'It''s all dust and sad farmers.'),
(47,3,1,'The dust isn''t that bad.'),
(47,4,0,'The farmers are.'),
(47,5,2,'The farmers are fine.'),
(47,6,0,'The farmers are very sad.'),
(47,7,2,'They''re farmers. They''re supposed to be sad.'),

-- 48 (5, Horde, 3) Quillboar
(48,0,0,'I don''t understand why the quillboar are so angry.'),
(48,1,1,'They''re always angry.'),
(48,2,0,'Maybe they have a reason.'),
(48,3,0,'What reason?'),
(48,4,2,'We''re in their home.'),
(48,5,0,'Oh.'),
(48,6,1,'Yeah.'),

-- 49 (28, neutral, 3) Weirdest thing
(49,0,0,'What''s the weirdest thing you''ve ever seen?'),
(49,1,1,'A gnome riding a mechanostrider.'),
(49,2,0,'That''s not weird. That''s normal.'),
(49,3,1,'A gnome riding a mechanostrider backwards.'),
(49,4,0,'That''s weird.'),
(49,5,2,'That''s brave.'),

-- 50 (60, neutral, 2) Silithyst run
(50,0,0,'The silithyst burns if you hold it too long.'),
(50,1,1,'Then don''t hold it. Pour it.'),
(50,2,0,'I wanted to look at it.'),
(50,3,1,'Look from the collector. That''s what it''s for.'),

-- 51 (58, neutral, 3) Retirement
(51,0,0,'You ever think about retiring?'),
(51,1,1,'To what?'),
(51,2,0,'A farm. Somewhere quiet.'),
(51,3,1,'You''d hate a farm.'),
(51,4,2,'I''d love a farm.'),
(51,5,1,'You''d be bored in a week.'),
(51,6,2,'In a day.'),
(51,7,0,'You don''t know me.'),
(51,8,1,'We''ve been adventuring together for years.'),
(51,9,0,'You still don''t know me.'),

-- 52 (10, neutral, 3) First wolf
(52,0,0,'What''s that?'),
(52,1,1,'A wolf.'),
(52,2,0,'Is it friendly?'),
(52,3,1,'No.'),
(52,4,2,'It''s very not friendly.'),
(52,5,0,'Then why are we standing here?'),
(52,6,1,'Good question.'),

-- 53 (50, neutral, 3) Azshara
(53,0,0,'You ever been to Azshara?'),
(53,1,1,'Once.'),
(53,2,0,'What''s it like?'),
(53,3,1,'Autumn.'),
(53,4,2,'That''s a season.'),
(53,5,1,'It''s autumn all the time.'),
(53,6,0,'That''s not natural.'),
(53,7,1,'It''s Azshara. Nothing''s natural.'),

-- 54 (5, Horde, 4) Hungry lowbies
(54,0,0,'I''m hungry.'),
(54,1,1,'You''re always hungry.'),
(54,2,0,'We haven''t eaten since this morning.'),
(54,3,1,'It''s afternoon.'),
(54,4,2,'See? Hours.'),
(54,5,3,'That''s not that long.'),
(54,6,0,'It''s long enough.'),
(54,7,1,'Eat a bread.'),
(54,8,0,'I ate the bread.'),

-- 55 (52, neutral, 4) How many died here
(55,0,0,'You ever think about how many people have died in these places?'),
(55,1,1,'All the time.'),
(55,2,0,'Really?'),
(55,3,1,'No. That was a lie.'),
(55,4,2,'That''s dark.'),
(55,5,1,'It''s honest.'),
(55,6,3,'It''s both.'),
(55,7,0,'I regret asking.'),

-- 56 (60, neutral, 2) Making it
(56,0,0,'We''re not going to make it.'),
(56,1,1,'We''ll make it.'),
(56,2,0,'You don''t know that.'),
(56,3,1,'No. But I''ve been wrong before.'),
(56,4,0,'That''s not reassuring.'),
(56,5,1,'It''s the best I''ve got.'),

-- 57 (60, neutral, 3) Are we the bad guys
(57,0,0,'I''m starting to think we''re the bad guys.'),
(57,1,1,'We''re not the bad guys.'),
(57,2,0,'We break into places and kill everything inside.'),
(57,3,1,'They''re usually evil.'),
(57,4,2,'Usually.'),
(57,5,0,'Mostly.'),
(57,6,1,'Sometimes.'),
(57,7,2,'That''s not comforting.'),

-- 58 (46, neutral, 3) Most money
(58,0,0,'What''s the most money you''ve ever had?'),
(58,1,1,'A hundred gold.'),
(58,2,0,'What did you spend it on?'),
(58,3,1,'A mount.'),
(58,4,2,'Worth it?'),
(58,5,1,'Every copper.'),

-- 59 (36, neutral, 3) Alterac Valley
(59,0,0,'You ever been to Alterac Valley?'),
(59,1,1,'Once.'),
(59,2,0,'How was it?'),
(59,3,1,'Long.'),
(59,4,2,'How long?'),
(59,5,1,'Three days.'),
(59,6,0,'Three days?'),

-- 60 (56, neutral, 3) Forsaken again
(60,0,0,'I don''t like the Forsaken.'),
(60,1,1,'That''s not a popular opinion.'),
(60,2,0,'It''s not an opinion. It''s a feeling.'),
(60,3,1,'Feelings can be wrong.'),
(60,4,2,'So can people.'),
(60,5,1,'That''s fair.'),

-- 61 (12, Alliance, 4) Stormwind cathedral
(61,0,0,'Have you seen the cathedral in Stormwind?'),
(61,1,1,'It''s huge.'),
(61,2,0,'It''s beautiful.'),
(61,3,1,'It''s a lot of stone.'),
(61,4,0,'It''s a lot of faith.'),
(61,5,2,'It''s a lot of both.'),
(61,6,3,'It''s a lot.'),

-- 62 (34, Horde, 2) Do they know
(62,0,0,'You think the Alliance knows we''re not all monsters?'),
(62,1,1,'No.'),
(62,2,0,'That was fast.'),
(62,3,1,'I''ve met the Alliance.'),

-- 63 (60, neutral, 3) What are we fighting for
(63,0,0,'What are we even fighting for?'),
(63,1,1,'Gold.'),
(63,2,0,'Besides gold.'),
(63,3,1,'Gear.'),
(63,4,2,'Besides gear.'),
(63,5,1,'The thrill of it.'),
(63,6,2,'The glory.'),
(63,7,0,'Those are the same thing.'),
(63,8,1,'Then pick one.'),

-- 64 (60, neutral, 4) What comes after
(64,0,0,'You ever wonder what''s after this?'),
(64,1,1,'More of this.'),
(64,2,0,'That''s not what I meant.'),
(64,3,1,'What did you mean?'),
(64,4,0,'After all of it. After the fighting.'),
(64,5,2,'Peace.'),
(64,6,0,'You think?'),
(64,7,3,'No. But it''s a nice thought.'),

-- 65 (20, neutral, 2) Darnassus
(65,0,0,'You ever been to Darnassus?'),
(65,1,1,'Once.'),
(65,2,0,'What''s it like?'),
(65,3,1,'Trees.'),
(65,4,0,'Just trees?'),
(65,5,1,'Very big trees.'),

-- 66 (58, neutral, 3) Dragons
(66,0,0,'You ever seen a dragon?'),
(66,1,1,'Once.'),
(66,2,0,'What did you do?'),
(66,3,1,'Ran.'),
(66,4,2,'Smart.'),
(66,5,1,'It was a very large dragon.'),
(66,6,0,'They''re all large.'),
(66,7,1,'This one was larger.'),

-- 67 (14, Alliance, 3) Goldshire
(67,0,0,'I don''t like Goldshire.'),
(67,1,1,'What''s wrong with Goldshire?'),
(67,2,0,'It''s full of people.'),
(67,3,1,'That''s the point of a town.'),
(67,4,0,'Not that many people.'),
(67,5,2,'It''s a lot.'),
(67,6,1,'It''s too many.'),

-- 68 (34, neutral, 3) Best weapon
(68,0,0,'What''s the best weapon?'),
(68,1,1,'A sword.'),
(68,2,0,'Why?'),
(68,3,1,'It''s reliable.'),
(68,4,2,'A bow is better.'),
(68,5,1,'You have to aim a bow.'),
(68,6,2,'You have to aim a sword.'),
(68,7,1,'Not as much.'),

-- 69 (26, neutral, 3) Going home
(69,0,0,'You ever think about going back home?'),
(69,1,1,'No.'),
(69,2,0,'Why not?'),
(69,3,1,'Nothing''s there.'),
(69,4,2,'Something''s there.'),
(69,5,1,'Nothing worth going back to.'),
(69,6,0,'That''s sad.'),
(69,7,1,'That''s life.'),

-- 70 (58, neutral, 3) Plague cauldron
(70,0,0,'You ever hear the sound of a plague cauldron?'),
(70,1,1,'It bubbles.'),
(70,2,0,'It hums.'),
(70,3,1,'It''s not humming. It''s bubbling.'),
(70,4,2,'It''s humming and bubbling.'),
(70,5,1,'That''s worse.'),
(70,6,2,'Much worse.'),

-- 71 (46, neutral, 3) Sand
(71,0,0,'I hate sand.'),
(71,1,1,'It''s coarse and rough and irritating.'),
(71,2,0,'And it gets everywhere.'),
(71,3,1,'Is that a quote?'),
(71,4,0,'No. It''s a fact.'),
(71,5,2,'It''s a very specific fact.'),

-- 72 (58, neutral, 3) Scourge
(72,0,0,'You ever wonder why the Scourge doesn''t just... leave?'),
(72,1,1,'They''re dead. They don''t leave.'),
(72,2,0,'They could leave.'),
(72,3,1,'They''re not going to.'),
(72,4,2,'Why not?'),
(72,5,0,'They like it here.'),
(72,6,1,'That''s the worst thing I''ve ever heard.'),

-- 73 (42, neutral, 3) Swamp of Sorrows
(73,0,0,'You ever been to the Swamp of Sorrows?'),
(73,1,1,'Once.'),
(73,2,0,'What''s it like?'),
(73,3,1,'Sorrowful.'),
(73,4,2,'That''s the name.'),
(73,5,1,'It earns the name.'),

-- 74 (50, Horde, 2) Revantusk
(74,0,0,'Revantusk Village hangs on the cliff like a dare.'),
(74,1,1,'Trolls like dares.'),
(74,2,0,'The forest trolls don''t.'),
(74,3,1,'That''s why it''s a dare.'),

-- 75 (46, neutral, 3) The plan
(75,0,0,'What''s the plan?'),
(75,1,1,'Kill everything.'),
(75,2,0,'That''s not a plan. That''s a goal.'),
(75,3,1,'Kill everything carefully.'),
(75,4,2,'That''s a plan.'),
(75,5,0,'That''s barely a plan.'),

-- 76 (60, neutral, 4) Running out of time
(76,0,0,'You ever feel like we''re running out of time?'),
(76,1,1,'All the time.'),
(76,2,0,'What do we do about it?'),
(76,3,1,'Run faster.'),
(76,4,2,'Or stop running.'),
(76,5,0,'That''s not helpful.'),
(76,6,3,'It''s an option.'),

-- 77 (46, neutral, 2) Blasted Lands
(77,0,0,'Nothing grows.'),
(77,1,1,'That''s the point of a blasting.'),
(77,2,0,'How do people live at Nethergarde?'),
(77,3,1,'Badly. And on purpose.'),

-- 78 (46, neutral, 3) Other side of portal
(78,0,0,'You think we''ll ever see the other side of the portal?'),
(78,1,1,'No.'),
(78,2,0,'Why not?'),
(78,3,1,'It''s closed.'),
(78,4,2,'Closed doesn''t mean forever.'),
(78,5,1,'It does if you''re patient enough.'),

-- 79 (16, Horde, 3) Undercity
(79,0,0,'I don''t like the Undercity.'),
(79,1,1,'Nobody likes the Undercity.'),
(79,2,0,'The Forsaken like the Undercity.'),
(79,3,1,'The Forsaken are dead.'),
(79,4,2,'That''s why they like it.'),

-- 80 (5, Horde, 3) Shaman
(80,0,0,'What''s a shaman?'),
(80,1,1,'Someone who talks to the elements.'),
(80,2,0,'Do the elements talk back?'),
(80,3,1,'Sometimes.'),
(80,4,0,'What do they say?'),
(80,5,2,'Mostly ''stop.'''),

-- 81 (5, Horde, 3) Warlock
(81,0,0,'What''s a warlock?'),
(81,1,1,'Someone who makes bad decisions.'),
(81,2,0,'What kind of bad decisions?'),
(81,3,1,'Demons.'),
(81,4,0,'That sounds cool.'),
(81,5,2,'It''s not.'),
(81,6,1,'It''s a little cool.'),

-- 82 (46, neutral, 2) Silithid hole
(82,0,0,'Don''t look in the hole.'),
(82,1,1,'I looked.'),
(82,2,0,'And?'),
(82,3,1,'It''s a hole with more hole under it. Happy?'),

-- 83 (32, neutral, 3) Windmill
(83,0,0,'You ever wonder why the windmill is always turning?'),
(83,1,1,'It''s windy.'),
(83,2,0,'But always?'),
(83,3,1,'It''s a very windy place.'),
(83,4,2,'That''s why they put a windmill there.'),
(83,5,0,'That''s circular logic.'),
(83,6,2,'It''s a windmill. That''s the point.'),

-- 84 (30, neutral, 3) Allergies
(84,0,0,'I think I''m allergic to something in this cave.'),
(84,1,1,'You''re allergic to work.'),
(84,2,0,'That''s not a real allergy.'),
(84,3,1,'It is for him.'),
(84,4,2,'It''s very real.'),

-- 85 (60, neutral, 3) Bugs watching
(85,0,0,'You ever feel like the bugs are watching us?'),
(85,1,1,'They are watching us.'),
(85,2,0,'That''s not comforting.'),
(85,3,1,'It''s not meant to be.'),
(85,4,2,'Everything you say is not meant to be comforting.'),
(85,5,1,'That''s true.'),

-- 86 (40, neutral, 2) Uldaman
(86,0,0,'You ever wonder who built Uldaman?'),
(86,1,1,'Titans.'),
(86,2,0,'You think?'),
(86,3,1,'I think that''s what everyone thinks.'),
(86,4,0,'What do you think?'),
(86,5,1,'I think it was someone very tall.'),

-- 87 (56, neutral, 3) Blackrock heat
(87,0,0,'You ever get used to the heat?'),
(87,1,1,'No.'),
(87,2,0,'Me neither.'),
(87,3,1,'You get used to the smell.'),
(87,4,2,'What smell?'),
(87,5,1,'Exactly.'),

-- 88 (40, neutral, 3) Faerie dragons
(88,0,0,'You ever see a faerie dragon?'),
(88,1,1,'They''re tiny.'),
(88,2,0,'They''re magical.'),
(88,3,1,'They''re thieves.'),
(88,4,0,'They''re magical thieves.'),
(88,5,2,'That''s the worst kind.'),

-- 89 (18, neutral, 2) Ratchet dock
(89,0,0,'The tide in Ratchet smells like tar.'),
(89,1,1,'That''s commerce.'),
(89,2,0,'I thought commerce smelled like gold.'),
(89,3,1,'Gold doesn''t smell. Tar does. Follow the tar.'),

-- 90 (50, Horde, 3) Alliance never leaves
(90,0,0,'You think the Alliance will ever leave us alone?'),
(90,1,1,'No.'),
(90,2,0,'Why not?'),
(90,3,1,'Because we won''t leave them alone.'),
(90,4,2,'That''s fair.'),

-- 91 (50, neutral, 3) Worst food
(91,0,0,'What''s the worst thing you''ve ever eaten?'),
(91,1,1,'Cave mushrooms.'),
(91,2,0,'Those aren''t that bad.'),
(91,3,1,'Cave mushrooms from a plague cave.'),
(91,4,2,'That''s different.'),
(91,5,1,'That''s what I said.'),

-- 92 (44, neutral, 2) ZF mallet
(92,0,0,'We need the mallet.'),
(92,1,1,'For the gong.'),
(92,2,0,'For the troll who owns the gong.'),
(92,3,1,'Same errand. Don''t drop it. It''s rude and loud.'),

-- 93 (60, neutral, 3) Stratholme
(93,0,0,'You ever think about Stratholme?'),
(93,1,1,'All the time.'),
(93,2,0,'Why?'),
(93,3,1,'Because it''s still there.'),
(93,4,2,'It''s not going anywhere.'),
(93,5,1,'That''s the problem.'),

-- 94 (60, neutral, 3) Onyxia's Lair
(94,0,0,'You ever been to Onyxia''s Lair?'),
(94,1,1,'Once.'),
(94,2,0,'How was it?'),
(94,3,1,'Loud.'),
(94,4,2,'Loud?'),
(94,5,1,'She roars.'),
(94,6,2,'That''s fair.'),

-- 95 (24, neutral, 3) Blackfathom
(95,0,0,'You ever been to Blackfathom Deeps?'),
(95,1,1,'Once.'),
(95,2,0,'What''s down there?'),
(95,3,1,'Water.'),
(95,4,2,'And fish.'),
(95,5,1,'Big fish.'),

-- 96 (14, Alliance, 4) Want to see a dragon
(96,0,0,'I want to see a dragon.'),
(96,1,1,'No you don''t.'),
(96,2,0,'I do.'),
(96,3,1,'You really don''t.'),
(96,4,2,'You really, really don''t.'),
(96,5,0,'Why not?'),
(96,6,1,'Because they''re big and angry.'),
(96,7,2,'And they breathe fire.'),
(96,8,3,'And they eat people.'),
(96,9,0,'I still want to see one.'),

-- 97 (24, neutral, 3) Threat meter
(97,0,0,'Stop hitting the thing I''m hitting.'),
(97,1,1,'I''m helping.'),
(97,2,0,'You''re helping it look at you.'),
(97,3,1,'I can take it.'),
(97,4,2,'You couldn''t take lunch. Let the shield do the work.'),

-- 98 (58, neutral, 3) Being followed
(98,0,0,'You ever feel like you''re being followed?'),
(98,1,1,'In the Plaguelands?'),
(98,2,0,'Anywhere.'),
(98,3,1,'That''s paranoia.'),
(98,4,2,'It''s not paranoia if it''s true.'),
(98,5,1,'In the Plaguelands it''s true.'),
(98,6,2,'In the Plaguelands everything''s true.'),

-- 99 (18, neutral, 3) Redridge fish
(99,0,0,'You ever notice how the fish in Redridge are always jumping?'),
(99,1,1,'That''s what fish do.'),
(99,2,0,'But always?'),
(99,3,1,'It''s a very active lake.'),
(99,4,2,'It''s a very fishy lake.'),
(99,5,0,'That''s not a word.'),
(99,6,2,'It is now.'),

-- 100 (32, neutral, 4) Scariest thing
(100,0,0,'What''s the scariest thing you''ve ever seen?'),
(100,1,1,'A gnoll.'),
(100,2,0,'A gnoll?'),
(100,3,1,'A very big gnoll.'),
(100,4,2,'Gnolls aren''t scary.'),
(100,5,1,'This one was.'),
(100,6,3,'I believe you.'),
(100,7,1,'Thank you.');

INSERT INTO `companion_banter_line` (`script_id`,`line_index`,`speaker_slot`,`text`) VALUES
-- 101 (52, neutral, 3) Burning Steppes
(101,0,0,'You ever seen a mountain that''s also a volcano?'),
(101,1,1,'Blackrock.'),
(101,2,0,'Besides Blackrock.'),
(101,3,1,'Just Blackrock.'),
(101,4,2,'There''s only one.'),
(101,5,0,'That''s enough.'),

-- 102 (54, neutral, 3) Un'Goro
(102,0,0,'You ever been to Un''Goro?'),
(102,1,1,'Once.'),
(102,2,0,'What''s it like?'),
(102,3,1,'Dinosaurs and crystals.'),
(102,4,2,'That sounds made up.'),
(102,5,1,'It''s not.'),
(102,6,2,'I know it''s not. That''s why I said it sounds made up.'),

-- 103 (44, neutral, 3) Searing Gorge
(103,0,0,'You ever leave your gloves near a forge vent?'),
(103,1,1,'Once.'),
(103,2,0,'What happened?'),
(103,3,1,'They became part of the vent.'),
(103,4,2,'That''s not how gloves work.'),
(103,5,1,'It is now.'),

-- 104 (60, neutral, 3) Moonglade
(104,0,0,'You ever been to Moonglade?'),
(104,1,1,'Once.'),
(104,2,0,'What''s it like?'),
(104,3,1,'Quiet.'),
(104,4,2,'It''s a druid place.'),
(104,5,1,'Very quiet.'),
(104,6,2,'Druids are quiet.'),
(104,7,1,'Not that quiet.'),

-- 105 (44, neutral, 2) Maraudon colors
(105,0,0,'Orange or purple?'),
(105,1,1,'That''s not a fashion question.'),
(105,2,0,'It is if you pick wrong.'),
(105,3,1,'Then pick the one that smells less like poison. That''s orange. I think.'),

-- 106 (46, neutral, 3) Tanaris
(106,0,0,'You ever been to Tanaris?'),
(106,1,1,'Once.'),
(106,2,0,'What''s it like?'),
(106,3,1,'Sand.'),
(106,4,2,'Just sand?'),
(106,5,1,'Sand and pirates.'),

-- 107 (34, neutral, 3) Hinterlands
(107,0,0,'You ever been to the Hinterlands?'),
(107,1,1,'Once.'),
(107,2,0,'What''s it like?'),
(107,3,1,'Green.'),
(107,4,2,'That''s it?'),
(107,5,1,'Green and trolls.'),

-- 108 (28, neutral, 2) Thousand Needles
(108,0,0,'You ever been to Thousand Needles?'),
(108,1,1,'Once.'),
(108,2,0,'What''s it like?'),
(108,3,1,'Up.'),
(108,4,0,'Up?'),
(108,5,1,'Everything''s up. Cliffs. Bridges. Everything.'),

-- 109 (46, neutral, 3) Tanaris again
(109,0,0,'You ever buy water in Tanaris?'),
(109,1,1,'Once.'),
(109,2,0,'How much did it cost?'),
(109,3,1,'Everything.'),
(109,4,2,'That''s not a price.'),
(109,5,1,'It is in Tanaris.'),

-- 110 (48, neutral, 3) Aerie Peak
(110,0,0,'You ever been to Aerie Peak?'),
(110,1,1,'Once.'),
(110,2,0,'What''s it like?'),
(110,3,1,'Windy.'),
(110,4,2,'And?'),
(110,5,1,'Windy and gryphons.'),

-- 111 (60, neutral, 2) UBRS
(111,0,0,'You ever been to Upper Blackrock Spire?'),
(111,1,1,'Once.'),
(111,2,0,'How was it?'),
(111,3,1,'Hot.'),
(111,4,0,'And?'),
(111,5,1,'Hot and full of orcs.'),

-- 112 (48, neutral, 3) Felwood
(112,0,0,'You ever been to Felwood?'),
(112,1,1,'Once.'),
(112,2,0,'What''s it like?'),
(112,3,1,'Sick.'),
(112,4,2,'The trees?'),
(112,5,1,'The trees. The animals. The air.'),

-- 113 (48, neutral, 4) Aerie Peak again
(113,0,0,'You ever wonder why they built Aerie Peak so high?'),
(113,1,1,'Defense.'),
(113,2,0,'From what?'),
(113,3,1,'Everything.'),
(113,4,2,'That''s not specific.'),
(113,5,3,'Everything is specific enough.'),
(113,6,0,'It''s really not.'),

-- 114 (5, Horde, 3) Tirisfal
(114,0,0,'You ever been to Tirisfal Glades?'),
(114,1,1,'I live there.'),
(114,2,0,'You live there?'),
(114,3,1,'Everyone lives there.'),
(114,4,0,'Not everyone.'),
(114,5,2,'The Forsaken live there.'),
(114,6,0,'I''m not Forsaken.'),
(114,7,1,'You are now.'),

-- 115 (42, neutral, 3) Swamp of Sorrows
(115,0,0,'You ever been to the Swamp of Sorrows?'),
(115,1,1,'Once.'),
(115,2,0,'What''s it like?'),
(115,3,1,'Wet.'),
(115,4,2,'And?'),
(115,5,1,'Wet and sad.'),

-- 116 (34, neutral, 2) Hinterlands again
(116,0,0,'You ever wonder why there are so many trolls in the Hinterlands?'),
(116,1,1,'They live there.'),
(116,2,0,'But so many?'),
(116,3,1,'They''re very social.'),

-- 117 (60, neutral, 2) AQ gate rumor
(117,0,0,'They say the gate will open when the bells have been enough.'),
(117,1,1,'Bells don''t open gates. Armies do.'),
(117,2,0,'Armies with bells.'),
(117,3,1,'Fine. Armies with bells. Bring a hammer either way.'),

-- 118 (13, Horde, 3) RFC
(118,0,0,'You ever been to Ragefire Chasm?'),
(118,1,1,'Once.'),
(118,2,0,'What''s it like?'),
(118,3,1,'Hot.'),
(118,4,2,'And?'),
(118,5,1,'Hot and full of cultists.'),

-- 119 (10, neutral, 4) Darkshore
(119,0,0,'You ever been to Darkshore?'),
(119,1,1,'Once.'),
(119,2,0,'What''s it like?'),
(119,3,1,'Dark.'),
(119,4,2,'And?'),
(119,5,1,'Dark and shore-y.'),
(119,6,3,'That''s not a word.'),
(119,7,1,'It is now.'),

-- 120 (60, neutral, 3) UBRS again
(120,0,0,'You ever wonder why they call it Upper Blackrock Spire?'),
(120,1,1,'Because it''s the upper part.'),
(120,2,0,'But it''s still Blackrock Spire.'),
(120,3,1,'It''s the upper part of Blackrock Spire.'),
(120,4,2,'That''s what I said.'),
(120,5,1,'Then why did you ask?'),
(120,6,2,'I was hoping for a better answer.'),

-- 121 (22, Alliance, 4) Ironforge
(121,0,0,'You ever been to Ironforge?'),
(121,1,1,'Once.'),
(121,2,0,'What''s it like?'),
(121,3,1,'Loud.'),
(121,4,2,'And?'),
(121,5,1,'Loud and full of dwarves.'),
(121,6,3,'That''s the point of Ironforge.'),
(121,7,1,'It''s a lot of point.'),

-- 122 (48, neutral, 3) Maraudon
(122,0,0,'You ever been to Maraudon?'),
(122,1,1,'Once.'),
(122,2,0,'What''s it like?'),
(122,3,1,'Wet.'),
(122,4,2,'And?'),
(122,5,1,'Wet and full of centaurs.'),

-- 123 (28, neutral, 3) Soulstone talk
(123,0,0,'If I die, use the stone.'),
(123,1,1,'I know.'),
(123,2,0,'Don''t loot me first.'),
(123,3,1,'I know that too.'),
(123,4,2,'He does not know that.'),

-- 124 (24, neutral, 3) Ashenvale
(124,0,0,'You ever been to Ashenvale?'),
(124,1,1,'Once.'),
(124,2,0,'What''s it like?'),
(124,3,1,'Green.'),
(124,4,2,'And?'),
(124,5,1,'Green and quiet.'),

-- 125 (60, neutral, 3) Silithus
(125,0,0,'You ever been to Silithus?'),
(125,1,1,'Once.'),
(125,2,0,'What''s it like?'),
(125,3,1,'Sand.'),
(125,4,2,'And?'),
(125,5,1,'Sand and bugs.'),

-- 126 (5, Horde, 2) Durotar
(126,0,0,'You ever been to Durotar?'),
(126,1,1,'I live there.'),
(126,2,0,'What''s it like?'),
(126,3,1,'Red.'),

-- 127 (24, Alliance, 2) Stockade
(127,0,0,'You ever been to the Stockade?'),
(127,1,1,'Once.'),
(127,2,0,'What''s it like?'),
(127,3,1,'Full of people who don''t want to be there.'),

-- 128 (20, neutral, 2) Deadmines
(128,0,0,'You ever been to the Deadmines?'),
(128,1,1,'Once.'),
(128,2,0,'What''s it like?'),
(128,3,1,'Mine-y.'),

-- 129 (5, neutral, 2) Goldshire
(129,0,0,'You ever been to Goldshire?'),
(129,1,1,'Once.'),
(129,2,0,'What''s it like?'),
(129,3,1,'Full of people.'),

-- 130 (60, neutral, 3) Stratholme
(130,0,0,'You ever been to Stratholme?'),
(130,1,1,'Once.'),
(130,2,0,'What''s it like?'),
(130,3,1,'Dead.'),
(130,4,2,'And?'),
(130,5,1,'Dead and on fire.'),

-- 131 (24, neutral, 4) Ashenvale again
(131,0,0,'You ever wonder why Ashenvale is so dark?'),
(131,1,1,'It''s the trees.'),
(131,2,0,'The trees?'),
(131,3,1,'Big trees. Lots of them.'),
(131,4,2,'That''s how forests work.'),
(131,5,3,'It''s very dark for a forest.'),
(131,6,0,'It''s a very big forest.'),

-- 132 (60, neutral, 3) Silithus again
(132,0,0,'You ever wonder why Silithus is so empty?'),
(132,1,1,'It''s a desert.'),
(132,2,0,'There are deserts with people.'),
(132,3,1,'Not this one.'),
(132,4,2,'Why not?'),
(132,5,1,'The bugs.'),

-- 133 (26, neutral, 3) Duskwood
(133,0,0,'You ever been to Duskwood?'),
(133,1,1,'Once.'),
(133,2,0,'What''s it like?'),
(133,3,1,'Dark.'),
(133,4,2,'And?'),
(133,5,1,'Dark and full of things that shouldn''t be there.'),

-- 134 (32, neutral, 3) Razorfen
(134,0,0,'You ever been to Razorfen Kraul?'),
(134,1,1,'Once.'),
(134,2,0,'What''s it like?'),
(134,3,1,'Spiky.'),
(134,4,2,'And?'),
(134,5,1,'Spiky and full of pigs.'),

-- 135 (14, Alliance, 3) Westfall lighthouse
(135,0,0,'The lighthouse at the Westfall coast is still lit.'),
(135,1,1,'Who''s lighting it?'),
(135,2,0,'Someone who hasn''t given up on ships.'),
(135,3,1,'Or someone who likes fire.'),
(135,4,2,'Could be both.'),

-- 136 (12, Alliance, 3) Northshire
(136,0,0,'You ever been to Northshire?'),
(136,1,1,'Once.'),
(136,2,0,'What''s it like?'),
(136,3,1,'Green.'),
(136,4,2,'And?'),
(136,5,1,'Green and full of wolves.'),

-- 137 (26, neutral, 3) Hillsbrad
(137,0,0,'You ever been to Hillsbrad?'),
(137,1,1,'Once.'),
(137,2,0,'What''s it like?'),
(137,3,1,'Hilly.'),
(137,4,2,'And?'),
(137,5,1,'Hilly and full of yetis.'),

-- 138 (60, neutral, 2) Naxx rumor
(138,0,0,'People talk about Naxxramas like it''s a weather report.'),
(138,1,1,'It''s a necropolis. Treat it like one.'),
(138,2,0,'Have you been close?'),
(138,3,1,'Close enough to stop talking like it''s weather.'),

-- 139 (60, neutral, 4) Scholomance
(139,0,0,'You ever been to Scholomance?'),
(139,1,1,'Once.'),
(139,2,0,'What''s it like?'),
(139,3,1,'Quiet.'),
(139,4,2,'It''s a school.'),
(139,5,1,'A very quiet school.'),
(139,6,3,'That''s the problem.'),

-- 140 (20, neutral, 3) Wailing Caverns
(140,0,0,'You ever been to Wailing Caverns?'),
(140,1,1,'Once.'),
(140,2,0,'What''s it like?'),
(140,3,1,'Wet.'),
(140,4,2,'And?'),
(140,5,1,'Wet and full of druids.'),

-- 141 (58, neutral, 3) Western Plaguelands
(141,0,0,'You ever been to the Western Plaguelands?'),
(141,1,1,'Once.'),
(141,2,0,'What''s it like?'),
(141,3,1,'Dead.'),
(141,4,2,'And?'),
(141,5,1,'Dead and grey.'),

-- 142 (60, neutral, 4) Moonglade again
(142,0,0,'You ever wonder why Moonglade is always night?'),
(142,1,1,'It''s not always night.'),
(142,2,0,'It feels like always night.'),
(142,3,1,'It''s the trees.'),
(142,4,2,'The trees again?'),
(142,5,3,'It''s always the trees.'),

-- 143 (20, neutral, 4) Gnomeregan
(143,0,0,'You ever been to Gnomeregan?'),
(143,1,1,'Once.'),
(143,2,0,'What''s it like?'),
(143,3,1,'Green.'),
(143,4,2,'Green?'),
(143,5,1,'Radioactive green.'),
(143,6,3,'That''s worse.'),

-- 144 (48, neutral, 2) Felwood again
(144,0,0,'You ever wonder why Felwood is so sick?'),
(144,1,1,'The Burning Legion.'),
(144,2,0,'That''s the answer to most things.'),
(144,3,1,'It''s a very good answer.'),

-- 145 (32, neutral, 3) Razorfen again
(145,0,0,'You ever wonder why the quilboar are so angry?'),
(145,1,1,'They''re always angry.'),
(145,2,0,'But why?'),
(145,3,1,'They''re quilboar.'),
(145,4,2,'That''s not a reason.'),
(145,5,1,'It''s a very good reason.'),

-- 146 (60, neutral, 2) MC douse
(146,0,0,'They want us to douse runes in a fire elemental''s house.'),
(146,1,1,'That''s the job.'),
(146,2,0,'That''s a contradiction.'),
(146,3,1,'So is adventuring. Bring water anyway.'),

-- 147 (5, Alliance, 4) Dun Morogh
(147,0,0,'You ever been to Dun Morogh?'),
(147,1,1,'Once.'),
(147,2,0,'What''s it like?'),
(147,3,1,'Cold.'),
(147,4,2,'And?'),
(147,5,1,'Cold and full of dwarves.'),
(147,6,3,'That''s the point.'),

-- 148 (12, Horde, 3) Echo Isles
(148,0,0,'You ever been to the Echo Isles?'),
(148,1,1,'Once.'),
(148,2,0,'What''s it like?'),
(148,3,1,'Wet.'),
(148,4,2,'And?'),
(148,5,1,'Wet and full of trolls.'),

-- 149 (42, Horde, 3) Thunder Bluff
(149,0,0,'You ever been to Thunder Bluff?'),
(149,1,1,'Once.'),
(149,2,0,'What''s it like?'),
(149,3,1,'High.'),
(149,4,2,'And?'),
(149,5,1,'High and full of tauren.'),

-- 150 (30, neutral, 3) Stranglethorn
(150,0,0,'You ever been to Stranglethorn?'),
(150,1,1,'Once.'),
(150,2,0,'What''s it like?'),
(150,3,1,'Green.'),
(150,4,2,'And?'),
(150,5,1,'Green and full of tigers.'),

-- 151 (56, neutral, 3) Dire Maul
(151,0,0,'You ever been to Dire Maul?'),
(151,1,1,'Once.'),
(151,2,0,'What''s it like?'),
(151,3,1,'Old.'),
(151,4,2,'And?'),
(151,5,1,'Old and full of ghosts.'),

-- 152 (5, neutral, 3) Elwynn
(152,0,0,'You ever been to Elwynn Forest?'),
(152,1,1,'Once.'),
(152,2,0,'What''s it like?'),
(152,3,1,'Green.'),
(152,4,2,'And?'),
(152,5,1,'Green and full of trees.'),

-- 153 (26, neutral, 3) Hillsbrad again
(153,0,0,'You ever wonder why Hillsbrad is so contested?'),
(153,1,1,'It''s between two factions.'),
(153,2,0,'Everything''s between two factions.'),
(153,3,1,'This one more than most.'),
(153,4,2,'That''s fair.'),

-- 154 (40, neutral, 3) Feralas
(154,0,0,'You ever been to Feralas?'),
(154,1,1,'Once.'),
(154,2,0,'What''s it like?'),
(154,3,1,'Green.'),
(154,4,2,'And?'),
(154,5,1,'Green and full of ogres.'),

-- 155 (12, Alliance, 2) Loch Modan
(155,0,0,'You ever been to Loch Modan?'),
(155,1,1,'Once.'),
(155,2,0,'What''s it like?'),
(155,3,1,'Wet.'),

-- 156 (10, neutral, 2) Flight path ledger
(156,0,0,'The flight master made me watch him write my name.'),
(156,1,1,'That''s the ledger. That''s how you don''t fall off the map.'),
(156,2,0,'He misspelled it.'),
(156,3,1,'Then you''re on the map twice. Lucky.'),

-- 157 (60, neutral, 2) Baron window
(157,0,0,'Forty-five minutes.'),
(157,1,1,'That''s not a conversation. That''s a clock.'),
(157,2,0,'That''s Stratholme.'),
(157,3,1,'Then stop talking and start the clock.'),

-- 158 (40, neutral, 3) Razorfen Downs
(158,0,0,'You ever been to Razorfen Downs?'),
(158,1,1,'Once.'),
(158,2,0,'What''s it like?'),
(158,3,1,'Dead.'),
(158,4,2,'And?'),
(158,5,1,'Dead and full of pigs.'),

-- 159 (44, neutral, 2) Zul'Farrak heat
(159,0,0,'The sand gets into the armor seams.'),
(159,1,1,'That''s the pyramid defending itself.'),
(159,2,0,'I want a bath.'),
(159,3,1,'There''s a pool. I wouldn''t.'),

-- 160 (58, neutral, 2) War effort cloth
(160,0,0,'They asked for more wool.'),
(160,1,1,'They always ask for more wool.'),
(160,2,0,'I gave them silk.'),
(160,3,1,'Then you''re someone''s favorite. Don''t get used to it.'),

-- 161 (34, Horde, 2) Orgrimmar
(161,0,0,'You ever been to Orgrimmar?'),
(161,1,1,'I live there.'),
(161,2,0,'What''s it like?'),
(161,3,1,'Hot.'),

-- 162 (20, neutral, 3) Southshore
(162,0,0,'You ever been to Southshore?'),
(162,1,1,'Once.'),
(162,2,0,'What''s it like?'),
(162,3,1,'Wet.'),
(162,4,2,'And?'),
(162,5,1,'Wet and full of murlocs.'),

-- 163 (24, Alliance, 3) Stockade again
(163,0,0,'You ever wonder why the Stockade is always full?'),
(163,1,1,'It''s a prison.'),
(163,2,0,'But always?'),
(163,3,1,'There are always criminals.'),
(163,4,2,'That''s fair.'),

-- 164 (18, neutral, 3) Redridge again
(164,0,0,'You ever wonder why Redridge has so many gnolls?'),
(164,1,1,'It''s a border zone.'),
(164,2,0,'Everything''s a border zone.'),
(164,3,1,'This one more than most.'),
(164,4,2,'That''s fair.'),

-- 165 (24, neutral, 3) Blackfathom again
(165,0,0,'You ever wonder what''s at the bottom of Blackfathom?'),
(165,1,1,'Water.'),
(165,2,0,'Besides water.'),
(165,3,1,'More water.'),
(165,4,2,'That''s not helpful.'),
(165,5,1,'It''s honest.'),

-- 166 (20, neutral, 3) Wetlands
(166,0,0,'You ever been to the Wetlands?'),
(166,1,1,'Once.'),
(166,2,0,'What''s it like?'),
(166,3,1,'Wet.'),
(166,4,2,'And?'),
(166,5,1,'Wet and full of orcs.'),

-- 167 (22, neutral, 3) Shadowfang
(167,0,0,'You ever been to Shadowfang Keep?'),
(167,1,1,'Once.'),
(167,2,0,'What''s it like?'),
(167,3,1,'Dark.'),
(167,4,2,'And?'),
(167,5,1,'Dark and full of worgen.'),

-- 168 (13, Horde, 2) RFC again
(168,0,0,'You ever been to Ragefire Chasm?'),
(168,1,1,'Once.'),
(168,2,0,'What''s it like?'),
(168,3,1,'Hot.'),

-- 169 (5, Alliance, 2) Elwynn again
(169,0,0,'You ever been to Elwynn?'),
(169,1,1,'Once.'),
(169,2,0,'What''s it like?'),
(169,3,1,'Green.'),

-- 170 (20, neutral, 2) Duskwood again
(170,0,0,'You ever been to Duskwood?'),
(170,1,1,'Once.'),
(170,2,0,'What''s it like?'),
(170,3,1,'Dark.'),

-- 171 (60, neutral, 2) Silithus camp
(171,0,0,'The tents here are losing to the wind.'),
(171,1,1,'Tighten the stakes. That''s the whole war.'),
(171,2,0,'I thought the war was bugs.'),
(171,3,1,'The bugs can wait five minutes. The tent can''t.'),

-- 172 (60, neutral, 2) Scholomance again
(172,0,0,'You ever wonder why Scholomance has so many books?'),
(172,1,1,'It''s a school.'),
(172,2,0,'But so many?'),
(172,3,1,'It''s a very committed school.'),

-- 173 (28, neutral, 2) Gnomeregan again
(173,0,0,'You ever wonder why Gnomeregan is so radioactive?'),
(173,1,1,'Bad decisions.'),
(173,2,0,'What kind of bad decisions?'),
(173,3,1,'Gnome kind.'),

-- 174 (5, Alliance, 3) Northshire bells
(174,0,0,'The abbey bells never stop.'),
(174,1,1,'They''re calling workers, not heroes.'),
(174,2,0,'I thought they were for us.'),
(174,3,1,'You can think that if it helps you swing.'),
(174,4,2,'It helped me.'),

-- 175 (10, neutral, 2) Westfall
(175,0,0,'You ever wonder why Westfall is so dusty?'),
(175,1,1,'It''s a field.'),
(175,2,0,'It''s a dust field.'),
(175,3,1,'It''s a very committed dust field.'),

-- 176 (24, neutral, 2) Paladin bubble
(176,0,0,'He just stood there in a golden shell.'),
(176,1,1,'That''s the point of the shell.'),
(176,2,0,'We were dying.'),
(176,3,1,'He was scheduling not dying. There''s a difference.'),

-- 177 (48, neutral, 3) Felwood sludge
(177,0,0,'Don''t step in the green.'),
(177,1,1,'All of it''s green.'),
(177,2,0,'The greener green.'),
(177,3,1,'That''s not a map. That''s a prayer.'),
(177,4,2,'Prayers work. Sometimes. Step around it.'),

-- 178 (26, neutral, 2) Bad compass
(178,0,0,'The compass is spinning.'),
(178,1,1,'Then the mountain is lying.'),
(178,2,0,'Mountains don''t lie.'),
(178,3,1,'This one has iron in its blood. Walk by the sun.'),

-- 179 (58, neutral, 2) Blackrock key
(179,0,0,'We still need the key.'),
(179,1,1,'We always need a key.'),
(179,2,0,'This one''s in a city that hates us.'),
(179,3,1,'Then we ask politely. With a raid.'),

-- 180 (5, Horde, 2) Mulgore
(180,0,0,'You ever wonder why Mulgore is so green?'),
(180,1,1,'It''s a plain.'),
(180,2,0,'But so green?'),
(180,3,1,'It''s a very committed plain.'),

-- 181 (32, neutral, 2) Razorfen Kraul yet again
(181,0,0,'You ever wonder why Razorfen Kraul is so spiky?'),
(181,1,1,'It''s a thorn bush.'),
(181,2,0,'But so spiky?'),
(181,3,1,'It''s a very committed thorn bush.'),

-- 182 (20, neutral, 2) Bank alt
(182,0,0,'I sent the extra cloth to the bank.'),
(182,1,1,'Did you remember which bank?'),
(182,2,0,'There''s more than one?'),
(182,3,1,'There''s always more than one. That''s the lesson.'),

-- 183 (36, neutral, 2) Dustwallow
(183,0,0,'You ever wonder why Dustwallow is so foggy?'),
(183,1,1,'It''s a marsh.'),
(183,2,0,'But so foggy?'),
(183,3,1,'It''s a very committed marsh.'),

-- 184 (16, Horde, 2) Silverpine again
(184,0,0,'You ever wonder why Silverpine is so dark?'),
(184,1,1,'It''s a pine forest.'),
(184,2,0,'But so dark?'),
(184,3,1,'It''s a very committed pine forest.'),

-- 185 (58, neutral, 2) Scholo viewing
(185,0,0,'The viewing room is the worst name in the Scholomance.'),
(185,1,1,'You viewed it.'),
(185,2,0,'I viewed too much.'),
(185,3,1,'That''s the curriculum.'),

-- 186 (28, neutral, 2) Gnomeregan signs
(186,0,0,'The sign said safe in three languages and probably in a fourth.'),
(186,1,1,'That''s gnomish for run.'),
(186,2,0,'We ran.'),
(186,3,1,'Then you speak the language.'),

-- 187 (40, neutral, 2) Sunburn
(187,0,0,'My neck is cooked.'),
(187,1,1,'That''s Tanaris. It does that.'),
(187,2,0,'I want a hat.'),
(187,3,1,'You wanted a shortcut. The hat was the shortcut.'),

-- 188 (18, neutral, 2) Wailing Caverns
(188,0,0,'You ever wonder why Wailing Caverns has so many raptors?'),
(188,1,1,'It''s a cave.'),
(188,2,0,'But so many?'),
(188,3,1,'It''s a very committed cave.'),

-- 189 (12, Horde, 2) Echo Isles again
(189,0,0,'You ever wonder why Echo Isles has so many trolls?'),
(189,1,1,'It''s a troll island.'),
(189,2,0,'But so many?'),
(189,3,1,'It''s a very committed troll island.'),

-- 190 (18, neutral, 2) Wailing drums
(190,0,0,'The drums in the Caverns don''t keep time.'),
(190,1,1,'They''re not for us.'),
(190,2,0,'Who are they for?'),
(190,3,1,'Whatever''s still dreaming down here. Walk softly.'),

-- 191 (58, neutral, 2) LBRS again
(191,0,0,'You ever wonder why LBRS has so many ropes?'),
(191,1,1,'It''s a spire.'),
(191,2,0,'But so many?'),
(191,3,1,'It''s a very committed spire.'),

-- 192 (8, Alliance, 2) Stormwind
(192,0,0,'You ever wonder why Stormwind has so many canals?'),
(192,1,1,'It''s a city.'),
(192,2,0,'But so many?'),
(192,3,1,'It''s a very committed city.'),

-- 193 (50, neutral, 2) Temple of Atal'Hakkar
(193,0,0,'You ever wonder why the Temple of Atal''Hakkar is so green?'),
(193,1,1,'It''s a swamp.'),
(193,2,0,'But so green?'),
(193,3,1,'It''s a very committed swamp.'),

-- 194 (60, neutral, 3) Stratholme again
(194,0,0,'You ever wonder why Stratholme has so many undead?'),
(194,1,1,'It''s a plague city.'),
(194,2,0,'But so many?'),
(194,3,1,'It''s a very committed plague city.'),
(194,4,2,'That''s one way to put it.'),

-- 195 (50, neutral, 2) Temple of Atal'Hakkar again
(195,0,0,'You ever wonder why the Temple of Atal''Hakkar has so many trolls?'),
(195,1,1,'It''s a troll temple.'),
(195,2,0,'But so many?'),
(195,3,1,'It''s a very committed troll temple.'),

-- 196 (42, Horde, 3) Thunder Bluff again
(196,0,0,'You ever wonder why Thunder Bluff has so many drums?'),
(196,1,1,'It''s a tauren city.'),
(196,2,0,'But so many?'),
(196,3,1,'It''s a very committed tauren city.'),
(196,4,2,'That''s one way to put it.'),

-- 197 (60, neutral, 2) Qiraji whisper
(197,0,0,'Do you hear that?'),
(197,1,1,'Sand.'),
(197,2,0,'Under the sand.'),
(197,3,1,'That''s worse. Walk. Don''t answer it.'),

-- 198 (56, neutral, 2) Blackrock Mountain
(198,0,0,'You ever wonder why Blackrock Mountain is so big?'),
(198,1,1,'It''s a mountain.'),
(198,2,0,'But so big?'),
(198,3,1,'It''s a very committed mountain.'),

-- 199 (48, neutral, 3) Old God statue
(199,0,0,'Don''t touch the statue.'),
(199,1,1,'I wasn''t going to.'),
(199,2,0,'Your hand was out.'),
(199,3,1,'That was pointing. Pointing is allowed.'),
(199,4,2,'Pointing is how it starts.'),

-- 200 (30, neutral, 2) Stranglethorn again
(200,0,0,'You ever wonder why Stranglethorn has so many tigers?'),
(200,1,1,'It''s a jungle.'),
(200,2,0,'But so many?'),
(200,3,1,'It''s a very committed jungle.');

INSERT INTO `companion_banter_line` (`script_id`,`line_index`,`speaker_slot`,`text`) VALUES
-- 201 (34, Horde, 3) Orc history
(201,0,0,'You know why the orcs came to Azeroth?'),
(201,1,1,'The portal.'),
(201,2,0,'Yes, but why did they go through it?'),
(201,3,1,'Because it was there.'),
(201,4,2,'That''s not why.'),
(201,5,0,'It''s close enough.'),
(201,6,2,'It really isn''t.'),

-- 202 (60, neutral, 3) Kel'Thuzad
(202,0,0,'Kel''Thuzad was a human once.'),
(202,1,1,'I know.'),
(202,2,0,'A living, breathing human. With a mother.'),
(202,3,1,'Everyone has a mother.'),
(202,4,2,'He had a mother who was proud of him.'),
(202,5,0,'Now you''re making it weird.'),
(202,6,2,'It is weird.'),

-- 203 (58, neutral, 4) Bad joke
(203,0,0,'Why did the gnome cross the road?'),
(203,1,1,'Don''t.'),
(203,2,0,'To get to the other side.'),
(203,3,1,'That''s the joke?'),
(203,4,2,'That''s the joke.'),
(203,5,3,'I want a new party.'),
(203,6,0,'I have more.'),
(203,7,1,'Please don''t.'),

-- 204 (28, neutral, 4) Bad puns
(204,0,0,'These caves are pretty gneiss.'),
(204,1,1,'No.'),
(204,2,0,'What? It''s a rock pun.'),
(204,3,1,'We''re not doing rock puns.'),
(204,4,2,'I thought it was ore-right.'),
(204,5,3,'I''m leaving.'),
(204,6,0,'You can''t leave. We''re in a dungeon.'),
(204,7,3,'Then I''m dying.'),

-- 205 (30, neutral, 3) Mages and portals
(205,0,0,'Why don''t mages just portal everywhere?'),
(205,1,1,'It''s exhausting.'),
(205,2,0,'That''s what they say.'),
(205,3,1,'It''s true.'),
(205,4,2,'It''s also expensive.'),
(205,5,0,'Everything''s expensive.'),
(205,6,2,'Portals especially.'),

-- 206 (56, neutral, 3) Tyrande and Malfurion
(206,0,0,'You ever wonder what Malfurion would think of all this?'),
(206,1,1,'Which ''this''?'),
(206,2,0,'Any of it. All of it.'),
(206,3,1,'He''d probably go back to sleep.'),
(206,4,2,'That''s his answer to most things.'),
(206,5,0,'He slept through the last war.'),
(206,6,2,'He sleeps through everything.'),

-- 207 (5, neutral, 4) Wet socks
(207,0,0,'My socks are wet.'),
(207,1,1,'We''re in a river.'),
(207,2,0,'I know where we are. I''m complaining.'),
(207,3,1,'You should have taken them off.'),
(207,4,2,'That''s what I said.'),
(207,5,3,'You didn''t say anything.'),
(207,6,2,'I thought it very loudly.'),
(207,7,0,'That''s not how it works.'),

-- 208 (32, neutral, 4) Alcohol
(208,0,0,'I could really use a drink.'),
(208,1,1,'It''s ten in the morning.'),
(208,2,0,'I know.'),
(208,3,1,'That''s not the point.'),
(208,4,2,'It''s a very good point.'),
(208,5,3,'It''s a very good time.'),
(208,6,0,'See? He gets it.'),

-- 209 (20, neutral, 4) Fishing
(209,0,0,'You ever go fishing?'),
(209,1,1,'I don''t have the patience.'),
(209,2,0,'You''re a hunter.'),
(209,3,1,'Fishing is different.'),
(209,4,2,'How?'),
(209,5,3,'Fish don''t shoot back.'),
(209,6,1,'That''s the difference.'),

-- 210 (40, neutral, 3) Bad memory
(210,0,0,'I''ve been here before.'),
(210,1,1,'You have not.'),
(210,2,0,'I recognize that rock.'),
(210,3,1,'That''s a different rock.'),
(210,4,2,'It looks the same.'),
(210,5,0,'All rocks look the same.'),
(210,6,1,'That''s what I''ve been saying.'),

-- 211 (60, neutral, 3) C'thun
(211,0,0,'They say C''Thun is asleep.'),
(211,1,1,'They say a lot of things.'),
(211,2,0,'What do you think?'),
(211,3,1,'I think I don''t want to wake him and find out.'),
(211,4,2,'That''s the smartest thing anyone''s said all day.'),
(211,5,0,'The bar is low.'),
(211,6,2,'The bar is on the floor.'),

-- 212 (30, neutral, 3) Tall tale
(212,0,0,'I once killed a kodo with one arrow.'),
(212,1,1,'No you didn''t.'),
(212,2,0,'It fell on the arrow.'),
(212,3,1,'That''s not killing it with an arrow.'),
(212,4,2,'It died, didn''t it?'),
(212,5,0,'Technically.'),
(212,6,1,'Technically you''re a liar.'),

-- 213 (26, neutral, 3) Tauren and kodos
(213,0,0,'Kodo are gentle creatures.'),
(213,1,1,'They step on people.'),
(213,2,0,'By accident.'),
(213,3,1,'That''s still stepping on people.'),
(213,4,2,'Gentle creatures can still step on people.'),
(213,5,0,'That''s what my grandfather said.'),
(213,6,1,'About kodos?'),
(213,7,0,'About himself.'),

-- 214 (50, neutral, 3) The Light
(214,0,0,'The Light doesn''t answer prayers.'),
(214,1,1,'That''s what paladins say.'),
(214,2,0,'And priests.'),
(214,3,1,'They would know.'),
(214,4,2,'Or they wouldn''t.'),
(214,5,0,'That''s the thing about faith.'),

-- 215 (38, neutral, 3) Warlocks
(215,0,0,'Warlocks are just mages with worse friends.'),
(215,1,1,'That''s not fair.'),
(215,2,0,'It''s a little fair.'),
(215,3,1,'They work harder than most mages.'),
(215,4,2,'At summoning demons.'),
(215,5,1,'And portals.'),
(215,6,0,'You''re making my point for me.'),

-- 216 (54, neutral, 2) Cenarion Hold
(216,0,0,'Cenarion Hold is a circle of calm in a lot of sand.'),
(216,1,1,'The sand is trying to join the circle.'),
(216,2,0,'The druids don''t look worried.'),
(216,3,1,'Druids never look worried. That''s how you know it''s bad.'),

-- 217 (16, Horde, 2) Peons
(217,0,0,'You ever talk to the peons?'),
(217,1,1,'They''re busy.'),
(217,2,0,'They''re always busy.'),
(217,3,1,'That''s why I don''t talk to them.'),
(217,4,0,'That''s cold.'),
(217,5,1,'That''s practical.'),

-- 218 (26, neutral, 3) Homesickness
(218,0,0,'I miss my mother''s cooking.'),
(218,1,1,'What did she make?'),
(218,2,0,'Stew.'),
(218,3,1,'What kind?'),
(218,4,2,'The same kind every day.'),
(218,5,0,'That sounds boring.'),
(218,6,2,'It was. I miss it.'),

-- 219 (40, neutral, 3) Retribution
(219,0,0,'Revenge is a fool''s game.'),
(219,1,1,'That''s what people say when they''ve won.'),
(219,2,0,'That''s what people say when they''ve lost.'),
(219,3,1,'Who says it when they''ve won?'),
(219,4,2,'Everyone who''s won anything.'),
(219,5,0,'That''s very cynical.'),
(219,6,2,'That''s very true.'),

-- 220 (48, neutral, 4) Big families
(220,0,0,'You have siblings?'),
(220,1,1,'Four.'),
(220,2,0,'Four?'),
(220,3,2,'That''s a lot.'),
(220,4,1,'It was a lot of food.'),
(220,5,3,'I have none.'),
(220,6,0,'That sounds lonely.'),
(220,7,3,'It''s quieter.'),

-- 221 (20, neutral, 4) Greetings
(221,0,0,'Why do paladins always say ''well met''?'),
(221,1,1,'It''s polite.'),
(221,2,0,'It''s a tic.'),
(221,3,1,'It''s a polite tic.'),
(221,4,2,'Well met.'),
(221,5,3,'See? He can''t help it.'),
(221,6,0,'He''s doing it again.'),

-- 222 (38, neutral, 2) Cooking
(222,0,0,'You can cook?'),
(222,1,1,'I can make soup.'),
(222,2,0,'What kind?'),
(222,3,1,'Soup soup.'),
(222,4,0,'What''s in it?'),
(222,5,1,'Whatever''s in the pot.'),

-- 223 (60, neutral, 2) Caverns of Time door
(223,0,0,'There''s a cave they won''t let us into.'),
(223,1,1,'Good.'),
(223,2,0,'Don''t you want to know?'),
(223,3,1,'I want to keep the hours I already have.'),

-- 224 (20, neutral, 3) Gnome engineering
(224,0,0,'You ever trust a gnomish device?'),
(224,1,1,'Once.'),
(224,2,0,'What happened?'),
(224,3,1,'It exploded.'),
(224,4,2,'Did it explode on purpose?'),
(224,5,1,'It exploded on time.'),
(224,6,0,'That''s worse.'),

-- 225 (46, neutral, 3) Medivh
(225,0,0,'Medivh opened the Dark Portal.'),
(225,1,1,'He was possessed.'),
(225,2,0,'He was still Medivh.'),
(225,3,1,'He was still possessed.'),
(225,4,2,'You''re defending him.'),
(225,5,1,'I''m explaining him. There''s a difference.'),

-- 226 (20, neutral, 4) Names
(226,0,0,'What''s your real name?'),
(226,1,1,'What I told you.'),
(226,2,0,'That''s not a real name.'),
(226,3,1,'It''s my real name.'),
(226,4,2,'It''s a nickname.'),
(226,5,3,'It''s a good nickname.'),
(226,6,1,'Thank you.'),
(226,7,0,'It''s not a real name.'),

-- 227 (40, neutral, 3) Night elves
(227,0,0,'Night elves live a long time.'),
(227,1,1,'Very long.'),
(227,2,0,'You ever wonder what that does to a person?'),
(227,3,1,'What do you mean?'),
(227,4,2,'They watch everyone they love die.'),
(227,5,0,'That''s dark.'),
(227,6,2,'That''s long life.'),

-- 228 (60, neutral, 3) Nefarian
(228,0,0,'You think Nefarian knows about Onyxia?'),
(228,1,1,'They''re siblings.'),
(228,2,0,'Do they like each other?'),
(228,3,1,'They''re dragons.'),
(228,4,2,'That''s not an answer.'),
(228,5,1,'That''s the only answer.'),

-- 229 (54, neutral, 3) Hunter pets
(229,0,0,'I had a bear once.'),
(229,1,1,'A pet bear?'),
(229,2,0,'A friend.'),
(229,3,1,'What happened to it?'),
(229,4,2,'He got old.'),
(229,5,0,'I''m sorry.'),
(229,6,2,'Thank you.'),

-- 230 (46, neutral, 3) Troll accents
(230,0,0,'You ever notice trolls all sound the same?'),
(230,1,1,'They don''t.'),
(230,2,0,'They do.'),
(230,3,1,'They come from different tribes.'),
(230,4,2,'They still sound the same.'),
(230,5,0,'That''s racist.'),
(230,6,2,'It''s observational.'),
(230,7,1,'It''s both.'),

-- 231 (40, neutral, 2) Paladin armor
(231,0,0,'Why is paladin armor always so shiny?'),
(231,1,1,'It''s ceremonial.'),
(231,2,0,'It''s very ceremonial.'),
(231,3,1,'It''s very shiny.'),
(231,4,0,'It''s the same thing.'),

-- 232 (34, Horde, 4) Blood oath
(232,0,0,'You ever swear a blood oath?'),
(232,1,1,'Once.'),
(232,2,0,'To who?'),
(232,3,1,'My brother.'),
(232,4,2,'Where is he now?'),
(232,5,1,'Dead.'),
(232,6,3,'I''m sorry.'),
(232,7,1,'He died well.'),

-- 233 (58, neutral, 2) Dragons as people
(233,0,0,'Dragons can look like people.'),
(233,1,1,'I know.'),
(233,2,0,'You ever wonder if anyone you''ve met was a dragon?'),
(233,3,1,'All the time.'),
(233,4,0,'And?'),
(233,5,1,'I still don''t know.'),

-- 234 (18, neutral, 4) Class envy
(234,0,0,'You ever wish you were a mage?'),
(234,1,1,'Sometimes.'),
(234,2,0,'You''d freeze to death in robes.'),
(234,3,1,'I''d have fireballs.'),
(234,4,2,'You''d still freeze.'),
(234,5,3,'Worth it.'),
(234,6,0,'It''s not worth it.'),
(234,7,3,'It''s a little worth it.'),

-- 235 (60, neutral, 3) AQ gates
(235,0,0,'You think the gates will ever close again?'),
(235,1,1,'No.'),
(235,2,0,'Then what was the point?'),
(235,3,1,'We bought time.'),
(235,4,2,'For what?'),
(235,5,1,'For the next thing.'),

-- 236 (44, neutral, 3) Sand trolls
(236,0,0,'Sand trolls are different from forest trolls.'),
(236,1,1,'How?'),
(236,2,0,'They''re sandier.'),
(236,3,1,'That''s not helpful.'),
(236,4,2,'It''s a little helpful.'),
(236,5,0,'It''s not helpful at all.'),

-- 237 (52, neutral, 3) The Black Flight
(237,0,0,'The black dragonflight is almost gone.'),
(237,1,1,'Almost.'),
(237,2,0,'Almost is not gone.'),
(237,3,1,'Almost is never gone.'),
(237,4,2,'That''s what almost means.'),

-- 238 (56, neutral, 3) Scourge tactics
(238,0,0,'The Scourge don''t take prisoners.'),
(238,1,1,'They do.'),
(238,2,0,'They don''t keep them.'),
(238,3,1,'That''s different.'),
(238,4,2,'That''s the same thing.'),
(238,5,0,'It really isn''t.'),

-- 239 (12, Alliance, 3) Kobolds
(239,0,0,'You take candle!'),
(239,1,1,'What?'),
(239,2,1,'That''s kobolds.'),
(239,3,2,'They''re very attached to candles.'),
(239,4,0,'I''m going to take a candle.'),
(239,5,1,'Please don''t.'),

-- 240 (5, Horde, 2) Grunts
(240,0,0,'You think grunts ever get promoted?'),
(240,1,1,'To what?'),
(240,2,0,'Higher grunt.'),
(240,3,1,'That''s not a rank.'),
(240,4,0,'It should be.'),

-- 241 (20, neutral, 4) Overpacking
(241,0,0,'Why do you have six swords?'),
(241,1,1,'Backups.'),
(241,2,0,'For what?'),
(241,3,1,'Sword breaking.'),
(241,4,2,'Swords don''t break.'),
(241,5,3,'They do.'),
(241,6,0,'They really don''t.'),
(241,7,3,'I''ve seen it.'),

-- 242 (60, neutral, 3) Hakkar
(242,0,0,'Hakkar was a blood god.'),
(242,1,1,'Was.'),
(242,2,1,'Gods don''t stay dead.'),
(242,3,2,'Some do.'),
(242,4,1,'Name one.'),
(242,5,2,'...Give me a minute.'),

-- 243 (36, neutral, 3) Druids and sleep
(243,0,0,'Druids sleep a lot.'),
(243,1,1,'They dream.'),
(243,2,0,'That''s a nice way to put it.'),
(243,3,1,'It''s the accurate way.'),
(243,4,2,'It''s a nice, accurate way.'),
(243,5,0,'I''m going to start saying I''m druiding instead of napping.'),
(243,6,1,'Please don''t.'),

-- 244 (42, neutral, 4) Smithing
(244,0,0,'You ever forge your own weapon?'),
(244,1,1,'Once.'),
(244,2,0,'How''d it turn out?'),
(244,3,1,'It''s a very fine shovel.'),
(244,4,2,'You were trying to make a sword.'),
(244,5,3,'He knows.'),
(244,6,1,'I know.'),

-- 245 (5, Horde, 2) Boars
(245,0,0,'Boars are the worst.'),
(245,1,1,'They''re just pigs.'),
(245,2,0,'Angry pigs.'),
(245,3,1,'With tusks.'),
(245,4,0,'And a grudge.'),
(245,5,1,'Against who?'),
(245,6,0,'Everyone.'),

-- 246 (26, neutral, 3) Troll regeneration
(246,0,0,'Trolls can regrow limbs.'),
(246,1,1,'They can regrow fingers.'),
(246,2,0,'I heard limbs.'),
(246,3,1,'Fingers.'),
(246,4,2,'Either way, don''t cut one on purpose.'),
(246,5,0,'I wasn''t going to.'),
(246,6,2,'You were thinking about it.'),
(246,7,0,'...Yes.'),

-- 247 (50, neutral, 4) The war
(247,0,0,'You think the war will ever end?'),
(247,1,1,'Which war?'),
(247,2,0,'Any of them.'),
(247,3,1,'No.'),
(247,4,2,'That was fast.'),
(247,5,3,'There''s always another one.'),
(247,6,0,'Then what are we fighting for?'),
(247,7,3,'The next one.'),

-- 248 (18, neutral, 3) Sewers
(248,0,0,'Why are we always in sewers?'),
(248,1,1,'They''re convenient.'),
(248,2,0,'Convenient for who?'),
(248,3,1,'For the people who built them.'),
(248,4,2,'And the rats.'),
(248,5,0,'The rats love them.'),

-- 249 (48, neutral, 3) Maraudon princess
(249,0,0,'The Princess of Maraudon is a giant slime.'),
(249,1,1,'That''s not a princess.'),
(249,2,0,'That''s what they call her.'),
(249,3,1,'She''s a slime.'),
(249,4,2,'Royalty is complicated.'),
(249,5,0,'Royalty is very complicated.'),

-- 250 (52, neutral, 3) Onyxia's head
(250,0,0,'They hung her head in Stormwind.'),
(250,1,1,'And in Orgrimmar.'),
(250,2,0,'Both?'),
(250,3,1,'Both.'),
(250,4,2,'That''s a lot of heads.'),
(250,5,0,'That''s one head twice.'),
(250,6,2,'Even better.'),

-- 251 (22, neutral, 3) Murlocs
(251,0,0,'Murlocs are just fish people.'),
(251,1,1,'Angry fish people.'),
(251,2,0,'Very angry.'),
(251,3,1,'And they scream.'),
(251,4,2,'All the time.'),
(251,5,0,'The screaming is the worst part.'),
(251,6,1,'The screaming is the only part.'),

-- 252 (52, neutral, 2) Blackrock orcs
(252,0,0,'The Blackrock orcs are different from the Horde orcs.'),
(252,1,1,'They''re all orcs.'),
(252,2,0,'They''re all orcs, but they''re not all the same.'),
(252,3,1,'That''s true of everyone.'),
(252,4,0,'We agree twice. That''s a record.'),

-- 253 (48, neutral, 3) Long stories
(253,0,0,'I had a mentor once.'),
(253,1,1,'What happened to him?'),
(253,2,0,'He died.'),
(253,3,1,'How?'),
(253,4,2,'A pit trap.'),
(253,5,0,'That''s not a story.'),
(253,6,2,'It''s a short one.'),

-- 254 (12, Alliance, 3) City life
(254,0,0,'You ever miss the city?'),
(254,1,1,'Sometimes.'),
(254,2,0,'What do you miss?'),
(254,3,1,'The bread.'),
(254,4,2,'The bread?'),
(254,5,1,'Fresh bread. Every morning.'),
(254,6,0,'That''s the only thing?'),
(254,7,1,'And the walls. I miss the walls.'),

-- 255 (60, neutral, 3) C'thun again
(255,0,0,'You think we actually killed C''Thun?'),
(255,1,1,'We killed something.'),
(255,2,0,'That''s not the same.'),
(255,3,1,'It''s close enough.'),
(255,4,2,'It''s really not.'),
(255,5,0,'We''ll find out.'),
(255,6,1,'That''s what I''m afraid of.'),

-- 256 (52, neutral, 3) Kel'Thuzad again
(256,0,0,'Kel''Thuzad doesn''t sleep.'),
(256,1,1,'He''s a lich.'),
(256,2,0,'Liches can sleep.'),
(256,3,1,'They don''t.'),
(256,4,2,'That''s why they''re so cranky.'),
(256,5,0,'That''s why they''re so dangerous.'),
(256,6,1,'Same thing.'),

-- 257 (60, neutral, 3) Dwarven ale
(257,0,0,'Dwarven ale is the strongest drink in the world.'),
(257,1,1,'Tauren have a stronger one.'),
(257,2,0,'They do not.'),
(257,3,1,'They do. It''s made from fermented kodo milk.'),
(257,4,2,'That sounds terrible.'),
(257,5,0,'It is terrible.'),
(257,6,2,'Then how is it stronger?'),
(257,7,1,'It''s terrible and it''s stronger.'),

-- 258 (22, Alliance, 3) Paladin tics
(258,0,0,'Do all paladins do the light thing?'),
(258,1,1,'What light thing?'),
(258,2,0,'The glow. On their hands.'),
(258,3,1,'It''s a blessing.'),
(258,4,2,'It''s a tic.'),
(258,5,1,'It''s a blessed tic.'),
(258,6,0,'You say that about everything.'),

-- 259 (52, neutral, 3) Onyxia dead
(259,0,0,'Onyxia''s dead for good this time.'),
(259,1,1,'Sure.'),
(259,2,0,'You don''t believe that.'),
(259,3,1,'I believe it every time.'),
(259,4,2,'And then?'),
(259,5,1,'And then she comes back.'),
(259,6,0,'She hasn''t come back yet.'),
(259,7,1,'Yet.'),

-- 260 (26, neutral, 2) Overthinking
(260,0,0,'You ever overthink things?'),
(260,1,1,'All the time.'),
(260,2,0,'What do you overthink?'),
(260,3,1,'This conversation.'),
(260,4,0,'...Fair.'),

-- 261 (12, Alliance, 3) The king
(261,0,0,'The boy king is doing his best.'),
(261,1,1,'His best isn''t much.'),
(261,2,0,'He''s ten.'),
(261,3,1,'He''s a king.'),
(261,4,2,'He''s a ten-year-old king.'),
(261,5,0,'He''ll grow into it.'),
(261,6,1,'Will he?'),

-- 262 (32, neutral, 3) Etiquette
(262,0,0,'You ever bow to anyone?'),
(262,1,1,'To officers.'),
(262,2,0,'Do you mean it?'),
(262,3,1,'No.'),
(262,4,2,'That''s honest.'),
(262,5,0,'That''s survival.'),

-- 263 (60, neutral, 2) Broken gear
(263,0,0,'My armor''s broken.'),
(263,1,1,'Fix it.'),
(263,2,0,'I can''t fix it here.'),
(263,3,1,'Then don''t get hit.'),
(263,4,0,'Great plan.'),

-- 264 (50, Horde, 3) Undercity politics
(264,0,0,'The Forsaken have their own agenda.'),
(264,1,1,'Everyone has their own agenda.'),
(264,2,0,'Theirs is scarier.'),
(264,3,1,'It''s not scarier. It''s just... clearer.'),
(264,4,2,'That''s scarier.'),
(264,5,1,'That''s fair.'),

-- 265 (22, neutral, 3) Gnoll laughter
(265,0,0,'Why do gnolls laugh like that?'),
(265,1,1,'They think it''s funny.'),
(265,2,0,'What''s funny?'),
(265,3,1,'Us.'),
(265,4,2,'That''s not funny.'),
(265,5,1,'They think it is.'),

-- 266 (28, neutral, 3) Centaur
(266,0,0,'Centaurs hate everyone.'),
(266,1,1,'They hate the tauren specifically.'),
(266,2,0,'They hate everyone specifically.'),
(266,3,1,'That''s a lot of specifics.'),
(266,4,2,'They''re very committed to hating.'),

-- 267 (12, Alliance, 3) Defias again
(267,0,0,'The Defias are just bandits.'),
(267,1,1,'They''re not just bandits.'),
(267,2,0,'They wear masks and rob people.'),
(267,3,1,'They''re angry bandits.'),
(267,4,2,'With a cause.'),
(267,5,0,'A bad cause.'),
(267,6,1,'A cause.'),

-- 268 (12, Alliance, 2) Hogger
(268,0,0,'You ever fight Hogger?'),
(268,1,1,'Everyone fights Hogger.'),
(268,2,0,'I''ve never fought Hogger.'),
(268,3,1,'You''re missing out.'),
(268,4,0,'I don''t think I am.'),

-- 269 (30, neutral, 3) Rationing
(269,0,0,'We''re running low on food.'),
(269,1,1,'How low?'),
(269,2,0,'One loaf and a half.'),
(269,3,1,'We''ll be fine.'),
(269,4,2,'We won''t be fine.'),
(269,5,0,'We will not be fine.'),

-- 270 (48, neutral, 4) Reputation
(270,0,0,'Reputation is everything.'),
(270,1,1,'It''s not everything.'),
(270,2,0,'It''s most things.'),
(270,3,1,'It''s some things.'),
(270,4,2,'It''s a lot of things.'),
(270,5,3,'It''s a thing.'),
(270,6,0,'You''re all terrible.'),

-- 271 (20, neutral, 3) Who's on watch
(271,0,0,'I''ll take first watch.'),
(271,1,1,'You took first watch last night.'),
(271,2,0,'I don''t sleep much.'),
(271,3,1,'That''s not a virtue. That''s a warning.'),
(271,4,2,'Wake me if the warning starts walking.'),

-- 272 (48, neutral, 3) Bad memories
(272,0,0,'You ever get nightmares?'),
(272,1,1,'Sometimes.'),
(272,2,0,'About what?'),
(272,3,1,'About this.'),
(272,4,2,'About what we''re doing right now?'),
(272,5,1,'About what we did yesterday.'),
(272,6,0,'That''s worse.'),

-- 273 (60, neutral, 3) Immortality
(273,0,0,'You think we''ll ever be immortal?'),
(273,1,1,'No.'),
(273,2,0,'That was fast.'),
(273,3,1,'We''re adventurers.'),
(273,4,2,'That''s exactly why.'),
(273,5,0,'That''s dark.'),
(273,6,1,'That''s honest.'),

-- 274 (36, neutral, 2) Alcohol again
(274,0,0,'You ever drink before a fight?'),
(274,1,1,'Once.'),
(274,2,0,'How''d it go?'),
(274,3,1,'I missed.'),
(274,4,0,'Missed what?'),
(274,5,1,'Everything.'),

-- 275 (28, neutral, 3) Bad at names
(275,0,0,'I forgot your name.'),
(275,1,1,'We''ve been traveling together for a month.'),
(275,2,0,'I know.'),
(275,3,1,'A month.'),
(275,4,2,'That''s a long time.'),
(275,5,0,'I''m bad at names.'),
(275,6,1,'It''s on my tombstone.'),

-- 276 (58, neutral, 3) Plaguelands heroes
(276,0,0,'Nobody remembers the heroes of the Plaguelands.'),
(276,1,1,'They remember Uther.'),
(276,2,1,'And the others?'),
(276,3,2,'Nobody remembers the others.'),
(276,4,0,'That''s how it works.'),

-- 277 (60, neutral, 3) Unknown heroes
(277,0,0,'There are people who died saving this world and nobody knows their names.'),
(277,1,1,'That''s a lot of people.'),
(277,2,0,'That''s most people.'),
(277,3,1,'That''s all people.'),
(277,4,2,'Eventually.'),
(277,5,0,'That''s very morbid.'),
(277,6,2,'That''s very true.'),

-- 278 (46, neutral, 2) Night elf cooking
(278,0,0,'Night elf food is terrible.'),
(278,1,1,'They don''t eat meat.'),
(278,2,0,'That''s not the problem.'),
(278,3,1,'That''s the whole problem.'),

-- 279 (14, Alliance, 3) First kill
(279,0,0,'You remember your first kill?'),
(279,1,1,'A wolf.'),
(279,2,0,'Mine was a boar.'),
(279,3,1,'How was it?'),
(279,4,2,'Quick.'),
(279,5,0,'Mine was not quick.'),
(279,6,2,'They never are.'),

-- 280 (52, neutral, 4) What are we
(280,0,0,'What are we?'),
(280,1,1,'What do you mean?'),
(280,2,0,'Like. Us. Adventurers. What are we?'),
(280,3,1,'Mercenaries.'),
(280,4,2,'Heroes.'),
(280,5,3,'Both.'),
(280,6,0,'That''s not comforting.'),
(280,7,3,'It''s not meant to be.'),

-- 281 (60, neutral, 2) Pressure
(281,0,0,'You ever feel the pressure?'),
(281,1,1,'What pressure?'),
(281,2,0,'The pressure to be the one who saves everyone.'),
(281,3,1,'Yes.'),
(281,4,0,'And?'),
(281,5,1,'I try not to think about it.'),

-- 282 (18, neutral, 2) Deadmines gears
(282,0,0,'The gears are still turning.'),
(282,1,1,'VanCleef liked a working mill.'),
(282,2,0,'He''s dead.'),
(282,3,1,'The mill didn''t get the letter.'),

-- 283 (24, neutral, 3) First aid
(283,0,0,'You know first aid?'),
(283,1,1,'A little.'),
(283,2,0,'How little?'),
(283,3,1,'I can stop bleeding.'),
(283,4,2,'That''s the important one.'),
(283,5,1,'That''s the only one.'),

-- 284 (13, Horde, 3) Bad directions
(284,0,0,'The directions said turn left at the skull.'),
(284,1,1,'Which skull?'),
(284,2,0,'The one on the pole.'),
(284,3,1,'There are four skulls on poles.'),
(284,4,2,'Then we''re lost.'),
(284,5,0,'We are extremely lost.'),

-- 285 (60, neutral, 2) Long campaigns
(285,0,0,'How long have we been doing this?'),
(285,1,1,'Years.'),
(285,2,0,'How many?'),
(285,3,1,'I stopped counting.'),
(285,4,0,'Why?'),
(285,5,1,'It made me sad.'),

-- 286 (34, neutral, 3) Training
(286,0,0,'Where did you train?'),
(286,1,1,'A monastery.'),
(286,2,0,'Which one?'),
(286,3,1,'One that''s gone now.'),
(286,4,2,'I''m sorry.'),
(286,5,1,'It''s fine. It was a long time ago.'),

-- 287 (5, Alliance, 3) Bad at directions
(287,0,0,'Which way is the city?'),
(287,1,1,'That way.'),
(287,2,0,'You''re pointing at a tree.'),
(287,3,1,'Past the tree.'),
(287,4,2,'You''re still pointing at a tree.'),
(287,5,0,'It''s a big tree.'),

-- 288 (5, neutral, 3) Optimism
(288,0,0,'Things will work out.'),
(288,1,1,'Will they?'),
(288,2,0,'No. But I like to say it.'),
(288,3,1,'That''s not comforting.'),
(288,4,2,'It''s comforting to me.'),
(288,5,0,'That''s what matters.'),

-- 289 (60, neutral, 4) What comes next
(289,0,0,'What comes after the war?'),
(289,1,1,'Another war.'),
(289,2,0,'Besides that.'),
(289,3,1,'Peace.'),
(289,4,2,'For who?'),
(289,5,3,'For someone.'),
(289,6,0,'Not for us.'),

-- 290 (8, Alliance, 4) Group leaders
(290,0,0,'Who''s in charge?'),
(290,1,1,'You are.'),
(290,2,0,'I''m not in charge.'),
(290,3,1,'You''re the one with the map.'),
(290,4,2,'And the sword.'),
(290,5,3,'And the hat.'),
(290,6,0,'The hat doesn''t mean anything.'),
(290,7,1,'It means a lot.'),

-- 291 (20, neutral, 3) Old wounds
(291,0,0,'You limp.'),
(291,1,1,'Old wound.'),
(291,2,0,'From what?'),
(291,3,1,'A bad fall.'),
(291,4,2,'A bad fall from what?'),
(291,5,1,'A gryphon.'),
(291,6,0,'You fell off a gryphon?'),
(291,7,1,'It fell off me.'),

-- 292 (58, neutral, 4) Burdens
(292,0,0,'You ever carry something you shouldn''t have?'),
(292,1,1,'Once.'),
(292,2,0,'What was it?'),
(292,3,1,'A letter.'),
(292,4,2,'A letter?'),
(292,5,3,'A letter can be heavy.'),
(292,6,0,'This one was.'),

-- 293 (60, neutral, 2) Molten bridge
(293,0,0,'The stone''s cracking.'),
(293,1,1,'Then we don''t stack on it.'),
(293,2,0,'There''s no other path.'),
(293,3,1,'Then we go one at a time and we don''t get poetic.'),

-- 294 (34, neutral, 4) Cold food
(294,0,0,'The food is cold.'),
(294,1,1,'We''re in a cave.'),
(294,2,0,'We have a fire.'),
(294,3,1,'The fire''s dying.'),
(294,4,2,'Then eat faster.'),
(294,5,3,'That''s not how food works.'),

-- 295 (52, neutral, 3) Leadership
(295,0,0,'You ever want to lead?'),
(295,1,1,'No.'),
(295,2,0,'Why not?'),
(295,3,1,'Leaders die first.'),
(295,4,2,'That''s not true.'),
(295,5,1,'It''s true often enough.'),

-- 296 (60, neutral, 4) The last war
(296,0,0,'You think this is the last war?'),
(296,1,1,'No.'),
(296,2,0,'You think there''ll be another?'),
(296,3,1,'There''s always another.'),
(296,4,2,'Then why fight?'),
(296,5,3,'Because someone has to.'),
(296,6,0,'That''s not a reason.'),
(296,7,3,'It''s the only reason.'),

-- 297 (34, neutral, 3) Bad orders
(297,0,0,'We followed bad orders once.'),
(297,1,1,'What happened?'),
(297,2,0,'People died.'),
(297,3,1,'I''m sorry.'),
(297,4,2,'We don''t follow bad orders anymore.'),
(297,5,0,'That''s something.'),
(297,6,2,'It''s not enough.'),

-- 298 (40, neutral, 2) Gadgetzan water
(298,0,0,'Water costs more than the room.'),
(298,1,1,'The room doesn''t keep you alive.'),
(298,2,0,'The goblin smiled when I paid.'),
(298,3,1,'That''s the local blessing.'),

-- 299 (18, neutral, 2) Random kindness
(299,0,0,'You ever help someone for no reason?'),
(299,1,1,'Sometimes.'),
(299,2,0,'Why?'),
(299,3,1,'Because I can.'),
(299,4,0,'That''s a good reason.'),
(299,5,1,'It''s the only reason.'),

-- 300 (60, neutral, 3) Remembering names
(300,0,0,'I want to be remembered.'),
(300,1,1,'You will be.'),
(300,2,0,'How do you know?'),
(300,3,1,'Because I''ll remember you.'),
(300,4,2,'That''s not the same.'),
(300,5,1,'It''s enough.');

INSERT INTO `companion_banter_line` (`script_id`,`line_index`,`speaker_slot`,`text`) VALUES
-- 301 (46, neutral, 2) Bronze sand
(301,0,0,'The hourglasses in Tanaris aren''t decorations.'),
(301,1,1,'Don''t turn them.'),
(301,2,0,'I wasn''t going to.'),
(301,3,1,'You were going to. That''s why I said it.'),

-- 302 (5, neutral, 4) Wolves
(302,0,0,'There''s a wolf behind you.'),
(302,1,1,'What?'),
(302,2,0,'Behind you.'),
(302,3,1,'I don''t see anything.'),
(302,4,2,'That''s because it''s behind you.'),
(302,5,3,'This is a bad joke.'),
(302,6,0,'There is a wolf.'),

-- 303 (60, neutral, 3) Lore dump
(303,0,0,'You know the Titans shaped this world?'),
(303,1,1,'That''s what they say.'),
(303,2,0,'They shaped it and then they left.'),
(303,3,1,'They had other worlds.'),
(303,4,2,'They left us with the Old Gods.'),
(303,5,0,'That''s not very polite.'),
(303,6,2,'That''s very Titans.'),

-- 304 (46, neutral, 3) Old soldiers
(304,0,0,'Old soldiers never die.'),
(304,1,1,'They do die.'),
(304,2,0,'They just don''t talk about it.'),
(304,3,1,'That''s not how it works.'),
(304,4,2,'It''s how it works for me.'),

-- 305 (12, Horde, 4) Bad at cooking
(305,0,0,'Who cooked this?'),
(305,1,1,'I did.'),
(305,2,0,'What is it?'),
(305,3,1,'Stew.'),
(305,4,2,'It''s grey.'),
(305,5,1,'Stew is grey.'),
(305,6,3,'Stew is brown.'),
(305,7,1,'Not my stew.'),

-- 306 (42, neutral, 3) The Light again
(306,0,0,'The Light doesn''t care if you''re good.'),
(306,1,1,'That''s not true.'),
(306,2,0,'It cares if you believe.'),
(306,3,1,'That''s not the same.'),
(306,4,2,'It''s not the same.'),
(306,5,0,'That''s what I said.'),
(306,6,2,'You said it wrong.'),

-- 307 (20, neutral, 4) Favorite food
(307,0,0,'What''s your favorite food?'),
(307,1,1,'Bread.'),
(307,2,0,'Just bread?'),
(307,3,1,'Fresh bread.'),
(307,4,2,'That''s still just bread.'),
(307,5,3,'Mine is meat.'),
(307,6,0,'Any meat?'),
(307,7,3,'Yes.'),
(307,8,1,'See? Bread is specific.'),

-- 308 (60, neutral, 2) Don't look back
(308,0,0,'Don''t look back.'),
(308,1,1,'Why?'),
(308,2,0,'Just don''t.'),
(308,3,1,'What''s behind us?'),
(308,4,0,'Nothing. That''s the point.'),
(308,5,1,'That''s not reassuring.'),

-- 309 (32, neutral, 3) Best decade
(309,0,0,'What was the best year of your life?'),
(309,1,1,'Before the war.'),
(309,2,0,'Which war?'),
(309,3,1,'The first one.'),
(309,4,2,'That was a long time ago.'),
(309,5,1,'Yes.'),
(309,6,0,'That''s sad.'),
(309,7,1,'It''s honest.'),

-- 310 (28, neutral, 3) Class tics
(310,0,0,'You ever notice how warriors always stand like this?'),
(310,1,1,'Like what?'),
(310,2,0,'Like they''re about to hit something.'),
(310,3,1,'We are about to hit something.'),
(310,4,2,'That''s the point.'),
(310,5,0,'That''s the problem.'),

-- 311 (50, Horde, 3) Undercity smells
(311,0,0,'The Undercity smells like death.'),
(311,1,1,'It''s the Undercity.'),
(311,2,0,'That''s not the point.'),
(311,3,1,'That''s the whole point.'),
(311,4,2,'The whole point is that it smells.'),
(311,5,0,'Yes.'),

-- 312 (60, neutral, 2) Onyxia road
(312,0,0,'The marsh is too quiet on the way in.'),
(312,1,1,'That''s a dragon''s front yard.'),
(312,2,0,'Should we be quieter?'),
(312,3,1,'We should be finished. Quiet is extra.'),

-- 313 (40, neutral, 3) Old languages
(313,0,0,'You speak any old languages?'),
(313,1,1,'A little Dwarvish.'),
(313,2,0,'That''s not old.'),
(313,3,1,'It''s older than Common.'),
(313,4,2,'Everything''s older than Common.'),
(313,5,0,'Common is very new.'),

-- 314 (20, neutral, 2) Map upside down
(314,0,0,'This map has north at the bottom.'),
(314,1,1,'Then turn it.'),
(314,2,0,'The notes are written the other way.'),
(314,3,1,'Then the cartographer hated us. Follow the river anyway.'),

-- 315 (34, neutral, 2) Old scar
(315,0,0,'Where''d you get that scar?'),
(315,1,1,'A bear.'),
(315,2,0,'A bear?'),
(315,3,0,'Did you win?'),
(315,4,1,'The bear did.'),

-- 316 (40, neutral, 4) Missing people
(316,0,0,'I miss my brother.'),
(316,1,1,'Where is he?'),
(316,2,0,'I don''t know.'),
(316,3,1,'When did you last see him?'),
(316,4,2,'Years ago.'),
(316,5,3,'You should look for him.'),
(316,6,0,'I don''t know where to start.'),
(316,7,1,'Start with his name.'),

-- 317 (52, neutral, 3) Old grudges
(317,0,0,'You ever forgive someone?'),
(317,1,1,'Once.'),
(317,2,0,'How was it?'),
(317,3,1,'Light.'),
(317,4,2,'That''s a good word.'),
(317,5,1,'That''s the word.'),

-- 318 (30, neutral, 2) Gnome jokes
(318,0,0,'How many gnomes does it take to light a torch?'),
(318,1,1,'How many?'),
(318,2,0,'None. They invented the torch.'),
(318,3,1,'That''s not a joke.'),
(318,4,0,'It''s a compliment.'),
(318,5,1,'It''s a bad compliment.'),

-- 319 (60, neutral, 2) BWL chalk
(319,0,0,'Who marked the turn?'),
(319,1,1,'Someone who lived.'),
(319,2,0,'The mark is smudged.'),
(319,3,1,'Then we mark it again. That''s how halls stay honest.'),

-- 320 (28, neutral, 3) Tired of dungeons
(320,0,0,'I''m tired of dungeons.'),
(320,1,1,'We''re not in a dungeon.'),
(320,2,0,'I''m tired of dungeons in general.'),
(320,3,1,'That''s fair.'),
(320,4,2,'I''m tired of caves.'),
(320,5,0,'Same thing.'),
(320,6,2,'Different thing.'),

-- 321 (44, neutral, 3) Best skill
(321,0,0,'What''s the most useful skill you have?'),
(321,1,1,'Tracking.'),
(321,2,0,'That''s not useful.'),
(321,3,1,'I found you, didn''t I?'),
(321,4,2,'That''s not the flex you think it is.'),
(321,5,1,'It''s a little the flex.'),

-- 322 (34, neutral, 3) Bad at lying
(322,0,0,'You''re a bad liar.'),
(322,1,1,'I''m not lying.'),
(322,2,0,'You''re lying right now.'),
(322,3,1,'No I''m not.'),
(322,4,2,'Your eye twitches.'),
(322,5,0,'It always twitches.'),
(322,6,2,'Then you''re always lying.'),

-- 323 (18, neutral, 3) Self-deprecating
(323,0,0,'I''m not very good at this.'),
(323,1,1,'You''re fine.'),
(323,2,0,'I''m really not.'),
(323,3,2,'You''re both fine.'),
(323,4,0,'We''re all fine.'),
(323,5,2,'That''s not comforting.'),

-- 324 (18, neutral, 3) Classes again
(324,0,0,'What class are you?'),
(324,1,1,'Warrior.'),
(324,2,0,'You don''t look like a warrior.'),
(324,3,1,'What does a warrior look like?'),
(324,4,2,'Bigger.'),
(324,5,0,'Angrier.'),
(324,6,1,'I''m working on it.'),

-- 325 (18, neutral, 3) Old family
(325,0,0,'You have family?'),
(325,1,1,'Somewhere.'),
(325,2,0,'Somewhere?'),
(325,3,1,'We don''t talk.'),
(325,4,2,'Why not?'),
(325,5,1,'They don''t approve of the adventuring.'),
(325,6,0,'Of the adventuring?'),
(325,7,1,'Of the dying part.'),

-- 326 (46, neutral, 3) Patience
(326,0,0,'You ever just wait?'),
(326,1,1,'Wait for what?'),
(326,2,0,'For things to be better.'),
(326,3,1,'That doesn''t work.'),
(326,4,2,'It works better than the alternative.'),
(326,5,0,'What''s the alternative?'),
(326,6,2,'Doing something.'),

-- 327 (60, neutral, 4) Endgame
(327,0,0,'What do we do when it''s all over?'),
(327,1,1,'Retire.'),
(327,2,0,'To what?'),
(327,3,1,'A farm.'),
(327,4,2,'You''d be bored.'),
(327,5,3,'I''d be free.'),
(327,6,0,'That''s the same thing.'),
(327,7,3,'It really isn''t.'),

-- 328 (22, Alliance, 3) Bad day
(328,0,0,'I''m having a bad day.'),
(328,1,1,'We''re in a dungeon.'),
(328,2,0,'That''s why I''m having a bad day.'),
(328,3,1,'We''re almost done.'),
(328,4,2,'You said that an hour ago.'),
(328,5,0,'It was true an hour ago.'),
(328,6,2,'It was not true an hour ago.'),

-- 329 (10, neutral, 4) First dungeon
(329,0,0,'This is my first dungeon.'),
(329,1,1,'You''re doing fine.'),
(329,2,0,'I''m terrified.'),
(329,3,1,'That''s normal.'),
(329,4,2,'I''m not terrified.'),
(329,5,3,'You should be.'),
(329,6,0,'That''s not helpful.'),
(329,7,3,'It''s honest.'),

-- 330 (36, neutral, 4) Biggest fear
(330,0,0,'What''s your biggest fear?'),
(330,1,1,'Drowning.'),
(330,2,0,'Mine is fire.'),
(330,3,1,'Mine is spiders.'),
(330,4,2,'Spiders?'),
(330,5,3,'Spiders.'),
(330,6,0,'We''re in a spider dungeon.'),
(330,7,3,'I KNOW.'),

-- 331 (48, neutral, 2) Free will
(331,0,0,'You think we have free will?'),
(331,1,1,'We''re talking about it. So yes.'),
(331,2,0,'That''s not proof.'),
(331,3,1,'It''s the best we''ve got.'),
(331,4,0,'It''s not proof.'),

-- 332 (28, neutral, 2) Bad at names again
(332,0,0,'What was your name again?'),
(332,1,1,'You forgot?'),
(332,2,0,'No. I''m testing you.'),
(332,3,1,'You forgot.'),
(332,4,0,'I forgot.'),

-- 333 (48, neutral, 2) Old debt
(333,0,0,'I owe someone money.'),
(333,1,1,'How much?'),
(333,2,0,'A lot.'),
(333,3,1,'How much is a lot?'),
(333,4,0,'More than I have.'),
(333,5,1,'That''s most of it.'),

-- 334 (20, neutral, 2) Fog on the road
(334,0,0,'I can''t see the road.'),
(334,1,1,'That''s why we have a road. Feel for it.'),
(334,2,0,'That''s not how roads work.'),
(334,3,1,'It is in this fog.'),

-- 335 (5, Alliance, 3) Lost in Elwynn
(335,0,0,'Where are we?'),
(335,1,1,'Elwynn.'),
(335,2,0,'Where in Elwynn?'),
(335,3,1,'The forest part.'),
(335,4,2,'It''s all forest.'),
(335,5,0,'Then we''re fine.'),

-- 336 (44, neutral, 4) What's in the bag
(336,0,0,'What''s in your bag?'),
(336,1,1,'Supplies.'),
(336,2,0,'What kind?'),
(336,3,1,'Food. Rope. Bandages.'),
(336,4,2,'Anything interesting?'),
(336,5,3,'A rock.'),
(336,6,0,'Why a rock?'),
(336,7,3,'I like it.'),

-- 337 (5, Alliance, 3) Stormwind guards
(337,0,0,'Have you seen the guards in Stormwind?'),
(337,1,1,'They''re everywhere.'),
(337,2,0,'They''re not everywhere.'),
(337,3,1,'They''re in Stormwind.'),
(337,4,2,'That''s one place.'),
(337,5,0,'One very guarded place.'),

-- 338 (42, Horde, 3) Old Horde
(338,0,0,'The old Horde did terrible things.'),
(338,1,1,'They were under demonic control.'),
(338,2,0,'That''s not an excuse.'),
(338,3,1,'It''s a reason.'),
(338,4,2,'Reasons and excuses are different.'),
(338,5,0,'Thank you.'),

-- 339 (60, neutral, 3) Regret
(339,0,0,'You have any regrets?'),
(339,1,1,'Too many.'),
(339,2,0,'Name one.'),
(339,3,1,'I trusted someone I shouldn''t have.'),
(339,4,2,'We all have.'),
(339,5,0,'That doesn''t make it better.'),
(339,6,2,'No. It doesn''t.'),

-- 340 (12, Alliance, 2) SI:7 door
(340,0,0,'They wouldn''t let me into SI:7.'),
(340,1,1,'Did you knock?'),
(340,2,0,'I knocked. Someone laughed.'),
(340,3,1,'That''s an answer.'),

-- 341 (60, neutral, 3) Bad leaders
(341,0,0,'Good leaders are hard to find.'),
(341,1,1,'Bad ones are easy.'),
(341,2,0,'That''s why there are more of them.'),
(341,3,1,'That''s a very dark thought.'),
(341,4,2,'It''s a very true thought.'),
(341,5,0,'That''s what makes it dark.'),

-- 342 (36, neutral, 3) Old friends again
(342,0,0,'I had a friend who went to the Plaguelands.'),
(342,1,1,'Did he come back?'),
(342,2,0,'No.'),
(342,3,1,'I''m sorry.'),
(342,4,2,'It was a long time ago.'),
(342,5,0,'It doesn''t feel long.'),
(342,6,2,'No. It doesn''t.'),

-- 343 (40, neutral, 3) Meaning
(343,0,0,'What''s the meaning of all this?'),
(343,1,1,'There isn''t one.'),
(343,2,0,'That''s dark.'),
(343,3,1,'That''s freeing.'),
(343,4,2,'That''s the same thing.'),
(343,5,1,'It really isn''t.'),

-- 344 (60, neutral, 3) The next war
(344,0,0,'You think we''ll be ready?'),
(344,1,1,'For what?'),
(344,2,0,'The next one.'),
(344,3,1,'We''re never ready.'),
(344,4,2,'Then why try?'),
(344,5,1,'Because we''re never ready.'),
(344,6,0,'That''s the answer.'),

-- 345 (50, Horde, 4) Bad memory
(345,0,0,'I don''t remember my father''s face.'),
(345,1,1,'That''s sad.'),
(345,2,0,'It''s normal.'),
(345,3,1,'It''s still sad.'),
(345,4,2,'My mother''s voice. Gone.'),
(345,5,3,'You''re all very depressing.'),
(345,6,0,'We''re being honest.'),
(345,7,3,'Honesty is depressing.'),

-- 346 (50, neutral, 2) Trapped
(346,0,0,'We''re trapped.'),
(346,1,1,'We''re not trapped.'),
(346,2,0,'The door closed behind us.'),
(346,3,1,'There''s always another way out.'),
(346,4,0,'Is there?'),
(346,5,1,'Usually.'),

-- 347 (56, neutral, 3) Last words
(347,0,0,'What would your last words be?'),
(347,1,1,'Something clever.'),
(347,2,0,'You''d get it wrong.'),
(347,3,1,'Probably.'),
(347,4,2,'Mine would be ''ow.'''),
(347,5,0,'That''s not clever.'),
(347,6,2,'That''s honest.'),

-- 348 (18, neutral, 4) Worst job
(348,0,0,'What''s the worst job you''ve ever had?'),
(348,1,1,'Latrine duty.'),
(348,2,0,'That''s not a job.'),
(348,3,1,'It was a job.'),
(348,4,2,'Mine was cooking for a guild.'),
(348,5,3,'That sounds nice.'),
(348,6,2,'They complained every meal.'),
(348,7,0,'That''s most jobs.'),

-- 349 (12, Alliance, 3) Home cooking
(349,0,0,'I miss home.'),
(349,1,1,'Where''s home?'),
(349,2,0,'A farm.'),
(349,3,1,'What kind?'),
(349,4,2,'A boring one.'),
(349,5,0,'I miss boring.'),
(349,6,1,'Everyone misses boring.'),

-- 350 (40, neutral, 3) Honest advice
(350,0,0,'Can I give you some advice?'),
(350,1,1,'No.'),
(350,2,0,'Don''t trust anyone.'),
(350,3,1,'You just gave me advice.'),
(350,4,2,'That''s why you shouldn''t trust me.'),
(350,5,0,'That''s a paradox.'),
(350,6,2,'That''s the point.'),

-- 351 (48, neutral, 3) Meaning again
(351,0,0,'What''s the point of adventuring?'),
(351,1,1,'To see things.'),
(351,2,0,'To kill things.'),
(351,3,1,'To get things.'),
(351,4,2,'To become something.'),
(351,5,0,'None of those are right.'),
(351,6,2,'All of those are right.'),

-- 352 (60, neutral, 3) Time
(352,0,0,'Time moves fast.'),
(352,1,1,'You''ve been thinking again.'),
(352,2,0,'It''s what I do.'),
(352,3,1,'It''s what you should stop doing.'),
(352,4,2,'I can''t.'),
(352,5,0,'I know.'),

-- 353 (26, neutral, 3) Bad at directions again
(353,0,0,'We''re going the wrong way.'),
(353,1,1,'How do you know?'),
(353,2,0,'The sun is setting in the east.'),
(353,3,1,'The sun sets in the west.'),
(353,4,2,'That''s what I said.'),
(353,5,0,'You said the opposite.'),
(353,6,2,'The opposite of west is east.'),
(353,7,0,'We''re definitely lost.'),

-- 354 (28, neutral, 3) Wrong map
(354,0,0,'I think this map is old.'),
(354,1,1,'How old?'),
(354,2,0,'It has Kalimdor as one continent.'),
(354,3,1,'It is one continent.'),
(354,4,2,'No, I mean one piece.'),
(354,5,0,'That''s the Great Sundering.'),
(354,6,2,'The map predates the Sundering.'),
(354,7,0,'That''s very old.'),

-- 355 (48, neutral, 2) Black dragon rumor
(355,0,0,'Someone said a black dragon was in the court.'),
(355,1,1,'Someone always says that.'),
(355,2,0,'What if it''s true?'),
(355,3,1,'Then we keep our voices down and our exits counted.'),

-- 356 (42, Horde, 3) Old Horde again
(356,0,0,'My grandfather fought in the First War.'),
(356,1,1,'On which side?'),
(356,2,0,'The wrong side.'),
(356,3,1,'There was no right side.'),
(356,4,2,'There was a wrong side.'),
(356,5,0,'He knew it, too.'),
(356,6,1,'Then he was on the right side eventually.'),
(356,7,0,'Eventually.'),

-- 357 (8, Alliance, 3) Stormwind canals
(357,0,0,'The canals smell like old fish.'),
(357,1,1,'That''s the city.'),
(357,2,0,'I thought cities were supposed to smell like bread.'),
(357,3,1,'That''s villages.'),
(357,4,2,'That''s bakeries.'),

-- 358 (40, neutral, 4) New armor
(358,0,0,'Nice armor.'),
(358,1,1,'Thanks.'),
(358,2,0,'Where''d you get it?'),
(358,3,1,'A dungeon.'),
(358,4,2,'Which one?'),
(358,5,3,'Doesn''t matter.'),
(358,6,0,'It matters.'),
(358,7,3,'It really doesn''t.'),

-- 359 (60, neutral, 3) No rest
(359,0,0,'We don''t get to rest.'),
(359,1,1,'We rest all the time.'),
(359,2,0,'Not really.'),
(359,3,1,'We''re resting right now.'),
(359,4,2,'We''re standing in a dungeon.'),
(359,5,0,'That''s resting for us.'),
(359,6,1,'That''s sad.'),

-- 360 (46, neutral, 3) Bad luck
(360,0,0,'I think I''m cursed.'),
(360,1,1,'Everyone thinks that.'),
(360,2,0,'No, I mean specifically.'),
(360,3,1,'What happened?'),
(360,4,2,'Everything.'),
(360,5,0,'That''s not specific.'),
(360,6,2,'It''s specific enough.'),

-- 361 (26, neutral, 2) Menethil ferry talk
(361,0,0,'The ferry captain whistled the whole way.'),
(361,1,1,'That''s how he counts the waves.'),
(361,2,0,'I counted the leaks.'),
(361,3,1,'Then you both had a hobby. Sit down.'),

-- 362 (32, neutral, 3) Bad advice
(362,0,0,'Just hit it harder.'),
(362,1,1,'That''s your advice?'),
(362,2,0,'It usually works.'),
(362,3,1,'It usually doesn''t.'),
(362,4,2,'It works enough.'),
(362,5,0,'That''s not how advice works.'),

-- 363 (26, neutral, 4) What's for dinner
(363,0,0,'What''s for dinner?'),
(363,1,1,'Bread.'),
(363,2,0,'Again?'),
(363,3,1,'We have bread.'),
(363,4,2,'We had bread yesterday.'),
(363,5,3,'And we''ll have bread tomorrow.'),
(363,6,0,'I hate bread.'),
(363,7,3,'You don''t hate bread.'),

-- 364 (26, neutral, 3) Bad singers
(364,0,0,'You ever sing?'),
(364,1,1,'Sometimes.'),
(364,2,0,'Sing something.'),
(364,3,1,'No.'),
(364,4,2,'Please.'),
(364,5,0,'Absolutely not.'),
(364,6,2,'He''s terrible.'),
(364,7,0,'I''m not terrible.'),

-- 365 (20, neutral, 3) Sleep
(365,0,0,'I haven''t slept in two days.'),
(365,1,1,'You should sleep.'),
(365,2,0,'I can''t.'),
(365,3,1,'Why not?'),
(365,4,2,'Nightmares.'),
(365,5,0,'About what?'),
(365,6,2,'I don''t want to talk about it.'),

-- 366 (32, neutral, 2) Razorfen thorns
(366,0,0,'Everything here is a thorn with opinions.'),
(366,1,1,'That''s a quilboar home.'),
(366,2,0,'I liked the Barrens better.'),
(366,3,1,'The Barrens sent you here. Be polite.'),

-- 367 (14, Alliance, 4) First crush
(367,0,0,'You ever been in love?'),
(367,1,1,'Once.'),
(367,2,0,'What happened?'),
(367,3,1,'She left.'),
(367,4,2,'Why?'),
(367,5,3,'He''s a bad person.'),
(367,6,1,'That''s not why.'),
(367,7,3,'It''s a little why.'),

-- 368 (40, neutral, 2) Kargath ale
(368,0,0,'The ale in Kargath tastes like the mine.'),
(368,1,1,'That''s how you know it''s local.'),
(368,2,0,'I wanted water.'),
(368,3,1,'In the Badlands, ale is the water that fought back.'),

-- 369 (40, neutral, 3) Bad at lying again
(369,0,0,'You''re lying.'),
(369,1,1,'I''m not.'),
(369,2,0,'Your ears are red.'),
(369,3,1,'They''re always red.'),
(369,4,2,'They''re redder now.'),
(369,5,0,'That''s not a thing.'),

-- 370 (56, neutral, 2) Dire Maul tribute
(370,0,0,'The ogres want a tribute.'),
(370,1,1,'Everyone wants a tribute.'),
(370,2,0,'These ones will smash us if we skip it.'),
(370,3,1,'Then it''s a fair tribute. Pay the ogres.'),

-- 371 (20, neutral, 3) Bad bosses
(371,0,0,'I had a terrible boss once.'),
(371,1,1,'What did they do?'),
(371,2,0,'Made me dig latrines.'),
(371,3,1,'That''s not that bad.'),
(371,4,2,'For six months.'),
(371,5,0,'That''s bad.'),
(371,6,2,'That''s very bad.'),

-- 372 (58, neutral, 3) Old enemies
(372,0,0,'You ever respect an enemy?'),
(372,1,1,'Once.'),
(372,2,0,'Who?'),
(372,3,1,'A Horde captain.'),
(372,4,2,'What did he do?'),
(372,5,1,'He let my squad go.'),
(372,6,0,'Why?'),
(372,7,1,'He said we weren''t worth killing.'),
(372,8,2,'That''s not respect.'),
(372,9,1,'It was respect.'),

-- 373 (42, neutral, 4) What now
(373,0,0,'What now?'),
(373,1,1,'We keep going.'),
(373,2,0,'For how long?'),
(373,3,1,'Until we stop.'),
(373,4,2,'When do we stop?'),
(373,5,3,'When we''re dead.'),
(373,6,0,'That''s morbid.'),
(373,7,3,'That''s honest.'),

-- 374 (24, neutral, 3) Broken gear again
(374,0,0,'My sword is dull.'),
(374,1,1,'Sharpen it.'),
(374,2,0,'No whetstone.'),
(374,3,1,'Use a rock.'),
(374,4,2,'That''s not how it works.'),
(374,5,0,'That''s how I do it.'),
(374,6,2,'That''s why your sword is dull.'),

-- 375 (8, Alliance, 3) Bad manners
(375,0,0,'You ever burp in public?'),
(375,1,1,'No.'),
(375,2,0,'Why not?'),
(375,3,1,'It''s rude.'),
(375,4,2,'It''s natural.'),
(375,5,0,'It''s both.'),

-- 376 (40, neutral, 3) Homesick again
(376,0,0,'I want to go home.'),
(376,1,1,'You said that.'),
(376,2,0,'I still mean it.'),
(376,3,1,'What''s stopping you?'),
(376,4,2,'The gold.'),
(376,5,0,'There''s always gold.'),

-- 377 (56, neutral, 2) UBRS key hunt
(377,0,0,'The key is upstairs.'),
(377,1,1,'Everything in Blackrock is upstairs or on fire.'),
(377,2,0,'Sometimes both.'),
(377,3,1,'That''s the review of the mountain.'),

-- 378 (18, neutral, 3) Bad at fighting
(378,0,0,'I''m not good at fighting.'),
(378,1,1,'You''re fine.'),
(378,2,0,'I missed three times.'),
(378,3,1,'That''s not bad.'),
(378,4,2,'It''s a little bad.'),
(378,5,0,'It''s very bad.'),

-- 379 (10, neutral, 2) Hearthstone cool
(379,0,0,'My hearthstone is still cooling.'),
(379,1,1,'Then we walk.'),
(379,2,0,'Walking is why I bought a hearthstone.'),
(379,3,1,'Walking is why you''re still alive.'),

-- 380 (46, neutral, 3) What's in the box
(380,0,0,'What''s in the box?'),
(380,1,1,'Don''t open it.'),
(380,2,0,'Why not?'),
(380,3,1,'Because I said so.'),
(380,4,2,'That''s not a reason.'),
(380,5,0,'It''s a good reason.'),
(380,6,2,'It''s not a reason at all.'),

-- 381 (12, Alliance, 2) Deeprun Tram late
(381,0,0,'The tram was late.'),
(381,1,1,'It''s underground. Late for what?'),
(381,2,0,'My patience.'),
(381,3,1,'Then it was on time for the rest of us.'),

-- 382 (18, neutral, 3) Sleep again
(382,0,0,'I dreamed about this place.'),
(382,1,1,'We''ve never been here.'),
(382,2,0,'I know.'),
(382,3,1,'That''s creepy.'),
(382,4,2,'It''s just a dream.'),
(382,5,0,'It''s a creepy dream.'),

-- 383 (50, Horde, 3) New recruits
(383,0,0,'The new recruits are getting younger.'),
(383,1,1,'They''re the same age.'),
(383,2,0,'We''re getting older.'),
(383,3,1,'That''s how it works.'),
(383,4,2,'I don''t like it.'),
(383,5,0,'Nobody likes it.'),

-- 384 (20, neutral, 3) Mana break
(384,0,0,'Drink. You''re empty.'),
(384,1,1,'I have one more spell.'),
(384,2,0,'That''s what you said before the last one.'),
(384,3,1,'And I had one more spell.'),
(384,4,2,'Sit. We''re not dying for poetry.'),

-- 385 (60, neutral, 3) End of the world
(385,0,0,'You think the world''s ending?'),
(385,1,1,'Which time?'),
(385,2,0,'This time.'),
(385,3,1,'The world''s always ending.'),
(385,4,2,'That''s not comforting.'),
(385,5,1,'It''s not meant to be.'),

-- 386 (42, Horde, 3) Old allies again
(386,0,0,'We had an Alliance prisoner once.'),
(386,1,1,'What happened to him?'),
(386,2,0,'We let him go.'),
(386,3,1,'Why?'),
(386,4,2,'He was fifteen.'),
(386,5,0,'That''s young.'),
(386,6,2,'That''s very young.'),

-- 387 (34, Horde, 3) Tauren patience
(387,0,0,'Tauren are patient.'),
(387,1,1,'Very.'),
(387,2,0,'You ever see a tauren get angry?'),
(387,3,1,'Once.'),
(387,4,2,'What happened?'),
(387,5,1,'I ran.'),
(387,6,0,'Smart.'),

-- 388 (42, neutral, 3) Bad at cooking yet again
(388,0,0,'You cook?'),
(388,1,1,'Sometimes.'),
(388,2,0,'What do you make?'),
(388,3,1,'Soup.'),
(388,4,2,'What kind?'),
(388,5,0,'Whatever''s in the pot.'),
(388,6,2,'That''s not cooking.'),

-- 389 (42, Horde, 2) Honor
(389,0,0,'Honor matters.'),
(389,1,1,'To who?'),
(389,2,0,'To me.'),
(389,3,1,'That''s enough.'),
(389,4,0,'Is it?'),
(389,5,1,'It''s what you have.'),

-- 390 (48, neutral, 3) Stuck
(390,0,0,'We''re stuck.'),
(390,1,1,'We''re not stuck.'),
(390,2,0,'The door''s locked.'),
(390,3,1,'We''ll find a key.'),
(390,4,2,'There''s no key.'),
(390,5,0,'There''s always a key.'),
(390,6,2,'There''s really not.'),

-- 391 (28, neutral, 2) Thousand Needles lift
(391,0,0,'The Great Lift should not exist.'),
(391,1,1,'Yet here we are, existing on it.'),
(391,2,0,'If the ropes go, we go.'),
(391,3,1,'Then don''t look at the ropes. Look at the horizon.'),

-- 392 (20, neutral, 3) Bad directions again
(392,0,0,'The map says turn right.'),
(392,1,1,'Which right?'),
(392,2,0,'The right right.'),
(392,3,1,'There''s only one right.'),
(392,4,2,'Then why did you ask?'),
(392,5,0,'I wanted to be sure.'),

-- 393 (60, neutral, 3) Old world
(393,0,0,'The old world was different.'),
(393,1,1,'How?'),
(393,2,0,'Quieter.'),
(393,3,1,'That''s just nostalgia.'),
(393,4,2,'It''s not.'),
(393,5,0,'It''s a little nostalgia.'),
(393,6,2,'It''s a lot of nostalgia.'),

-- 394 (60, neutral, 3) Dragons again
(394,0,0,'Dragons are people too.'),
(394,1,1,'They''re dragons.'),
(394,2,0,'Dragons. People. Same thing.'),
(394,3,1,'It''s not the same thing.'),
(394,4,2,'It''s close.'),
(394,5,0,'It''s not close at all.'),

-- 395 (48, neutral, 2) WSG flag
(395,0,0,'Don''t celebrate until the flag is home.'),
(395,1,1,'I wasn''t celebrating. I was breathing.'),
(395,2,0,'It looked like celebrating.'),
(395,3,1,'Then look at the gate, not at me.'),

-- 396 (60, neutral, 2) Bad days
(396,0,0,'I''ve had bad days.'),
(396,1,1,'Everyone has.'),
(396,2,0,'Worse than most.'),
(396,3,1,'Probably not.'),

-- 397 (50, neutral, 3) Old grudges again
(397,0,0,'I still hate them.'),
(397,1,1,'Who?'),
(397,2,0,'Everyone who did this.'),
(397,3,1,'That''s a lot of people.'),
(397,4,2,'It''s a lot of hate.'),
(397,5,0,'It''s what I have.'),

-- 398 (56, neutral, 2) Scholomance key
(398,0,0,'The key is cold.'),
(398,1,1,'It''s a key to a school for the dead. Of course it''s cold.'),
(398,2,0,'I don''t want to go in.'),
(398,3,1,'Nobody does. That''s the entrance exam.'),

-- 399 (5, Alliance, 2) Goldshire overcrowded
(399,0,0,'There''s no bed left at the Lion''s Pride.'),
(399,1,1,'Sleep in the stable.'),
(399,2,0,'With the horses?'),
(399,3,1,'They complain less than the regulars.'),

-- 400 (48, neutral, 2) AB nodes
(400,0,0,'We don''t need the lumber mill.'),
(400,1,1,'We need the lumber mill.'),
(400,2,0,'We need the blacksmith.'),
(400,3,1,'We need both. That''s why it''s a war, not a shopping list.');

INSERT INTO `companion_banter_line` (`script_id`,`line_index`,`speaker_slot`,`text`) VALUES
-- 401 (28, neutral, 2) Shimmering Flats
(401,0,0,'The goblins race like dying is a spectator sport.'),
(401,1,1,'It is. That''s the ticket price.'),
(401,2,0,'I''m not betting.'),
(401,3,1,'Then you''re the only adult on the salt.'),

-- 402 (28, neutral, 2) Old scar
(402,0,0,'This one was a boar. This one was a person.'),
(402,1,1,'You don''t have to inventory.'),
(402,2,0,'I do. Otherwise they blur.'),
(402,3,1,'Then keep the list. Don''t add a third tonight.'),

-- 403 (44, neutral, 3) Lore: the Sundering
(403,0,0,'You know why the world is shaped like this?'),
(403,1,1,'Because of the Sundering.'),
(403,2,0,'Because of the Well of Eternity.'),
(403,3,1,'Same thing.'),
(403,4,2,'It''s not the same thing.'),
(403,5,0,'It''s the same event.'),
(403,6,2,'Same event, different reasons.'),
(403,7,0,'It doesn''t matter now.'),

-- 404 (8, Alliance, 4) First night in the city
(404,0,0,'I''ve never seen so many people.'),
(404,1,1,'Stormwind''s not that big.'),
(404,2,0,'It''s big to me.'),
(404,3,1,'Where are you from?'),
(404,4,2,'A village.'),
(404,5,3,'Which one?'),
(404,6,2,'You wouldn''t know it.'),
(404,7,0,'I''d like to.'),
(404,8,2,'It''s gone now.'),

-- 405 (20, neutral, 2) Rez sickness
(405,0,0,'I feel like I left something in the graveyard.'),
(405,1,1,'You did. A few minutes of your life.'),
(405,2,0,'Can I have them back?'),
(405,3,1,'Walk it off. That''s the whole spell.'),

-- 406 (60, neutral, 3) Monologue: what a veteran saw
(406,0,0,'I''ve seen things you wouldn''t believe.'),
(406,1,1,'Try me.'),
(406,2,0,'I saw a man walk into a plague cloud and come out... different.'),
(406,3,1,'Different how?'),
(406,4,2,'His eyes.'),
(406,5,0,'That''s it?'),
(406,6,2,'His eyes were green.'),
(406,7,1,'That''s not that strange.'),
(406,8,2,'They weren''t green before.'),

-- 407 (44, neutral, 3) Bad directions bit
(407,0,0,'The map says there''s a river here.'),
(407,1,1,'There''s no river here.'),
(407,2,0,'The map is wrong.'),
(407,3,1,'The map is old.'),
(407,4,2,'The map is a lie.'),
(407,5,0,'It''s a very committed lie.'),
(407,6,2,'It''s a very committed map.'),

-- 408 (48, neutral, 3) Lore: the Old Gods
(408,0,0,'You know what''s under the world?'),
(408,1,1,'Rocks.'),
(408,2,0,'Old Gods.'),
(408,3,1,'Rocks and Old Gods.'),
(408,4,2,'The Old Gods are the rocks.'),
(408,5,0,'That''s horrifying.'),
(408,6,2,'That''s true.'),

-- 409 (42, neutral, 3) Monologue: an old friend
(409,0,0,'I had a friend who wanted to be a hero.'),
(409,1,1,'What happened?'),
(409,2,0,'He became one.'),
(409,3,1,'That''s good.'),
(409,4,2,'He died doing it.'),
(409,5,0,'That''s the cost.'),
(409,6,2,'It''s not worth it.'),
(409,7,0,'He thought it was.'),

-- 410 (30, neutral, 3) Tall tale
(410,0,0,'I once fought three ogres at once.'),
(410,1,1,'And?'),
(410,2,0,'I won.'),
(410,3,1,'I don''t believe you.'),
(410,4,2,'He''s lying.'),
(410,5,0,'I''m exaggerating.'),
(410,6,2,'You''re lying.'),
(410,7,0,'I''m telling a story.'),

-- 411 (32, neutral, 3) Bad life advice
(411,0,0,'You should always trust your instincts.'),
(411,1,1,'My instincts told me to run from that bear.'),
(411,2,0,'That was correct.'),
(411,3,1,'I ran into the bear''s den.'),
(411,4,2,'That was incorrect.'),
(411,5,0,'Very incorrect.'),

-- 412 (36, neutral, 4) First time in a raid
(412,0,0,'This is bigger than I expected.'),
(412,1,1,'It''s a dungeon.'),
(412,2,0,'It''s a very big dungeon.'),
(412,3,1,'It''s the same size as the others.'),
(412,4,2,'It''s bigger.'),
(412,5,3,'It''s the same size.'),
(412,6,0,'You''re all wrong.'),

-- 413 (24, neutral, 2) Monologue: the sea
(413,0,0,'I used to sail.'),
(413,1,1,'What happened?'),
(413,2,0,'The sea took my brother.'),
(413,3,1,'I''m sorry.'),
(413,4,0,'I still sail.'),
(413,5,1,'Why?'),
(413,6,0,'Because he loved it.'),

-- 414 (40, neutral, 2) Uldaman map
(414,0,0,'The dwarves left notes in three languages.'),
(414,1,1,'That''s how you know it''s important.'),
(414,2,0,'I can read one.'),
(414,3,1,'Read that one twice. Guess the others.'),

-- 415 (60, neutral, 2) Monologue: the long war
(415,0,0,'I''ve been fighting for ten years.'),
(415,1,1,'Ten years?'),
(415,2,0,'Ten years.'),
(415,3,1,'How do you keep going?'),
(415,4,0,'I don''t know how to stop.'),

-- 416 (28, neutral, 3) Bad advice again
(416,0,0,'When in doubt, hit it harder.'),
(416,1,1,'What if that doesn''t work?'),
(416,2,0,'Hit it harder than that.'),
(416,3,1,'That''s not advice.'),
(416,4,2,'It''s advice.'),
(416,5,0,'It''s bad advice.'),

-- 417 (60, neutral, 3) Lore: Onyxia and Nefarian
(417,0,0,'Nefarian and Onyxia were siblings.'),
(417,1,1,'They were dragons.'),
(417,2,0,'They were siblings.'),
(417,3,1,'Dragons are siblings.'),
(417,4,2,'They were both trying to take over the world.'),
(417,5,0,'Siblings.'),
(417,6,2,'Very committed siblings.'),

-- 418 (60, neutral, 3) Monologue: the last battle
(418,0,0,'I''ve seen the end of the world.'),
(418,1,1,'Which time?'),
(418,2,0,'The time at Ahn''Qiraj.'),
(418,3,1,'What did it look like?'),
(418,4,2,'It looked like a lot of bugs.'),
(418,5,0,'That''s not dramatic.'),
(418,6,2,'It was very dramatic at the time.'),

-- 419 (28, neutral, 2) Monologue: why I left home
(419,0,0,'I left home when I was sixteen.'),
(419,1,1,'Why?'),
(419,2,0,'I wanted to see the world.'),
(419,3,1,'Did you?'),
(419,4,0,'I saw enough of it.'),
(419,5,1,'Would you go back?'),
(419,6,0,'No.'),

-- 420 (48, neutral, 2) Just a ring
(420,0,0,'A whole keep for a ring.'),
(420,1,1,'Rings are small. Keeps are stubborn.'),
(420,2,0,'I wanted a sword.'),
(420,3,1,'Put the ring on. Pretend it''s a sword that whispers.'),

-- 421 (26, neutral, 3) Monologue: my teacher
(421,0,0,'I had a teacher once.'),
(421,1,1,'What did they teach you?'),
(421,2,0,'How to fight.'),
(421,3,1,'And?'),
(421,4,2,'How to die.'),
(421,5,0,'That''s dark.'),
(421,6,2,'It''s practical.'),

-- 422 (60, neutral, 3) Lore: the Burning Legion
(422,0,0,'The Burning Legion is still out there.'),
(422,1,1,'Where?'),
(422,2,0,'Somewhere.'),
(422,3,1,'That''s not helpful.'),
(422,4,2,'It''s not meant to be.'),
(422,5,0,'It''s meant to be a warning.'),
(422,6,2,'It''s both.'),

-- 423 (34, neutral, 3) Monastery library
(423,0,0,'Don''t touch the books.'),
(423,1,1,'I can read.'),
(423,2,0,'That''s not the issue. The issue is the books can read you back.'),
(423,3,1,'That''s a terrible library.'),
(423,4,2,'That''s a Scarlet library.'),

-- 424 (60, neutral, 2) AQ ruins crate
(424,0,0,'The labels are bleached off.'),
(424,1,1,'Open the one that doesn''t hiss.'),
(424,2,0,'None of them hiss.'),
(424,3,1,'Then we''re early. Label them before the quartermaster yells.'),

-- 425 (60, neutral, 4) Monologue: what I lost
(425,0,0,'I lost everything in the Plaguelands.'),
(425,1,1,'Everything?'),
(425,2,0,'My family. My home. My name.'),
(425,3,1,'Your name?'),
(425,4,2,'I''m not who I was.'),
(425,5,3,'That''s true of all of us.'),
(425,6,0,'Not like this.'),
(425,7,3,'No. Not like this.'),

-- 426 (28, neutral, 3) Tall tale
(426,0,0,'I once killed a dragon.'),
(426,1,1,'You did not.'),
(426,2,0,'It was a very small dragon.'),
(426,3,1,'That''s a whelpling.'),
(426,4,2,'It was a very big whelpling.'),

-- 427 (24, neutral, 2) Monologue: the road
(427,0,0,'I''ve been on the road for years.'),
(427,1,1,'Where are you going?'),
(427,2,0,'Somewhere.'),
(427,3,1,'Where?'),
(427,4,0,'Somewhere else.'),
(427,5,1,'That''s not an answer.'),
(427,6,0,'It''s the only answer I have.'),

-- 428 (58, neutral, 3) Lore: the Light and the Shadow
(428,0,0,'The Light and the Shadow are the same thing.'),
(428,1,1,'That''s heresy.'),
(428,2,0,'It''s philosophy.'),
(428,3,1,'It''s heresy.'),
(428,4,2,'It can be both.'),
(428,5,0,'It usually is.'),

-- 429 (24, neutral, 3) Bad directions
(429,0,0,'I think we''re going in circles.'),
(429,1,1,'We''re not.'),
(429,2,0,'That''s the same tree.'),
(429,3,1,'It''s a different tree.'),
(429,4,2,'It''s the same tree.'),
(429,5,2,'We''re going in circles.'),

-- 430 (18, neutral, 2) Venture Company
(430,0,0,'The goblins named a company after venture.'),
(430,1,1,'That''s honest. The trees aren''t stockholders.'),
(430,2,0,'The tauren are angry.'),
(430,3,1,'The tauren are right. That''s not always the same as winning.'),

-- 431 (54, neutral, 3) LBRS ropes
(431,0,0,'Don''t trust that ledge.'),
(431,1,1,'I wasn''t going to.'),
(431,2,0,'You were looking at it like a shortcut.'),
(431,3,1,'Looking isn''t jumping.'),
(431,4,2,'With him it is.'),

-- 432 (26, neutral, 2) Monologue: what I miss
(432,0,0,'I miss the smell of bread.'),
(432,1,1,'Where from?'),
(432,2,0,'Home.'),
(432,3,1,'Where''s home?'),
(432,4,0,'Gone.'),
(432,5,1,'I''m sorry.'),
(432,6,0,'Thank you.'),

-- 433 (18, neutral, 3) Tall tale
(433,0,0,'I once punched a bear.'),
(433,1,1,'You did not.'),
(433,2,0,'I did.'),
(433,3,1,'What happened?'),
(433,4,2,'The bear punched back.'),
(433,5,0,'That''s the story.'),
(433,6,2,'That''s the whole story.'),

-- 434 (46, neutral, 3) Lore: the Titans
(434,0,0,'The Titans shaped this world.'),
(434,1,1,'And then left.'),
(434,2,0,'They had other worlds.'),
(434,3,1,'That''s not comforting.'),
(434,4,2,'It''s not meant to be.'),
(434,5,0,'It''s a fact.'),

-- 435 (20, neutral, 4) First kill
(435,0,0,'I killed someone today.'),
(435,1,1,'How do you feel?'),
(435,2,0,'Sick.'),
(435,3,1,'That''s normal.'),
(435,4,2,'That''s very normal.'),
(435,5,3,'That''s the right feeling.'),
(435,6,0,'I hope so.'),
(435,7,1,'You will.'),

-- 436 (46, neutral, 3) Monologue: the man I was
(436,0,0,'I used to be a farmer.'),
(436,1,1,'What happened?'),
(436,2,0,'The Horde came.'),
(436,3,1,'And?'),
(436,4,2,'And now I''m this.'),
(436,5,0,'That''s not a bad thing.'),
(436,6,2,'It''s a different thing.'),

-- 437 (48, neutral, 2) We don't call
(437,0,0,'We don''t call it.'),
(437,1,1,'Agreed.'),
(437,2,0,'If it calls us?'),
(437,3,1,'We were already leaving. That''s the answer.'),

-- 438 (24, Alliance, 2) Monologue: my father
(438,0,0,'My father was a soldier.'),
(438,1,1,'Was?'),
(438,2,0,'He died in the First War.'),
(438,3,1,'I''m sorry.'),
(438,4,0,'I never met him.'),
(438,5,1,'That''s worse.'),
(438,6,0,'It''s different.'),

-- 439 (28, neutral, 2) Door or wall
(439,0,0,'That''s a door.'),
(439,1,1,'That''s a wall with ambitions.'),
(439,2,0,'I can open it.'),
(439,3,1,'Open it slowly. Ambitions bite.'),

-- 440 (60, neutral, 3) Lore: the Qiraji
(440,0,0,'The Qiraji were sealed for a thousand years.'),
(440,1,1,'And we opened them.'),
(440,2,0,'We didn''t open them.'),
(440,3,1,'We opened them.'),
(440,4,2,'The gates opened.'),
(440,5,0,'Same thing.'),
(440,6,2,'Different thing.'),

-- 441 (60, neutral, 3) Monologue: the weight
(441,0,0,'You ever carry a body?'),
(441,1,1,'Once.'),
(441,2,0,'They''re heavier than you think.'),
(441,3,1,'I know.'),
(441,4,2,'Not like that.'),
(441,5,0,'Like what?'),
(441,6,2,'Like they''re still holding on.'),

-- 442 (50, Horde, 2) Monologue: Thrall
(442,0,0,'Thrall saved us.'),
(442,1,1,'He did.'),
(442,2,0,'He freed us.'),
(442,3,0,'And now he''s a politician.'),
(442,4,1,'That''s the price.'),

-- 443 (60, neutral, 2) Monologue: the long dark
(443,0,0,'I''ve been in the dark so long I forgot the sun.'),
(443,1,1,'That''s poetic.'),
(443,2,0,'It''s true.'),
(443,3,1,'Did you see it again?'),
(443,4,0,'Once.'),
(443,5,1,'How was it?'),
(443,6,0,'Bright.'),

-- 444 (28, neutral, 2) Smell of old blood
(444,0,0,'This hall already had a fight.'),
(444,1,1,'Recently?'),
(444,2,0,'Recently enough that we shouldn''t add a second.'),
(444,3,1,'Too late. We''re the second. Stay tight.'),

-- 445 (60, neutral, 3) Lore: the Lich King
(445,0,0,'The Lich King is still out there.'),
(445,1,1,'Somewhere.'),
(445,2,0,'North.'),
(445,3,1,'North of what?'),
(445,4,2,'North of everything.'),
(445,5,0,'That''s not helpful.'),
(445,6,2,'That''s not meant to be.'),

-- 446 (22, Alliance, 3) Monologue: first love
(446,0,0,'I was in love once.'),
(446,1,1,'What happened?'),
(446,2,0,'She married someone else.'),
(446,3,1,'Why?'),
(446,4,2,'He was a lord.'),
(446,5,0,'That''s shallow.'),
(446,6,2,'That''s practical.'),

-- 447 (40, neutral, 3) Tall tale
(447,0,0,'I once outran a horse.'),
(447,1,1,'You did not.'),
(447,2,0,'I did.'),
(447,3,1,'How?'),
(447,4,2,'The horse was tired.'),
(447,5,0,'That doesn''t count.'),
(447,6,2,'It counts.'),

-- 448 (12, Alliance, 2) Monologue: my mother
(448,0,0,'My mother told me never to go into caves.'),
(448,1,1,'And?'),
(448,2,0,'Here I am.'),
(448,3,1,'In a cave.'),

-- 449 (60, neutral, 2) Naxx frost
(449,0,0,'The air from that thing is winter in the wrong month.'),
(449,1,1,'Don''t stand in the breath.'),
(449,2,0,'I''m not.'),
(449,3,1,'You''re leaning. Leaning is standing. Move.'),

-- 450 (26, neutral, 2) Stockade rats
(450,0,0,'The Stockade has rats the size of cats.'),
(450,1,1,'That''s a prison. That''s the livestock.'),
(450,2,0,'I''m not eating one.'),
(450,3,1,'Good. We still have standards.'),

-- 451 (5, Horde, 3) Bad directions
(451,0,0,'Where''s Orgrimmar?'),
(451,1,1,'That way.'),
(451,2,0,'You''re pointing at a rock.'),
(451,3,1,'Past the rock.'),
(451,4,2,'Still a rock.'),
(451,5,0,'It''s a big rock.'),

-- 452 (60, neutral, 4) Monologue: the cost
(452,0,0,'You ever wonder what it cost us?'),
(452,1,1,'The war?'),
(452,2,0,'Everything.'),
(452,3,1,'That''s a lot.'),
(452,4,2,'It is a lot.'),
(452,5,3,'It was worth it.'),
(452,6,0,'Was it?'),
(452,7,3,'It has to be.'),

-- 453 (40, neutral, 2) Uldaman stones
(453,0,0,'These halls were cut by people who expected to be remembered.'),
(453,1,1,'They were. By dust.'),
(453,2,0,'That''s grim.'),
(453,3,1,'That''s archaeology.'),

-- 454 (28, neutral, 2) Hold the line
(454,0,0,'Hold.'),
(454,1,1,'I am.'),
(454,2,0,'Hold like you mean the ground.'),
(454,3,1,'I mean the ground. The ground can tell.'),

-- 455 (50, neutral, 3) Lore: Silithus
(455,0,0,'Silithus was a forest once.'),
(455,1,1,'What happened?'),
(455,2,0,'The Qiraji.'),
(455,3,1,'The bugs?'),
(455,4,2,'The bugs.'),
(455,5,0,'Bugs did that?'),
(455,6,2,'Bugs and time.'),

-- 456 (48, neutral, 3) Tall tale again
(456,0,0,'I once wrestled a bear.'),
(456,1,1,'You did not.'),
(456,2,0,'I did.'),
(456,3,1,'What happened?'),
(456,4,2,'I lost.'),
(456,5,0,'That''s not a good story.'),
(456,6,2,'It''s an honest story.'),

-- 457 (24, Alliance, 2) Southshore inn
(457,0,0,'The Southshore inn smells like wet wool.'),
(457,1,1,'That''s the weather coming inside.'),
(457,2,0,'I asked for a dry room.'),
(457,3,1,'They gave you a sense of humor instead.'),

-- 458 (60, neutral, 2) Kel'Thuzad name
(458,0,0,'Don''t say his name like a joke.'),
(458,1,1,'I wasn''t.'),
(458,2,0,'You were smiling.'),
(458,3,1,'Then I stopped. That''s the whole conversation.'),

-- 459 (36, neutral, 2) Dustwallow fog
(459,0,0,'The fog here has a shape.'),
(459,1,1,'Don''t give it a name.'),
(459,2,0,'I was going to say dragon.'),
(459,3,1,'Especially don''t.'),

-- 460 (18, neutral, 2) Harpy nests
(460,0,0,'The wind up here is all feathers and screaming.'),
(460,1,1,'That''s a nest.'),
(460,2,0,'I want the ground.'),
(460,3,1,'Then you should have stayed on it. Watch the sky.'),

-- 461 (52, neutral, 3) Lore: Blackrock
(461,0,0,'Blackrock Mountain was a dwarven city once.'),
(461,1,1,'And now?'),
(461,2,0,'Orcs and dragons.'),
(461,3,1,'That''s a downgrade.'),
(461,4,2,'It''s a change.'),
(461,5,0,'It''s a downgrade.'),
(461,6,2,'It''s both.'),

-- 462 (28, neutral, 2) Fall back
(462,0,0,'Back. Now.'),
(462,1,1,'We can take him.'),
(462,2,0,'We can take the next one. This one gets the hallway.'),
(462,3,1,'Fine. I''m going. Don''t you dare die being brave.'),

-- 463 (24, Alliance, 2) Stockade visit
(463,0,0,'I walked past the Stockade.'),
(463,1,1,'Did you go in?'),
(463,2,0,'I like my visits optional.'),
(463,3,1,'Wise.'),

-- 464 (42, neutral, 2) Feralas rain
(464,0,0,'It rains here like the forest is washing its hands.'),
(464,1,1,'The forest has a lot to wash.'),
(464,2,0,'I like it.'),
(464,3,1,'Then you''re the first. Don''t tell the ogres.'),

-- 465 (48, neutral, 2) Light's Hope quiet
(465,0,0,'Nobody jokes at Light''s Hope after dark.'),
(465,1,1,'The chapel hears you.'),
(465,2,0,'Chapels don''t hear.'),
(465,3,1,'This one does. Keep your voice for the living.'),

-- 466 (18, neutral, 2) Tall tale
(466,0,0,'I once caught a fish this big.'),
(466,1,1,'That''s not that big.'),
(466,2,0,'It was bigger.'),
(466,3,1,'How much bigger?'),
(466,4,0,'A lot bigger.'),

-- 467 (60, neutral, 2) C'Thun eye
(467,0,0,'Don''t look at the eye.'),
(467,1,1,'Which eye?'),
(467,2,0,'Any eye that isn''t yours.'),
(467,3,1,'That''s a lot of eyes. I''ll look at the floor.'),

-- 468 (60, neutral, 2) Bug army
(468,0,0,'They don''t break like people break.'),
(468,1,1,'They''re not people. Stop expecting manners.'),
(468,2,0,'I expected them to stop.'),
(468,3,1,'They stop when the hive stops. Hit the hive.'),

-- 469 (40, neutral, 2) Badlands wash
(469,0,0,'This wash was a river once.'),
(469,1,1,'Once is doing a lot of work in that sentence.'),
(469,2,0,'There''s still mud.'),
(469,3,1,'Mud is a rumor of water. Don''t trust it.'),

-- 470 (5, neutral, 3) Bad directions
(470,0,0,'Where are we going?'),
(470,1,1,'Somewhere.'),
(470,2,0,'Where?'),
(470,3,1,'I don''t know.'),
(470,4,2,'Then why are we going?'),
(470,5,0,'Because we''re going.'),
(470,6,1,'That''s not a reason.'),

-- 471 (8, Alliance, 2) Ironforge slums
(471,0,0,'The Commons is louder than the forge.'),
(471,1,1,'That''s people, not anvils.'),
(471,2,0,'People are worse.'),
(471,3,1,'People buy your drinks. Anvils don''t.'),

-- 472 (60, neutral, 2) Stratholme live
(472,0,0,'Live side or undead side?'),
(472,1,1,'That''s not a choice. That''s a mood.'),
(472,2,0,'I prefer the one with fewer bells.'),
(472,3,1,'Then you prefer disappointment.'),

-- 473 (12, Horde, 2) Valley of Wisdom
(473,0,0,'Thrall''s keep is quieter than I expected.'),
(473,1,1,'He doesn''t need to shout. The city does it for him.'),
(473,2,0,'Has anyone actually seen him today?'),
(473,3,1,'That''s not a question you ask out loud.'),

-- 474 (26, neutral, 3) Tall tale
(474,0,0,'I once climbed a mountain.'),
(474,1,1,'Which one?'),
(474,2,0,'The tall one.'),
(474,3,1,'That''s not a name.'),
(474,4,2,'It doesn''t have a name.'),
(474,5,0,'It does have a name.'),

-- 475 (60, neutral, 2) Winterspring owl
(475,0,0,'That owl is too big.'),
(475,1,1,'That''s a wildkin.'),
(475,2,0,'That''s an owl with a grudge.'),
(475,3,1,'Don''t name it. Naming it makes it personal.'),

-- 476 (42, Horde, 2) Shadowprey
(476,0,0,'Shadowprey Village is quieter than the rest of Desolace.'),
(476,1,1,'The sea does the shouting.'),
(476,2,0,'I like it.'),
(476,3,1,'Don''t get comfortable. The centaur didn''t.'),

-- 477 (10, neutral, 3) Bag space
(477,0,0,'I can''t carry another copper ore.'),
(477,1,1,'Then stop picking it up.'),
(477,2,0,'It''s ore.'),
(477,3,1,'It''s weight. Learn the difference.'),
(477,4,2,'Drop the boar meat first.'),

-- 478 (60, neutral, 3) Lore: the Dark Portal
(478,0,0,'The Dark Portal was opened by Medivh.'),
(478,1,1,'And closed by the Alliance.'),
(478,2,0,'And now it''s closed.'),
(478,3,1,'For now.'),
(478,4,0,'That''s ominous.'),
(478,5,2,'It''s honest.'),

-- 479 (52, neutral, 3) Monologue: my friend
(479,0,0,'I had a friend who was a paladin.'),
(479,1,1,'What happened?'),
(479,2,0,'He fell.'),
(479,3,1,'Fell?'),
(479,4,2,'In battle.'),
(479,5,0,'I''m sorry.'),
(479,6,2,'He was a good man.'),
(479,7,0,'Then he died well.'),

-- 480 (46, neutral, 2) Tanaris beetles
(480,0,0,'The beetles here are a professional insult.'),
(480,1,1,'They''re just hungry.'),
(480,2,0,'So am I. I don''t chew boots.'),
(480,3,1,'Then you''re losing. Keep your boots on.'),

-- 481 (5, Horde, 2) Razor Hill heat
(481,0,0,'Razor Hill is a frying pan with a watchtower.'),
(481,1,1,'That''s Durotar.'),
(481,2,0,'I asked for shade.'),
(481,3,1,'There''s a rock. Sit behind it.'),

-- 482 (28, neutral, 2) Worse later
(482,0,0,'We''ll talk later.'),
(482,1,1,'We won''t.'),
(482,2,0,'We might.'),
(482,3,1,'We won''t. That''s how we stay a party and not a trial.'),

-- 483 (52, neutral, 2) BRD lockdown
(483,0,0,'If they lock the door, we live here now.'),
(483,1,1,'That''s not a joke.'),
(483,2,0,'It''s a schedule.'),
(483,3,1,'Then we don''t let them lock the door.'),

-- 484 (16, Horde, 3) Monologue: first weapon
(484,0,0,'My first weapon was a stick.'),
(484,1,1,'A stick?'),
(484,2,0,'A sharp stick.'),
(484,3,1,'That''s a spear.'),
(484,4,2,'It''s a stick.'),
(484,5,0,'It''s a spear.'),

-- 485 (18, neutral, 2) Night insects
(485,0,0,'The insects are organizing.'),
(485,1,1,'They''re eating. That''s not a union.'),
(485,2,0,'It sounds like a union.'),
(485,3,1,'Smoke. They hate smoke. So will you. Choose.'),

-- 486 (60, neutral, 2) Monologue: what I lost again
(486,0,0,'I lost my wife in the Plaguelands.'),
(486,1,1,'I''m sorry.'),
(486,2,0,'I keep going.'),
(486,3,1,'Why?'),
(486,4,0,'Because she would want me to.'),
(486,5,1,'That''s a good reason.'),
(486,6,0,'It''s the only reason.'),

-- 487 (44, neutral, 2) Hinterlands altar
(487,0,0,'The trolls left the altar clean.'),
(487,1,1,'That''s worse than messy.'),
(487,2,0,'Why?'),
(487,3,1,'Messy means they left. Clean means they''re coming back.'),

-- 488 (60, neutral, 2) War effort pies
(488,0,0,'Someone donated pies to the war.'),
(488,1,1,'Armies eat. That''s not a joke.'),
(488,2,0,'I thought it was cloth and metal.'),
(488,3,1,'It''s also pies. Write that down.'),

-- 489 (5, Alliance, 2) Monologue: first home
(489,0,0,'I was born in Elwynn.'),
(489,1,1,'Nice place.'),
(489,2,0,'It was.'),
(489,3,1,'Was?'),
(489,4,0,'I can''t go back.'),
(489,5,1,'Why not?'),
(489,6,0,'Too many memories.'),

-- 490 (10, neutral, 2) Vendor trash
(490,0,0,'Why do we keep grey items?'),
(490,1,1,'Because vendors have gold and we have pockets.'),
(490,2,0,'My pockets have holes.'),
(490,3,1,'Then you have a vendor problem and a tailor problem.'),

-- 491 (20, neutral, 3) Warlock healthstone
(491,0,0,'Eat the stone.'),
(491,1,1,'It looks like a rock.'),
(491,2,0,'It is a rock. A useful one.'),
(491,3,1,'That''s a low standard for dinner.'),
(491,4,2,'It''s a high standard for not dying.'),

-- 492 (60, neutral, 2) Light's Hope hammer
(492,0,0,'He blessed the hammer like it could hear.'),
(492,1,1,'Maybe it can.'),
(492,2,0,'It''s metal.'),
(492,3,1,'So are we, on a good day. Let him finish.'),

-- 493 (40, neutral, 2) Sun prayer
(493,0,0,'The sun here is a personal attack.'),
(493,1,1,'It''s the same sun.'),
(493,2,0,'It wasn''t this rude in the forest.'),
(493,3,1,'The forest was a hat. Buy an actual one.'),

-- 494 (60, neutral, 2) Stratholme holy water
(494,0,0,'Don''t spill it.'),
(494,1,1,'I know what it is.'),
(494,2,0,'Knowing and not spilling are different skills.'),
(494,3,1,'Then walk behind me. I''ll do both.'),

-- 495 (24, Alliance, 3) Theramore walls
(495,0,0,'Theramore looks like it was built to last a siege.'),
(495,1,1,'It was.'),
(495,2,0,'Has it had one?'),
(495,3,1,'Give it time.'),
(495,4,2,'Don''t.'),

-- 496 (42, neutral, 3) Monologue: my mother
(496,0,0,'My mother was a healer.'),
(496,1,1,'Was?'),
(496,2,0,'She died in the plague.'),
(496,3,1,'I''m sorry.'),
(496,4,2,'She saved a lot of people.'),
(496,5,0,'That''s something.'),
(496,6,2,'It''s everything.'),

-- 497 (12, Horde, 2) Sen'jin beach
(497,0,0,'The trolls at Sen''jin fish like the sea owes them.'),
(497,1,1,'It does. It took the islands.'),
(497,2,0,'Do they ever catch enough?'),
(497,3,1,'They catch stories. Fish are extra.'),

-- 498 (14, Alliance, 2) Lakeshire bridge
(498,0,0,'They keep rebuilding the Lakeshire bridge.'),
(498,1,1,'The orcs keep unbuilding it.'),
(498,2,0,'That''s not a word.'),
(498,3,1,'It is on that bridge.'),

-- 499 (56, neutral, 4) Monologue: what I remember
(499,0,0,'I remember the world before the war.'),
(499,1,1,'What was it like?'),
(499,2,0,'Quiet.'),
(499,3,1,'Just quiet?'),
(499,4,2,'Quiet and green.'),
(499,5,3,'That sounds nice.'),
(499,6,0,'It was.'),
(499,7,3,'Do you miss it?'),

-- 500 (42, Horde, 2) Grom'gol
(500,0,0,'Grom''gol is a camp with jungle pressing on every post.'),
(500,1,1,'The jungle wants the camp back.'),
(500,2,0,'The tigers are already collecting rent.'),
(500,3,1,'Pay in arrows.');

INSERT INTO `companion_banter_line` (`script_id`,`line_index`,`speaker_slot`,`text`) VALUES
-- 501 (18, neutral, 3) Bad directions
(501,0,0,'We should have taken the other path.'),
(501,1,1,'There was no other path.'),
(501,2,0,'There was definitely another path.'),
(501,3,1,'It was covered in spiders.'),
(501,4,2,'And this one isn''t?'),
(501,5,0,'...Good point.'),

-- 502 (20, neutral, 2) Shaman totems
(502,0,0,'Why are there four sticks in the dirt?'),
(502,1,1,'They''re not sticks.'),
(502,2,0,'They look like sticks.'),
(502,3,1,'Don''t kick them. That''s an order.'),

-- 503 (32, neutral, 2) Arathi mill
(503,0,0,'The mill still turns.'),
(503,1,1,'The war didn''t need flour. The mill didn''t care.'),
(503,2,0,'That''s stubborn.'),
(503,3,1,'That''s a mill.'),

-- 504 (48, neutral, 3) Lore: the Black Flight
(504,0,0,'The black dragonflight was almost wiped out.'),
(504,1,1,'Almost.'),
(504,2,0,'Almost is a lot when you''re talking about dragons.'),
(504,3,1,'Almost is nothing when you''re talking about dragons.'),
(504,4,2,'Which is it?'),
(504,5,0,'Both.'),

-- 505 (24, Alliance, 3) City talk
(505,0,0,'Do you ever miss Stormwind?'),
(505,1,1,'I miss the bread.'),
(505,2,0,'You always say that.'),
(505,3,1,'It''s good bread.'),
(505,4,2,'It''s bread.'),
(505,5,0,'It''s Stormwind bread.'),

-- 506 (26, neutral, 2) Southshore versus
(506,0,0,'You can smell Tarren Mill from here when the wind''s wrong.'),
(506,1,1,'That''s not smell. That''s politics.'),
(506,2,0,'Politics smell.'),
(506,3,1,'In Hillsbrad they do.'),

-- 507 (28, neutral, 3) Monster talk
(507,0,0,'You ever notice how many things want to kill us?'),
(507,1,1,'Everything.'),
(507,2,0,'Not everything.'),
(507,3,1,'Everything with teeth.'),
(507,4,2,'And some without.'),
(507,5,0,'Fair.'),

-- 508 (28, neutral, 2) Tall tale
(508,0,0,'I once fought a dragon.'),
(508,1,1,'You did not.'),
(508,2,0,'I did.'),
(508,3,1,'What kind?'),
(508,4,0,'A small one.'),
(508,5,1,'A whelpling.'),
(508,6,0,'A dragon.'),

-- 509 (40, neutral, 3) Bad advice
(509,0,0,'You know what your problem is?'),
(509,1,1,'No.'),
(509,2,0,'You overthink everything.'),
(509,3,1,'That''s not a problem.'),
(509,4,2,'It is when you''re being hit.'),
(509,5,0,'That''s fair.'),

-- 510 (60, neutral, 4) Monologue: what we're really doing
(510,0,0,'You know what we''re actually doing?'),
(510,1,1,'Killing things.'),
(510,2,0,'Looting.'),
(510,3,1,'Getting paid.'),
(510,4,0,'We''re keeping the world from ending.'),
(510,5,2,'That too.'),
(510,6,3,'Mostly the first three.'),

-- 511 (42, neutral, 2) Swamp of Sorrows
(511,0,0,'The name is not subtle.'),
(511,1,1,'The swamp didn''t hire a poet.'),
(511,2,0,'The green dragons might have.'),
(511,3,1,'Then the poet quit. Walk the dry bits.'),

-- 512 (38, neutral, 4) Desolace
(512,0,0,'Desolace is depressing.'),
(512,1,1,'It''s a wasteland.'),
(512,2,0,'It used to be a jungle.'),
(512,3,1,'What happened?'),
(512,4,2,'The centaur.'),
(512,5,3,'And time.'),
(512,6,0,'Mostly time.'),

-- 513 (60, neutral, 3) Monologue: what I carry
(513,0,0,'You know what I keep in my pack?'),
(513,1,1,'Loot.'),
(513,2,0,'A letter.'),
(513,3,1,'From who?'),
(513,4,2,'My sister.'),
(513,5,0,'Where is she?'),
(513,6,2,'Dead.'),

-- 514 (26, neutral, 2) Ashenvale logging
(514,0,0,'The stumps go on for a mile.'),
(514,1,1,'That''s a war measured in lumber.'),
(514,2,0,'The elves aren''t going to forget.'),
(514,3,1,'Nobody asked them to. That''s the problem.'),

-- 515 (26, neutral, 2) It's a trap
(515,0,0,'If it looks like a chest, it isn''t.'),
(515,1,1,'That''s a sad way to live.'),
(515,2,0,'It''s a long way to live.'),
(515,3,1,'Fine. You open it. I''ll stand back and be right.'),

-- 516 (44, neutral, 3) Lore: Jintha'Alor
(516,0,0,'Jintha''Alor was a troll city.'),
(516,1,1,'Was?'),
(516,2,0,'Still is.'),
(516,3,1,'Then why ''was''?'),
(516,4,2,'Because nobody lives there anymore.'),
(516,5,0,'Trolls do.'),
(516,6,2,'Not the same trolls.'),

-- 517 (36, neutral, 2) Next time
(517,0,0,'Next time we mark the trap.'),
(517,1,1,'Next time we don''t step where the last fool stepped.'),
(517,2,0,'That was me.'),
(517,3,1,'I know. That''s why I''m saying it kindly.'),

-- 518 (24, Alliance, 2) Refuge Pointe
(518,0,0,'Refuge Pointe is well named.'),
(518,1,1,'It''s a point. It''s not much of a refuge.'),
(518,2,0,'The walls are trying.'),
(518,3,1,'The ogres aren''t.'),

-- 519 (5, Alliance, 2) Monologue: first day
(519,0,0,'My first day in the army I cried.'),
(519,1,1,'Everyone does.'),
(519,2,0,'You did?'),

-- 520 (60, neutral, 3) Plagueland well
(520,0,0,'Don''t drink from that well.'),
(520,1,1,'I wasn''t going to.'),
(520,2,0,'You were looking at it like water.'),
(520,3,1,'It was a well. Old habit.'),
(520,4,2,'New habit: don''t.'),

-- 521 (40, neutral, 3) Tall tale
(521,0,0,'I once walked from Feralas to Tanaris.'),
(521,1,1,'That''s a long walk.'),
(521,2,0,'It was.'),
(521,3,1,'Why?'),
(521,4,2,'I had no money.'),
(521,5,0,'That''s fair.'),

-- 522 (60, neutral, 3) Monologue: what I've seen
(522,0,0,'I''ve seen a man turn into a sheep and forget he was a man.'),
(522,1,1,'That''s the spell.'),
(522,2,0,'He forgot permanently.'),
(522,3,1,'That''s not the spell.'),
(522,4,2,'That''s what happened.'),
(522,5,0,'That''s terrifying.'),

-- 523 (28, neutral, 3) Bad advice
(523,0,0,'You should drink more water.'),
(523,1,1,'We''re in a cave.'),
(523,2,0,'There''s water everywhere.'),
(523,3,1,'It''s not clean water.'),
(523,4,2,'It''s fine.'),
(523,5,0,'It''s really not.'),

-- 524 (60, neutral, 3) Lore: the Scourge
(524,0,0,'The Scourge grows every day.'),
(524,1,1,'It always grows.'),
(524,2,0,'One day it''ll be everywhere.'),
(524,3,1,'Not if we stop it.'),
(524,4,2,'We can''t stop it.'),
(524,5,0,'We can slow it.'),
(524,6,2,'For a while.'),

-- 525 (5, Alliance, 3) Elwynn fence
(525,0,0,'The farmer asked us to watch his fence.'),
(525,1,1,'That''s not a contract.'),
(525,2,0,'He paid in apples.'),
(525,3,1,'Then it''s a contract.'),
(525,4,2,'A short one.'),

-- 526 (5, neutral, 3) Monster talk
(526,0,0,'That wolf is looking at us.'),
(526,1,1,'Wolves always look at people.'),
(526,2,0,'This one is looking at us specifically.'),
(526,3,1,'That''s what looking means.'),
(526,4,2,'It''s a hungry look.'),
(526,5,0,'They''re always hungry.'),

-- 527 (20, neutral, 2) Mage food
(527,0,0,'Is this bread real?'),
(527,1,1,'It''s bread until it isn''t.'),
(527,2,0,'That''s not an answer.'),
(527,3,1,'Eat it before the spell changes its mind.'),

-- 528 (36, neutral, 2) Monologue: first hunt
(528,0,0,'My first hunt I killed a rabbit.'),
(528,1,1,'Everyone starts small.'),
(528,2,0,'I cried.'),
(528,3,1,'Everyone does.'),

-- 529 (52, neutral, 2) BRM attunement
(529,0,0,'Another letter. Another seal.'),
(529,1,1,'That''s how mountains keep guests out.'),
(529,2,0,'I have four letters.'),
(529,3,1,'Then you''re almost a guest. Don''t lose the fourth.'),

-- 530 (38, neutral, 2) Wipe story
(530,0,0,'Don''t tell that story in the tavern.'),
(530,1,1,'It''s a good story.'),
(530,2,0,'It''s a story where we all died.'),
(530,3,1,'That''s why it''s good. We''re here to ruin the ending.'),

-- 531 (5, Horde, 3) Tall tale
(531,0,0,'I once shot a bird out of the sky.'),
(531,1,1,'How far?'),
(531,2,0,'Very far.'),
(531,3,1,'How far is very far?'),
(531,4,2,'It was up there.'),
(531,5,0,'That''s not a distance.'),

-- 532 (30, neutral, 3) Lore: Alterac
(532,0,0,'Alterac used to be a kingdom.'),
(532,1,1,'What happened?'),
(532,2,0,'They betrayed the Alliance.'),
(532,3,1,'And?'),
(532,4,2,'And now they''re bandits.'),
(532,5,0,'That''s a downgrade.'),

-- 533 (40, neutral, 2) Almost had it
(533,0,0,'We almost had it.'),
(533,1,1,'Almost is how ghosts talk.'),
(533,2,0,'We''ll get it next time.'),
(533,3,1,'Next time we bring more water and less almost.'),

-- 534 (12, Alliance, 2) Cathedral pigeons
(534,0,0,'The cathedral square is full of pigeons.'),
(534,1,1,'They''re waiting for crumbs. Same as us.'),
(534,2,0,'I came for a blessing.'),
(534,3,1,'Take a crumb. It''s closer.'),

-- 535 (56, neutral, 2) Dragonkin patrol
(535,0,0,'They walk like they remember being bigger.'),
(535,1,1,'They were. That''s the insult.'),
(535,2,0,'Do we fight them?'),
(535,3,1,'We don''t start it. We finish it if they do.'),

-- 536 (60, neutral, 2) Argent dawn tabard
(536,0,0,'The tabard is uglier than I expected.'),
(536,1,1,'Ugly is honest. Pretty tabards lie.'),
(536,2,0,'I still want one.'),
(536,3,1,'Earn it. That''s the only tailor they respect.'),

-- 537 (60, neutral, 1) Cenarion dusk
(537,0,0,'The druids don''t look at the sand like it''s an enemy.'),
(537,1,0,'They look at it like a patient.'),
(537,2,0,'I couldn''t do that.'),
(537,3,0,'I look at it like a thing that wants my water. That''s as holy as I get.'),

-- 538 (5, Alliance, 4) First day
(538,0,0,'I just started adventuring.'),
(538,1,1,'How''s it going?'),
(538,2,0,'I''ve died twice.'),
(538,3,1,'That''s not bad.'),
(538,4,2,'That''s pretty bad.'),
(538,5,3,'You''ll die more.'),
(538,6,0,'That''s not comforting.'),
(538,7,3,'It''s not meant to be.'),

-- 539 (24, neutral, 3) Lore: Ashenvale
(539,0,0,'Ashenvale was a night elf forest.'),
(539,1,1,'It still is.'),
(539,2,0,'The Horde is cutting it down.'),
(539,3,1,'That''s a problem.'),
(539,4,2,'That''s a war.'),
(539,5,0,'Same thing.'),

-- 540 (12, Alliance, 3) Stormwind cheese
(540,0,0,'I bought cheese in the Trade District.'),
(540,1,1,'Was it good?'),
(540,2,0,'It was expensive.'),
(540,3,1,'That''s not the same thing.'),
(540,4,2,'In Stormwind it is.'),

-- 541 (28, neutral, 3) Monster talk
(541,0,0,'Have you seen the size of these spiders?'),
(541,1,1,'Big.'),
(541,2,0,'Very big.'),
(541,3,1,'They''re just spiders.'),
(541,4,2,'They''re giant spiders.'),
(541,5,0,'That''s what I said.'),

-- 542 (52, neutral, 2) Just a belt
(542,0,0,'All that for a belt.'),
(542,1,1,'It''s a very good belt.'),
(542,2,0,'It had better hold up a kingdom.'),
(542,3,1,'It''ll hold up your trousers. That''s the miracle.'),

-- 543 (12, Alliance, 3) Lore: Darkshore
(543,0,0,'Darkshore was hit by the Sundering.'),
(543,1,1,'Everything was hit by the Sundering.'),
(543,2,0,'Darkshore more than most.'),
(543,3,1,'That''s fair.'),
(543,4,2,'It''s still pretty.'),
(543,5,0,'It''s still sad.'),

-- 544 (36, neutral, 2) Never again
(544,0,0,'I''m never going in there again.'),
(544,1,1,'You''ll go in tomorrow.'),
(544,2,0,'I won''t.'),
(544,3,1,'You will. That''s why we packed twice the bandages.'),

-- 545 (5, Horde, 2) Orgrimmar echo
(545,0,0,'The Valley of Strength echoes if you shout.'),
(545,1,1,'Don''t shout. The peons already have enough noise.'),
(545,2,0,'I was calling a vendor.'),
(545,3,1,'Walk. It''s faster than shouting.'),

-- 546 (48, neutral, 3) Monster talk again
(546,0,0,'Why is everything in here so angry?'),
(546,1,1,'We''re in their home.'),
(546,2,0,'We are not in their home.'),
(546,3,1,'We''re in a cave.'),
(546,4,2,'That''s their home.'),
(546,5,0,'Fair.'),

-- 547 (12, Horde, 2) Bloodhoof morning
(547,0,0,'Bloodhoof Village smells like grass and cookfires.'),
(547,1,1,'That''s the good version of the Barrens.'),
(547,2,0,'There''s a good version?'),
(547,3,1,'This is as close as it gets.'),

-- 548 (20, neutral, 3) Tall tale
(548,0,0,'I once killed a crocolisk with my bare hands.'),
(548,1,1,'You did not.'),
(548,2,0,'I did.'),
(548,3,1,'How?'),
(548,4,2,'It was a small one.'),
(548,5,0,'That doesn''t count.'),

-- 549 (40, neutral, 3) Lore: Uldaman
(549,0,0,'Uldaman has Titans in it.'),
(549,1,1,'Dead Titans.'),
(549,2,0,'Very dead Titans.'),
(549,3,1,'That''s not comforting.'),
(549,4,2,'It''s not meant to be.'),
(549,5,0,'It''s a warning.'),

-- 550 (40, neutral, 2) Retired wish
(550,0,0,'When I retire I''m going to grow something that doesn''t bite.'),
(550,1,1,'Tomatoes bite if you insult them.'),
(550,2,0,'I''ll be polite to tomatoes.'),
(550,3,1,'Then you''ll last a season. That''s a retirement.'),

-- 551 (48, neutral, 3) Monster talk
(551,0,0,'You ever notice how quiet it gets before something bad happens?'),
(551,1,1,'It''s always quiet.'),
(551,2,0,'Not this quiet.'),
(551,3,1,'You''re imagining it.'),
(551,4,2,'I''m not.'),
(551,5,0,'...It is quiet.'),

-- 552 (50, neutral, 3) Bad advice
(552,0,0,'You should always have a backup plan.'),
(552,1,1,'What''s your backup plan?'),
(552,2,0,'Run.'),
(552,3,1,'That''s not a plan.'),
(552,4,2,'It''s a plan.'),
(552,5,0,'It''s a bad plan.'),

-- 553 (10, neutral, 3) Tall tale
(553,0,0,'I once survived a fall from a cliff.'),
(553,1,1,'You did not.'),
(553,2,0,'I did.'),
(553,3,1,'How high?'),
(553,4,2,'Very high.'),
(553,5,0,'How high is very high?'),
(553,6,2,'It was a small cliff.'),

-- 554 (36, neutral, 3) Lore: Arathi
(554,0,0,'Arathi used to be one kingdom.'),
(554,1,1,'And now?'),
(554,2,0,'Two.'),
(554,3,1,'Which two?'),
(554,4,2,'Stromgarde and the rest.'),
(554,5,0,'That''s not two kingdoms.'),
(554,6,2,'It''s close enough.'),

-- 555 (58, neutral, 1) Light's Hope dusk
(555,0,0,'At dusk this chapel looks like it''s holding the ground down.'),
(555,1,0,'I don''t know if that''s faith or carpentry.'),
(555,2,0,'I don''t need to know.'),
(555,3,0,'I just need it to keep holding until morning.'),

-- 556 (32, neutral, 3) Monster talk
(556,0,0,'Do you ever feel bad for the things we kill?'),
(556,1,1,'Sometimes.'),
(556,2,0,'They''re just animals.'),
(556,3,1,'Some of them.'),
(556,4,2,'Most of them.'),
(556,5,0,'Not the ones that talk.'),

-- 557 (36, neutral, 3) Lore: Dustwallow
(557,0,0,'Theramore is in Dustwallow.'),
(557,1,1,'It''s a human city.'),
(557,2,0,'It''s a human city in the middle of nowhere.'),
(557,3,1,'That''s the point.'),
(557,4,2,'That''s a weird point.'),
(557,5,0,'It''s a strategic point.'),

-- 558 (8, Alliance, 2) Wetlands road
(558,0,0,'The Wetlands road is a suggestion.'),
(558,1,1,'The raptors treat it as a menu.'),
(558,2,0,'I miss proper cobbles.'),
(558,3,1,'Then you miss Stormwind. Keep walking.'),

-- 559 (46, neutral, 3) Monologue: what I carry
(559,0,0,'I carry a rock from my home village.'),
(559,1,1,'Why?'),
(559,2,0,'Because it''s the only thing left.'),
(559,3,1,'That''s sad.'),
(559,4,2,'It''s a rock.'),
(559,5,0,'It''s not just a rock.'),

-- 560 (60, neutral, 2) AV snow
(560,0,0,'The snow in Alterac doesn''t care who wins.'),
(560,1,1,'That''s why both sides keep dying in it.'),
(560,2,0,'I lost a boot.'),
(560,3,1,'Then you lost the war. Find the boot.'),

-- 561 (5, Alliance, 3) Tall tale
(561,0,0,'I once saved a village from bandits.'),
(561,1,1,'You did not.'),
(561,2,0,'I did.'),
(561,3,1,'How many bandits?'),
(561,4,2,'One.'),
(561,5,0,'That''s not a village raid.'),

-- 562 (60, neutral, 1) Help me help it
(562,0,0,'Help me help it.'),
(562,1,0,'That''s a stupid sentence.'),
(562,2,0,'It''s the only one I have that isn''t a speech.'),
(562,3,0,'Drink. Walk. Don''t be brave without telling me first.'),

-- 563 (20, neutral, 2) Torch oil
(563,0,0,'The torch is dying.'),
(563,1,1,'Then stop waving it.'),
(563,2,0,'I''m looking.'),
(563,3,1,'You''re painting the walls. Hold still.'),

-- 564 (52, neutral, 3) Lore: Blackrock Depths
(564,0,0,'BRD was a dwarven city.'),
(564,1,1,'Dark Iron dwarves.'),
(564,2,1,'They''re still there.'),
(564,3,2,'Some of them.'),
(564,4,0,'The ones we haven''t killed.'),

-- 565 (20, neutral, 3) Who has rope
(565,0,0,'Who brought rope?'),
(565,1,1,'You said you''d bring rope.'),
(565,2,0,'I brought food.'),
(565,3,1,'We can''t climb food.'),
(565,4,2,'We can sit and regret. That''s a kind of climbing.'),

-- 566 (34, neutral, 2) Alterac ruins
(566,0,0,'There''s a whole kingdom under this snow.'),
(566,1,1,'There''s a whole warning under this snow.'),
(566,2,0,'We should look.'),
(566,3,1,'We should not. That''s how you join the kingdom.'),

-- 567 (10, neutral, 2) First aid linen
(567,0,0,'We''re out of linen bandages.'),
(567,1,1,'We have wool.'),
(567,2,0,'Wool itches.'),
(567,3,1,'Bleeding itches more.'),

-- 568 (28, neutral, 3) Tall tale
(568,0,0,'I once rode a kodo.'),
(568,1,1,'Everyone rides kodos.'),
(568,2,0,'I rode one bareback.'),
(568,3,1,'That''s different.'),
(568,4,2,'It was very different.'),
(568,5,0,'How?'),
(568,6,2,'It was very bumpy.'),

-- 569 (26, neutral, 3) Bad advice
(569,0,0,'You should always be prepared.'),
(569,1,1,'Prepared for what?'),
(569,2,0,'Anything.'),
(569,3,1,'That''s impossible.'),
(569,4,2,'That''s why I carry rope.'),
(569,5,0,'Rope doesn''t help with everything.'),
(569,6,2,'It helps with most things.'),

-- 570 (54, neutral, 4) Monster talk
(570,0,0,'You ever wonder what''s in the lava?'),
(570,1,1,'Lava.'),
(570,2,0,'Besides lava.'),
(570,3,1,'Rocks.'),
(570,4,2,'Fire.'),
(570,5,3,'Dead things.'),
(570,6,0,'That''s the answer.'),
(570,7,3,'That''s always the answer.'),

-- 571 (58, neutral, 3) Lore: Western Plaguelands
(571,0,0,'The Western Plaguelands used to be Lordaeron.'),
(571,1,1,'It still is.'),
(571,2,0,'It''s not.'),
(571,3,1,'It''s Lordaeron with a different name.'),
(571,4,2,'It''s a corpse with a different name.'),
(571,5,0,'That''s fair.'),

-- 572 (42, Horde, 2) Camp Mojache
(572,0,0,'Camp Mojache smells like herbs and wet feathers.'),
(572,1,1,'The Grimtotem don''t visit for the herbs.'),
(572,2,0,'Do we?'),
(572,3,1,'We visit for the not-dying.'),

-- 573 (52, neutral, 3) Tall tale
(573,0,0,'I once killed a dragon.'),
(573,1,1,'You said that.'),
(573,2,0,'It was a different dragon.'),
(573,3,1,'You''re a liar.'),
(573,4,2,'I''m a storyteller.'),
(573,5,0,'Same thing.'),

-- 574 (26, neutral, 2) Not a chest
(574,0,0,'See?'),
(574,1,1,'Teeth. I see teeth.'),
(574,2,0,'That''s a mimic.'),
(574,3,1,'That''s a reason I don''t open things first.'),

-- 575 (20, neutral, 3) Monster talk
(575,0,0,'Why are there crocodiles in the sewers?'),
(575,1,1,'Someone put them there.'),
(575,2,0,'Who?'),
(575,3,1,'Someone.'),
(575,4,2,'That''s not an answer.'),
(575,5,0,'It''s the only answer.'),

-- 576 (30, neutral, 2) Steamwheedle fee
(576,0,0,'They charged a docking fee and a looking fee.'),
(576,1,1,'Goblins invent fees the way orcs invent wars.'),
(576,2,0,'Is there a leaving fee?'),
(576,3,1,'There will be if you ask.'),

-- 577 (24, neutral, 3) Lore: Blackfathom
(577,0,0,'Blackfathom Deeps is a temple.'),
(577,1,1,'To what?'),
(577,2,0,'Something old.'),
(577,3,1,'Old things are bad.'),
(577,4,2,'Old things are interesting.'),
(577,5,0,'Old things are usually bad.'),

-- 578 (60, neutral, 3) Monster talk
(578,0,0,'You ever wonder what the bugs are thinking?'),
(578,1,1,'They''re not thinking.'),
(578,2,0,'They have a hive mind.'),
(578,3,1,'That''s thinking.'),
(578,4,2,'That''s a lot of thinking.'),
(578,5,0,'That''s the problem.'),

-- 579 (38, neutral, 2) Won't retire
(579,0,0,'You won''t retire.'),
(579,1,1,'I might.'),
(579,2,0,'You won''t. You''ll die with a pack on.'),
(579,3,1,'Then pack lightly. That''s my will.'),

-- 580 (60, neutral, 2) Tall tale
(580,0,0,'I once swam from Menethil to Theramore.'),
(580,1,1,'You did not.'),
(580,2,0,'I did.'),
(580,3,1,'There are sharks.'),
(580,4,0,'I know.'),
(580,5,1,'You''re a liar.'),

-- 581 (22, neutral, 3) Bad advice
(581,0,0,'You should always check for traps.'),
(581,1,1,'We''re in a field.'),
(581,2,0,'You never know.'),
(581,3,2,'There could be traps.'),
(581,4,0,'There are no traps.'),

-- 582 (18, neutral, 3) Monster talk
(582,0,0,'Why do wolves hunt in packs?'),
(582,1,1,'Because it works.'),
(582,2,0,'So do bears.'),
(582,3,1,'Bears are bigger.'),
(582,4,2,'That''s fair.'),

-- 583 (60, neutral, 2) Chillwind letters
(583,0,0,'They''re still sending letters out of Chillwind.'),
(583,1,1,'Someone has to tell the world the plague is still here.'),
(583,2,0,'The world knows.'),
(583,3,1,'The world forgets. That''s why the letters.'),

-- 584 (24, Alliance, 3) Aerie Peak gryphons
(584,0,0,'The gryphons at Aerie Peak look at you like you owe them.'),
(584,1,1,'You do. That''s the fare.'),
(584,2,0,'I paid in silver.'),
(584,3,1,'They prefer meat.'),
(584,4,2,'Pay in meat next time.'),

-- 585 (32, neutral, 2) Desolace bones
(585,0,0,'There are more bones than grass.'),
(585,1,1,'That''s the name of the place, almost.'),
(585,2,0,'Who leaves this many?'),
(585,3,1,'Everyone who passed through and everyone who didn''t.'),

-- 586 (28, neutral, 2) Not a trial
(586,0,0,'I''m not angry.'),
(586,1,1,'You''re walking like a verdict.'),
(586,2,0,'That''s just my knees.'),
(586,3,1,'Then your knees are judgmental. I''ll allow it.'),

-- 587 (5, neutral, 3) Monster talk
(587,0,0,'That rabbit is looking at us.'),
(587,1,1,'It''s a rabbit.'),
(587,2,0,'It''s a very confident rabbit.'),
(587,3,2,'It''s coming toward us.'),
(587,4,0,'Kill it.'),

-- 588 (36, neutral, 2) Lost the argument
(588,0,0,'This place lost the argument.'),
(588,1,1,'With whom?'),
(588,2,0,'Time. Weather. Something with more patience than walls.'),
(588,3,1,'Then we don''t add our names. Passing through is the prayer.'),

-- 589 (18, neutral, 3) Tall tale
(589,0,0,'I once killed a gnoll with a single punch.'),
(589,1,1,'You did not.'),
(589,2,0,'I did.'),
(589,3,1,'What kind of gnoll?'),
(589,4,2,'A small one.'),
(589,5,0,'That doesn''t count.'),

-- 590 (40, neutral, 1) Stupid together
(590,0,0,'We''ll be stupid together.'),
(590,1,0,'That''s not a motto I''d stitch on a tabard.'),
(590,2,0,'It''s the only motto that ever worked.'),
(590,3,0,'The pretty ones are for people who didn''t have to carry anyone.'),

-- 591 (58, neutral, 2) Un'Goro pack
(591,0,0,'Don''t run from the little ones.'),
(591,1,1,'The little ones have parents.'),
(591,2,0,'That''s what I said.'),
(591,3,1,'You said don''t run. I heard don''t die. Same order.'),

-- 592 (22, Alliance, 2) Menethil rain
(592,0,0,'Menethil never dries.'),
(592,1,1,'It''s a harbor. It''s not supposed to.'),
(592,2,0,'My boots disagree.'),
(592,3,1,'Your boots can file a complaint with the tide.'),

-- 593 (34, neutral, 1) I buried worse
(593,0,0,'I''ve buried worse than this.'),
(593,1,0,'That''s not a boast.'),
(593,2,0,'That''s a warning to myself not to get poetic.'),
(593,3,0,'Poetry is for after the shovel.'),

-- 594 (8, Alliance, 3) Monster talk
(594,0,0,'You ever think about what we leave behind?'),
(594,1,1,'Bodies.'),
(594,2,0,'Besides bodies.'),
(594,3,1,'Loot.'),
(594,4,2,'Besides loot.'),
(594,5,0,'Nothing.'),
(594,6,2,'That''s dark.'),

-- 595 (60, neutral, 2) Burning Steppes
(595,0,0,'The ground is warm through the boots.'),
(595,1,1,'That''s the mountain talking.'),
(595,2,0,'I don''t want to hear it.'),
(595,3,1,'Then don''t stand still. The mountain likes still feet.'),

-- 596 (52, neutral, 3) Tall tale
(596,0,0,'I once outran a wolf.'),
(596,1,1,'You did not.'),
(596,2,0,'I did.'),
(596,3,1,'How?'),
(596,4,2,'It was tired.'),
(596,5,0,'That doesn''t count.'),

-- 597 (5, Alliance, 3) Monster talk
(597,0,0,'Why do kobolds love candles so much?'),
(597,1,1,'They''re warm.'),
(597,2,0,'They''re shiny.'),
(597,3,1,'They''re useful.'),
(597,4,2,'They''re just candles.'),
(597,5,0,'Not to a kobold.'),

-- 598 (20, neutral, 2) Stonetalon peak
(598,0,0,'The air''s thin up here.'),
(598,1,1,'That''s how you know you climbed.'),
(598,2,0,'I preferred the thick air.'),
(598,3,1,'The thick air had harpies. Breathe anyway.'),

-- 599 (40, neutral, 3) Lore: the Burning Steppes
(599,0,0,'The Burning Steppes used to be farmland.'),
(599,1,1,'And now?'),
(599,2,0,'Ash.'),
(599,3,1,'That''s a change.'),
(599,4,2,'It''s a tragedy.'),
(599,5,0,'It''s both.'),

-- 600 (48, neutral, 2) Green dragon swamp
(600,0,0,'The dragons here dream too loud.'),
(600,1,1,'Don''t wake them.'),
(600,2,0,'How do you not wake a dream?'),
(600,3,1,'By not being interesting. Be boring. Survive.');

INSERT INTO `companion_banter_line` (`script_id`,`line_index`,`speaker_slot`,`text`) VALUES
-- 601 (26, neutral, 2) Good chest
(601,0,0,'This one is actually a chest.'),
(601,1,1,'Don''t sound disappointed.'),
(601,2,0,'I was ready for a fight.'),
(601,3,1,'Be ready for gold. It''s rarer.'),

-- 602 (24, Alliance, 2) Nethergarde watch
(602,0,0,'Nethergarde stares at the Dark Portal like it might blink.'),
(602,1,1,'It might.'),
(602,2,0,'That''s not comforting.'),
(602,3,1,'It wasn''t meant to be.'),

-- 603 (60, neutral, 3) Monologue: what I gave up
(603,0,0,'I gave up everything to be here.'),
(603,1,1,'Like what?'),
(603,2,0,'A farm. A wife. A life.'),
(603,3,1,'And now?'),
(603,4,2,'Now I have this.'),
(603,5,0,'Is it enough?'),
(603,6,2,'I don''t know.'),

-- 604 (46, neutral, 2) Searing Gorge
(604,0,0,'The air tastes like coins.'),
(604,1,1,'That''s ore. That''s the gorge.'),
(604,2,0,'I want a wet cloth.'),
(604,3,1,'Hold it over your mouth. Fashion is over.'),

-- 605 (28, neutral, 2) Die clever
(605,0,0,'If you die, die clever.'),
(605,1,1,'That''s not a plan.'),
(605,2,0,'It''s a standard.'),
(605,3,1,'Then I''ll trip on purpose and call it tactics.'),

-- 606 (24, neutral, 2) Split fairly
(606,0,0,'Need before greed.'),
(606,1,1,'I need it.'),
(606,2,0,'You already have one.'),
(606,3,1,'I need two. That''s greed with extra steps. Fine. Take it.'),

-- 607 (18, neutral, 1) Light in a bottle
(607,0,0,'I bought a flask of oil like it was a relic.'),
(607,1,0,'In a cave, it is.'),
(607,2,0,'Don''t laugh at people who hoard light.'),
(607,3,0,'Laugh at people who think they''ll always have a sun.'),

-- 608 (20, neutral, 2) Tall tale
(608,0,0,'I once swam across a river in full armor.'),
(608,1,1,'You did not.'),
(608,2,0,'I did.'),
(608,3,1,'How?'),
(608,4,0,'I almost drowned.'),
(608,5,1,'That''s not the same.'),

-- 609 (20, neutral, 3) Monster talk
(609,0,0,'Do you ever feel like the walls are watching us?'),
(609,1,1,'No.'),
(609,2,0,'Me neither.'),
(609,3,1,'Then why did you ask?'),
(609,4,2,'I wanted to be sure.'),
(609,5,0,'That''s reassuring.'),
(609,6,1,'It''s not meant to be.'),

-- 610 (20, neutral, 2) Duskwood road
(610,0,0,'Stay on the road.'),
(610,1,1,'I know.'),
(610,2,0,'The trees lean in when you don''t.'),
(610,3,1,'I said I know. Walk.'),

-- 611 (40, neutral, 3) Monologue: what I miss
(611,0,0,'I miss sleeping through the night.'),
(611,1,1,'You can sleep here.'),
(611,2,0,'Not really.'),
(611,3,1,'Why not?'),
(611,4,2,'The dreams.'),
(611,5,0,'About what?'),
(611,6,2,'I don''t want to talk about it.'),

-- 612 (5, Alliance, 4) First steps
(612,0,0,'I don''t know what I''m doing.'),
(612,1,1,'Nobody does at first.'),
(612,2,0,'I really don''t.'),
(612,3,1,'You''ll learn.'),
(612,4,2,'Or you''ll die.'),
(612,5,3,'That''s not helpful.'),
(612,6,2,'It''s honest.'),

-- 613 (10, neutral, 2) Cooking fire
(613,0,0,'The cooking fire''s gone out.'),
(613,1,1,'Then we eat it cold.'),
(613,2,0,'That''s not cooking.'),
(613,3,1,'That''s dinner. Don''t be proud.'),

-- 614 (22, neutral, 3) Tall tale
(614,0,0,'I once killed two wolves at once.'),
(614,1,1,'You did not.'),
(614,2,0,'I did.'),
(614,3,1,'How?'),
(614,4,2,'They were fighting each other.'),
(614,5,0,'That doesn''t count.'),

-- 615 (28, neutral, 2) Forgot the skin
(615,0,0,'The drum''s torn.'),
(615,1,1,'Then they already had a worse night than us.'),
(615,2,0,'Or they''re coming back with a new one.'),
(615,3,1,'Then we don''t be here for the encore.'),

-- 616 (40, neutral, 1) When I look back
(616,0,0,'Be where I left you when I look back.'),
(616,1,0,'If you moved, move where I can still count you.'),
(616,2,0,'I don''t need a hero in the next room.'),
(616,3,0,'I need a fool in this one.'),

-- 617 (48, neutral, 3) Monologue: the road
(617,0,0,'I''ve been on the road for so long I forgot what a home feels like.'),
(617,1,1,'That''s sad.'),
(617,2,0,'It''s normal for us.'),
(617,3,1,'It''s still sad.'),
(617,4,2,'It''s still normal.'),
(617,5,0,'It''s both.'),

-- 618 (28, neutral, 2) Encore
(618,0,0,'We''re not staying for the encore.'),
(618,1,1,'I wanted loot.'),
(618,2,0,'Loot that''s still here after an encore is bait.'),
(618,3,1,'Fine. We leave. I hate how often you''re right.'),

-- 619 (28, neutral, 2) Merciful cowards
(619,0,0,'Merciful cowards live longer.'),
(619,1,1,'That''s not the song they sing in towns.'),
(619,2,0,'Towns weren''t here.'),
(619,3,1,'Then we don''t sing. We walk. That''s the verse.'),

-- 620 (48, neutral, 2) Blue dragon far
(620,0,0,'I saw something blue over Winterspring.'),
(620,1,1,'Sky.'),
(620,2,0,'With wings.'),
(620,3,1,'Then we were lucky it was far. Stay lucky.'),

-- 621 (60, neutral, 3) Tall tale
(621,0,0,'I once fought a dragon and lived.'),
(621,1,1,'That''s just survival.'),
(621,2,0,'It''s a story.'),
(621,3,1,'It''s a Tuesday.'),
(621,4,2,'It''s both.'),

-- 622 (34, Horde, 3) Monologue: the old country
(622,0,0,'My people came from across the sea.'),
(622,1,1,'Everyone did.'),
(622,2,0,'Not everyone.'),
(622,3,1,'The elves didn''t.'),
(622,4,2,'The elves are elves.'),
(622,5,0,'That''s fair.'),

-- 623 (36, neutral, 1) After the shovel
(623,0,0,'After the shovel, you can talk.'),
(623,1,0,'Before the shovel, you work.'),
(623,2,0,'I learned that too late the first time.'),
(623,3,0,'I won''t learn it late again.'),

-- 624 (58, neutral, 2) Monster talk
(624,0,0,'The undead don''t feel pain.'),
(624,1,1,'That''s a mercy.'),
(624,2,0,'It''s not a mercy.'),
(624,3,1,'It''s not a curse either.'),
(624,4,0,'It''s something.'),

-- 625 (50, neutral, 2) Red dragon pass
(625,0,0,'The red ones at least look like they care.'),
(625,1,1,'Caring and burning can be the same hobby.'),
(625,2,0,'That''s not fair.'),
(625,3,1,'Dragons aren''t a court. Don''t petition them.'),

-- 626 (5, Alliance, 2) Monologue: my first house
(626,0,0,'I grew up in a house with a red roof.'),
(626,1,1,'Nice.'),
(626,2,0,'It''s gone now.'),
(626,3,1,'I''m sorry.'),
(626,4,0,'It was a long time ago.'),

-- 627 (28, neutral, 3) Tall tale
(627,0,0,'I once rode a windrider.'),
(627,1,1,'Everyone rides windriders.'),
(627,2,0,'I rode one upside down.'),
(627,3,1,'That''s impossible.'),
(627,4,2,'It was very fast.'),
(627,5,0,'That''s not the same.'),

-- 628 (40, neutral, 3) Bad directions
(628,0,0,'I think we should go left.'),
(628,1,1,'We should go right.'),
(628,2,0,'You always say right.'),
(628,3,1,'Because it''s always right.'),
(628,4,2,'It''s never right.'),
(628,5,0,'It''s sometimes right.'),

-- 629 (36, neutral, 3) Monster talk
(629,0,0,'Do you ever wonder if the fish know we''re here?'),
(629,1,1,'Fish don''t care.'),
(629,2,0,'Fish care.'),
(629,3,2,'They care a little.'),
(629,4,0,'They really don''t.'),

-- 630 (60, neutral, 3) Monologue: what I sacrificed
(630,0,0,'I missed my father''s funeral for a raid.'),
(630,1,1,'That''s rough.'),
(630,2,0,'He would have understood.'),
(630,3,1,'Would he?'),
(630,4,2,'He was an adventurer too.'),
(630,5,0,'Then he would have.'),

-- 631 (12, Horde, 2) Crossroads inn
(631,0,0,'The Crossroads inn has a hole in the wall.'),
(631,1,1,'That''s a window now.'),
(631,2,0,'It was made by a raid.'),
(631,3,1,'Then it''s a well-ventilated inn.'),

-- 632 (18, neutral, 3) Tall tale
(632,0,0,'I once killed a wolf with my teeth.'),
(632,1,1,'You did not.'),
(632,2,0,'I did.'),
(632,3,1,'That''s disgusting.'),
(632,4,2,'It was efficient.'),
(632,5,0,'It was disgusting.'),

-- 633 (5, Horde, 4) Monster talk
(633,0,0,'Do scarecrows scare you?'),
(633,1,1,'No.'),
(633,2,0,'They''re just straw.'),
(633,3,1,'And cloth.'),
(633,4,2,'And a hat.'),
(633,5,0,'I''m scared of them.'),
(633,6,3,'Why?'),
(633,7,0,'They never move. Until they do.'),

-- 634 (36, neutral, 2) Will and testament
(634,0,0,'If I don''t come back, the dagger goes to you.'),
(634,1,1,'I don''t want it.'),
(634,2,0,'That''s why you get it.'),
(634,3,1,'Come back anyway. I''m bad at inheriting.'),

-- 635 (18, neutral, 2) Rogue vanish
(635,0,0,'Where did he go?'),
(635,1,1,'Away. That''s his job.'),
(635,2,0,'He was supposed to open the door.'),
(635,3,1,'He opened it. From the other side. Relax.'),

-- 636 (58, neutral, 2) Tall tale
(636,0,0,'I once held a bridge with three men.'),
(636,1,1,'You were one of the three.'),
(636,2,0,'Yes.'),
(636,3,1,'Which one?'),
(636,4,0,'The one who ran.'),

-- 637 (12, Horde, 2) Ratchet prices
(637,0,0,'Gazlowe charged me for directions.'),
(637,1,1,'Did you get there?'),
(637,2,0,'I did.'),
(637,3,1,'Then the directions worked. Pay the goblin.'),

-- 638 (44, neutral, 1) Gadgetzan dusk
(638,0,0,'Gadgetzan at dusk is all lanterns and bad deals.'),
(638,1,0,'I like it.'),
(638,2,0,'Nobody pretends the desert is fair.'),
(638,3,0,'Fairness is a forest idea. Out here you pay and you drink.'),

-- 639 (18, neutral, 1) Hoard light
(639,0,0,'I hoard light.'),
(639,1,0,'That''s not poetry. That''s inventory.'),
(639,2,0,'Two torches. One flask. No speeches.'),
(639,3,0,'If you ask to borrow the last torch, the answer is already no.'),

-- 640 (40, neutral, 3) Tall tale
(640,0,0,'I once crossed the ocean in a rowboat.'),
(640,1,1,'You did not.'),
(640,2,0,'I did.'),
(640,3,1,'That''s impossible.'),
(640,4,2,'It took a long time.'),
(640,5,0,'It''s impossible.'),

-- 641 (60, neutral, 3) Monologue: what I remember
(641,0,0,'I remember the first time I saw a dragon.'),
(641,1,1,'What did you do?'),
(641,2,0,'Nothing.'),
(641,3,1,'Nothing?'),
(641,4,2,'I couldn''t move.'),
(641,5,0,'That''s understandable.'),
(641,6,2,'It flew away.'),

-- 642 (5, neutral, 2) Azuremyst no
(642,0,0,'I heard there''s land west of the sea.'),
(642,1,1,'There''s always land west of the sea. That''s what seas are for.'),
(642,2,0,'I meant new land.'),
(642,3,1,'Then you meant rumors. We have enough old land to die on.'),

-- 643 (60, neutral, 2) Never saw a dragon
(643,0,0,'I never saw a dragon.'),
(643,1,1,'You did.'),
(643,2,0,'I saw a shape. That''s different.'),
(643,3,1,'That''s how people survive the story. Keep the shape.'),

-- 644 (5, Horde, 3) Tall tale
(644,0,0,'I once rode a kodo bareback.'),
(644,1,1,'Everyone does.'),
(644,2,0,'I rode it into a river.'),
(644,3,1,'That''s different.'),
(644,4,2,'It was very wet.'),
(644,5,0,'How wet?'),
(644,6,2,'Very wet.'),

-- 645 (30, neutral, 2) Booty Bay ropes
(645,0,0,'Don''t look down through the boards.'),
(645,1,1,'I already did.'),
(645,2,0,'The sharks already did too.'),
(645,3,1,'Then we''re all introduced. Walk faster.'),

-- 646 (16, Horde, 2) Smile with the axe
(646,0,0,'Don''t smile like that.'),
(646,1,1,'Like what?'),
(646,2,0,'Like the axe is the joke.'),
(646,3,1,'The axe is the joke. I''m just the setup.'),

-- 647 (12, Alliance, 2) Ironforge noise
(647,0,0,'I can''t hear myself think by the Great Forge.'),
(647,1,1,'That''s the point. You work, you don''t think.'),
(647,2,0,'I was trying to ask for directions.'),
(647,3,1,'Point. Don''t shout.'),

-- 648 (42, neutral, 1) Kargath dusk
(648,0,0,'Kargath at dusk looks like the land is on fire and too tired to finish.'),
(648,1,0,'I understand the land.'),
(648,2,0,'I''ll sleep anyway.'),
(648,3,0,'Tired fire still burns if you give it a boot.'),

-- 649 (5, Alliance, 2) Tall tale
(649,0,0,'I once killed a wolf with a stick.'),
(649,1,1,'You did not.'),
(649,2,0,'I did.'),
(649,3,1,'What kind of stick?'),
(649,4,0,'A sharp one.'),

-- 650 (58, neutral, 2) Keep the shape
(650,0,0,'Keep it a shape.'),
(650,1,1,'Don''t name it.'),
(650,2,0,'Names make it smaller.'),
(650,3,1,'Names make it come when called. We don''t call. We leave.'),

-- 651 (32, neutral, 3) Monster talk
(651,0,0,'Do you ever feel sorry for the wolves?'),
(651,1,1,'No.'),
(651,2,0,'They''re just hungry.'),
(651,3,1,'They''re trying to eat us.'),
(651,4,2,'That''s fair.'),
(651,5,0,'That''s very fair.'),

-- 652 (10, neutral, 2) Fishing patience
(652,0,0,'Nothing''s biting.'),
(652,1,1,'That''s fishing.'),
(652,2,0,'I thought fishing was fish.'),
(652,3,1,'Fishing is waiting with a stick. Fish are a rumor.'),

-- 653 (26, neutral, 3) Tall tale
(653,0,0,'I once wrestled a crocolisk.'),
(653,1,1,'You did not.'),
(653,2,0,'I did.'),
(653,3,1,'Who won?'),
(653,4,2,'The crocolisk.'),
(653,5,0,'That''s not a story.'),
(653,6,2,'It''s an honest one.'),

-- 654 (60, neutral, 2) Titles hear
(654,0,0,'Don''t say the name.'),
(654,1,1,'I wasn''t going to.'),
(654,2,0,'You were winding up.'),
(654,3,1,'I''ll wind down. The hall can have the silence.'),

-- 655 (26, neutral, 4) Monster talk
(655,0,0,'Do you ever feel like we''re the bad guys?'),
(655,1,1,'No.'),
(655,2,0,'We break into places.'),
(655,3,1,'They''re evil places.'),
(655,4,2,'Usually.'),
(655,5,3,'Not always.'),

-- 656 (28, neutral, 2) Tax on living
(656,0,0,'Living has a tax.'),
(656,1,1,'Everything does.'),
(656,2,0,'This one''s collected in stories.'),
(656,3,1,'Then we underreport. I never saw a dragon. Happy?'),

-- 657 (10, neutral, 2) Tall tale
(657,0,0,'I once caught a fish with my hands.'),
(657,1,1,'You did not.'),
(657,2,0,'I did.'),
(657,3,1,'How?'),
(657,4,0,'It was very slow.'),

-- 658 (60, neutral, 3) Monologue: what I believe
(658,0,0,'I believe in the Light.'),
(658,1,1,'Why?'),
(658,2,0,'Because it''s all I have.'),
(658,3,1,'That''s not a reason.'),
(658,4,2,'It''s the only reason.'),
(658,5,0,'It''s a reason.'),

-- 659 (26, neutral, 2) Local rumor
(659,0,0,'The innkeep said not to take the east road.'),
(659,1,1,'Innkeeps say that about every road that isn''t their door.'),
(659,2,0,'He showed me a grave.'),
(659,3,1,'Then we take the west road. Graves are specific.'),

-- 660 (42, Horde, 2) Splintertree
(660,0,0,'Splintertree smells like sap and old blood.'),
(660,1,1,'That''s Ashenvale from our side.'),
(660,2,0,'The elves don''t see it that way.'),
(660,3,1,'They have their own smell. It''s pine and grudges.'),

-- 661 (60, neutral, 2) Hall silence
(661,0,0,'I don''t like this silence.'),
(661,1,1,'It''s better than drums.'),
(661,2,0,'Drums tell you where they are.'),
(661,3,1,'Then we listen harder. Silence is a drum that forgot the skin.'),

-- 662 (36, neutral, 3) Tall tale
(662,0,0,'I once fought a murloc with my bare hands.'),
(662,1,1,'Everyone fights murlocs.'),
(662,2,0,'I fought ten murlocs.'),
(662,3,1,'You did not.'),
(662,4,2,'I did.'),
(662,5,0,'You''re a liar.'),

-- 663 (26, neutral, 2) True name
(663,0,0,'You can use my name here.'),
(663,1,1,'Why here?'),
(663,2,0,'Because nobody in this room has money or a grudge.'),
(663,3,1,'That''s the nicest inn I''ve heard of. Let''s not ruin it.'),

-- 664 (50, neutral, 1) A fool in this one
(664,0,0,'I need a fool in this one.'),
(664,1,0,'That''s you.'),
(664,2,0,'That''s me.'),
(664,3,0,'That''s the party. Don''t upgrade us.'),

-- 665 (10, neutral, 2) Profession trainer
(665,0,0,'The trainer wants gold to tell me what I already know.'),
(665,1,1,'That''s a trainer.'),
(665,2,0,'I could guess.'),
(665,3,1,'Guessing burns the hide. Pay the gold.'),

-- 666 (52, neutral, 2) Conversation with a keep
(666,0,0,'I don''t want a conversation with this keep.'),
(666,1,1,'Keeps talk anyway.'),
(666,2,0,'Then we don''t answer.'),
(666,3,1,'That''s the plan. If it asks twice, we run.'),

-- 667 (5, Horde, 2) Thunder Bluff wind
(667,0,0,'The wind on Thunder Bluff could take a kodo.'),
(667,1,1,'It has.'),
(667,2,0,'You''re joking.'),
(667,3,1,'Hold the rail.'),

-- 668 (32, neutral, 1) Too late the first time
(668,0,0,'I was slow the first time it mattered.'),
(668,1,0,'I told myself I was careful.'),
(668,2,0,'Careful is a word cowards borrow.'),
(668,3,0,'I still borrow it. I just walk faster now.'),

-- 669 (38, neutral, 2) If it asks twice
(669,0,0,'If it asks twice, we run.'),
(669,1,1,'That''s superstition.'),
(669,2,0,'That''s statistics.'),
(669,3,1,'I like statistics better. Run on two. Fine.'),

-- 670 (24, Alliance, 2) Morgan's Vigil
(670,0,0,'Morgan''s Vigil smells like ash even on a still day.'),
(670,1,1,'That''s Blackrock breathing.'),
(670,2,0,'Can a mountain breathe?'),
(670,3,1,'This one does.'),

-- 671 (58, neutral, 1) I won't be famous
(671,0,0,'I used to think I''d be famous.'),
(671,1,0,'Now I''d settle for a door that locks and a name nobody shouts.'),
(671,2,0,'That''s not giving up.'),
(671,3,0,'That''s learning the price of shouting.'),

-- 672 (36, neutral, 1) Mostly the same
(672,0,0,'Mostly the same number.'),
(672,1,0,'That''s the sentence I hate.'),
(672,2,0,'Mostly is where the graves live.'),
(672,3,0,'I still get up. That''s the other sentence.'),

-- 673 (46, neutral, 1) The ending can be ugly
(673,0,0,'The ending can be ugly.'),
(673,1,0,'I used to want a clean one.'),
(673,2,0,'Clean endings are for people who weren''t there.'),
(673,3,0,'We were there. We''ll take messy and breathing.'),

-- 674 (52, neutral, 1) We're too high
(674,0,0,'We''re too high.'),
(674,1,0,'I don''t mean the mountain.'),
(674,2,0,'I mean the part where we started believing we couldn''t fall.'),
(674,3,0,'We can. That''s why I''m counting steps.'),

-- 675 (52, neutral, 3) Tall tale
(675,0,0,'I once crossed the Burning Steppes alone.'),
(675,1,1,'That''s not impressive.'),
(675,2,0,'It was at night.'),
(675,3,1,'That''s more impressive.'),
(675,4,2,'It was during a storm.'),
(675,5,0,'Now you''re lying.'),

-- 676 (58, neutral, 1) Stories I can lose
(676,0,0,'I can lose a story.'),
(676,1,0,'I''ve lost better ones than the one we''re in.'),
(676,2,0,'Don''t make me choose between you and a good ending.'),
(676,3,0,'I''ll pick you. The ending can be ugly.'),

-- 677 (50, neutral, 1) I'll handle the rest
(677,0,0,'I''ll handle the rest.'),
(677,1,0,'That''s a lie I tell so you sleep.'),
(677,2,0,'I''ll try anyway.'),
(677,3,0,'Trying is the only honest version of I''ll handle it.'),

-- 678 (60, neutral, 2) Centaur herds
(678,0,0,'They move like a storm with spears.'),
(678,1,1,'Don''t race a centaur on open ground.'),
(678,2,0,'We have a hill.'),
(678,3,1,'Keep the hill. That''s the whole strategy.'),

-- 679 (44, neutral, 3) Tall tale
(679,0,0,'I once killed a troll with a rock.'),
(679,1,1,'You did not.'),
(679,2,0,'I did.'),
(679,3,1,'What kind of rock?'),
(679,4,2,'A very big rock.'),
(679,5,0,'That doesn''t count.'),

-- 680 (14, Alliance, 2) Sentinel Hill
(680,0,0,'Sentinel Hill looks smaller than the stories.'),
(680,1,1,'The stories are older than the hill.'),
(680,2,0,'The tower''s still standing.'),
(680,3,1,'That''s the whole review.'),

-- 681 (36, neutral, 1) Don't test how tired
(681,0,0,'Don''t test how tired I am.'),
(681,1,0,'The answer is very.'),
(681,2,0,'The answer is also not enough to put you down.'),
(681,3,0,'That''s as romantic as I get. Take the water.'),

-- 682 (44, neutral, 2) Quiet confession
(682,0,0,'I don''t pray.'),
(682,1,1,'You don''t have to announce it.'),
(682,2,0,'I wanted you to know in case it matters later.'),
(682,3,1,'It won''t. I''ll still drag you out.'),

-- 683 (40, neutral, 3) Tall tale
(683,0,0,'I once found a Titan artifact.'),
(683,1,1,'You did not.'),
(683,2,0,'I did.'),
(683,3,1,'What was it?'),
(683,4,2,'A rock.'),
(683,5,0,'That''s just a rock.'),

-- 684 (40, neutral, 3) Monster talk
(684,0,0,'Why is the Badlands so red?'),
(684,1,1,'Iron.'),
(684,2,0,'Rust.'),
(684,3,1,'Blood.'),
(684,4,2,'Iron and rust.'),
(684,5,0,'That''s the answer.'),

-- 685 (5, Horde, 2) Undercity damp
(685,0,0,'The Undercity smells like wet stone and old potions.'),
(685,1,1,'That''s home.'),
(685,2,0,'That''s a warning.'),
(685,3,1,'Same thing, down here.'),

-- 686 (40, neutral, 2) Guide's advice
(686,0,0,'The guide said stay off the ridgeline.'),
(686,1,1,'Guides always say that.'),
(686,2,0,'This one had scars.'),
(686,3,1,'Then we stay off the ridgeline. Scars are a map.'),

-- 687 (28, neutral, 3) Monster talk
(687,0,0,'Do you ever feel sorry for the troggs?'),
(687,1,1,'No.'),
(687,2,0,'They''re just animals.'),
(687,3,1,'They''re trying to eat us.'),
(687,4,2,'That''s fair.'),

-- 688 (60, neutral, 3) Old captain
(688,0,0,'He used to give orders like weather.'),
(688,1,1,'What happened to him?'),
(688,2,0,'Weather.'),
(688,3,1,'That''s a short eulogy.'),
(688,4,2,'It''s the true kind.'),

-- 689 (48, neutral, 3) Tall tale
(689,0,0,'I once swam across the Great Sea.'),
(689,1,1,'You did not.'),
(689,2,0,'I did.'),
(689,3,1,'There are sea monsters.'),
(689,4,2,'I know.'),
(689,5,0,'You''re a liar.'),

-- 690 (18, neutral, 2) Repair bill
(690,0,0,'The repair bill was larger than the bounty.'),
(690,1,1,'Then it wasn''t a bounty. It was a donation to the smith.'),
(690,2,0,'I liked the armor.'),
(690,3,1,'The armor liked being whole.'),

-- 691 (46, neutral, 1) Faces for them
(691,0,0,'We don''t have faces for inns yet.'),
(691,1,0,'Inns want a story that ends.'),
(691,2,0,'Ours hasn''t.'),
(691,3,0,'That''s good. Unfinished is another word for alive.'),

-- 692 (5, Horde, 2) Brill cemetery
(692,0,0,'Brill has more graves than houses.'),
(692,1,1,'The houses used to be people.'),
(692,2,0,'That''s grim.'),
(692,3,1,'That''s Tirisfal.'),

-- 693 (38, neutral, 3) Tall tale
(693,0,0,'I once tamed a lion.'),
(693,1,1,'You did not.'),
(693,2,0,'I did.'),
(693,3,1,'How?'),
(693,4,2,'It was asleep.'),
(693,5,0,'That doesn''t count.'),

-- 694 (5, Horde, 1) Orgrimmar from the gate
(694,0,0,'The valley hits you in the chest.'),
(694,1,0,'That''s the drums. That''s the anvil. That''s the point.'),
(694,2,0,'I thought I wanted quiet.'),
(694,3,0,'I wanted to belong to a noise that knew my name.'),

-- 695 (50, neutral, 2) Come back
(695,0,0,'Come back.'),
(695,1,1,'That''s the plan.'),
(695,2,0,'Say it like a promise.'),
(695,3,1,'I don''t make those. I''ll do it anyway.'),

-- 696 (12, Horde, 2) Camp Taurajo
(696,0,0,'Camp Taurajo feels like the last polite place in the Barrens.'),
(696,1,1,'The quilboar didn''t get the notice.'),
(696,2,0,'The tauren still offer water.'),
(696,3,1,'That''s why it''s polite.'),

-- 697 (60, neutral, 2) Don't wait
(697,0,0,'If I''m late, don''t wait at the gate.'),
(697,1,1,'I''ll wait.'),
(697,2,0,'That''s how you get two bodies.'),
(697,3,1,'Then I''ll wait badly and nearby. That''s the compromise.'),

-- 698 (58, neutral, 2) Near bosses
(698,0,0,'Stop talking near that door.'),
(698,1,1,'It''s a door.'),
(698,2,0,'It''s a door with a title. Titles hear better.'),
(698,3,1,'Then we whisper. I hate whispering. Fine.'),

-- 699 (20, neutral, 2) Venture shredder
(699,0,0,'That shredder is a barn with an axe.'),
(699,1,1,'Don''t stand in front of the barn.'),
(699,2,0,'I was looking for a weak point.'),
(699,3,1,'The weak point is the goblin. Aim up.'),

-- 700 (50, Horde, 3) Tall tale
(700,0,0,'I once killed a lion with a spear.'),
(700,1,1,'You did not.'),
(700,2,0,'I did.'),
(700,3,1,'How?'),
(700,4,2,'It was very old.'),
(700,5,0,'That doesn''t count.');

INSERT INTO `companion_banter_line` (`script_id`,`line_index`,`speaker_slot`,`text`) VALUES
-- 701 (5, Horde, 4) First day nerves
(701,0,0,'I don''t think I can do this.'),
(701,1,1,'You can do this.'),
(701,2,0,'I really can''t.'),
(701,3,1,'You really can.'),
(701,4,2,'If you can''t, we''ll carry you.'),
(701,5,3,'That''s not how fighting works.'),
(701,6,2,'It''s how friendship works.'),

-- 702 (10, neutral, 2) Inn bed
(702,0,0,'The innkeep says the bed is included.'),
(702,1,1,'Included with what? The fleas?'),
(702,2,0,'The room.'),
(702,3,1,'Then the fleas are a tax. Sleep anyway.'),

-- 703 (28, neutral, 3) Monster talk
(703,0,0,'Why do bears stand on two legs?'),
(703,1,1,'To intimidate.'),
(703,2,0,'It works.'),
(703,3,1,'It really works.'),
(703,4,2,'I''ve never seen anything more terrifying.'),
(703,5,0,'A bear on two legs is a person with claws.'),

-- 704 (58, neutral, 3) Monologue: what I saw
(704,0,0,'I saw a man walk into a plague cloud and come out laughing.'),
(704,1,1,'Laughing?'),
(704,2,0,'Laughing.'),
(704,3,1,'That''s worse than dying.'),
(704,4,2,'It''s different.'),
(704,5,0,'It''s worse.'),

-- 705 (20, neutral, 2) Nagafog
(705,0,0,'The naga left the beach looking organized.'),
(705,1,1,'That''s worse than messy.'),
(705,2,0,'They''re gone.'),
(705,3,1,'They''re swimming. Gone is a land word.'),

-- 706 (60, neutral, 2) Already leaving
(706,0,0,'We were already leaving.'),
(706,1,1,'That''s a good sentence.'),
(706,2,0,'It''s a better door.'),
(706,3,1,'Then find one. I''ll bring the rear. Don''t wait if I slow down.'),

-- 707 (18, neutral, 2) Mail waiting
(707,0,0,'There''s mail at the box.'),
(707,1,1,'It''s probably a bill.'),
(707,2,0,'It could be a gift.'),
(707,3,1,'It''s a bill that thinks it''s a gift.'),

-- 708 (48, neutral, 2) Tall tale
(708,0,0,'I once outran a bear.'),
(708,1,1,'You did not.'),
(708,2,0,'I did.'),
(708,3,1,'How?'),
(708,4,0,'I didn''t.'),
(708,5,1,'Then why did you say you did?'),
(708,6,0,'It''s a better story.'),

-- 709 (14, Alliance, 2) Feathermoon ferry
(709,0,0,'The Feathermoon ferry rocks like it''s angry.'),
(709,1,1,'The sea is angry. The boat is honest.'),
(709,2,0,'I liked the dock better.'),
(709,3,1,'The dock doesn''t go anywhere.'),

-- 710 (52, neutral, 2) Bring the rear
(710,0,0,'I''ll bring the rear.'),
(710,1,1,'That''s where people die.'),
(710,2,0,'That''s where people watch.'),
(710,3,1,'Watch and don''t be a hero. That''s an order from below you.'),

-- 711 (26, neutral, 2) Stay down
(711,0,0,'Stay down.'),
(711,1,1,'I can stand.'),
(711,2,0,'You can bleed standing. Stay down. That''s an order from a friend.'),
(711,3,1,'Those are the worst orders. Fine.'),

-- 712 (26, neutral, 3) Tall tale
(712,0,0,'I once killed a bear with my fists.'),
(712,1,1,'You did not.'),
(712,2,0,'I did.'),
(712,3,1,'How?'),
(712,4,2,'It was a small bear.'),
(712,5,0,'That doesn''t count.'),

-- 713 (60, neutral, 3) Monologue: what I carry
(713,0,0,'I carry my brother''s sword.'),
(713,1,1,'Where is he?'),
(713,2,0,'Dead.'),
(713,3,1,'I''m sorry.'),
(713,4,2,'He would have wanted me to use it.'),
(713,5,0,'Then you''re using it well.'),
(713,6,2,'Thank you.'),

-- 714 (5, Alliance, 2) Redridge tower
(714,0,0,'Stonewatch looks like it lost an argument with a dragon.'),
(714,1,1,'It did.'),
(714,2,0,'Did the dragon win?'),
(714,3,1,'Look at the tower.'),

-- 715 (20, neutral, 1) Rude to fate
(715,0,0,'I can be rude to fate.'),
(715,1,0,'It''s never done me a kindness worth manners.'),
(715,2,0,'If it wants me, it can wait in line.'),
(715,3,0,'I have friends ahead of it.'),

-- 716 (28, neutral, 2) Spite our way out
(716,0,0,'We spite our way out.'),
(716,1,1,'That''s not a formation.'),
(716,2,0,'It''s a mood. Moods count.'),
(716,3,1,'Fine. Spite on the left. Hope on the right. Me in the middle complaining.'),

-- 717 (54, neutral, 3) Tall tale
(717,0,0,'I once tamed a wolf.'),
(717,1,1,'You did not.'),
(717,2,0,'I did.'),
(717,3,1,'How?'),
(717,4,2,'I fed it.'),
(717,5,0,'That''s not taming.'),

-- 718 (60, neutral, 1) Friends ahead of it
(718,0,0,'I have friends ahead of it.'),
(718,1,0,'That''s not poetry.'),
(718,2,0,'That''s a queue.'),
(718,3,0,'Fate can take a number. We''re not done with the road.'),

-- 719 (30, neutral, 2) Don't make it a statue
(719,0,0,'Don''t make it a statue.'),
(719,1,1,'I wasn''t going to.'),
(719,2,0,'You were composing.'),
(719,3,1,'I was breathing with extra words. I''ll stop. Mostly.'),

-- 720 (56, neutral, 2) Run on two
(720,0,0,'Run on two.'),
(720,1,1,'Two what?'),
(720,2,0,'Two knocks. Two screams. Two mistakes.'),
(720,3,1,'That''s a lot of twos. I''ll count. You run first if I lose the number.'),

-- 721 (18, neutral, 3) Monster talk
(721,0,0,'Do raptors hunt in packs?'),
(721,1,1,'Yes.'),
(721,2,0,'That''s terrifying.'),
(721,3,1,'It''s efficient.'),
(721,4,2,'It''s terrifying.'),
(721,5,0,'It''s both.'),

-- 722 (48, neutral, 1) When I can see the sky
(722,0,0,'I miss the sky more than I miss bread.'),
(722,1,0,'That''s a stupid thing to admit.'),
(722,2,0,'Bread I can buy.'),
(722,3,0,'The sky I have to walk to.'),

-- 723 (5, Horde, 2) Sylvanas rumor
(723,0,0,'Someone said Sylvanas was in the Royal Quarter.'),
(723,1,1,'Someone always says that.'),
(723,2,0,'Was she?'),
(723,3,1,'If you have to ask, you weren''t invited.'),

-- 724 (34, Horde, 3) Monster talk
(724,0,0,'Why do wolves howl at the moon?'),
(724,1,1,'To talk to each other.'),
(724,2,0,'To talk to the moon.'),
(724,3,1,'The moon doesn''t talk back.'),
(724,4,2,'How do you know?'),
(724,5,0,'That''s fair.'),

-- 725 (24, neutral, 2) Drink this
(725,0,0,'Drink this.'),
(725,1,1,'It smells like a swamp.'),
(725,2,0,'It is a swamp. A useful one.'),
(725,3,1,'If I live I''m billing you for the taste.'),

-- 726 (48, neutral, 2) Tall tale
(726,0,0,'I once walked from Darnassus to Ironforge.'),
(726,1,1,'That''s a long walk.'),
(726,2,0,'It was.'),
(726,3,1,'How long?'),
(726,4,0,'Three months.'),
(726,5,1,'That''s not that long.'),
(726,6,0,'It felt long.'),

-- 727 (58, neutral, 1) Booty Bay dusk
(727,0,0,'Booty Bay at dusk is lanterns hung over a drop.'),
(727,1,0,'I don''t look down anymore.'),
(727,2,0,'That''s not bravery.'),
(727,3,0,'That''s me keeping the dinner I paid too much for.'),

-- 728 (26, neutral, 2) Don't thank me
(728,0,0,'Don''t thank me.'),
(728,1,1,'I was going to.'),
(728,2,0,'Thank me when we''re outside. In here it''s noise.'),
(728,3,1,'Then I''ll nod. That''s quieter.'),

-- 729 (5, Alliance, 3) Tall tale
(729,0,0,'I once killed a bear.'),
(729,1,1,'You did not.'),
(729,2,0,'I did.'),
(729,3,1,'How?'),
(729,4,2,'I had help.'),
(729,5,0,'That counts.'),

-- 730 (56, neutral, 2) Tap once
(730,0,0,'Tap once.'),
(730,1,1,'That''s it?'),
(730,2,0,'Once is a question. Twice is a conversation.'),
(730,3,1,'I don''t want a conversation with this keep. Once.'),

-- 731 (5, Horde, 4) Monster talk
(731,0,0,'Why are kodos so calm?'),
(731,1,1,'They''re big.'),
(731,2,0,'Being big doesn''t make you calm.'),
(731,3,1,'It helps.'),
(731,4,2,'It really helps.'),
(731,5,3,'I wish I was a kodo.'),
(731,6,0,'No you don''t.'),

-- 732 (44, neutral, 2) Don't give it a church
(732,0,0,'Don''t give the mountain a church.'),
(732,1,1,'Too late. Someone already did.'),
(732,2,0,'That''s a ruin.'),
(732,3,1,'Ruins are churches that lost the argument. Don''t pray. Pass.'),

-- 733 (50, neutral, 1) I don't pray here
(733,0,0,'I don''t pray in places like this.'),
(733,1,0,'Not because I don''t believe.'),
(733,2,0,'Because I don''t want whatever lives here to think I''m talking to it.'),
(733,3,0,'I''ll pray when I can see the sky.'),

-- 734 (56, neutral, 2) Hunter pet name
(734,0,0,'You named the bear Dinner?'),
(734,1,1,'It''s a joke.'),
(734,2,0,'Does the bear know?'),
(734,3,1,'The bear eats first. The bear doesn''t mind.'),

-- 735 (60, neutral, 1) The whole ambition
(735,0,0,'People think we want glory.'),
(735,1,0,'I want soup that doesn''t move and a morning that isn''t a test.'),
(735,2,0,'Glory can wait outside.'),
(735,3,0,'If it knocks, I''m not home.'),

-- 736 (44, neutral, 3) Tall tale
(736,0,0,'I once killed a crocodile with a spear.'),
(736,1,1,'You did not.'),
(736,2,0,'I did.'),
(736,3,1,'How?'),
(736,4,2,'It was asleep.'),
(736,5,0,'That doesn''t count.'),

-- 737 (24, neutral, 2) Call it tactics
(737,0,0,'That wasn''t a retreat. That was tactics.'),
(737,1,1,'You fell in a bush.'),
(737,2,0,'A tactical bush.'),
(737,3,1,'Fine. Tactical. Leaves in your hair. Victory.'),

-- 738 (54, neutral, 1) Steal my friends back
(738,0,0,'I''ll steal my friends back.'),
(738,1,0,'That''s the only theft I still like.'),
(738,2,0,'The rest is vendor trash and stories.'),
(738,3,0,'Stories I can lose. People I can''t.'),

-- 739 (22, Alliance, 3) Tall tale
(739,0,0,'I once outdrank three dwarves.'),
(739,1,1,'You did not.'),
(739,2,0,'I did.'),
(739,3,1,'How?'),
(739,4,2,'They were on a diet.'),
(739,5,0,'That doesn''t count.'),

-- 740 (46, neutral, 1) Simple is ugly
(740,0,0,'Simple is ugly.'),
(740,1,0,'I can live with ugly.'),
(740,2,0,'I can''t live with clever that got someone killed.'),
(740,3,0,'If I have to choose, I''ll be the fool with a rope.'),

-- 741 (10, neutral, 2) Gnoll banner
(741,0,0,'They plant banners like they pay taxes.'),
(741,1,1,'Gnolls pay in teeth.'),
(741,2,0,'That''s not a tax.'),
(741,3,1,'It is if you''re the one collecting.'),

-- 742 (52, neutral, 1) Saints get left
(742,0,0,'Saints get left for speeches.'),
(742,1,0,'I don''t do speeches well.'),
(742,2,0,'I do rope, water, and bad timing.'),
(742,3,0,'If you want a saint, hire a cathedral. If you want out, stay close.'),

-- 743 (18, neutral, 2) Tent leak
(743,0,0,'The tent leaks.'),
(743,1,1,'Then sleep on the high side.'),
(743,2,0,'There is no high side.'),
(743,3,1,'Then sleep angry. It keeps you warm.'),

-- 744 (12, Horde, 2) Freewind Post
(744,0,0,'Freewind Post is a handful of lifts and a lot of air.'),
(744,1,1,'Don''t look down.'),
(744,2,0,'I already did.'),
(744,3,1,'Then don''t look twice.'),

-- 745 (40, neutral, 1) Carry anyone
(745,0,0,'I''ve carried people.'),
(745,1,0,'They''re heavier when they trust you.'),
(745,2,0,'That''s not a complaint.'),
(745,3,0,'That''s me asking you not to get heavier tonight.'),

-- 746 (44, neutral, 2) Priest shield
(746,0,0,'The shield broke.'),
(746,1,1,'Then you were supposed to stop getting hit.'),
(746,2,0,'That''s your job.'),
(746,3,1,'My job is the shield. Your job is the stopping.'),

-- 747 (48, neutral, 1) The work of keeping them
(747,0,0,'Keeping people is work.'),
(747,1,0,'I used to think it was luck.'),
(747,2,0,'Luck is what you call it when you''re tired of explaining the work.'),
(747,3,0,'I''m not that tired yet. Don''t test how tired.'),

-- 748 (10, neutral, 2) Murloc tide
(748,0,0,'Don''t turn your back on the water.'),
(748,1,1,'I know.'),
(748,2,0,'That''s where the singing comes from.'),
(748,3,1,'That''s not singing. Walk inland.'),

-- 749 (5, Horde, 2) Cairne's patience
(749,0,0,'A tauren told me to wait.'),
(749,1,1,'Then wait.'),
(749,2,0,'How long?'),
(749,3,1,'Until he''s done thinking. It might be tomorrow.'),

-- 750 (36, neutral, 3) Tall tale
(750,0,0,'I once killed a wolf with a rock.'),
(750,1,1,'You did not.'),
(750,2,0,'I did.'),
(750,3,1,'What kind of rock?'),
(750,4,2,'A big rock.'),
(750,5,0,'That doesn''t count.'),

-- 751 (20, neutral, 2) Watch fire
(751,0,0,'Let the fire burn lower.'),
(751,1,1,'We''ll be seen.'),
(751,2,0,'We''ll be seen anyway. I''d rather see first.'),
(751,3,1,'Fine. Lower. Not out.'),

-- 752 (58, neutral, 1) Don't finish us
(752,0,0,'Don''t finish us.'),
(752,1,0,'That''s a prayer I can say without a chapel.'),
(752,2,0,'Stay in the middle with me.'),
(752,3,0,'The end can find someone else. We''re busy.'),

-- 753 (26, neutral, 2) Druid forms
(753,0,0,'Pick a shape and stay in it.'),
(753,1,1,'I pick the one that isn''t dying.'),
(753,2,0,'That''s all of them, one after another.'),
(753,3,1,'Then I''m doing it right.'),

-- 754 (30, neutral, 2) Sad can wait
(754,0,0,'Sad can wait for town.'),
(754,1,1,'Town makes it louder.'),
(754,2,0,'Town has chairs. Sit first. Be sad sitting.'),
(754,3,1,'That''s almost kind. Don''t repeat it.'),

-- 755 (60, neutral, 2) Lockpicking queue
(755,0,0,'There''s a lock.'),
(755,1,1,'There''s always a lock.'),
(755,2,0,'Can you open it?'),
(755,3,1,'I can open it if you stop breathing on my picks.'),

-- 756 (8, Alliance, 2) Booty Bay Alliance
(756,0,0,'The goblins in Booty Bay charged me to stand on the dock.'),
(756,1,1,'Did you stand on it?'),
(756,2,0,'I had to. The boat was late.'),
(756,3,1,'Then you rented the dock. Congratulations.'),

-- 757 (52, neutral, 2) The book stays empty
(757,0,0,'Some nights don''t go in the book.'),
(757,1,1,'That''s a kind of mercy.'),
(757,2,0,'It''s a kind of cowardice.'),
(757,3,1,'Then we''re merciful cowards. I can live with that.'),

-- 758 (44, neutral, 2) Don't need a sequel
(758,0,0,'I don''t need a sequel.'),
(758,1,1,'That''s what first nights always say.'),
(758,2,0,'This isn''t a first night.'),
(758,3,1,'Then don''t write a second. Walk.'),

-- 759 (18, neutral, 2) Camp chores
(759,0,0,'Someone has to bury the bones.'),
(759,1,1,'We could leave them.'),
(759,2,0,'Then we advertise a feast.'),
(759,3,1,'I''ll get the shovel.'),

-- 760 (24, Alliance, 2) Astranaar night
(760,0,0,'Astranaar is quiet at night.'),
(760,1,1,'The lake does the talking.'),
(760,2,0,'I heard wolves.'),
(760,3,1,'Then the lake had company.'),

-- 761 (28, neutral, 2) Sharpening stone
(761,0,0,'Your edge is gone.'),
(761,1,1,'It still cuts.'),
(761,2,0,'It still insults the smith.'),
(761,3,1,'Fine. Stone. Don''t watch me.'),

-- 762 (56, neutral, 2) Don't write a second
(762,0,0,'If we live, we don''t have to make it a tale.'),
(762,1,1,'Someone will anyway.'),
(762,2,0,'Let them lie.'),
(762,3,1,'They will. That''s the tax on living.'),

-- 763 (60, neutral, 2) Ammo count
(763,0,0,'How many arrows do you have?'),
(763,1,1,'Enough.'),
(763,2,0,'That''s not a number.'),
(763,3,1,'It''s a number that ends when I start shouting.'),

-- 764 (54, neutral, 2) Order from below
(764,0,0,'That''s an order from below you.'),
(764,1,1,'You don''t outrank me.'),
(764,2,0,'I outworry you. That''s close enough.'),
(764,3,1,'Fine. I won''t be a hero. I''ll be a problem that lives.'),

-- 765 (60, neutral, 2) Problem that lives
(765,0,0,'Be a problem that lives.'),
(765,1,1,'That''s the job title.'),
(765,2,0,'It''s the only promotion I want.'),
(765,3,1,'Then you''re cheap to manage. Don''t die. That''s the review.'),

-- 766 (16, Horde, 2) Sepulcher
(766,0,0,'The Sepulcher is a grave that learned to be a town.'),
(766,1,1,'That''s Silverpine.'),
(766,2,0,'The worgen don''t respect town limits.'),
(766,3,1,'Neither did we, once.'),

-- 767 (16, Horde, 1) Ratchet dusk
(767,0,0,'Ratchet at dusk is goblins counting out loud.'),
(767,1,0,'I find it restful.'),
(767,2,0,'Nobody here is pretending the world is a hymn.'),
(767,3,0,'It''s a ledger. I can sleep next to a ledger.'),

-- 768 (60, neutral, 2) Nothing happened
(768,0,0,'Nothing happened.'),
(768,1,1,'That''s the story we sell.'),
(768,2,0,'Something happened.'),
(768,3,1,'That''s the story we keep. Don''t mix them at the bar.'),

-- 769 (60, neutral, 2) Don't mix them
(769,0,0,'Don''t mix the stories at the bar.'),
(769,1,1,'I know which is which.'),
(769,2,0,'Ale doesn''t.'),
(769,3,1,'Then I drink after I lie. That''s order. That''s civilization.'),

-- 770 (8, Alliance, 2) Kobold candle
(770,0,0,'He was more worried about the candle than the sword.'),
(770,1,1,'That''s a kobold.'),
(770,2,0,'I almost felt bad.'),
(770,3,1,'Feel bad after he''s done stabbing. Timing matters.'),

-- 771 (38, neutral, 2) Quiet boots
(771,0,0,'Your boots are a war drum.'),
(771,1,1,'They''re boots.'),
(771,2,0,'They''re a war drum that hates stealth.'),
(771,3,1,'Then I won''t stealth. I''ll arrive.'),

-- 772 (30, neutral, 2) Hasn't admitted it
(772,0,0,'The wall hasn''t admitted it''s a door.'),
(772,1,1,'Then we don''t argue with walls.'),
(772,2,0,'We tap.'),
(772,3,1,'We tap once. If it answers, we leave. If it doesn''t, we also leave.'),

-- 773 (18, neutral, 3) Forgot water
(773,0,0,'Who packed the waterskins?'),
(773,1,1,'You did.'),
(773,2,0,'They''re empty.'),
(773,3,1,'Then you packed them with optimism.'),
(773,4,2,'Optimism isn''t drinkable.'),

-- 774 (5, Alliance, 1) Stormwind from the gate
(774,0,0,'The city is louder from the inside.'),
(774,1,0,'From the gate it looked like a promise.'),
(774,2,0,'From the canal it looks like work.'),
(774,3,0,'I''ll take the work. Promises don''t pay repairs.'),

-- 775 (60, neutral, 2) Spare cloak
(775,0,0,'You''re shivering.'),
(775,1,1,'I''m fine.'),
(775,2,0,'Take the spare cloak.'),
(775,3,1,'That''s yours.'),
(775,4,0,'It''s ours until you stop making that noise.'),

-- 776 (22, neutral, 2) Shadowfang doors
(776,0,0,'Every door in here creaks on purpose.'),
(776,1,1,'Worgen don''t believe in oil.'),
(776,2,0,'I believe in oil.'),
(776,3,1,'Then you''re the polite one. Don''t oil the boss''s door.'),

-- 777 (30, neutral, 2) Coward on purpose
(777,0,0,'I''ll be the coward on purpose.'),
(777,1,1,'That''s a skill.'),
(777,2,0,'It''s a decision.'),
(777,3,1,'Decisions are skills that paid taxes. Go.'),

-- 778 (5, Horde, 2) Durotar scorpions
(778,0,0,'The scorpions here are the size of dogs.'),
(778,1,1,'Don''t call them dogs. You''ll insult the dogs.'),
(778,2,0,'I''m insulting the scorpions.'),
(778,3,1,'They don''t care. That''s the problem.'),

-- 779 (18, neutral, 2) Rain on the hill
(779,0,0,'If this rain gets worse, we stop.'),
(779,1,1,'If this rain gets worse, we drown standing.'),
(779,2,0,'That''s not a plan.'),
(779,3,1,'It''s weather. Plans don''t apply.'),

-- 780 (58, neutral, 2) Approach sideways
(780,0,0,'Approach sideways.'),
(780,1,1,'That''s how crabs do it.'),
(780,2,0,'Crabs live.'),
(780,3,1,'Crabs also get eaten. But fine. Sideways. Don''t make it a dance.'),

-- 781 (12, Alliance, 2) Dwarf breakfast
(781,0,0,'The dwarf ordered ale with breakfast.'),
(781,1,1,'That is breakfast.'),
(781,2,0,'There was bread too.'),
(781,3,1,'For the ale.'),

-- 782 (24, neutral, 2) Redridge lake
(782,0,0,'The lake is pretty if you ignore the orcs.'),
(782,1,1,'That''s a lot of ignoring.'),
(782,2,0,'I''m practicing.'),
(782,3,1,'Practice faster. They''re not ignoring you.'),

-- 783 (32, neutral, 2) Waited rudely
(783,0,0,'This mountain waited rudely.'),
(783,1,1,'That''s a personal way to see stone.'),
(783,2,0,'Stone''s been personal all day.'),
(783,3,1,'Then we finish being personal at the top. Or the pass. I''m not picky.'),

-- 784 (60, neutral, 2) Passing through
(784,0,0,'Passing through is the prayer.'),
(784,1,1,'That''s thin theology.'),
(784,2,0,'It''s the only kind that fits in a pack.'),
(784,3,1,'Then pack it. Don''t unroll it at every altar.'),

-- 785 (46, neutral, 2) Don't unroll it
(785,0,0,'Don''t unroll it at every altar.'),
(785,1,1,'I like altars.'),
(785,2,0,'Altars like you back. That''s the problem.'),
(785,3,1,'Then I''ll nod and keep my coin. A cheap pilgrimage.'),

-- 786 (26, neutral, 2) Poor shields
(786,0,0,'Books make poor shields.'),
(786,1,1,'You checked.'),
(786,2,0,'I checked so you don''t have to.'),
(786,3,1,'That''s a gift. A paper one. I''ll still bring a real shield.'),

-- 787 (52, neutral, 1) The price of shouting
(787,0,0,'Shouting gets you help.'),
(787,1,0,'It also gets you found.'),
(787,2,0,'I''ve been found by the wrong people.'),
(787,3,0,'I whisper now. If you need me, look at my hand.'),

-- 788 (60, neutral, 1) I still borrow it
(788,0,0,'I still call it careful.'),
(788,1,0,'You can call it fear if you want.'),
(788,2,0,'Fear got me here with the same number of friends I started with.'),
(788,3,0,'Mostly the same number.'),

-- 789 (60, neutral, 2) Defias mask
(789,0,0,'The stitching on that mask is better than mine.'),
(789,1,1,'Crime pays for tailors.'),
(789,2,0,'Should we hire theirs?'),
(789,3,1,'Hire ours. Stay out of red.'),

-- 790 (24, neutral, 1) Intend to return
(790,0,0,'I don''t intend to return to this one.'),
(790,1,0,'That''s how I stay polite to it.'),
(790,2,0,'I won''t steal its stones.'),
(790,3,0,'I''ll steal my friends back and leave the rest.'),

-- 791 (36, neutral, 1) The count hasn't changed
(791,0,0,'The count hasn''t changed.'),
(791,1,0,'I check more than I admit.'),
(791,2,0,'If I stop checking, that''s when it changes.'),
(791,3,0,'So I check. Don''t call it love if it bothers you. Call it math.'),

-- 792 (54, neutral, 1) A way down
(792,0,0,'There''s always a way down.'),
(792,1,0,'That''s not comforting if you''re already low.'),
(792,2,0,'It''s comforting if you''re too high.'),
(792,3,0,'We''re too high. I''m looking for the down.'),

-- 793 (12, Alliance, 2) Paladin tithe
(793,0,0,'The paladin trainer asked for a donation.'),
(793,1,1,'To the cathedral?'),
(793,2,0,'To the repair bill on his hammer.'),
(793,3,1,'That''s more honest than most sermons.'),

-- 794 (52, neutral, 1) Keep it in my head
(794,0,0,'I keep a lot in my head.'),
(794,1,0,'Maps. Debts. The way you walk when you''re hurt and lying.'),
(794,2,0,'Don''t ask me to forget the last one.'),
(794,3,0,'That''s how I know when to stop asking you if you''re fine.'),

-- 795 (48, neutral, 2) Camp coffee
(795,0,0,'This isn''t coffee.'),
(795,1,1,'It''s hot. That''s the requirement.'),
(795,2,0,'It tastes like bark.'),
(795,3,1,'It is bark. Drink it before it cools into a philosophy.'),

-- 796 (12, Alliance, 2) Gnomeregan refugees
(796,0,0,'There''s a gnome in Tinker Town who still wears a radiation badge.'),
(796,1,1,'Does it still tick?'),
(796,2,0,'He says it keeps him honest.'),
(796,3,1,'That''s a grim kind of clock.'),

-- 797 (40, neutral, 1) When you're hurt
(797,0,0,'You walk different when you''re hurt.'),
(797,1,0,'You think you''re hiding it.'),
(797,2,0,'You''re hiding it from yourself.'),
(797,3,0,'I''m not fooled. Sit. That''s not a question.'),

-- 798 (60, neutral, 1) Don't be brave
(798,0,0,'Don''t be brave without telling me first.'),
(798,1,0,'Bravery is just a surprise to your friends.'),
(798,2,0,'I hate surprises.'),
(798,3,0,'Tell me. We''ll be stupid together. That''s safer.'),

-- 799 (24, neutral, 2) Stolen rations
(799,0,0,'Who ate the last biscuit?'),
(799,1,1,'The one who was hungry.'),
(799,2,0,'That was mine.'),
(799,3,1,'Then you should have slept with it. That''s camp law.'),

-- 800 (46, neutral, 1) Not heavier tonight
(800,0,0,'Don''t get heavier tonight.'),
(800,1,0,'I know that''s not how weight works.'),
(800,2,0,'You know what I mean.'),
(800,3,0,'Stay a problem I can argue with. Not a problem I have to lift.');

INSERT INTO `companion_banter_line` (`script_id`,`line_index`,`speaker_slot`,`text`) VALUES
-- 801 (20, neutral, 2) Second watch
(801,0,0,'Your watch. I''m done.'),
(801,1,1,'You said that an hour ago.'),
(801,2,0,'I said it quietly. Now I''m saying it.'),
(801,3,1,'Sit up. I''ll take it. Don''t die in your sleep. It''s rude.'),

-- 802 (44, neutral, 1) The only honest version
(802,0,0,'Trying is the only honest version.'),
(802,1,0,'I don''t promise outcomes.'),
(802,2,0,'I promise I won''t leave you to the dark because it''s convenient.'),
(802,3,0,'Convenience can go hang. You''re inconvenient. Stay that way.'),

-- 803 (52, neutral, 1) Unfinished is alive
(803,0,0,'Unfinished is another word for alive.'),
(803,1,0,'Don''t rush the ending to make a tavern quieter.'),
(803,2,0,'Let the tavern wait.'),
(803,3,0,'We''re still in the middle. I like the middle. Don''t finish us.'),

-- 804 (20, neutral, 2) Can't swim
(804,0,0,'I''m not crossing that.'),
(804,1,1,'It''s shallow.'),
(804,2,0,'It''s wet.'),
(804,3,1,'That''s the definition. Hold the rope. We won''t tell anyone.'),

-- 805 (58, neutral, 2) Last torch
(805,0,0,'That''s the last torch.'),
(805,1,1,'Then we stop using it as a toy.'),
(805,2,0,'I wasn''t.'),
(805,3,1,'You were writing your name on the wall. Walk.'),

-- 806 (56, neutral, 2) Name of the horse
(806,0,0,'You never named the horse.'),
(806,1,1,'Naming things makes them leave.'),
(806,2,0,'That''s not how horses work.'),
(806,3,1,'It''s how mine work. Call it Horse. It answers.'),

-- 807 (38, neutral, 2) Echo count
(807,0,0,'Don''t shout. I want to hear the other footsteps.'),
(807,1,1,'There aren''t other footsteps.'),
(807,2,0,'There were.'),
(807,3,1,'Then we wait until there aren''t. That''s the plan.'),

-- 808 (24, neutral, 2) Too many knives
(808,0,0,'How many knives do you need?'),
(808,1,1,'One more than the last time I needed a knife.'),
(808,2,0,'That''s not a number.'),
(808,3,1,'It''s a lifestyle. Don''t audit me.'),

-- 809 (12, Alliance, 2) Darnassus quiet
(809,0,0,'Nobody shouts in Darnassus.'),
(809,1,1,'They don''t have to. The trees carry it.'),
(809,2,0,'That''s unsettling.'),
(809,3,1,'That''s the point.'),

-- 810 (58, neutral, 2) Not praying to a stick
(810,0,0,'I''m not praying to a stick.'),
(810,1,1,'It''s a torch.'),
(810,2,0,'It''s a stick with a job.'),
(810,3,1,'Jobs deserve respect. Don''t blow on it.'),

-- 811 (60, neutral, 2) Don't tell the cave
(811,0,0,'Don''t tell the cave we miss doors.'),
(811,1,1,'The cave already knows.'),
(811,2,0,'Then don''t confirm it.'),
(811,3,1,'I wouldn''t give a cave the satisfaction. Walk.'),

-- 812 (22, Alliance, 2) Belong in Ashenvale
(812,0,0,'You look like you belong in Ashenvale.'),
(812,1,1,'That''s the leaves.'),
(812,2,0,'That''s the staring at trees.'),
(812,3,1,'The trees started it.'),

-- 813 (20, neutral, 2) Can't read
(813,0,0,'Read this for me.'),
(813,1,1,'It''s a warning about wolves.'),
(813,2,0,'I know about wolves.'),
(813,3,1,'Now you know about the sign. That''s literacy.'),

-- 814 (18, neutral, 2) Warrior charge
(814,0,0,'You charged the whole pack.'),
(814,1,1,'They were close together. Efficient.'),
(814,2,0,'That''s not the word.'),
(814,3,1,'It is if you live. Count later.'),

-- 815 (44, neutral, 2) Give a cave
(815,0,0,'I wouldn''t give a cave the satisfaction.'),
(815,1,1,'That''s spite.'),
(815,2,0,'Spite walks farther than hope some nights.'),
(815,3,1,'Then we spite our way out. I can do that.'),

-- 816 (60, neutral, 1) Don't name the dark
(816,0,0,'I''m not naming what''s out there.'),
(816,1,0,'Names are invitations.'),
(816,2,0,'If it wants me, it can use the one I already have.'),
(816,3,0,'I won''t make it easier.'),

-- 817 (28, neutral, 1) Menethil dusk
(817,0,0,'Menethil at dusk is gulls and wet rope.'),
(817,1,0,'The sea sounds like it''s chewing.'),
(817,2,0,'I still prefer it to caves.'),
(817,3,0,'Caves don''t have gulls. That''s the whole review.'),

-- 818 (14, Alliance, 2) Nijel's Point
(818,0,0,'Nijel''s Point is a handful of tents and a lot of pride.'),
(818,1,1,'Pride is cheaper than stone.'),
(818,2,0,'Until the wind takes the tents.'),
(818,3,1,'Then they buy more pride.'),

-- 819 (12, Horde, 2) Mor'shan
(819,0,0,'The Mor''shan rampart is a wall with an argument on both sides.'),
(819,1,1,'That''s a border.'),
(819,2,0,'Ashenvale doesn''t agree it''s a border.'),
(819,3,1,'Ashenvale can file a complaint with the lumber mill.'),

-- 820 (58, neutral, 2) Hate caves
(820,0,0,'I hate caves.'),
(820,1,1,'You''ve said.'),
(820,2,0,'I''m saying it again so the cave hears.'),
(820,3,1,'The cave doesn''t care. Watch the ceiling anyway.'),

-- 821 (56, neutral, 2) Not enough rope
(821,0,0,'The rope is short.'),
(821,1,1,'Then the drop is shorter than we hoped.'),
(821,2,0,'That''s not how I wanted to hear that.'),
(821,3,1,'Tie twice. Hope once. Climb.'),

-- 822 (20, neutral, 2) Wrong turn
(822,0,0,'We were here an hour ago.'),
(822,1,1,'Then we make a different mistake.'),
(822,2,0,'That''s not navigation.'),
(822,3,1,'It is if the first one didn''t work.'),

-- 823 (32, neutral, 2) Right turn
(823,0,0,'Left.'),
(823,1,1,'You said left last time.'),
(823,2,0,'Last time left was wrong. This left is new.'),
(823,3,1,'I''m marking the wall. Argue with the mark, not with me.'),

-- 824 (54, neutral, 2) Broken buckle
(824,0,0,'My pack buckle''s gone.'),
(824,1,1,'Use the spare strap.'),
(824,2,0,'There is no spare strap.'),
(824,3,1,'Then use mine. That''s why we walk in a pack.'),

-- 825 (56, neutral, 2) Don't loot yet
(825,0,0,'Not yet.'),
(825,1,1,'It''s just a corpse.'),
(825,2,0,'It''s a corpse in a doorway. Doorways have opinions.'),
(825,3,1,'Fine. We clear. Then you can be rich.'),

-- 826 (52, neutral, 2) Lost glove
(826,0,0,'I dropped a glove in the last room.'),
(826,1,1,'Leave it.'),
(826,2,0,'It''s a good glove.'),
(826,3,1,'It''s a good way to die. I have a spare. Take it.'),

-- 827 (60, neutral, 2) Vendor later
(827,0,0,'We''ll sell it in town.'),
(827,1,1,'We''ll forget it in a bag.'),
(827,2,0,'Then I''ll remind you.'),
(827,3,1,'Then you''re the bank. Don''t die. That''s policy.'),

-- 828 (24, neutral, 2) Homesick bread
(828,0,0,'This bread isn''t right.'),
(828,1,1,'It''s bread.'),
(828,2,0,'Home bread had seeds.'),
(828,3,1,'Then you''re not home. Eat. Seeds later.'),

-- 829 (12, Horde, 2) Sunrock Retreat
(829,0,0,'Sun Rock Retreat is a cave with opinions.'),
(829,1,1,'The tauren have a lot of them.'),
(829,2,0,'About the Venture Company?'),
(829,3,1,'About everything. Start with the Company.'),

-- 830 (44, neutral, 2) Too heavy
(830,0,0,'I can''t take the pauldrons.'),
(830,1,1,'Leave them.'),
(830,2,0,'They''re good pauldrons.'),
(830,3,1,'They''re good paperweights. Live. Buy worse ones later.'),

-- 831 (8, Alliance, 1) Alliance gate tax
(831,0,0,'The guard at the gate asked where I was headed.'),
(831,1,0,'I said home.'),
(831,2,0,'He laughed like home was a tavern.'),
(831,3,0,'He might be right. I''m still going.'),

-- 832 (22, neutral, 2) Packed twice
(832,0,0,'Why two waterskins?'),
(832,1,1,'Because last time you asked why one.'),
(832,2,0,'That''s fair.'),
(832,3,1,'It''s not fair. It''s experience. Drink the first slowly.'),

-- 833 (5, Alliance, 1) Ironforge dusk
(833,0,0,'Ironforge doesn''t have dusk. It has a dimmer anvil.'),
(833,1,0,'I miss a horizon.'),
(833,2,0,'I''ll live.'),
(833,3,0,'The beer helps the living. That''s the local sky.'),

-- 834 (36, neutral, 2) Rain prayer
(834,0,0,'If it rains again I''m converting.'),
(834,1,1,'To what?'),
(834,2,0,'Whatever stops weather.'),
(834,3,1,'That''s not a faith. That''s a complaint. Put the hood up.'),

-- 835 (60, neutral, 2) Night market
(835,0,0,'The night market sells things that don''t like daylight.'),
(835,1,1,'That''s a poetic way to say stolen.'),
(835,2,0,'Some of it''s just ugly.'),
(835,3,1,'Ugly is legal. Don''t buy the things that whisper.'),

-- 836 (10, neutral, 2) Afraid of water
(836,0,0,'I''ll wait on the bank.'),
(836,1,1,'The bank isn''t the job.'),
(836,2,0,'The river is deeper than it looks.'),
(836,3,1,'Then we find a shallower lie. Come on.'),

-- 837 (26, neutral, 2) Fence prices
(837,0,0,'He offered half.'),
(837,1,1,'That''s a fence. That''s the business model.'),
(837,2,0,'I could find a vendor.'),
(837,3,1,'Vendors ask where you got it. Pay for the amnesia.'),

-- 838 (22, Alliance, 2) Darkshire lanterns
(838,0,0,'They light every lantern in Darkshire before dusk.'),
(838,1,1,'And it still isn''t enough.'),
(838,2,0,'Then why do they bother?'),
(838,3,1,'So they can see what''s eating them.'),

-- 839 (50, neutral, 2) Not the droids
(839,0,0,'If anyone asks, we were never in that cellar.'),
(839,1,1,'We were in that cellar.'),
(839,2,0,'That''s why I''m saying it.'),
(839,3,1,'Nod. Don''t add details. Details are how cellars follow you.'),

-- 840 (42, neutral, 2) False name
(840,0,0,'Don''t use my real name at the next inn.'),
(840,1,1,'What name then?'),
(840,2,0,'Anything with fewer letters.'),
(840,3,1,'I''ll call you Short. That''s two.'),

-- 841 (20, neutral, 2) Nod is enough
(841,0,0,'That nod is enough.'),
(841,1,1,'I can say it.'),
(841,2,0,'You don''t have to. I heard the nod.'),
(841,3,1,'Good. Talking would make it worse.'),

-- 842 (60, neutral, 2) Boring forever
(842,0,0,'May we be boring forever.'),
(842,1,1,'That''s a terrible toast.'),
(842,2,0,'It''s the only toast I like.'),
(842,3,1,'Fine. Boring. Don''t spill the drink. That''s exciting.'),

-- 843 (5, Horde, 2) Mulgore kodos
(843,0,0,'A kodo sat on the road and would not move.'),
(843,1,1,'Then the road belongs to the kodo.'),
(843,2,0,'We have somewhere to be.'),
(843,3,1,'So does the kodo. It''s already there.'),

-- 844 (42, Horde, 2) Zoram'gar
(844,0,0,'Zoram''gar is a dock pretending to be a fortress.'),
(844,1,1,'It''s a fortress pretending to be a dock.'),
(844,2,0,'Which is it?'),
(844,3,1,'Depends whether the naga are swimming.'),

-- 845 (28, neutral, 2) Rituals matter
(845,0,0,'Check the straps. Every time.'),
(845,1,1,'I checked yesterday.'),
(845,2,0,'Yesterday''s straps belong to yesterday.'),
(845,3,1,'That''s almost wise. Don''t let it go to your head.'),

-- 846 (60, neutral, 2) Morning count
(846,0,0,'We''re all here.'),
(846,1,1,'Say it after you count.'),
(846,2,0,'I counted.'),
(846,3,1,'Count again. I like the number better the second time.'),

-- 847 (52, neutral, 2) Lie us home
(847,0,0,'Lie us home.'),
(847,1,1,'That''s a terrible job title.'),
(847,2,0,'It''s the only one I have tonight.'),
(847,3,1,'Fine. Home is two hills over. I don''t care if it''s true.'),

-- 848 (20, neutral, 2) The arrangement
(848,0,0,'We have an arrangement.'),
(848,1,1,'Which one?'),
(848,2,0,'The one where nobody dies stupid.'),
(848,3,1,'That''s a high bar. I''ll try to die clever if I have to.'),

-- 849 (52, neutral, 2) Hate how often
(849,0,0,'I hate how often you''re right.'),
(849,1,1,'Practice. You''ll get there.'),
(849,2,0,'Don''t make it a lesson.'),
(849,3,1,'It is a lesson. That''s why you hate it.'),

-- 850 (38, neutral, 2) Smell of wet fur
(850,0,0,'Something''s close.'),
(850,1,1,'You always say that.'),
(850,2,0,'I can smell wet fur.'),
(850,3,1,'Then I believe you. Weapons out. Complaining later.'),

-- 851 (5, Horde, 2) Tirisfal bats
(851,0,0,'The bats in Tirisfal fly like they own the dusk.'),
(851,1,1,'They do.'),
(851,2,0,'I waved a torch.'),
(851,3,1,'That''s how you rent the dusk for a minute.'),

-- 852 (38, neutral, 2) Card game
(852,0,0,'I''m not playing cards with a rogue.'),
(852,1,1,'That''s prejudice.'),
(852,2,0,'That''s pattern recognition.'),
(852,3,1,'Fine. Play with the paladin. Lose honestly.'),

-- 853 (60, neutral, 2) Don't plant a flag
(853,0,0,'Don''t plant a flag on this.'),
(853,1,1,'I wasn''t going to.'),
(853,2,0,'You were looking for a stick.'),
(853,3,1,'It was for walking. Walking isn''t claiming.'),

-- 854 (60, neutral, 2) Dice curse
(854,0,0,'These dice are cursed.'),
(854,1,1,'You said that when you were winning.'),
(854,2,0,'They were lucky then.'),
(854,3,1,'They''re wood. Sit down or don''t. Don''t blame timber.'),

-- 855 (60, neutral, 2) North has ears
(855,0,0,'North has ears.'),
(855,1,1,'South has worse.'),
(855,2,0,'Then we go west.'),
(855,3,1,'West has the sea. Pick a vice.'),

-- 856 (60, neutral, 2) High bar
(856,0,0,'The bar is on the floor and I still trip.'),
(856,1,1,'Then we lower the bar.'),
(856,2,0,'That''s sad.'),
(856,3,1,'That''s survival. Sad can wait for town.'),

-- 857 (60, neutral, 2) Don't repeat it
(857,0,0,'If I say something kind, forget it.'),
(857,1,1,'I already did.'),
(857,2,0,'Good.'),
(857,3,1,'I lied. I kept it. Don''t make me say which line.'),

-- 858 (30, neutral, 2) Which line
(858,0,0,'Which line did you keep?'),
(858,1,1,'The one where you didn''t leave.'),
(858,2,0,'That wasn''t kindness. That was logistics.'),
(858,3,1,'Then I like your logistics. Shut up.'),

-- 859 (58, neutral, 2) Compromise with dark
(859,0,0,'We can sit in the dark.'),
(859,1,1,'We can sit in a little light.'),
(859,2,0,'Little light is how you get seen.'),
(859,3,1,'No light is how you get lost. Pick being seen.'),

-- 860 (26, neutral, 2) Pick being seen
(860,0,0,'I''d rather be seen than lost.'),
(860,1,1,'That''s a grown-up sentence.'),
(860,2,0,'Don''t put it on a stone.'),
(860,3,1,'I won''t. I''ll put it in the morning and forget it.'),

-- 861 (12, Alliance, 2) Auberdine dock
(861,0,0,'The boat to Auberdine was packed.'),
(861,1,1,'Night elves travel light. Humans don''t.'),
(861,2,0,'I brought one bag.'),
(861,3,1,'And three opinions.'),

-- 862 (56, neutral, 2) Save for daylight
(862,0,0,'Save it for daylight.'),
(862,1,1,'The speech?'),
(862,2,0,'The fear. The speech. The inventory of regrets.'),
(862,3,1,'Daylight''s going to be busy. Fine.'),

-- 863 (58, neutral, 2) Daylight's busy
(863,0,0,'Daylight''s going to be busy.'),
(863,1,1,'Daylight always is.'),
(863,2,0,'This one has extra.'),
(863,3,1,'Then we start it early. Sleep like you mean the morning.'),

-- 864 (34, Horde, 2) Stonard mud
(864,0,0,'Stonard is a boot stuck in a swamp.'),
(864,1,1,'It''s our boot.'),
(864,2,0,'The swamp is winning.'),
(864,3,1,'The swamp always thinks that.'),

-- 865 (60, neutral, 2) That's the verse
(865,0,0,'If this is a song, I hate the chorus.'),
(865,1,1,'The chorus is just footsteps.'),
(865,2,0,'That''s a dull song.'),
(865,3,1,'Dull songs get you home. Hum anyway.'),

-- 866 (10, neutral, 2) Blisters
(866,0,0,'My feet are done.'),
(866,1,1,'Your feet don''t get a vote.'),
(866,2,0,'They''ve blistered.'),
(866,3,1,'Then they''ve filed a complaint. We still walk.'),

-- 867 (36, neutral, 2) Truce with the dark
(867,0,0,'We have a truce with the dark.'),
(867,1,1,'The dark didn''t sign.'),
(867,2,0,'We signed for it.'),
(867,3,1,'That''s one-sided. Keep the torch anyway.'),

-- 868 (20, neutral, 2) Guard bribe
(868,0,0,'He looked at the bag.'),
(868,1,1,'Smile. Don''t explain.'),
(868,2,0,'I wasn''t going to.'),
(868,3,1,'You explain when you''re nervous. Don''t be nervous.'),

-- 869 (28, neutral, 2) Keep the torch
(869,0,0,'Keep the torch.'),
(869,1,1,'It''s almost gone.'),
(869,2,0,'Almost is enough for the last door.'),
(869,3,1,'Then the last door had better be close. I''m not praying to a stick.'),

-- 870 (12, Alliance, 2) Night elf shoes
(870,0,0,'She wasn''t wearing shoes.'),
(870,1,1,'She''s a night elf.'),
(870,2,0,'The road is stone.'),
(870,3,1,'Her feet are older than the road.'),

-- 871 (10, neutral, 2) New boots
(871,0,0,'These boots aren''t broken in.'),
(871,1,1,'That''s what roads are for.'),
(871,2,0,'The road is winning.'),
(871,3,1,'Good. That''s how boots learn.'),

-- 872 (40, neutral, 2) Not far
(872,0,0,'Not far.'),
(872,1,1,'That''s where you always put it.'),
(872,2,0,'That''s where it belongs.'),
(872,3,1,'Then we''re agreed. Don''t sleep on it. That''s how you lose a kidney.'),

-- 873 (24, Alliance, 2) Chillwind camp
(873,0,0,'Chillwind Camp is all canvas and stubbornness.'),
(873,1,1,'The plague doesn''t care about canvas.'),
(873,2,0,'The Argent Dawn does.'),
(873,3,1,'That''s why they''re still there.'),

-- 874 (34, Horde, 2) Kargath dust
(874,0,0,'Kargath is all red dust and worse news.'),
(874,1,1,'That''s the Badlands greeting.'),
(874,2,0,'Is there water?'),
(874,3,1,'There''s ale. Ration it like water.'),

-- 875 (26, neutral, 2) Publication enough
(875,0,0,'If this gets told, let it be wrong.'),
(875,1,1,'Why?'),
(875,2,0,'Wrong stories keep the real doors hidden.'),
(875,3,1,'Then I''ll lie badly. I''m good at that.'),

-- 876 (48, neutral, 2) Lie badly
(876,0,0,'Lie badly.'),
(876,1,1,'That''s easy.'),
(876,2,0,'Make it boring.'),
(876,3,1,'Boredom is my gift. I''ll say we walked and nothing happened.'),

-- 877 (50, neutral, 2) Me in the middle
(877,0,0,'I''ll take the middle.'),
(877,1,1,'That''s the safe one.'),
(877,2,0,'That''s the one that drags both ends.'),
(877,3,1,'Then it isn''t safe. Take it. You would anyway.'),

-- 878 (40, neutral, 2) Find me one
(878,0,0,'Find me a door.'),
(878,1,1,'I found a crack.'),
(878,2,0,'A crack isn''t a door.'),
(878,3,1,'It''s a door that hasn''t admitted it. We can help.'),

-- 879 (56, neutral, 2) Lose the number
(879,0,0,'If I lose the number, you run first.'),
(879,1,1,'That''s not brave.'),
(879,2,0,'That''s the point.'),
(879,3,1,'Then I''ll be the coward on purpose. Don''t praise me for it.'),

-- 880 (5, neutral, 2) First death
(880,0,0,'If I die, drag me to a spirit healer.'),
(880,1,1,'If you die, you''ll find them yourself.'),
(880,2,0,'That''s not comforting.'),
(880,3,1,'It''s accurate. Comfort is extra.'),

-- 881 (10, neutral, 2) Borrowed sword
(881,0,0,'This isn''t mine.'),
(881,1,1,'It is until we find the owner.'),
(881,2,0,'What if the owner is dead?'),
(881,3,1,'Then it''s yours. Don''t make it a debate in the rain.'),

-- 882 (48, neutral, 2) Smell before we wave
(882,0,0,'Smell before we wave.'),
(882,1,1,'That''s a grim greeting.'),
(882,2,0,'It''s a safe one.'),
(882,3,1,'Then I''ll sniff. If it''s pork, we wave. If it''s pitch, we don''t.'),

-- 883 (20, neutral, 2) Learned to cook
(883,0,0,'I hope it isn''t a trap that learned to cook.'),
(883,1,1,'That''s a specific fear.'),
(883,2,0,'I''ve had a specific life.'),
(883,3,1,'Then we approach sideways. Specific lives deserve angles.'),

-- 884 (24, Alliance, 2) Trees started it
(884,0,0,'The sentinels started it.'),
(884,1,1,'That''s not how wars begin in the telling.'),
(884,2,0,'That''s how they begin on the ground.'),
(884,3,1,'Then keep your voice down. The trees have ears. I mean that.'),

-- 885 (42, Horde, 2) Hammerfall
(885,0,0,'Hammerfall looks like it was dropped onto the highlands.'),
(885,1,1,'It was. On purpose.'),
(885,2,0,'The Alliance can see it from the road.'),
(885,3,1,'Good. Let them.'),

-- 886 (52, neutral, 2) There's a camp
(886,0,0,'There''s a camp.'),
(886,1,1,'Ours or theirs?'),
(886,2,0,'Too soon to say.'),
(886,3,1,'Then it''s theirs until it offers stew. Don''t smile yet.'),

-- 887 (60, neutral, 2) We don't count
(887,0,0,'We don''t stay to count.'),
(887,1,1,'I like counting.'),
(887,2,0,'Count while you walk.'),
(887,3,1,'I''ll count steps. If I reach a thousand, I want a chair.'),

-- 888 (8, Alliance, 1) Darnassus dusk
(888,0,0,'Darnassus at dusk is all silver and footsteps you can''t hear.'),
(888,1,0,'I stomped on purpose so I wouldn''t vanish.'),
(888,2,0,'A priestess looked at me like I''d kicked a hymn.'),
(888,3,0,'I''ll stomp quieter. I won''t vanish.'),

-- 889 (38, neutral, 2) I'm not picky
(889,0,0,'I''m not picky.'),
(889,1,1,'You are.'),
(889,2,0,'I''m picky about dying. Everything else can be ugly.'),
(889,3,1,'That''s a reasonable religion. Convert me later. Climb now.'),

-- 890 (60, neutral, 2) Convert me later
(890,0,0,'Convert me later.'),
(890,1,1,'I wasn''t preaching.'),
(890,2,0,'You were breathing like a sermon.'),
(890,3,1,'That''s altitude. Don''t give it a church.'),

-- 891 (26, neutral, 2) Cheap pilgrimage
(891,0,0,'A cheap pilgrimage.'),
(891,1,1,'Those are the honest ones.'),
(891,2,0,'The expensive ones buy better songs.'),
(891,3,1,'I don''t need a song. I need the road to end in soup.'),

-- 892 (42, neutral, 2) A kind of wealth
(892,0,0,'A good pot is a kind of wealth.'),
(892,1,1,'Don''t say that in Stormwind.'),
(892,2,0,'I''ll say it anywhere.'),
(892,3,1,'Then you''re a philosopher with soot on your hands. I can live with that.'),

-- 893 (28, neutral, 2) Nobles can wait
(893,0,0,'The nobles can wait.'),
(893,1,1,'They won''t.'),
(893,2,0,'Then they can send a letter to the stew.'),
(893,3,1,'Stew doesn''t read. That''s why I like it.'),

-- 894 (24, neutral, 2) Read later
(894,0,0,'Read later if we live.'),
(894,1,1,'That''s a grim bookmark.'),
(894,2,0,'It''s an honest one.'),
(894,3,1,'Then I''ll dog-ear the page with hope. Don''t laugh.'),

-- 895 (60, neutral, 2) Bring a real shield
(895,0,0,'Bring a real shield.'),
(895,1,1,'I have a real shield.'),
(895,2,0,'You have a lid.'),
(895,3,1,'It''s a lid that learned. Don''t insult graduates.'),

-- 896 (40, neutral, 1) First watch monologue
(896,0,0,'I''ll take first watch.'),
(896,1,0,'Don''t argue. I don''t sleep much anyway.'),
(896,2,0,'If something moves, I''ll kick you. Softly.'),
(896,3,0,'Mostly softly.'),

-- 897 (28, neutral, 1) Look at my hand
(897,0,0,'If I raise two fingers, we stop.'),
(897,1,0,'If I close the fist, we run.'),
(897,2,0,'Don''t ask me to explain in the moment.'),
(897,3,0,'The moment is the whole reason for the hand.'),

-- 898 (10, neutral, 2) Afraid of dark
(898,0,0,'Leave the lantern up.'),
(898,1,1,'We''ll be seen.'),
(898,2,0,'I''ll be seen shaking if you don''t.'),
(898,3,1,'Then we leave it up. Pride is cheaper than panic.'),

-- 899 (56, neutral, 1) I still get up
(899,0,0,'I still get up.'),
(899,1,0,'That''s not bravery.'),
(899,2,0,'That''s a habit I don''t know how to break.'),
(899,3,0,'If I learn how, I hope it''s in a bed, not a ditch.'),

-- 900 (38, neutral, 1) Messy and breathing
(900,0,0,'Messy and breathing.'),
(900,1,0,'That''s the standard.'),
(900,2,0,'If you can complain, you''re meeting it.'),
(900,3,0,'Complain. I like the sound. It means the count hasn''t changed.');

INSERT INTO `companion_banter_line` (`script_id`,`line_index`,`speaker_slot`,`text`) VALUES
-- 901 (14, Alliance, 4) Someone's first sword
(901,0,0,'It''s heavier than I thought.'),
(901,1,1,'You''ll get used to it.'),
(901,2,0,'How long does that take?'),
(901,3,1,'A while.'),
(901,4,2,'Mine took a month.'),
(901,5,3,'Mine took a year.'),
(901,6,0,'That''s not encouraging.'),
(901,7,3,'It wasn''t meant to be.'),

-- 902 (56, neutral, 3) A quiet confession
(902,0,0,'Can I tell you something?'),
(902,1,1,'Sure.'),
(902,2,0,'I''m afraid of dying in a place like this.'),
(902,3,1,'Everyone is.'),
(902,4,2,'No, I mean a place with no sky.'),
(902,5,0,'...Yeah.'),
(902,6,1,'Yeah.'),

-- 903 (46, neutral, 4) An argument
(903,0,0,'You don''t know what you''re talking about.'),
(903,1,1,'I know exactly what I''m talking about.'),
(903,2,0,'You''ve never been to Kalimdor.'),
(903,3,1,'I''ve been to Kalimdor.'),
(903,4,2,'You''ve been to Theramore. That''s not Kalimdor.'),
(903,5,3,'Theramore is in Kalimdor.'),
(903,6,2,'Theramore is a wall with people inside it.'),
(903,7,0,'That''s the truest thing anyone''s said all day.'),

-- 904 (26, neutral, 3) Tall tale, properly told
(904,0,0,'I once saw a man fight a bear with a frying pan.'),
(904,1,1,'Did he win?'),
(904,2,0,'He won the fight.'),
(904,3,1,'And then?'),
(904,4,0,'The bear''s mother showed up.'),
(904,5,2,'That''s not an end.'),
(904,6,0,'It is for him.'),

-- 905 (18, neutral, 3) Lore: who actually built the gates
(905,0,0,'Everyone credits the heroes for opening Ahn''Qiraj.'),
(905,1,1,'It took an army.'),
(905,2,0,'It took farmers.'),
(905,3,1,'What?'),
(905,4,2,'They donated the cloth. The bandages. The food.'),
(905,5,0,'That''s not heroic.'),
(905,6,2,'It''s how armies eat.'),

-- 906 (30, neutral, 3) Two friends, one tired
(906,0,0,'You''re quiet.'),
(906,1,1,'I''m tired.'),
(906,2,0,'You''re always tired.'),
(906,3,1,'Because we never stop.'),
(906,4,2,'We stopped yesterday.'),
(906,5,1,'For an hour.'),
(906,6,0,'An hour counts.'),
(906,7,1,'It really doesn''t.'),

-- 907 (10, neutral, 2) A lesson
(907,0,0,'Never draw your sword unless you mean it.'),
(907,1,1,'Why?'),
(907,2,0,'Because they''ll see it and draw theirs.'),
(907,3,1,'And then?'),
(907,4,0,'Then one of you has to use it.'),

-- 908 (44, neutral, 3) Practical talk
(908,0,0,'How many bandages do you carry?'),
(908,1,1,'Twenty.'),
(908,2,0,'Twenty?'),
(908,3,1,'I''ve needed thirty.'),
(908,4,2,'When?'),
(908,5,1,'Once.'),
(908,6,0,'That''s a lot of bleeding.'),
(908,7,1,'It was.'),

-- 909 (5, Horde, 3) Home
(909,0,0,'I miss the smell of smoke.'),
(909,1,1,'Campfire smoke?'),
(909,2,0,'Home smoke.'),
(909,3,1,'What''s the difference?'),
(909,4,2,'One means dinner. The other means home.'),
(909,5,0,'That''s nice.'),
(909,6,2,'It''s true.'),

-- 910 (48, neutral, 3) The old argument
(910,0,0,'You can''t trust the Forsaken.'),
(910,1,1,'You can''t trust anyone.'),
(910,2,0,'That''s a different argument.'),
(910,3,1,'It''s the same argument.'),
(910,4,2,'It''s really not.'),
(910,5,0,'It''s close enough at three in the morning.'),

-- 911 (50, neutral, 3) A short monologue
(911,0,0,'When I was young I thought I''d be famous.'),
(911,1,1,'And now?'),
(911,2,0,'Now I''d settle for a warm bed.'),
(911,3,1,'That''s sad.'),
(911,4,2,'That''s growing up.'),
(911,5,0,'It''s both.'),

-- 912 (60, neutral, 4) A quiet moment
(912,0,0,'It''s beautiful down here, in a way.'),
(912,1,1,'It''s a cave.'),
(912,2,0,'The light on the water.'),
(912,3,1,'That''s fungus.'),
(912,4,2,'It''s glowing fungus.'),
(912,5,3,'It''s still fungus.'),
(912,6,0,'Let me have this.'),
(912,7,3,'Fine.'),

-- 913 (44, neutral, 2) A secret
(913,0,0,'I can''t read.'),
(913,1,1,'What?'),
(913,2,0,'I can''t read. I never learned.'),
(913,3,1,'...How do you get by?'),
(913,4,0,'I ask people I trust.'),
(913,5,1,'Then you trust me?'),
(913,6,0,'I do now.'),

-- 914 (56, neutral, 1) More than brave
(914,0,0,'I''ve restarted more times than I''ve been brave.'),
(914,1,0,'That''s supposed to be embarrassing.'),
(914,2,0,'It''s not.'),
(914,3,0,'It''s the reason I''m still a problem that lives.'),

-- 915 (52, neutral, 3) War stories
(915,0,0,'You ever lose someone in a raid?'),
(915,1,1,'Everyone has.'),
(915,2,0,'Who?'),
(915,3,1,'A priest.'),
(915,4,2,'What happened?'),
(915,5,1,'He ran out of mana.'),
(915,6,0,'That''s not how you want to go.'),
(915,7,1,'No. It isn''t.'),

-- 916 (36, neutral, 3) Practical
(916,0,0,'Tie your boots tighter.'),
(916,1,1,'Why?'),
(916,2,0,'Because we''re about to run.'),
(916,3,1,'Run from what?'),
(916,4,2,'From whatever''s making that sound.'),
(916,5,0,'What sound?'),
(916,6,1,'That one.'),
(916,7,0,'Oh.'),

-- 917 (60, neutral, 2) A moment
(917,0,0,'Do you ever think about the ones who didn''t make it?'),
(917,1,1,'All the time.'),
(917,2,0,'Do you think they''re watching?'),
(917,3,1,'I hope not.'),
(917,4,0,'Why?'),
(917,5,1,'Because I''m not proud of everything I''ve done.'),

-- 918 (48, neutral, 3) Practical
(918,0,0,'Eat something.'),
(918,1,1,'I''m not hungry.'),
(918,2,0,'Eat anyway.'),
(918,3,1,'Why?'),
(918,4,2,'Because you''ll be hungry later and we might not stop.'),
(918,5,0,'That''s fair.'),
(918,6,1,'That''s how it works.'),

-- 919 (12, Alliance, 3) A lesson
(919,0,0,'Never trust a man in a clean cloak.'),
(919,1,1,'Why?'),
(919,2,0,'He hasn''t been in a fight yet.'),
(919,3,1,'Or he''s very good at them.'),
(919,4,2,'That''s worse.'),
(919,5,0,'That''s much worse.'),

-- 920 (42, Horde, 3) A quiet moment
(920,0,0,'The drums stopped.'),
(920,1,1,'Good.'),
(920,2,0,'I liked them.'),
(920,3,1,'You always say that.'),
(920,4,2,'Because I always like them.'),
(920,5,0,'That''s why they stopped.'),
(920,6,2,'Because I like them?'),
(920,7,0,'Because you never stop liking them.'),

-- 921 (60, neutral, 2) A confession
(921,0,0,'I''ve killed people who didn''t deserve it.'),
(921,1,1,'We all have.'),
(921,2,0,'That''s not absolution.'),
(921,3,1,'No. It''s not.'),
(921,4,0,'Then why say it?'),
(921,5,1,'Because it''s true.'),

-- 922 (60, neutral, 2) Practical
(922,0,0,'We''re out of bandages.'),
(922,1,1,'We''re out of cloth.'),
(922,2,0,'We''re out of luck.'),
(922,3,1,'We''re not out of luck.'),
(922,4,0,'We''re close.'),

-- 923 (60, neutral, 2) A moment
(923,0,0,'Do you think we''ll ever be done?'),
(923,1,1,'Done with what?'),
(923,2,0,'All of it.'),
(923,3,1,'No.'),
(923,4,0,'That''s honest.'),
(923,5,1,'That''s the only thing I have left.'),

-- 924 (60, neutral, 3) Practical
(924,0,0,'We should mark the path.'),
(924,1,1,'With what?'),
(924,2,0,'Chalk.'),
(924,3,1,'We don''t have chalk.'),
(924,4,2,'We have dirt.'),
(924,5,0,'That won''t work.'),
(924,6,2,'It''ll work enough.'),

-- 925 (24, neutral, 3) A lesson
(925,0,0,'The forest changes.'),
(925,1,1,'Forests don''t change.'),
(925,2,0,'They change every season.'),
(925,3,1,'That''s not the same.'),
(925,4,2,'It''s exactly the same.'),
(925,5,0,'Old maps kill people.'),
(925,6,1,'That''s the lesson.'),

-- 926 (18, neutral, 3) An argument
(926,0,0,'You always do this.'),
(926,1,1,'Do what?'),
(926,2,0,'Walk in front.'),
(926,3,1,'Someone has to.'),
(926,4,2,'It doesn''t have to be you.'),
(926,5,0,'It''s always me.'),
(926,6,2,'That''s the problem.'),

-- 927 (60, neutral, 3) Quiet moment
(927,0,0,'The tent held.'),
(927,1,1,'I fixed it.'),
(927,2,0,'It held in the storm.'),
(927,3,1,'I know.'),
(927,4,2,'That''s the first thing you''ve fixed all week.'),
(927,5,0,'It''s the first thing that needed fixing.'),
(927,6,2,'Fair.'),

-- 928 (36, neutral, 2) Practical
(928,0,0,'Watch the water.'),
(928,1,1,'What about it?'),
(928,2,0,'It''s rising.'),
(928,3,1,'How fast?'),
(928,4,0,'Faster than we''re walking.'),

-- 929 (5, Horde, 3) Tall tale
(929,0,0,'I once killed a wolf with a rock.'),
(929,1,1,'You told me that.'),
(929,2,0,'It was a different wolf.'),
(929,3,1,'There''s only one wolf story.'),
(929,4,2,'It''s a good story.'),
(929,5,0,'It''s not even a good story.'),

-- 930 (60, neutral, 2) A moment
(930,0,0,'Do you ever miss the sun?'),
(930,1,1,'We were outside yesterday.'),
(930,2,0,'That''s not what I mean.'),
(930,3,1,'I know.'),
(930,4,0,'Do you?'),
(930,5,1,'Yes.'),

-- 931 (28, neutral, 3) Practical
(931,0,0,'Label the crate.'),
(931,1,1,'Why?'),
(931,2,0,'Because last time we didn''t and we lost a day.'),
(931,3,1,'That was one day.'),
(931,4,2,'One day is a lot when the lift only runs twice.'),
(931,5,0,'That''s fair.'),
(931,6,1,'That''s how it works.'),

-- 932 (60, neutral, 3) A quiet argument
(932,0,0,'We should have left earlier.'),
(932,1,1,'We couldn''t leave earlier.'),
(932,2,0,'We could have.'),
(932,3,1,'The wagon wasn''t ready.'),
(932,4,2,'It''s never ready.'),
(932,5,0,'Then we never leave.'),

-- 933 (52, neutral, 3) Lore
(933,0,0,'The Searing Gorge is what''s left of a forest.'),
(933,1,1,'A forest?'),
(933,2,0,'Before the dwarves dug too deep.'),
(933,3,1,'They dug that much?'),
(933,4,2,'They woke something.'),
(933,5,0,'What?'),
(933,6,2,'Something with fire.'),

-- 934 (5, neutral, 2) A lesson
(934,0,0,'Never fight a man with nothing to lose.'),
(934,1,1,'Why?'),
(934,2,0,'Because he''ll do anything.'),
(934,3,1,'So will I.'),
(934,4,0,'That''s the problem.'),

-- 935 (36, neutral, 3) Practical
(935,0,0,'Check the rope.'),
(935,1,1,'I checked it.'),
(935,2,0,'Check it again.'),
(935,3,1,'I checked it twice.'),
(935,4,2,'Check it a third time.'),
(935,5,0,'That''s paranoid.'),
(935,6,2,'That''s how I''m still here.'),

-- 936 (60, neutral, 4) An argument
(936,0,0,'We should have taken the other tunnel.'),
(936,1,1,'There was no other tunnel.'),
(936,2,0,'There was definitely another tunnel.'),
(936,3,1,'It was blocked.'),
(936,4,2,'It was passable.'),
(936,5,3,'It was neither.'),
(936,6,0,'That doesn''t make sense.'),
(936,7,3,'Neither does this argument.'),

-- 937 (52, neutral, 3) Lore
(937,0,0,'The First War started with a single portal.'),
(937,1,1,'A single portal and a single king.'),
(937,2,0,'A single king who was a dragon.'),
(937,3,1,'That came later.'),
(937,4,2,'It came at the same time.'),
(937,5,0,'History is messy.'),
(937,6,2,'History is always messy.'),

-- 938 (56, neutral, 3) A quiet moment
(938,0,0,'I''ve been in this library before.'),
(938,1,1,'You told me.'),
(938,2,0,'I didn''t tell you the whole thing.'),
(938,3,1,'Then tell me.'),
(938,4,2,'I found a book here.'),
(938,5,0,'What was in it?'),
(938,6,2,'A spell I shouldn''t have read.'),

-- 939 (52, neutral, 3) A practical warning
(939,0,0,'Watch the ridge.'),
(939,1,1,'I''m watching it.'),
(939,2,0,'There''s something up there.'),
(939,3,1,'It''s a goat.'),
(939,4,2,'Goats don''t watch people.'),
(939,5,0,'Goats watch everything.'),
(939,6,2,'That''s the problem.'),

-- 940 (30, neutral, 3) A story
(940,0,0,'I was there when they found the first corrupted furbolg.'),
(940,1,1,'Where?'),
(940,2,0,'Felwood.'),
(940,3,1,'What was it like?'),
(940,4,2,'It was still standing.'),
(940,5,0,'That''s it?'),
(940,6,2,'It was still standing and it was dead.'),

-- 941 (60, neutral, 3) An argument
(941,0,0,'You didn''t have to kill him.'),
(941,1,1,'He was going to kill us.'),
(941,2,0,'You don''t know that.'),
(941,3,1,'He had a sword.'),
(941,4,2,'Lots of people have swords.'),
(941,5,0,'We have swords.'),
(941,6,2,'...Fair.'),

-- 942 (58, neutral, 3) A quiet moment
(942,0,0,'It''s snowing.'),
(942,1,1,'We''re outside.'),
(942,2,0,'It''s snowing hard.'),
(942,3,1,'It''s Winterspring.'),
(942,4,2,'It''s snowing harder.'),

-- 943 (40, neutral, 1) The answer is no
(943,0,0,'The answer is already no.'),
(943,1,0,'I say it in my head so I don''t have to say it to your face.'),
(943,2,0,'If I say it to your face, it''s because we''re dying.'),
(943,3,0,'I''d rather keep it in my head.'),

-- 944 (50, Horde, 2) Warsong started it
(944,0,0,'The Warsong started it.'),
(944,1,1,'That''s not how they tell it in Orgrimmar.'),
(944,2,0,'Orgrimmar is far from the stumps.'),
(944,3,1,'Then we tell it true here. Quietly. Axes still carry.'),

-- 945 (60, neutral, 3) An argument
(945,0,0,'You should have told me.'),
(945,1,1,'I didn''t know.'),
(945,2,0,'You knew.'),
(945,3,1,'I suspected.'),
(945,4,2,'Suspecting is knowing.'),
(945,5,0,'Suspecting is not knowing.'),
(945,6,2,'At this point it''s the same thing.'),

-- 946 (40, neutral, 3) Practical
(946,0,0,'Take the boards off the wagon.'),
(946,1,1,'Then we have no wagon.'),
(946,2,0,'Then we have boards.'),
(946,3,1,'That''s not the same.'),
(946,4,2,'It''s the same when you''re stuck in dust.'),
(946,5,0,'That''s fair.'),

-- 947 (60, neutral, 4) A quiet moment
(947,0,0,'The sandstorm is over.'),
(947,1,1,'The tents held.'),
(947,2,1,'That''s the first good news all day.'),
(947,3,2,'There''s sand in everything.'),
(947,4,3,'Everything.'),
(947,5,0,'Everything except the tents.'),
(947,6,3,'Even the tents.'),

-- 948 (60, neutral, 1) I'll like you angry
(948,0,0,'I''ll like you angry.'),
(948,1,0,'Anger means the count hasn''t changed.'),
(948,2,0,'Silence is the thing I don''t trust.'),
(948,3,0,'Make a noise. Any noise. I''ll take a swear.'),

-- 949 (28, neutral, 3) A story
(949,0,0,'I crossed that bridge once.'),
(949,1,1,'Once?'),
(949,2,0,'Once.'),
(949,3,1,'Why only once?'),
(949,4,2,'Because it fell the second time.'),
(949,5,0,'That''s a good reason.'),
(949,6,2,'It''s the best reason.'),

-- 950 (58, neutral, 3) An argument
(950,0,0,'You''re pulling it wrong.'),
(950,1,1,'I''m pulling it fine.'),
(950,2,1,'Then you pull it.'),
(950,3,2,'I am pulling it.'),
(950,4,2,'This is why we can''t do anything.'),

-- 951 (26, neutral, 3) A quiet moment
(951,0,0,'It''s quiet tonight.'),
(951,1,1,'Too quiet.'),
(951,2,0,'You always say that.'),
(951,3,1,'Because it''s always too quiet.'),
(951,4,2,'It''s never too quiet.'),
(951,5,0,'It''s quiet right now.'),
(951,6,2,'...It''s a little quiet.'),

-- 952 (58, neutral, 3) Practical
(952,0,0,'We should follow the footprints.'),
(952,1,1,'They could be old.'),
(952,2,0,'They''re fresh.'),
(952,3,1,'How fresh?'),
(952,4,2,'They''re still filling with water.'),
(952,5,0,'Then we follow them fast.'),
(952,6,2,'We follow them fast.'),

-- 953 (18, neutral, 3) A story
(953,0,0,'I drank from that trough once.'),
(953,1,1,'And?'),
(953,2,0,'And I was sick for a week.'),
(953,3,1,'From the water?'),
(953,4,2,'From the water.'),
(953,5,0,'That''s a warning.'),
(953,6,2,'That''s the whole warning.'),

-- 954 (60, neutral, 4) An argument
(954,0,0,'We shouldn''t open the cabinets.'),
(954,1,1,'We came here for the cabinets.'),
(954,2,0,'We came here for the books.'),
(954,3,1,'The books are in the cabinets.'),
(954,4,2,'Some things shouldn''t be read.'),
(954,5,3,'Some things shouldn''t be left in a school full of corpses.'),
(954,6,0,'That''s fair.'),
(954,7,3,'That''s very fair.'),

-- 955 (60, neutral, 3) A quiet moment
(955,0,0,'I found a toy horse.'),
(955,1,1,'Where?'),
(955,2,0,'In the street.'),
(955,3,1,'Stratholme?'),
(955,4,2,'It was under a barricade.'),
(955,5,0,'What did you do with it?'),
(955,6,2,'I put it on the altar.'),
(955,7,0,'That''s good.'),
(955,8,2,'It''s all I could do.'),

-- 956 (60, neutral, 3) Practical
(956,0,0,'The seals are still intact.'),
(956,1,1,'Good.'),
(956,2,0,'We should leave them that way.'),
(956,3,1,'Agreed.'),
(956,4,2,'Then why are we here?'),
(956,5,0,'To make sure nobody else opens them.'),
(956,6,2,'That''s a good reason.'),

-- 957 (5, Horde, 3) A story
(957,0,0,'I saw a scarecrow move once.'),
(957,1,1,'Scarecrows don''t move.'),
(957,2,0,'It was the wind.'),
(957,3,1,'Then it didn''t move.'),
(957,4,2,'It moved enough.'),
(957,5,0,'That''s how the wind works.'),

-- 958 (30, neutral, 4) An argument
(958,0,0,'We should go around.'),
(958,1,1,'We should go through.'),
(958,2,0,'Through is faster.'),
(958,3,1,'Through is dangerous.'),
(958,4,2,'Around is also dangerous.'),
(958,5,3,'Everything is dangerous.'),
(958,6,0,'Then we go through.'),

-- 959 (5, neutral, 3) Practical
(959,0,0,'The axle is cracked.'),
(959,1,1,'How cracked?'),
(959,2,0,'Cracked enough.'),
(959,3,1,'That''s not a measurement.'),
(959,4,2,'It''s a measurement when you''re on the road.'),
(959,5,0,'That''s fair.'),
(959,6,2,'That''s how it works.'),

-- 960 (60, neutral, 3) A quiet moment
(960,0,0,'The chalk mark is still there.'),
(960,1,1,'It''s been weeks.'),
(960,2,0,'It''s still there.'),
(960,3,1,'Someone must have redrawn it.'),
(960,4,2,'Or nobody came this way.'),
(960,5,0,'That''s worse.'),
(960,6,2,'That''s much worse.'),

-- 961 (20, neutral, 2) Practical
(961,0,0,'We''re losing the light.'),
(961,1,1,'Then we make camp.'),
(961,2,0,'We''re not near water.'),
(961,3,1,'Then we go thirsty.'),
(961,4,0,'That''s a bad idea.'),
(961,5,1,'It''s the only idea.'),

-- 962 (32, neutral, 3) A story
(962,0,0,'I found a shield in that burrow.'),
(962,1,1,'Did you keep it?'),
(962,2,0,'I fixed the strap and left it.'),
(962,3,1,'Why?'),
(962,4,2,'Because it wasn''t mine.'),
(962,5,0,'That''s kind of you.'),
(962,6,2,'That''s how it works.'),

-- 963 (60, neutral, 3) Practical
(963,0,0,'The jar is cracked.'),
(963,1,1,'Then we don''t use it.'),
(963,2,0,'We need the water.'),
(963,3,1,'Then we drink it now.'),
(963,4,2,'That''s a good idea.'),
(963,5,0,'That''s the only idea.'),

-- 964 (28, neutral, 3) An argument
(964,0,0,'The label says camp four.'),
(964,1,1,'There is no camp four.'),
(964,2,0,'Then where does this go?'),
(964,3,1,'Camp three.'),
(964,4,2,'But the label says four.'),
(964,5,0,'Then it goes to camp three.'),
(964,6,2,'That''s how labels work.'),

-- 965 (26, neutral, 3) A quiet moment
(965,0,0,'The apples are still rolling.'),
(965,1,1,'Catch them.'),
(965,2,0,'I caught them.'),
(965,3,1,'Then why are they still rolling?'),
(965,4,2,'There are a lot of apples.'),

-- 966 (44, neutral, 3) Practical
(966,0,0,'The pot is cracked.'),
(966,1,1,'Then we leave it.'),
(966,2,0,'The next travelers will need it.'),
(966,3,1,'It''s cracked.'),
(966,4,2,'Then we leave it where they can find it.'),
(966,5,0,'That''s fair.'),

-- 967 (60, neutral, 4) An argument
(967,0,0,'We should have brought more jars.'),
(967,1,1,'We brought enough.'),
(967,2,0,'We didn''t bring enough.'),
(967,3,1,'We brought three.'),
(967,4,2,'We needed five.'),
(967,5,3,'We needed six.'),
(967,6,0,'Then next time we bring six.'),

-- 968 (40, neutral, 3) A quiet moment
(968,0,0,'The beach is different.'),
(968,1,1,'It''s the tide.'),
(968,2,0,'The markers moved.'),
(968,3,1,'The tide moved them.'),
(968,4,2,'Then the path is wrong.'),
(968,5,0,'Then we ask a fisher.'),
(968,6,2,'That''s the lesson.'),

-- 969 (46, neutral, 4) Practical
(969,0,0,'Tie the corners.'),
(969,1,1,'Which corners?'),
(969,2,0,'The ones that aren''t tied.'),
(969,3,1,'That''s all of them.'),
(969,4,2,'Then tie them all.'),
(969,5,3,'That''s a lot of corners.'),
(969,6,0,'That''s a lot of awning.'),

-- 970 (52, neutral, 3) An argument
(970,0,0,'We forgot the key again.'),
(970,1,1,'We didn''t forget it.'),
(970,2,0,'It''s on the other side of the door.'),
(970,3,1,'Then we get it back.'),
(970,4,2,'The door is locked.'),
(970,5,0,'Then we break the door.'),
(970,6,2,'Now you''re thinking.'),

-- 971 (60, neutral, 3) A quiet moment
(971,0,0,'The tents are still up.'),
(971,1,1,'They held the storm.'),
(971,2,0,'They held.'),
(971,3,1,'That''s a good sign.'),
(971,4,2,'That''s the first good sign all week.'),
(971,5,0,'Don''t jinx it.'),
(971,6,2,'I don''t believe in jinxes.'),
(971,7,0,'That''s how they get you.'),

-- 972 (56, neutral, 4) An argument
(972,0,0,'The step is cracked.'),
(972,1,1,'It''s held for years.'),
(972,2,0,'It''s cracked.'),
(972,3,2,'That''s not a guarantee.'),
(972,4,3,'Nothing is a guarantee.'),
(972,5,0,'Then we mark it.'),

-- 973 (16, Horde, 3) A story
(973,0,0,'The courier lost a boot in that rut.'),
(973,1,1,'You said that.'),
(973,2,0,'He lost the other one later.'),
(973,3,1,'How?'),
(973,4,2,'Different rut.'),
(973,5,0,'That''s a bad day.'),
(973,6,2,'That''s a very bad day.'),

-- 974 (24, neutral, 3) A quiet moment
(974,0,0,'The moss on this marker is fresh.'),
(974,1,1,'So it''s been moved.'),
(974,2,0,'Or it''s been raining.'),
(974,3,1,'It hasn''t rained.'),
(974,4,2,'Then it''s been moved.'),
(974,5,0,'By who?'),
(974,6,2,'By someone who didn''t want us to find the path.'),

-- 975 (60, neutral, 3) Practical
(975,0,0,'The ledger is soaked.'),
(975,1,1,'Then we dry it.'),
(975,2,0,'The pages are stuck.'),
(975,3,1,'Then we peel them apart.'),
(975,4,2,'That''s a slow job.'),
(975,5,0,'That''s the job we have.'),
(975,6,2,'That''s fair.'),

-- 976 (60, neutral, 3) A story
(976,0,0,'I found a toy horse in Stratholme.'),
(976,1,1,'You told me.'),
(976,2,0,'I dream about it.'),
(976,3,1,'About the horse?'),
(976,4,2,'About the child.'),
(976,5,0,'I''m sorry.'),
(976,6,2,'It''s the only thing I brought back.'),

-- 977 (42, neutral, 3) Practical
(977,0,0,'The sign is wrong.'),
(977,1,1,'Then we ignore the sign.'),
(977,2,0,'The sign is the only sign.'),
(977,3,1,'Then we fix the sign.'),
(977,4,2,'We don''t have tools.'),
(977,5,0,'Then we leave it wrong.'),
(977,6,2,'That''s how people die.'),

-- 978 (60, neutral, 3) A quiet moment
(978,0,0,'The jars are intact.'),
(978,1,1,'All of them?'),
(978,2,0,'All of them.'),
(978,3,1,'That''s a first.'),
(978,4,2,'That''s a very good first.'),
(978,5,0,'Don''t jinx it.'),
(978,6,2,'I told you I don''t believe in jinxes.'),

-- 979 (52, neutral, 3) An argument
(979,0,0,'It was a cooking pan.'),
(979,1,1,'It was a signal mirror.'),
(979,2,1,'It flashed.'),
(979,3,2,'Pans flash.'),
(979,4,0,'Then we were right not to answer.'),
(979,5,2,'Then we were right.'),

-- 980 (30, neutral, 4) A story
(980,0,0,'The parrot knew every complaint in the inn.'),
(980,1,1,'Every one?'),
(980,2,0,'Every one.'),
(980,3,1,'How?'),
(980,4,2,'The kitchen window.'),
(980,5,3,'That''s terrible.'),
(980,6,0,'It learned a nicer greeting after.'),
(980,7,3,'That''s something.'),

-- 981 (42, neutral, 3) Practical
(981,0,0,'The post is spinning.'),
(981,1,1,'Then set it straight.'),
(981,2,0,'The ground is soft.'),
(981,3,1,'Then pack it with stones.'),
(981,4,2,'That''s what we did last time.'),
(981,5,0,'Then it worked.'),
(981,6,2,'It worked for a month.'),

-- 982 (52, neutral, 2) A quiet moment
(982,0,0,'I found a waterskin on the road.'),
(982,1,1,'Whose?'),
(982,2,0,'No name.'),
(982,3,1,'Then leave it.'),
(982,4,0,'I gave it to the wagon crew.'),
(982,5,1,'That''s kind of you.'),
(982,6,0,'They needed water.'),

-- 983 (5, Horde, 4) An argument
(983,0,0,'The crows came back.'),
(983,1,1,'They always come back.'),
(983,2,0,'They avoided it for a morning.'),
(983,3,1,'A morning is not a day.'),
(983,4,2,'A morning is a lot.'),
(983,5,3,'A morning is a morning.'),
(983,6,0,'This is why we can''t have nice things.'),

-- 984 (40, neutral, 3) Practical
(984,0,0,'The marker is faded.'),
(984,1,1,'Then don''t rely on it.'),
(984,2,0,'Then how do we find the way?'),
(984,3,1,'We ask the archivist.'),
(984,4,2,'The archivist is three days away.'),
(984,5,0,'Then we guess.'),

-- 985 (38, neutral, 3) A story
(985,0,0,'The camels refused the short route.'),
(985,1,1,'Camels are stubborn.'),
(985,2,0,'Camels are smart.'),
(985,3,1,'That''s the same thing.'),
(985,4,2,'It really isn''t.'),
(985,5,0,'The long route had water.'),
(985,6,2,'The camels were right.'),

-- 986 (10, neutral, 3) A quiet moment
(986,0,0,'There are fish in the tide pool.'),
(986,1,1,'They''ll die when the tide goes out.'),
(986,2,0,'Then we carry water.'),
(986,3,1,'Buckets?'),
(986,4,2,'Buckets.'),
(986,5,0,'That''s a lot of trips.'),
(986,6,2,'That''s a lot of fish.'),

-- 987 (30, neutral, 2) Practical
(987,0,0,'The bird is listening.'),
(987,1,1,'It''s a bird.'),
(987,2,0,'It''s a bird that repeats things.'),
(987,3,1,'Then say something nice.'),
(987,4,0,'Something nice.'),

-- 988 (42, Horde, 1) Warsong comment
(988,0,0,'The outrider spat and called it a greeting.'),
(988,1,0,'I''ll take it.'),
(988,2,0,'In this forest, spit is honest.'),
(988,3,0,'Smiles are for towns that still have bakers.'),

-- 989 (12, Alliance, 2) A lesson
(989,0,0,'The bell rope is tangled again.'),
(989,1,1,'Then we untangle it.'),
(989,2,0,'It happens every week.'),
(989,3,1,'Then it happens every week.'),
(989,4,0,'That''s not a solution.'),
(989,5,1,'It''s the solution we have.'),

-- 990 (20, neutral, 3) Practical
(990,0,0,'The rope is frayed.'),
(990,1,1,'Then we don''t cross.'),
(990,2,0,'Then we don''t get across.'),
(990,3,1,'Then we wait.'),
(990,4,2,'Wait for what?'),
(990,5,0,'For the tide.'),
(990,6,2,'That''s a long wait.'),

-- 991 (56, neutral, 4) An argument
(991,0,0,'The harness is slipping.'),
(991,1,1,'Then tighten it.'),
(991,2,0,'I''m tightening it.'),
(991,3,1,'Tighten it more.'),
(991,4,2,'It''s as tight as it gets.'),
(991,5,3,'Then the strap is worn.'),
(991,6,0,'Then we replace the strap.'),

-- 992 (58, neutral, 4) A quiet moment
(992,0,0,'The bell rang on time.'),
(992,1,1,'For once.'),
(992,2,1,'Someone fixed the clapper.'),
(992,3,2,'Someone did.'),
(992,4,3,'That''s good.'),
(992,5,0,'That''s very good.'),

-- 993 (30, neutral, 3) A story
(993,0,0,'The pass was blocked by a pine.'),
(993,1,1,'Then we went around.'),
(993,2,0,'There was no around.'),
(993,3,1,'Then we went through.'),
(993,4,2,'It took a day.'),
(993,5,0,'That''s not bad.'),
(993,6,2,'It took a very long day.'),

-- 994 (40, neutral, 3) Practical
(994,0,0,'The wagon is buried.'),
(994,1,1,'How buried?'),
(994,2,0,'To the axle.'),
(994,3,1,'Then we dig.'),
(994,4,2,'With what?'),
(994,5,0,'With boards.'),
(994,6,2,'Boards aren''t shovels.'),
(994,7,0,'Boards are shovels when you''re desperate.'),

-- 995 (24, Alliance, 2) A quiet moment
(995,0,0,'The prisoner was lying.'),
(995,1,1,'How do you know?'),
(995,2,0,'He said he knew every guard by name.'),
(995,3,1,'And?'),
(995,4,0,'There are two hundred guards.'),
(995,5,1,'That''s a lot of names.'),

-- 996 (24, neutral, 2) Practical
(996,0,0,'The marker is under moss.'),
(996,1,1,'Then scrape it off.'),
(996,2,0,'It''s old moss.'),
(996,3,1,'Then scrape carefully.'),
(996,4,0,'I am scraping carefully.'),
(996,5,1,'Then keep scraping.'),

-- 997 (36, neutral, 3) A story
(997,0,0,'There was a lantern in the marsh.'),
(997,1,1,'A lantern?'),
(997,2,0,'On a fishing line.'),
(997,3,1,'Why?'),
(997,4,2,'To keep the fisher awake.'),
(997,5,0,'That''s clever.'),
(997,6,2,'That''s how it works.'),

-- 998 (20, neutral, 3) Practical
(998,0,0,'The latch is open.'),
(998,1,1,'Then close it.'),
(998,2,0,'I''m closing it.'),
(998,3,1,'Close it before the lift moves.'),
(998,4,2,'The lift is moving.'),
(998,5,0,'I closed it.'),
(998,6,2,'Good.'),

-- 999 (12, Alliance, 3) A lesson
(999,0,0,'The net is caught on the rocks.'),
(999,1,1,'Then pull it free.'),
(999,2,0,'The current is strong.'),
(999,3,1,'Then pull from upriver.'),
(999,4,2,'That''s clever.'),
(999,5,0,'That''s how my father did it.'),
(999,6,2,'Then your father was clever.'),

-- 1000 (22, Alliance, 2) Light's Hope paladins
(1000,0,0,'There are more paladins at Light''s Hope than beds.'),
(1000,1,1,'They sleep in their armor.'),
(1000,2,0,'That can''t be comfortable.'),
(1000,3,1,'Comfort isn''t the doctrine.');
