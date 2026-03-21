-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: db
-- Generation Time: Mar 21, 2026 at 03:08 PM
-- Server version: 8.4.8
-- PHP Version: 8.3.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `smart_campus`
--

-- --------------------------------------------------------

--
-- Table structure for table `academic_rules`
--

CREATE TABLE `academic_rules` (
  `id` int NOT NULL,
  `rule_name` varchar(100) NOT NULL,
  `value_days` int NOT NULL,
  `description` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `academic_rules`
--

INSERT INTO `academic_rules` (`id`, `rule_name`, `value_days`, `description`) VALUES
(1, 'Study Weeks', 14, '2 Week of study week before exams starting'),
(2, 'Examination Period', 14, '2 week of examination week'),
(3, 'Late Policy', 15, 'unit: minute'),
(4, 'Maximum Booking Duration', 2, 'A student can book a facility for maximum 2 hours per session'),
(5, 'Buffer Time', 15, 'The transition time between two different class sessions'),
(6, 'Advance Booking Limit', 3, 'Day in advance a facility can be reserved'),
(7, 'Mid-Semester Break', 7, '1 week of mid-semester break');

-- --------------------------------------------------------

--
-- Table structure for table `academic_term`
--

CREATE TABLE `academic_term` (
  `term_id` int NOT NULL,
  `intake_code` varchar(25) NOT NULL,
  `current_semester` smallint UNSIGNED NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `course_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `academic_term`
--

INSERT INTO `academic_term` (`term_id`, `intake_code`, `current_semester`, `is_active`, `start_date`, `end_date`, `course_id`) VALUES
(1, 'F-ICT-GEN-202601', 1, 1, '2026-01-05', '2026-04-27', 1),
(2, 'D-ICT-SE-202601', 1, 1, '2026-01-05', '2026-05-11', 4),
(3, 'B-CS-AI-202601', 1, 1, '2026-01-05', '2026-05-11', 2),
(4, 'B-CS-CYB-202601', 1, 1, '2026-01-05', '2026-05-11', 3);

-- --------------------------------------------------------

--
-- Table structure for table `admin_profiles`
--

CREATE TABLE `admin_profiles` (
  `id` int NOT NULL,
  `ad_id` varchar(12) NOT NULL,
  `user_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `admin_profiles`
--

INSERT INTO `admin_profiles` (`id`, `ad_id`, `user_id`) VALUES
(1, 'AD262069', 1),
(5, 'AD264013', 42),
(6, 'AD263133', 43),
(7, 'AD266020', 44);

-- --------------------------------------------------------

--
-- Table structure for table `auth_group`
--

CREATE TABLE `auth_group` (
  `id` int NOT NULL,
  `name` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `auth_group`
--

INSERT INTO `auth_group` (`id`, `name`) VALUES
(1, 'admin'),
(2, 'lecturer'),
(3, 'student');

-- --------------------------------------------------------

--
-- Table structure for table `auth_group_permissions`
--

CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_permission`
--

CREATE TABLE `auth_permission` (
  `id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `auth_permission`
--

INSERT INTO `auth_permission` (`id`, `name`, `content_type_id`, `codename`) VALUES
(1, 'Can add log entry', 1, 'add_logentry'),
(2, 'Can change log entry', 1, 'change_logentry'),
(3, 'Can delete log entry', 1, 'delete_logentry'),
(4, 'Can view log entry', 1, 'view_logentry'),
(5, 'Can add permission', 3, 'add_permission'),
(6, 'Can change permission', 3, 'change_permission'),
(7, 'Can delete permission', 3, 'delete_permission'),
(8, 'Can view permission', 3, 'view_permission'),
(9, 'Can add group', 2, 'add_group'),
(10, 'Can change group', 2, 'change_group'),
(11, 'Can delete group', 2, 'delete_group'),
(12, 'Can view group', 2, 'view_group'),
(13, 'Can add user', 4, 'add_user'),
(14, 'Can change user', 4, 'change_user'),
(15, 'Can delete user', 4, 'delete_user'),
(16, 'Can view user', 4, 'view_user'),
(17, 'Can add content type', 5, 'add_contenttype'),
(18, 'Can change content type', 5, 'change_contenttype'),
(19, 'Can delete content type', 5, 'delete_contenttype'),
(20, 'Can view content type', 5, 'view_contenttype'),
(21, 'Can add session', 6, 'add_session'),
(22, 'Can change session', 6, 'change_session'),
(23, 'Can delete session', 6, 'delete_session'),
(24, 'Can view session', 6, 'view_session'),
(25, 'Can add academic_rules', 7, 'add_academic_rules'),
(26, 'Can change academic_rules', 7, 'change_academic_rules'),
(27, 'Can delete academic_rules', 7, 'delete_academic_rules'),
(28, 'Can view academic_rules', 7, 'view_academic_rules'),
(29, 'Can add course', 10, 'add_course'),
(30, 'Can change course', 10, 'change_course'),
(31, 'Can delete course', 10, 'delete_course'),
(32, 'Can view course', 10, 'view_course'),
(33, 'Can add departments', 13, 'add_departments'),
(34, 'Can change departments', 13, 'change_departments'),
(35, 'Can delete departments', 13, 'delete_departments'),
(36, 'Can view departments', 13, 'view_departments'),
(37, 'Can add facilities', 14, 'add_facilities'),
(38, 'Can change facilities', 14, 'change_facilities'),
(39, 'Can delete facilities', 14, 'delete_facilities'),
(40, 'Can view facilities', 14, 'view_facilities'),
(41, 'Can add subject', 20, 'add_subject'),
(42, 'Can change subject', 20, 'change_subject'),
(43, 'Can delete subject', 20, 'delete_subject'),
(44, 'Can view subject', 20, 'view_subject'),
(45, 'Can add academic_term', 8, 'add_academic_term'),
(46, 'Can change academic_term', 8, 'change_academic_term'),
(47, 'Can delete academic_term', 8, 'delete_academic_term'),
(48, 'Can view academic_term', 8, 'view_academic_term'),
(49, 'Can add course_enrollment', 11, 'add_course_enrollment'),
(50, 'Can change course_enrollment', 11, 'change_course_enrollment'),
(51, 'Can delete course_enrollment', 11, 'delete_course_enrollment'),
(52, 'Can view course_enrollment', 11, 'view_course_enrollment'),
(53, 'Can add lecturer_profiles', 15, 'add_lecturer_profiles'),
(54, 'Can change lecturer_profiles', 15, 'change_lecturer_profiles'),
(55, 'Can delete lecturer_profiles', 15, 'delete_lecturer_profiles'),
(56, 'Can view lecturer_profiles', 15, 'view_lecturer_profiles'),
(57, 'Can add session', 19, 'add_session'),
(58, 'Can change session', 19, 'change_session'),
(59, 'Can delete session', 19, 'delete_session'),
(60, 'Can view session', 19, 'view_session'),
(61, 'Can add lecturer_subjects', 16, 'add_lecturer_subjects'),
(62, 'Can change lecturer_subjects', 16, 'change_lecturer_subjects'),
(63, 'Can delete lecturer_subjects', 16, 'delete_lecturer_subjects'),
(64, 'Can view lecturer_subjects', 16, 'view_lecturer_subjects'),
(65, 'Can add course_subject', 12, 'add_course_subject'),
(66, 'Can change course_subject', 12, 'change_course_subject'),
(67, 'Can delete course_subject', 12, 'delete_course_subject'),
(68, 'Can view course_subject', 12, 'view_course_subject'),
(69, 'Can add class_session', 9, 'add_class_session'),
(70, 'Can change class_session', 9, 'change_class_session'),
(71, 'Can delete class_session', 9, 'delete_class_session'),
(72, 'Can view class_session', 9, 'view_class_session'),
(73, 'Can add map node', 18, 'add_mapnode'),
(74, 'Can change map node', 18, 'change_mapnode'),
(75, 'Can delete map node', 18, 'delete_mapnode'),
(76, 'Can view map node', 18, 'view_mapnode'),
(77, 'Can add map edge', 17, 'add_mapedge'),
(78, 'Can change map edge', 17, 'change_mapedge'),
(79, 'Can delete map edge', 17, 'delete_mapedge'),
(80, 'Can view map edge', 17, 'view_mapedge'),
(81, 'Can add admin_profiles', 21, 'add_admin_profiles'),
(82, 'Can change admin_profiles', 21, 'change_admin_profiles'),
(83, 'Can delete admin_profiles', 21, 'delete_admin_profiles'),
(84, 'Can view admin_profiles', 21, 'view_admin_profiles'),
(85, 'Can add student_profiles', 22, 'add_student_profiles'),
(86, 'Can change student_profiles', 22, 'change_student_profiles'),
(87, 'Can delete student_profiles', 22, 'delete_student_profiles'),
(88, 'Can view student_profiles', 22, 'view_student_profiles'),
(89, 'Can add attendance session', 24, 'add_attendancesession'),
(90, 'Can change attendance session', 24, 'change_attendancesession'),
(91, 'Can delete attendance session', 24, 'delete_attendancesession'),
(92, 'Can view attendance session', 24, 'view_attendancesession'),
(93, 'Can add attendance mark', 23, 'add_attendancemark'),
(94, 'Can change attendance mark', 23, 'change_attendancemark'),
(95, 'Can delete attendance mark', 23, 'delete_attendancemark'),
(96, 'Can view attendance mark', 23, 'view_attendancemark'),
(97, 'Can add attachments', 25, 'add_attachments'),
(98, 'Can change attachments', 25, 'change_attachments'),
(99, 'Can delete attachments', 25, 'delete_attachments'),
(100, 'Can view attachments', 25, 'view_attachments'),
(101, 'Can add faq', 26, 'add_faq'),
(102, 'Can change faq', 26, 'change_faq'),
(103, 'Can delete faq', 26, 'delete_faq'),
(104, 'Can view faq', 26, 'view_faq'),
(105, 'Can add faq reaction', 27, 'add_faqreaction'),
(106, 'Can change faq reaction', 27, 'change_faqreaction'),
(107, 'Can delete faq reaction', 27, 'delete_faqreaction'),
(108, 'Can view faq reaction', 27, 'view_faqreaction'),
(109, 'Can add canned response', 29, 'add_cannedresponse'),
(110, 'Can change canned response', 29, 'change_cannedresponse'),
(111, 'Can delete canned response', 29, 'delete_cannedresponse'),
(112, 'Can view canned response', 29, 'view_cannedresponse'),
(113, 'Can add booking', 28, 'add_booking'),
(114, 'Can change booking', 28, 'change_booking'),
(115, 'Can delete booking', 28, 'delete_booking'),
(116, 'Can view booking', 28, 'view_booking'),
(117, 'Can add ticket message', 31, 'add_ticketmessage'),
(118, 'Can change ticket message', 31, 'change_ticketmessage'),
(119, 'Can delete ticket message', 31, 'delete_ticketmessage'),
(120, 'Can view ticket message', 31, 'view_ticketmessage'),
(121, 'Can add support ticket', 30, 'add_supportticket'),
(122, 'Can change support ticket', 30, 'change_supportticket'),
(123, 'Can delete support ticket', 30, 'delete_supportticket'),
(124, 'Can view support ticket', 30, 'view_supportticket'),
(125, 'Can add timetable_preference', 34, 'add_timetable_preference'),
(126, 'Can change timetable_preference', 34, 'change_timetable_preference'),
(127, 'Can delete timetable_preference', 34, 'delete_timetable_preference'),
(128, 'Can view timetable_preference', 34, 'view_timetable_preference'),
(129, 'Can add lecturer_assignment', 32, 'add_lecturer_assignment'),
(130, 'Can change lecturer_assignment', 32, 'change_lecturer_assignment'),
(131, 'Can delete lecturer_assignment', 32, 'delete_lecturer_assignment'),
(132, 'Can view lecturer_assignment', 32, 'view_lecturer_assignment'),
(133, 'Can add skipped_date', 33, 'add_skipped_date'),
(134, 'Can change skipped_date', 33, 'change_skipped_date'),
(135, 'Can delete skipped_date', 33, 'delete_skipped_date'),
(136, 'Can view skipped_date', 33, 'view_skipped_date'),
(137, 'Can add ticket activity', 35, 'add_ticketactivity'),
(138, 'Can change ticket activity', 35, 'change_ticketactivity'),
(139, 'Can delete ticket activity', 35, 'delete_ticketactivity'),
(140, 'Can view ticket activity', 35, 'view_ticketactivity'),
(141, 'Can add announcement', 36, 'add_announcement'),
(142, 'Can change announcement', 36, 'change_announcement'),
(143, 'Can delete announcement', 36, 'delete_announcement'),
(144, 'Can view announcement', 36, 'view_announcement'),
(145, 'Can add announcement target', 37, 'add_announcementtarget'),
(146, 'Can change announcement target', 37, 'change_announcementtarget'),
(147, 'Can delete announcement target', 37, 'delete_announcementtarget'),
(148, 'Can view announcement target', 37, 'view_announcementtarget'),
(149, 'Can add subject component', 38, 'add_subjectcomponent'),
(150, 'Can change subject component', 38, 'change_subjectcomponent'),
(151, 'Can delete subject component', 38, 'delete_subjectcomponent'),
(152, 'Can view subject component', 38, 'view_subjectcomponent');

-- --------------------------------------------------------

--
-- Table structure for table `auth_user`
--

CREATE TABLE `auth_user` (
  `id` int NOT NULL,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `auth_user`
--

INSERT INTO `auth_user` (`id`, `password`, `last_login`, `is_superuser`, `username`, `first_name`, `last_name`, `email`, `is_staff`, `is_active`, `date_joined`) VALUES
(1, 'pbkdf2_sha256$1200000$ZgIbRoHmmBmVAfw6p3BEeB$eMGNFxeWZUz/MiOV7d1WeATz4q/Rrq5gaS2lIF80dUA=', '2026-03-21 08:44:02.744852', 1, 'limjunhong1015@gmail.com', 'Lim', 'Jun Hong', 'limjunhong1015@gmail.com', 1, 1, '2026-02-26 11:30:16.196969'),
(18, 'pbkdf2_sha256$1200000$Jys4B4WnS6Y77PYnj420fW$tPY6U2PF03NNZQNsw5ckwdeFj+qfVYvLVOjHsmtcnFA=', '2026-03-14 16:08:19.733209', 0, 'mokyusheng@gmail.com', 'Mok', 'Yu Sheng', 'mokyusheng@gmail.com', 1, 1, '2026-03-01 17:06:16.433234'),
(19, 'pbkdf2_sha256$1200000$FHRt0htUwRbwCLQ4fT38uT$QFjmLyJ4q18hLmP7VLchgNwmL57O+yiu+k7H75gRdWE=', '2026-03-20 08:52:29.612095', 0, 'ljack7599@gmail.com', 'Lee', 'Zhen Sheng', 'ljack7599@gmail.com', 0, 1, '2026-03-01 17:13:09.153354'),
(20, 'pbkdf2_sha256$1200000$cNMpCmuRr6d7O2xvLNKH39$gmTeHGRqa5VKP8cYfWKJnzh1y1P1p1uxaqnxaFOOah4=', NULL, 0, 'siti.aminah@gmail.com', 'Siti', 'Aminah', 'siti.aminah@gmail.com', 1, 1, '2026-03-18 06:25:55.892045'),
(21, 'pbkdf2_sha256$1200000$mWqGAd6zErZh3s0VQq9rbF$4Jp+nXX5JMCBYknzPJXPKY63uor0PX92NyjDJk9YHZY=', NULL, 0, 'ravi.s@gmail.com', 'Ravi', 'Subramaniam', 'ravi.s@gmail.com', 1, 1, '2026-03-18 06:25:55.942416'),
(22, 'pbkdf2_sha256$1200000$st5seVLsMgg2l9U2dXSnL7$5feWVmVCJBSE04+tlcJoTBQ5TuAOi+gPEs8xjXCkHhI=', '2026-03-18 07:19:57.988182', 0, 'mei.ling@gmail.com', 'Mei', 'Ling', 'mei.ling@gmail.com', 1, 1, '2026-03-18 06:56:23.606061'),
(23, 'pbkdf2_sha256$1200000$er0xYlsBw1M9ifgvBOferi$Lx3A/ma0EFuntm7WDIYcm0wRppgmr0J6rU40/LihFwg=', '2026-03-18 07:20:10.168457', 0, 'ahmad.f@gmail.com', 'Ahmad', 'Fadzil', 'ahmad.f@gmail.com', 1, 1, '2026-03-18 06:56:23.632064'),
(24, 'pbkdf2_sha256$1200000$DryeY7sxwqaW7GHQWPvT8Z$AXnHiA3UqtgKs1h+Oy6+U/PGiqj8+M3TO5AKGehEh+c=', '2026-03-18 07:32:25.006948', 0, 'priyanka.d@gmail.com', 'Priyanka', 'Devi', 'priyanka.d@gmail.com', 1, 1, '2026-03-18 06:56:23.642443'),
(25, 'pbkdf2_sha256$1200000$h6natAm7NKThhzmLKNqrG6$4F8rDpzALZKKyVW4i0Kp7dVx7VAHO09FbRw1glkVbwk=', '2026-03-18 07:32:34.084669', 0, 'wei.kang@gmail.com', 'Wei', 'Kang', 'wei.kang@gmail.com', 1, 1, '2026-03-18 06:56:23.652813'),
(26, 'pbkdf2_sha256$1200000$uWUJaCGPj7a68hHKTOwJDI$/FNmmbM24m39FnhP+pggP+ytsmPm9yRxGYOgrsaVr4E=', '2026-03-18 07:32:44.680188', 0, 'nurul.izzah@gmail.com', 'Nurul', 'Izzah', 'nurul.izzah@gmail.com', 1, 1, '2026-03-18 06:56:23.665473'),
(27, 'pbkdf2_sha256$1200000$2J4BQ8QWkrv2X7jS13BV8a$5ah5aootUAKugPoIas4Yz+dlmqh2Q7gAlPzOB3w701E=', '2026-03-18 07:32:56.988629', 0, 'sanjay.k@gmail.com', 'Sanjay', 'Kumar', 'sanjay.k@gmail.com', 1, 1, '2026-03-18 06:56:23.676120'),
(28, 'pbkdf2_sha256$1200000$EVdSE1Uq2QQRGT1f580OSL$ZE71wIT4Qj7P1hFCnWiVe7mlKdIJYJ3MV91TujJiWcY=', NULL, 0, 'zhi.hao@gmail.com', 'Zhi', 'Hao', 'zhi.hao@gmail.com', 1, 1, '2026-03-18 06:56:23.685893'),
(29, 'pbkdf2_sha256$1200000$DELLJU2ziElJf9Xvu5AEQT$zpGt0jOs3g0KQ6/iDRfSLx7r0ocRA1RFLBUQlHpmhYU=', NULL, 0, 'tamsergefrank@gmail.com', 'Tam', 'Serge Frank', 'tamsergefrank@gmail.com', 1, 1, '2026-03-18 06:56:23.697778'),
(30, 'pbkdf2_sha256$1200000$iCpf6255fdhQtCUR3Jyxn5$lFSOvIlbsrXFIqXc2djcpEbDKu/L9KIo39KiEdkzBMg=', NULL, 0, 'siti.z@gmail.com', 'Siti', 'Zubaidah', 'siti.z@gmail.com', 1, 1, '2026-03-18 06:56:23.708707'),
(31, 'pbkdf2_sha256$1200000$c1clDq00VuK1SQipx9WGa5$3KyH2MxcZOAfwLYQUpViurhyvVfnOKqID9Eqvgvjv48=', NULL, 0, 'kenji.t@gmail.com', 'Kenji', 'Tanaka', 'kenji.t@gmail.com', 1, 1, '2026-03-18 06:56:23.720983'),
(32, 'pbkdf2_sha256$1200000$pt7FNNkQBiK4P3ZegQbF7a$MzlbSbI4rK951rg6FRROnvBlIqi9WfDpINF36AYZA0c=', NULL, 0, 'liam.o@gmail.com', 'Liam', 'O\'Sullivan', 'liam.o@gmail.com', 1, 1, '2026-03-18 06:56:23.734643'),
(33, 'pbkdf2_sha256$1200000$uIZDIQ58hDOensY9a2aSFK$357daxaY3irKODOA8jGCtI7ZRe7DS43vfQxVIWMq7E8=', NULL, 0, 'xavier.d@gmail.com', 'Xavier', 'Deschamps', 'xavier.d@gmail.com', 1, 1, '2026-03-18 06:56:23.748644'),
(34, 'pbkdf2_sha256$1200000$CpHlju4cxGBHeGRSKcpgm3$Iv5uxnu7TDVfPy3ZH9xYpUhvdbPqzjDscVRt6ZrHiW4=', NULL, 0, 'thanh.n@gmail.com', 'Thanh', 'Nguyen', 'thanh.n@gmail.com', 1, 1, '2026-03-18 06:56:23.763979'),
(35, 'pbkdf2_sha256$1200000$Hj4NOfQb98ahp14WK7stFM$eS1BRh/MYTGhnsH6VjUZ1VodJAZVJGxSP+Da4M2bPj4=', NULL, 0, 'elena.p@gmail.com', 'Elena', 'Petrova', 'elena.p@gmail.com', 1, 1, '2026-03-18 06:56:23.784377'),
(36, 'pbkdf2_sha256$1200000$i5yWrAMTk7IQAExsdg2BRH$9gff7EqbdqM79x51ge/W+CsP/bqNGIEUfEyKeWM2qf0=', NULL, 0, 'hans.m@gmail.com', 'Hans', 'Müller', 'hans.m@gmail.com', 1, 1, '2026-03-18 06:56:23.801585'),
(37, 'pbkdf2_sha256$1200000$hslUN1Yq2xl3Rmi8p8f3mg$c4UJKLOdPARhj3bAZ0EDTkX92iv63ynzUchPotwrz2Y=', NULL, 0, 'arjun.m@gmail.com', 'Arjun', 'Malhotra', 'arjun.m@gmail.com', 1, 1, '2026-03-18 06:56:23.816574'),
(38, 'pbkdf2_sha256$1200000$9aKczMiAYolKPU4MRKJxS9$cy+DqMZ221fkpXcmXgYZUeHYq/2exdsOOYW1lQ0huZ8=', NULL, 0, 'farrah.z@gmail.com', 'Farrah', 'Zulkifli', 'farrah.z@gmail.com', 1, 1, '2026-03-18 06:56:23.832498'),
(39, 'pbkdf2_sha256$1200000$WWlQokPSlmpwdRWVfl7ZVn$OqjzZT8DQbLX9//91Jv+3Z79vf1Psx0BSfTwpMoJbpI=', NULL, 0, 'ming.zhe@gmail.com', 'Ming', 'Zhe', 'ming.zhe@gmail.com', 1, 1, '2026-03-18 06:56:23.847038'),
(40, 'pbkdf2_sha256$1200000$j1wM21OzXyrQSAqzWy8pSz$PkmEXI3Lsy6o21bfZ8r24qfv5MwMgM9bsUYT+HgPPt8=', NULL, 0, 's.connor@gmail.com', 'Sarah', 'Connor', 's.connor@gmail.com', 1, 1, '2026-03-18 06:56:23.862248'),
(42, 'pbkdf2_sha256$1200000$aMCyY8W6vzyaR9bqH7WiWt$ZLWfICef1cjtb15I9Zr/Yw3yGDx/vdjVJqb4f/DHZmk=', NULL, 0, 'aidenlee@admin.campus.edu', 'Aiden', 'Lee', 'aidenlee@admin.campus.edu', 1, 1, '2026-03-18 17:01:35.761640'),
(43, 'pbkdf2_sha256$1200000$hx48aZkm1zXRRJPOgdiiyA$AdTVah0fZCEl9RY8+VBgMCh4K3FimnC5O4yH28lCtkA=', NULL, 0, 'sofiamartinez@admin.campus.edu', 'Sofia', 'Martinez', 'sofiamartinez@admin.campus.edu', 1, 1, '2026-03-18 17:01:35.779778'),
(44, 'pbkdf2_sha256$1200000$6AFZy4CkbapHmHUXzPVeSZ$SwEmhWwl8Jyj7pGg06brTXeDi8GJmgYFSxXMXhGUgGY=', NULL, 0, 'rajpatel@admin.campus.edu', 'Raj', 'Patel', 'rajpatel@admin.campus.edu', 1, 1, '2026-03-18 17:01:35.790282'),
(45, 'pbkdf2_sha256$1200000$rVWDO6mTpreqIKxKrVt4Tl$0k4K3YoqFAUoYL4ZzYDa2UabC/sFYtFWH/SqryG9AxM=', NULL, 0, 'junhong@student.campus.edu', 'Jun', 'Hong', 'junhong@student.campus.edu', 0, 1, '2026-03-18 17:01:35.804906'),
(46, 'pbkdf2_sha256$1200000$X5rhzqoDKeGQU3DRC2d5PE$zchp2sNbZHfQK3OJM+ctqJQiNKgIa0oI0qyHIGitejw=', NULL, 0, 'weichen@student.campus.edu', 'Wei', 'Chen', 'weichen@student.campus.edu', 0, 1, '2026-03-18 17:01:35.826394'),
(47, 'pbkdf2_sha256$1200000$MzWajAVyKCTJ0mq5lw76AT$gW64WTZc0C58xQDU6RAq0gpQu3id4orBuXRXn9RYziY=', NULL, 0, 'amirhassan@student.campus.edu', 'Amir', 'Hassan', 'amirhassan@student.campus.edu', 0, 1, '2026-03-18 17:01:35.841749'),
(48, 'pbkdf2_sha256$1200000$EG4Nxlycg9CHNLzNPYg25T$Nuf+11YplnKb6ynaPoUUwcgsP+jz+YrJPCIRkqxV7vU=', NULL, 0, 'emilyjohnson@student.campus.edu', 'Emily', 'Johnson', 'emilyjohnson@student.campus.edu', 0, 1, '2026-03-18 17:01:35.853396'),
(49, 'pbkdf2_sha256$1200000$rUcAC6nuyZGn6plTJA2t2Q$TuJ20nae9x84dVJDz3+CWrBbMsn6m+QlkygiZphBgOQ=', NULL, 0, 'sitinurhaliza@student.campus.edu', 'Siti', 'Nurhaliza', 'sitinurhaliza@student.campus.edu', 0, 1, '2026-03-18 17:01:35.863282'),
(50, 'pbkdf2_sha256$1200000$JLliAPRqjEARcGQxif8ifS$pysy2Qafazfki53wlIgFt8ut1MDc2JtcE2Q1ASHMfNY=', NULL, 0, 'kenjitanaka@student.campus.edu', 'Kenji', 'Tanaka', 'kenjitanaka@student.campus.edu', 0, 1, '2026-03-18 17:01:35.875913'),
(51, 'pbkdf2_sha256$1200000$UgfUVMG4LatAY1H5RNxWvw$KeTT98vxfKWeQ/F/t8YEBte+fxTwy0QfjUfzO6NaCKA=', NULL, 0, 'davidsmith@student.campus.edu', 'David', 'Smith', 'davidsmith@student.campus.edu', 0, 1, '2026-03-18 17:01:35.890893'),
(52, 'pbkdf2_sha256$1200000$uE1xlpZoGfQFic1az1Oc0Z$4JhUKY+rWpckflqamW1vmm2Zl+WDFyaVIpSAaZKnU60=', NULL, 0, 'fatimakhan@student.campus.edu', 'Fatima', 'Khan', 'fatimakhan@student.campus.edu', 0, 1, '2026-03-18 17:01:35.905549'),
(53, 'pbkdf2_sha256$1200000$tyNvZ8OZoeKwLUEwpKEKJg$Re8vxCWaBIu3PIAQwb9Cs7JuLfdp4zz88LXWq0Y5HXU=', NULL, 0, 'lucassilva@student.campus.edu', 'Lucas', 'Silva', 'lucassilva@student.campus.edu', 0, 1, '2026-03-18 17:01:35.927513'),
(54, 'pbkdf2_sha256$1200000$YAtqSbXaAjGUdHETt5JFGd$lAM+veDHR7hmwJZVv7nUY/PI5lsZn9Ehctt/GbRnHLU=', NULL, 0, 'nguyenminh@student.campus.edu', 'Nguyen', 'Minh', 'nguyenminh@student.campus.edu', 0, 1, '2026-03-18 17:01:35.953324');

-- --------------------------------------------------------

--
-- Table structure for table `auth_user_groups`
--

CREATE TABLE `auth_user_groups` (
  `id` bigint NOT NULL,
  `user_id` int NOT NULL,
  `group_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `auth_user_groups`
--

INSERT INTO `auth_user_groups` (`id`, `user_id`, `group_id`) VALUES
(32, 1, 1),
(49, 18, 2),
(50, 19, 3),
(51, 20, 2),
(53, 21, 2),
(55, 22, 2),
(57, 23, 2),
(59, 24, 2),
(61, 25, 2),
(63, 26, 2),
(65, 27, 2),
(67, 28, 2),
(69, 29, 2),
(71, 30, 2),
(73, 31, 2),
(75, 32, 2),
(77, 33, 2),
(79, 34, 2),
(81, 35, 2),
(83, 36, 2),
(85, 37, 2),
(87, 38, 2),
(89, 39, 2),
(91, 40, 2),
(94, 42, 1),
(96, 43, 1),
(98, 44, 1),
(100, 45, 3),
(102, 46, 3),
(104, 47, 3),
(106, 48, 3),
(108, 49, 3),
(110, 50, 3),
(112, 51, 3),
(114, 52, 3),
(116, 53, 3),
(118, 54, 3);

-- --------------------------------------------------------

--
-- Table structure for table `auth_user_user_permissions`
--

CREATE TABLE `auth_user_user_permissions` (
  `id` bigint NOT NULL,
  `user_id` int NOT NULL,
  `permission_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `booking`
--

CREATE TABLE `booking` (
  `booking_id` int NOT NULL,
  `booking_date` date NOT NULL,
  `start_time` time(6) NOT NULL,
  `end_time` time(6) NOT NULL,
  `purpose` longtext,
  `status` varchar(20) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `user_id` int NOT NULL,
  `facility_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `booking`
--

INSERT INTO `booking` (`booking_id`, `booking_date`, `start_time`, `end_time`, `purpose`, `status`, `created_at`, `user_id`, `facility_id`) VALUES
(1, '2026-03-12', '10:00:00.000000', '12:30:00.000000', 'group discussion', 'Cancelled', '2026-03-11 09:55:10.061200', 19, 1),
(2, '2026-03-13', '09:30:00.000000', '13:30:00.000000', 'Lab exercise', 'Cancelled', '2026-03-12 07:17:30.871436', 19, 2),
(3, '2026-03-18', '08:30:00.000000', '16:40:00.000000', 'Event', 'Rejected', '2026-03-12 08:40:10.135065', 19, 3),
(4, '2026-03-17', '06:40:00.000000', '20:40:00.000000', 'Lab exercise', 'Cancelled', '2026-03-13 08:38:14.527479', 19, 2),
(5, '2026-03-19', '07:45:00.000000', '09:45:00.000000', 'group discussion', 'Cancelled', '2026-03-13 08:45:14.269170', 19, 1),
(6, '2026-03-23', '07:20:00.000000', '21:20:00.000000', 'group discussion', 'Cancelled', '2026-03-13 09:18:04.149366', 19, 1),
(7, '2026-03-15', '05:20:00.000000', '07:20:00.000000', 'group discussion', 'Cancelled', '2026-03-13 09:19:47.686106', 19, 1),
(8, '2026-03-15', '15:15:00.000000', '17:15:00.000000', '', 'Rejected', '2026-03-13 09:59:21.045067', 19, 1),
(9, '2026-03-20', '10:30:00.000000', '12:30:00.000000', 'group discussion', 'Approved', '2026-03-17 13:24:45.366065', 19, 1),
(10, '2026-03-20', '13:00:00.000000', '15:20:00.000000', 'group discussion', 'Approved', '2026-03-17 15:16:26.652696', 19, 1);

-- --------------------------------------------------------

--
-- Table structure for table `campus_announcement`
--

CREATE TABLE `campus_announcement` (
  `announcement_id` int NOT NULL,
  `subject` varchar(255) NOT NULL,
  `content` longtext NOT NULL,
  `date_published` datetime(6) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `announcement_type` varchar(10) NOT NULL,
  `author_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `campus_announcement`
--

INSERT INTO `campus_announcement` (`announcement_id`, `subject`, `content`, `date_published`, `is_active`, `announcement_type`, `author_id`) VALUES
(4, 'Greeting hari raya', 'Selamat Hari Raya Aidilfitri to all our staff and students—wishing you a joyous celebration filled with peace, prosperity, and cherished moments with loved ones!', '2026-03-19 18:19:26.507843', 1, 'BANNER', 1),
(5, 'Student View only', 'New Feature Alert: Explore the campus like never before with our interactive Navigation Map! Find your way to lecture halls, cafes, and labs directly from your Student Dashboard. Try it now!', '2026-03-20 08:51:47.788977', 1, 'BANNER', 1),
(7, 'Only Visitor View', 'Welcome To APU Smart Campus Management System. Visit Us at Our Open Day! 28–29 Mar & 4–5 Apr 2026', '2026-03-20 09:15:03.161020', 1, 'BANNER', 1),
(10, 'Selamat Hari Raya Aidilfitri: Campus Holiday Notice', '<p>Dear Staff and Students,</p><p>In celebration of the upcoming <strong>Hari Raya Aidilfitri</strong>, please be informed that the campus will be closed for the festive break.</p><ol><li data-list=\"bullet\"><span class=\"ql-ui\" contenteditable=\"false\"></span><strong>Holiday Start</strong>: Friday, 20th March 2026</li><li data-list=\"bullet\"><span class=\"ql-ui\" contenteditable=\"false\"></span><strong>Campus Reopens</strong>: Wednesday, 25th March 2026</li></ol><p>All classes and administrative operations will be suspended during this period. We encourage everyone to take this time to rest, celebrate with loved ones, and stay safe.</p><p>To those traveling back to their hometowns, we wish you a safe journey (<em>Balik Kampung</em>). To all our Muslim friends and colleagues, <strong>Selamat Hari Raya Aidilfitri, Maaf Zahir dan Batin.</strong></p><p><br></p><p>Warm regards, </p><p><strong>Campus Administration</strong></p>', '2026-03-20 13:07:02.860193', 1, 'NORMAL', 1),
(11, 'This is announcement.', '<p>This is announcements. Lorem ipsum dolor, sit amet consectetur adipisicing elit. Eligendi quisquam iste accusamus consectetur aspernatur hic, aliquid modi nihil veniam corrupti fugiat, molestias, eum harum. Cupiditate, ipsam quibusdam! Eius aut temporibus officiis nesciunt, quaerat voluptate. Totam, facilis dolor ipsam aliquam, nemo dolores animi repudiandae minus reiciendis asperiores dolore, in voluptatum?</p><p><br></p><p>Pariatur, consectetur excepturi cum blanditiis recusandae consequuntur. Soluta blanditiis cupiditate facilis iste provident sed veritatis natus ad, nesciunt architecto rerum eligendi maxime porro ipsa reiciendis vero minima.</p><p><br></p><p>A consequatur placeat minima ex, facilis quasi veniam odio laboriosam magni et similique necessitatibus itaque nesciunt, aliquam asperiores reiciendis eveniet atque iure ducimus laudantium quia ratione maxime deserunt accusantium. Earum obcaecati modi labore beatae incidunt vel, quaerat veniam, sed totam, pariatur ea animi saepe ratione explicabo debitis blanditiis! Deleniti, mollitia ea harum corrupti obcaecati, voluptates magnam odio neque distinctio quam dicta provident beatae, sunt suscipit! Necessitatibus ad nemo dolore culpa iste ea est odio illum facere quia quidem similique rerum temporibus ipsam doloribus, illo excepturi sequi dolores voluptatem aliquam itaque repellendus repudiandae. Maiores quidem blanditiis consequatur unde deserunt hic enim illum corrupti similique. Iure quam odio hic tenetur quibusdam iste facilis quisquam illum quaerat? Sint assumenda perferendis obcaecati autem facilis, dolores praesentium velit exercitationem?</p>', '2026-03-20 13:28:36.626470', 1, 'NORMAL', 1);

-- --------------------------------------------------------

--
-- Table structure for table `campus_announcementTarget`
--

CREATE TABLE `campus_announcementTarget` (
  `target_id` int NOT NULL,
  `is_for_students` tinyint(1) NOT NULL,
  `is_for_lecturer` tinyint(1) NOT NULL,
  `is_for_admins` tinyint(1) NOT NULL,
  `is_visitor_visible` tinyint(1) NOT NULL,
  `academic_term` varchar(50) DEFAULT NULL,
  `announcement_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `campus_announcementTarget`
--

INSERT INTO `campus_announcementTarget` (`target_id`, `is_for_students`, `is_for_lecturer`, `is_for_admins`, `is_visitor_visible`, `academic_term`, `announcement_id`) VALUES
(4, 1, 1, 1, 0, NULL, 4),
(5, 1, 0, 0, 0, NULL, 5),
(7, 0, 0, 0, 1, '', 7),
(10, 1, 1, 1, 1, NULL, 10),
(11, 1, 1, 1, 1, NULL, 11);

-- --------------------------------------------------------

--
-- Table structure for table `campus_attachments`
--

CREATE TABLE `campus_attachments` (
  `id` int NOT NULL,
  `object_id` int UNSIGNED NOT NULL,
  `file` varchar(100) NOT NULL,
  `uploaded_at` datetime(6) NOT NULL,
  `content_type_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `campus_attachments`
--

INSERT INTO `campus_attachments` (`id`, `object_id`, `file`, `uploaded_at`, `content_type_id`) VALUES
(1, 5, 'attachments/faq_5_688b3fae.jpeg', '2026-03-08 06:18:32.637793', 26),
(2, 14, 'attachments/faq_14_c32a7302.png', '2026-03-09 14:48:57.812824', 26),
(3, 1, 'attachments/supportticket_1_20260312093214.jpeg', '2026-03-12 09:32:14.444013', 30),
(4, 2, 'attachments/supportticket_2_20260312155655.jpeg', '2026-03-12 15:56:55.380711', 30),
(17, 32, 'attachments/ticketmessage_32_20260313125547.docx', '2026-03-13 12:55:47.864755', 31),
(18, 42, 'attachments/ticketmessage_42_20260317094659.docx', '2026-03-17 09:46:59.106357', 31),
(19, 42, 'attachments/ticketmessage_42_20260317094659.png', '2026-03-17 09:46:59.130728', 31),
(20, 9, 'attachments/announcement_9_20260320130434.png', '2026-03-20 13:04:34.169880', 36),
(21, 10, 'attachments/announcement_10_20260320130702.png', '2026-03-20 13:07:02.906662', 36),
(22, 11, 'attachments/announcement_11_20260320132836.jpg', '2026-03-20 13:28:36.675551', 36),
(23, 11, 'attachments/announcement_11_20260320132836_M6yM63J.jpg', '2026-03-20 13:28:36.721226', 36),
(24, 11, 'attachments/announcement_11_20260320132836_HwNczdx.jpg', '2026-03-20 13:28:36.770102', 36),
(25, 11, 'attachments/announcement_11_20260320132836_RweQ8zl.jpg', '2026-03-20 13:28:36.826362', 36),
(26, 11, 'attachments/announcement_11_20260320132836_Vwdgu7F.jpg', '2026-03-20 13:28:36.882662', 36);

-- --------------------------------------------------------

--
-- Table structure for table `campus_attendanceMark`
--

CREATE TABLE `campus_attendanceMark` (
  `id` bigint NOT NULL,
  `status` varchar(10) NOT NULL,
  `marked_at` datetime(6) NOT NULL,
  `student_id` int NOT NULL,
  `session_id` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `campus_AttendanceSession`
--

CREATE TABLE `campus_AttendanceSession` (
  `id` bigint NOT NULL,
  `otp` varchar(4) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `expires_at` datetime(6) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `created_by_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `campus_faq`
--

CREATE TABLE `campus_faq` (
  `id` int NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` longtext NOT NULL,
  `category` varchar(3) NOT NULL,
  `published_time` datetime(6) NOT NULL,
  `last_edit` datetime(6) NOT NULL,
  `is_visitor_visible` tinyint(1) NOT NULL,
  `is_ad_visible` tinyint(1) NOT NULL,
  `is_lc_visible` tinyint(1) NOT NULL,
  `is_tp_visible` tinyint(1) NOT NULL,
  `view_count` int UNSIGNED NOT NULL,
  `n_likes` int UNSIGNED NOT NULL,
  `n_dislikes` int UNSIGNED NOT NULL,
  `slug` varchar(50) NOT NULL,
  `author_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `campus_faq`
--

INSERT INTO `campus_faq` (`id`, `title`, `content`, `category`, `published_time`, `last_edit`, `is_visitor_visible`, `is_ad_visible`, `is_lc_visible`, `is_tp_visible`, `view_count`, `n_likes`, `n_dislikes`, `slug`, `author_id`) VALUES
(2, 'a', '<p>a</p>', 'GEN', '2026-03-08 05:29:50.563449', '2026-03-08 13:59:59.756067', 0, 0, 0, 0, 1, 0, 0, 'a', 1),
(10, 'Studnet View Only', '<p>Student View</p>', 'ATT', '2026-03-08 14:40:44.998226', '2026-03-08 14:40:44.998254', 0, 0, 0, 1, 0, 0, 0, 'studnet-view-only', 1),
(11, 'Admin View Only', '<p>Admin View Only\r\nEdited\r\n</p>', 'ANN', '2026-03-08 14:42:11.000142', '2026-03-08 17:00:07.546734', 0, 1, 0, 0, 4, 0, 0, 'admin-view-only', 1),
(12, 'Lecturer View only', '<p>Lecturer view only</p>', 'GEN', '2026-03-08 14:42:31.296623', '2026-03-09 14:45:43.546158', 0, 0, 1, 0, 3, 0, 0, 'lecturer-view-only', 1),
(13, 'Visitor View Only', '<p>Welcome Visitor </p>', 'BOK', '2026-03-08 14:42:55.721731', '2026-03-11 02:07:49.324706', 1, 0, 0, 0, 15, 0, 0, 'visitor-view-only', 1),
(14, 'A long time ago', '<p><img src=\"/media/attachments/faq_14_c32a7302.png\"/></p><p>Testing </p><p>wwwwwwwwq\r\nass</p>', 'MAP', '2026-03-09 14:48:57.758969', '2026-03-09 14:48:57.822691', 0, 0, 1, 1, 0, 0, 0, 'a-long-time-ago', 1);

-- --------------------------------------------------------

--
-- Table structure for table `campus_faqreaction`
--

CREATE TABLE `campus_faqreaction` (
  `id` bigint NOT NULL,
  `value` smallint NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `faq_id` int NOT NULL,
  `user_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `campus_mapedge`
--

CREATE TABLE `campus_mapedge` (
  `id` bigint NOT NULL,
  `from_node_id` bigint NOT NULL,
  `to_node_id` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `campus_mapnode`
--

CREATE TABLE `campus_mapnode` (
  `id` bigint NOT NULL,
  `node_id` varchar(10) NOT NULL,
  `name` varchar(100) NOT NULL,
  `node_type` varchar(10) NOT NULL,
  `x` int NOT NULL,
  `y` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `campus_subjectcomponent`
--

CREATE TABLE `campus_subjectcomponent` (
  `component_id` int NOT NULL,
  `hours_per_class` int NOT NULL,
  `total_required_hours` int NOT NULL,
  `class_type` varchar(20) NOT NULL,
  `subject_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `campus_subjectcomponent`
--

INSERT INTO `campus_subjectcomponent` (`component_id`, `hours_per_class`, `total_required_hours`, `class_type`, `subject_id`) VALUES
(1, 2, 24, 'Lecture', 1),
(2, 2, 24, 'Tutorial', 1),
(3, 2, 24, 'Lecture', 2),
(4, 2, 24, 'Tutorial', 2),
(5, 2, 24, 'Lecture', 3),
(6, 2, 24, 'Lab', 3),
(7, 2, 24, 'Lecture', 4),
(8, 2, 24, 'Tutorial', 4),
(9, 2, 24, 'Lecture', 5),
(10, 2, 24, 'Tutorial', 5),
(11, 2, 24, 'Lecture', 6),
(12, 2, 24, 'Tutorial', 6),
(13, 2, 24, 'Lecture', 7),
(14, 2, 24, 'Tutorial', 7),
(15, 2, 24, 'Lecture', 8),
(16, 2, 24, 'Lab', 8),
(17, 2, 24, 'Lecture', 9),
(18, 2, 24, 'Tutorial', 9),
(19, 2, 24, 'Lecture', 10),
(20, 2, 24, 'Tutorial', 10),
(21, 2, 24, 'Practical', 11),
(22, 2, 24, 'Lecture', 12),
(23, 2, 24, 'Tutorial', 12),
(24, 2, 24, 'Lecture', 13),
(25, 2, 24, 'Tutorial', 13),
(26, 2, 24, 'Lecture', 14),
(27, 2, 24, 'Tutorial', 14),
(28, 2, 24, 'Lecture', 15),
(29, 2, 24, 'Lab', 15),
(30, 2, 24, 'Lecture', 16),
(31, 2, 24, 'Tutorial', 16),
(32, 2, 24, 'Lecture', 17),
(33, 2, 24, 'Tutorial', 17),
(34, 2, 28, 'Lecture', 19),
(35, 2, 28, 'Tutorial', 19),
(36, 2, 28, 'Lecture', 20),
(37, 2, 28, 'Lab', 20),
(38, 2, 28, 'Lecture', 21),
(39, 2, 28, 'Lab', 21),
(40, 2, 28, 'Lecture', 23),
(41, 2, 28, 'Lab', 23),
(42, 2, 28, 'Lecture', 24),
(43, 2, 28, 'Tutorial', 24),
(44, 2, 28, 'Lecture', 25),
(45, 2, 28, 'Tutorial', 25),
(46, 2, 28, 'Lecture', 26),
(47, 2, 28, 'Tutorial', 26),
(48, 2, 28, 'Lecture', 28),
(49, 2, 28, 'Tutorial', 28),
(50, 2, 28, 'Lecture', 29),
(51, 2, 28, 'Lab', 29),
(52, 2, 28, 'Lecture', 30),
(53, 2, 28, 'Tutorial', 30),
(54, 2, 28, 'Lecture', 31),
(55, 2, 28, 'Tutorial', 31),
(56, 2, 28, 'Lecture', 32),
(57, 2, 28, 'Lab', 32),
(58, 2, 28, 'Lecture', 34),
(59, 2, 28, 'Lab', 34),
(60, 2, 28, 'Lecture', 36),
(61, 2, 28, 'Lab', 36),
(62, 2, 28, 'Lecture', 37),
(63, 2, 28, 'Lab', 37),
(64, 2, 28, 'Lecture', 38),
(65, 2, 28, 'Tutorial', 38),
(66, 2, 28, 'Lecture', 41),
(67, 2, 28, 'Lab', 41),
(68, 2, 28, 'Lecture', 44),
(69, 2, 28, 'Lab', 44),
(70, 2, 28, 'Lecture', 46),
(71, 2, 28, 'Tutorial', 46),
(72, 2, 28, 'Lecture', 51),
(73, 2, 28, 'Tutorial', 51),
(74, 2, 28, 'Lecture', 55),
(75, 2, 28, 'Tutorial', 55),
(76, 2, 28, 'Lecture', 56),
(77, 2, 28, 'Lab', 56),
(78, 2, 28, 'Lecture', 58),
(79, 2, 28, 'Tutorial', 58),
(80, 2, 28, 'Lecture', 60),
(81, 2, 28, 'Tutorial', 60),
(82, 2, 28, 'Lecture', 61),
(83, 2, 28, 'Tutorial', 61),
(84, 2, 28, 'Lecture', 62),
(85, 2, 28, 'Tutorial', 62),
(86, 2, 28, 'Lecture', 63),
(87, 2, 28, 'Tutorial', 63),
(88, 2, 28, 'Lecture', 64),
(89, 2, 28, 'Lab', 64),
(90, 2, 28, 'Lecture', 68),
(91, 2, 28, 'Tutorial', 68),
(92, 2, 28, 'Lecture', 69),
(93, 2, 28, 'Tutorial', 69),
(94, 2, 28, 'Lecture', 70),
(95, 2, 28, 'Tutorial', 70),
(96, 2, 28, 'Lecture', 71),
(97, 2, 28, 'Tutorial', 71),
(98, 2, 28, 'Lecture', 72),
(99, 2, 28, 'Lab', 72),
(100, 2, 28, 'Lecture', 75),
(101, 2, 28, 'Tutorial', 75),
(102, 2, 28, 'Lecture', 76),
(103, 2, 28, 'Tutorial', 76),
(104, 2, 28, 'Practical', 77),
(105, 2, 28, 'Lecture', 78),
(106, 2, 28, 'Tutorial', 78),
(107, 2, 28, 'Lecture', 80),
(108, 2, 28, 'Tutorial', 80),
(109, 2, 28, 'Lecture', 81),
(110, 2, 28, 'Lab', 81),
(111, 2, 28, 'Lecture', 82),
(112, 2, 28, 'Tutorial', 82),
(113, 2, 28, 'Lecture', 83),
(114, 2, 28, 'Tutorial', 83),
(115, 2, 28, 'Lecture', 84),
(116, 2, 28, 'Lab', 84),
(117, 2, 28, 'Lecture', 85),
(118, 2, 28, 'Tutorial', 85),
(119, 2, 28, 'Lecture', 86),
(120, 2, 28, 'Lab', 86),
(121, 2, 28, 'Practical', 87),
(122, 2, 28, 'Lecture', 88),
(123, 2, 28, 'Tutorial', 88),
(124, 2, 28, 'Lecture', 89),
(125, 2, 28, 'Lab', 89),
(126, 2, 28, 'Lecture', 18),
(127, 2, 28, 'Lecture', 22),
(128, 2, 28, 'Lecture', 27),
(129, 2, 28, 'Lecture', 35),
(130, 2, 28, 'Lecture', 73),
(131, 2, 28, 'Lecture', 74),
(132, 2, 28, 'Lecture', 33),
(133, 2, 28, 'Tutorial', 33),
(134, 2, 28, 'Lecture', 39),
(135, 2, 28, 'Lab', 39),
(136, 2, 28, 'Lecture', 40),
(137, 2, 28, 'Lab', 40),
(138, 2, 28, 'Lecture', 42),
(139, 2, 28, 'Lab', 42),
(140, 2, 28, 'Lecture', 43),
(141, 2, 28, 'Tutorial', 43),
(142, 2, 28, 'Practical', 45),
(143, 2, 28, 'Lecture', 47),
(144, 2, 28, 'Lab', 47),
(145, 2, 28, 'Lecture', 48),
(146, 2, 28, 'Tutorial', 48),
(147, 2, 28, 'Lecture', 49),
(148, 2, 28, 'Tutorial', 49),
(149, 2, 28, 'Practical', 50),
(150, 2, 28, 'Lecture', 52),
(151, 2, 28, 'Lab', 52),
(152, 2, 28, 'Lecture', 53),
(153, 2, 28, 'Tutorial', 53),
(154, 2, 28, 'Lecture', 54),
(155, 2, 28, 'Tutorial', 54),
(156, 2, 28, 'Practical', 57),
(157, 2, 28, 'Lecture', 59),
(158, 2, 28, 'Lab', 59),
(159, 2, 28, 'Lecture', 65),
(160, 2, 28, 'Tutorial', 65),
(161, 2, 28, 'Lecture', 66),
(162, 2, 28, 'Tutorial', 66),
(163, 2, 28, 'Lecture', 67),
(164, 2, 28, 'Lab', 67),
(165, 2, 28, 'Lecture', 79),
(166, 2, 28, 'Tutorial', 79),
(167, 8, 320, 'Practical', 90),
(168, 2, 24, 'Lecture', 91),
(169, 2, 24, 'Tutorial', 91);

-- --------------------------------------------------------

--
-- Table structure for table `campus_supportticket`
--

CREATE TABLE `campus_supportticket` (
  `id` bigint NOT NULL,
  `title` varchar(255) NOT NULL,
  `category` varchar(3) NOT NULL,
  `description` longtext NOT NULL,
  `status` varchar(20) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `assigned_to_id` int DEFAULT NULL,
  `created_by_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `campus_supportticket`
--

INSERT INTO `campus_supportticket` (`id`, `title`, `category`, `description`, `status`, `created_at`, `updated_at`, `assigned_to_id`, `created_by_id`) VALUES
(1, 'Testing feedback submission', 'ANN', '<p>aThis is description</p><ol><li data-list=\"ordered\"><span class=\"ql-ui\" contenteditable=\"false\"></span>sdqwa</li><li data-list=\"ordered\"><span class=\"ql-ui\" contenteditable=\"false\"></span><span class=\"ql-size-large\">List 2</span></li></ol><p><img src=\"/media/attachments/supportticket_1_20260312093214.jpeg\"/></p><p><br/></p>', 'in_progress', '2026-03-12 09:32:13.610092', '2026-03-15 12:40:56.724271', 1, 18),
(2, 'More style', 'MAP', '<p><span class=\"ql-size-small\">Testing</span></p><p>Testing</p><p><span class=\"ql-size-large\">Testing</span></p><p><span class=\"ql-size-huge\">Testing</span></p><p><strong>Testing</strong></p><p><em>Testing</em></p><p><u>Testing</u></p><p>Testing</p><p><a href=\"https://heroicons.com/outline\" rel=\"noopener noreferrer\" target=\"_blank\">Testing</a></p><p><img src=\"/media/attachments/supportticket_2_20260312155655.jpeg\"/></p>', 'resolved', '2026-03-12 15:56:54.888813', '2026-03-13 16:33:51.740110', NULL, 18),
(3, 'Announcement not working', 'ANN', '<p>What is the announcement placement banner for? announcement didnt work. </p>', 'in_progress', '2026-03-15 12:47:22.320421', '2026-03-15 12:48:20.295355', 1, 19),
(4, 'Just testing', 'GEN', '<p>ujsJust testing</p>', 'resolved', '2026-03-15 15:44:50.412783', '2026-03-15 16:16:26.962595', 1, 19),
(5, 'Testing Again', 'BOK', '<p>Testing AGAINNN</p>', 'resolved', '2026-03-15 16:17:18.252291', '2026-03-15 16:17:40.081229', 1, 19),
(6, 'Navigation too good', 'MAP', '<p>Mok yu sheng well done </p>', 'in_progress', '2026-03-17 08:52:21.731296', '2026-03-17 09:44:09.226768', 1, 19);

-- --------------------------------------------------------

--
-- Table structure for table `campus_ticketactivity`
--

CREATE TABLE `campus_ticketactivity` (
  `id` bigint NOT NULL,
  `action` varchar(20) NOT NULL,
  `old_value` varchar(255) DEFAULT NULL,
  `new_value` varchar(255) DEFAULT NULL,
  `timestamp` datetime(6) NOT NULL,
  `ticket_id` bigint NOT NULL,
  `user_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `campus_ticketactivity`
--

INSERT INTO `campus_ticketactivity` (`id`, `action`, `old_value`, `new_value`, `timestamp`, `ticket_id`, `user_id`) VALUES
(1, 'escalation', 'Open', 'Escalated / In Progress', '2026-03-13 16:02:27.433740', 2, 18),
(2, 'escalation', 'Open', 'Escalated / In Progress', '2026-03-13 16:02:34.091941', 2, 18),
(3, 'escalation', 'Open', 'Escalated / In Progress', '2026-03-13 16:02:47.173185', 2, 18),
(4, 'escalation', NULL, NULL, '2026-03-13 16:24:32.563205', 2, 18),
(5, 'status_change', 'Open', 'Closed', '2026-03-13 16:25:55.426052', 2, 18),
(6, 'status_change', 'Closed', 'Resolved', '2026-03-13 16:33:51.748391', 2, 18),
(7, 'escalation', NULL, NULL, '2026-03-13 16:43:56.810285', 1, 18),
(8, 'escalation', NULL, NULL, '2026-03-13 17:11:18.222605', 1, 18),
(9, 'status_change', 'Open', 'In Progress', '2026-03-15 12:40:56.750965', 1, 1),
(10, 'status_change', 'Open', 'In Progress', '2026-03-15 12:48:20.306776', 3, 1),
(11, 'closure_request', NULL, 'rejected', '2026-03-15 13:52:55.457626', 3, 19),
(12, 'closure_request', NULL, 'rejected', '2026-03-15 15:39:49.165031', 3, 19),
(13, 'closure_request', NULL, 'rejected', '2026-03-15 15:42:50.595345', 3, 19),
(14, 'rejected_closure', NULL, NULL, '2026-03-15 15:42:59.091145', 3, 1),
(15, 'status_change', 'Open', 'In Pprogress', '2026-03-15 16:15:44.029058', 4, 1),
(16, 'status_change', 'In Progress', 'Resolved', '2026-03-15 16:16:26.972405', 4, 1),
(17, 'status_change', 'Open', 'In Pprogress', '2026-03-15 16:17:25.084539', 5, 1),
(18, 'status_change', 'In Progress', 'Resolved', '2026-03-15 16:17:40.088886', 5, 19),
(19, 'escalation', NULL, NULL, '2026-03-15 16:18:19.541760', 3, 19),
(20, 'closure_request', NULL, 'rejected', '2026-03-17 09:40:54.444768', 6, 19),
(21, 'status_change', 'Open', 'In Pprogress', '2026-03-17 09:44:09.231612', 6, 1),
(22, 'rejected_closure', NULL, NULL, '2026-03-17 09:45:54.160425', 6, 1);

-- --------------------------------------------------------

--
-- Table structure for table `campus_ticketmessage`
--

CREATE TABLE `campus_ticketmessage` (
  `id` bigint NOT NULL,
  `content` longtext NOT NULL,
  `sent_at` datetime(6) NOT NULL,
  `is_admin_reply` tinyint(1) NOT NULL,
  `sender_id` int NOT NULL,
  `ticket_id` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `campus_ticketmessage`
--

INSERT INTO `campus_ticketmessage` (`id`, `content`, `sent_at`, `is_admin_reply`, `sender_id`, `ticket_id`) VALUES
(32, '<p>HELO</p>', '2026-03-13 12:55:47.836710', 0, 18, 2),
(33, '<p>Hello</p><p><br></p>', '2026-03-13 14:35:41.498880', 0, 18, 2),
(34, '<p>testing</p>', '2026-03-13 14:48:25.452028', 0, 18, 2),
(35, '<p>Testing</p><p><br></p>', '2026-03-13 14:58:23.476859', 0, 18, 2),
(36, '<p>Halo</p>', '2026-03-13 16:43:46.807637', 0, 18, 1),
(37, '<p>Testing here</p>', '2026-03-13 16:43:52.026215', 0, 18, 1),
(38, '<p>abc</p>', '2026-03-17 08:56:12.392492', 0, 19, 6),
(39, '<p>abc</p><p>abc</p>', '2026-03-17 09:39:20.924965', 0, 19, 6),
(40, '<p>hello</p>', '2026-03-17 09:40:31.305904', 1, 1, 6),
(41, '<p>halo</p>', '2026-03-17 09:40:48.401636', 1, 1, 6),
(42, '<p>Why i cannot request to close ticket? </p><p><img src=\"/media/attachments/ticketmessage_42_20260317094659.png\"/></p>', '2026-03-17 09:46:55.579481', 0, 19, 6);

-- --------------------------------------------------------

--
-- Table structure for table `class_session`
--

CREATE TABLE `class_session` (
  `id` int NOT NULL,
  `date` date DEFAULT NULL,
  `status` varchar(20) NOT NULL,
  `lecturer_id` int NOT NULL,
  `term_id` int DEFAULT NULL,
  `session_id` int NOT NULL,
  `subject_component_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `course`
--

CREATE TABLE `course` (
  `course_id` int NOT NULL,
  `course_code` varchar(20) NOT NULL,
  `course_name` varchar(255) NOT NULL,
  `total_credits_to_graduate` int NOT NULL,
  `total_semester` int NOT NULL,
  `semester_week` int NOT NULL,
  `level` varchar(20) NOT NULL,
  `year_taken` int NOT NULL,
  `specialization` varchar(100) DEFAULT NULL,
  `internship` tinyint(1) NOT NULL,
  `dept_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `course`
--

INSERT INTO `course` (`course_id`, `course_code`, `course_name`, `total_credits_to_graduate`, `total_semester`, `semester_week`, `level`, `year_taken`, `specialization`, `internship`, `dept_id`) VALUES
(1, 'F-ICT-GEN', 'Foundation Programme (Computing & Technology Route)', 50, 3, 12, 'Foundation', 1, NULL, 0, 1),
(2, 'B-CS-AI', 'Bachelor of Computer Science (Hons) (Artificial Intelligence)', 50, 7, 14, 'Degree', 3, 'Artificial Intelligence', 1, 2),
(3, 'B-CS-CYB', 'Bachelor of Science (Honours) in Computer Science (Cyber Security)', 50, 7, 14, 'Degree', 3, 'Cyber Security', 1, 2),
(4, 'D-ICT-SE', 'Diploma in Information & Communication Technology with a specialism in Software Engineering', 50, 6, 14, 'Diploma', 2, 'Software Engineering', 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `course_enrollment`
--

CREATE TABLE `course_enrollment` (
  `id` int NOT NULL,
  `enrollment_status` varchar(20) NOT NULL,
  `student_id` int NOT NULL,
  `term_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `course_enrollment`
--

INSERT INTO `course_enrollment` (`id`, `enrollment_status`, `student_id`, `term_id`) VALUES
(5, 'Active', 19, 1),
(6, 'Active', 45, 2),
(7, 'Active', 46, 3),
(8, 'Active', 47, 1),
(9, 'Active', 48, 4),
(10, 'Active', 49, 2),
(11, 'Active', 50, 3),
(12, 'Active', 51, 1),
(13, 'Active', 52, 4),
(14, 'Active', 53, 2),
(15, 'Active', 54, 3);

-- --------------------------------------------------------

--
-- Table structure for table `course_subject`
--

CREATE TABLE `course_subject` (
  `id` int NOT NULL,
  `recommended_semester` int NOT NULL,
  `course_id` int NOT NULL,
  `subject_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `course_subject`
--

INSERT INTO `course_subject` (`id`, `recommended_semester`, `course_id`, `subject_id`) VALUES
(13, 1, 1, 1),
(14, 1, 1, 2),
(15, 1, 1, 3),
(16, 1, 1, 4),
(17, 1, 1, 5),
(18, 2, 1, 6),
(19, 2, 1, 7),
(20, 2, 1, 8),
(21, 2, 1, 9),
(22, 3, 1, 10),
(23, 3, 1, 11),
(24, 3, 1, 12),
(25, 3, 1, 13),
(26, 3, 1, 14),
(27, 3, 1, 15),
(28, 3, 1, 16),
(29, 3, 1, 17),
(42, 1, 2, 18),
(43, 1, 2, 77),
(44, 1, 2, 19),
(45, 1, 2, 20),
(46, 1, 2, 21),
(47, 1, 2, 22),
(48, 1, 2, 23),
(49, 1, 2, 24),
(50, 2, 2, 25),
(51, 2, 2, 26),
(52, 2, 2, 27),
(53, 2, 2, 28),
(54, 2, 2, 29),
(55, 2, 2, 30),
(56, 2, 2, 31),
(57, 3, 2, 32),
(58, 3, 2, 77),
(59, 3, 2, 33),
(60, 3, 2, 34),
(61, 3, 2, 35),
(62, 3, 2, 36),
(63, 3, 2, 37),
(64, 3, 2, 38),
(65, 4, 2, 39),
(66, 4, 2, 40),
(67, 4, 2, 41),
(68, 4, 2, 42),
(69, 4, 2, 43),
(70, 4, 2, 44),
(71, 4, 2, 45),
(72, 5, 2, 90),
(73, 6, 2, 46),
(74, 6, 2, 47),
(75, 6, 2, 48),
(76, 6, 2, 49),
(77, 6, 2, 50),
(78, 6, 2, 51),
(79, 6, 2, 52),
(80, 6, 2, 53),
(81, 7, 2, 54),
(82, 7, 2, 55),
(83, 7, 2, 56),
(84, 7, 2, 57),
(85, 1, 3, 18),
(86, 1, 3, 77),
(87, 1, 3, 19),
(88, 1, 3, 20),
(89, 1, 3, 21),
(90, 1, 3, 22),
(91, 1, 3, 23),
(92, 1, 3, 24),
(101, 2, 3, 25),
(102, 2, 3, 26),
(103, 2, 3, 28),
(104, 2, 3, 27),
(105, 2, 3, 29),
(106, 2, 3, 58),
(107, 2, 3, 30),
(108, 2, 3, 31),
(109, 3, 3, 33),
(110, 3, 3, 34),
(111, 3, 3, 35),
(112, 3, 3, 59),
(113, 3, 3, 60),
(114, 3, 3, 37),
(115, 3, 3, 38),
(116, 4, 3, 61),
(117, 4, 3, 41),
(118, 4, 3, 62),
(119, 4, 3, 63),
(120, 4, 3, 64),
(121, 4, 3, 43),
(122, 4, 3, 44),
(123, 4, 3, 45),
(124, 5, 3, 90),
(125, 6, 3, 46),
(126, 6, 3, 65),
(127, 6, 3, 66),
(128, 6, 3, 67),
(129, 6, 3, 50),
(130, 6, 3, 51),
(131, 6, 3, 53),
(132, 6, 3, 68),
(133, 7, 3, 69),
(134, 7, 3, 70),
(135, 7, 3, 71),
(136, 7, 3, 57),
(137, 7, 3, 72),
(138, 1, 4, 10),
(139, 1, 4, 73),
(140, 1, 4, 74),
(141, 1, 4, 75),
(142, 1, 4, 19),
(143, 1, 4, 76),
(144, 2, 4, 78),
(145, 2, 4, 79),
(146, 2, 4, 80),
(147, 2, 4, 81),
(149, 3, 4, 82),
(150, 3, 4, 83),
(151, 3, 4, 27),
(152, 3, 4, 29),
(153, 3, 4, 31),
(154, 4, 4, 84),
(155, 4, 4, 25),
(156, 4, 4, 85),
(157, 4, 4, 86),
(158, 5, 4, 87),
(159, 5, 4, 88),
(160, 5, 4, 28),
(161, 5, 4, 89),
(162, 6, 4, 90);

-- --------------------------------------------------------

--
-- Table structure for table `departments`
--

CREATE TABLE `departments` (
  `dept_id` int NOT NULL,
  `dept_name` varchar(100) NOT NULL,
  `dept_code` varchar(10) NOT NULL,
  `head_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `departments`
--

INSERT INTO `departments` (`dept_id`, `dept_name`, `dept_code`, `head_id`) VALUES
(1, 'Information & Communication Technology', 'ICT', NULL),
(2, 'Computer Science', 'CS', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `django_admin_log`
--

CREATE TABLE `django_admin_log` (
  `id` int NOT NULL,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint UNSIGNED NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `django_content_type`
--

CREATE TABLE `django_content_type` (
  `id` int NOT NULL,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `django_content_type`
--

INSERT INTO `django_content_type` (`id`, `app_label`, `model`) VALUES
(1, 'admin', 'logentry'),
(2, 'auth', 'group'),
(3, 'auth', 'permission'),
(4, 'auth', 'user'),
(7, 'campus', 'academic_rules'),
(8, 'campus', 'academic_term'),
(21, 'campus', 'admin_profiles'),
(36, 'campus', 'announcement'),
(37, 'campus', 'announcementtarget'),
(25, 'campus', 'attachments'),
(23, 'campus', 'attendancemark'),
(24, 'campus', 'attendancesession'),
(28, 'campus', 'booking'),
(29, 'campus', 'cannedresponse'),
(9, 'campus', 'class_session'),
(10, 'campus', 'course'),
(11, 'campus', 'course_enrollment'),
(12, 'campus', 'course_subject'),
(13, 'campus', 'departments'),
(14, 'campus', 'facilities'),
(26, 'campus', 'faq'),
(27, 'campus', 'faqreaction'),
(32, 'campus', 'lecturer_assignment'),
(15, 'campus', 'lecturer_profiles'),
(16, 'campus', 'lecturer_subjects'),
(17, 'campus', 'mapedge'),
(18, 'campus', 'mapnode'),
(19, 'campus', 'session'),
(33, 'campus', 'skipped_date'),
(22, 'campus', 'student_profiles'),
(20, 'campus', 'subject'),
(38, 'campus', 'subjectcomponent'),
(30, 'campus', 'supportticket'),
(35, 'campus', 'ticketactivity'),
(31, 'campus', 'ticketmessage'),
(34, 'campus', 'timetable_preference'),
(5, 'contenttypes', 'contenttype'),
(6, 'sessions', 'session');

-- --------------------------------------------------------

--
-- Table structure for table `django_migrations`
--

CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `django_migrations`
--

INSERT INTO `django_migrations` (`id`, `app`, `name`, `applied`) VALUES
(1, 'contenttypes', '0001_initial', '2026-02-03 16:04:14.786385'),
(2, 'auth', '0001_initial', '2026-02-03 16:04:15.063123'),
(3, 'admin', '0001_initial', '2026-02-03 16:04:15.143128'),
(4, 'admin', '0002_logentry_remove_auto_add', '2026-02-03 16:04:15.151645'),
(5, 'admin', '0003_logentry_add_action_flag_choices', '2026-02-03 16:04:15.161883'),
(6, 'contenttypes', '0002_remove_content_type_name', '2026-02-03 16:04:15.211830'),
(7, 'auth', '0002_alter_permission_name_max_length', '2026-02-03 16:04:15.244119'),
(8, 'auth', '0003_alter_user_email_max_length', '2026-02-03 16:04:15.264846'),
(9, 'auth', '0004_alter_user_username_opts', '2026-02-03 16:04:15.273993'),
(10, 'auth', '0005_alter_user_last_login_null', '2026-02-03 16:04:15.305028'),
(11, 'auth', '0006_require_contenttypes_0002', '2026-02-03 16:04:15.308436'),
(12, 'auth', '0007_alter_validators_add_error_messages', '2026-02-03 16:04:15.316717'),
(13, 'auth', '0008_alter_user_username_max_length', '2026-02-03 16:04:15.337958'),
(14, 'auth', '0009_alter_user_last_name_max_length', '2026-02-03 16:04:15.363107'),
(15, 'auth', '0010_alter_group_name_max_length', '2026-02-03 16:04:15.388411'),
(16, 'auth', '0011_update_proxy_permissions', '2026-02-03 16:04:15.397136'),
(17, 'auth', '0012_alter_user_first_name_max_length', '2026-02-03 16:04:15.419194'),
(18, 'sessions', '0001_initial', '2026-02-03 16:04:15.443334'),
(19, 'sessions', '0001_initial', '2026-03-21 09:11:27.641189'),
(20, 'campus', '0002_mapnode_mapedge', '2026-02-26 11:04:42.366115'),
(21, 'campus', '0003_lecturer_profiles_lc_id_admin_profiles_and_more', '2026-02-26 11:05:46.432978'),
(22, 'campus', '0004_departments_head_alter_admin_profiles_user_and_more', '2026-03-07 13:11:04.731816'),
(23, 'campus', '0005_attendance_models', '2026-03-07 13:12:18.910810'),
(24, 'campus', '0006_attachments_faq', '2026-03-07 13:12:23.001625'),
(25, 'campus', '0007_alter_faq_author', '2026-03-08 06:17:09.731131'),
(26, 'campus', '0002_auto_20260308_1731', '2026-03-08 09:32:14.277517'),
(38, 'campus', '0001_initial', '2026-03-11 15:41:34.693216'),
(39, 'campus', '0002_faq_is_visitor_visible', '2026-03-11 15:42:16.004637'),
(40, 'campus', '0003_faqreaction', '2026-03-11 15:42:16.010362'),
(41, 'campus', '0004_cannedresponse_booking_supportticket_ticketmessage', '2026-03-11 15:42:20.223088'),
(42, 'campus', '0005_alter_supportticket_category', '2026-03-11 16:49:16.688842'),
(43, 'campus', '0006_alter_supportticket_category', '2026-03-12 07:48:30.017382'),
(44, 'campus', '0006_alter_booking_status', '2026-03-12 09:18:25.202101'),
(45, 'campus', '0007_class_session_date_class_session_status_and_more', '2026-03-13 03:55:33.579696'),
(46, 'campus', '0008_ticketactivity', '2026-03-13 15:53:07.642755'),
(47, 'campus', '0009_alter_ticketactivity_action', '2026-03-15 15:42:39.185786'),
(48, 'campus', '0010_delete_cannedresponse', '2026-03-17 09:48:43.749434'),
(49, 'campus', '0011_announcement_remove_facilities_capacity_and_more', '2026-03-17 14:14:29.641093'),
(50, 'campus', '0012_alter_subjectcomponent_hours_per_class', '2026-03-17 14:56:04.338389'),
(51, 'campus', '0013_remove_facilities_building_and_more', '2026-03-17 15:17:12.385372'),
(52, 'campus', '0014_announcement_announcement_type_announcement_author_and_more', '2026-03-19 08:59:53.335540'),
(53, 'campus', '0015_announcementtarget_is_visitor_visible', '2026-03-20 08:43:27.759520'),
(54, 'campus', '0016_alter_announcement_author', '2026-03-20 09:07:09.288060'),
(55, 'campus', '0002_remove_class_session_subject_and_more', '2026-03-21 09:43:40.599575');

-- --------------------------------------------------------

--
-- Table structure for table `django_session`
--

CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `django_session`
--

INSERT INTO `django_session` (`session_key`, `session_data`, `expire_date`) VALUES
('0epqg2lgmg2s9hs2ravf2py8hn0bci4k', 'e30:1vvDyh:rQYMMnzEesB1g0RPbsq1PZ6YjjWMEavlB1qicAtYDzE', '2026-03-11 12:26:55.402248'),
('2ma87up2v1sdyc49h9qa7zdyc0a81u7m', '.eJxVjEEOwiAQRe_C2hCgjGKX7j0DGZjBogZMaRON8e5a04Vu_3v_PYXHeRr83Hj0mUQvtNj8bgHjhcsC6IzlVGWsZRpzkIsiV9rksRJfD6v7FxiwDUt2q6BTjCkimI4_R-OSJWsTGu3AdojgKNgQolN7grRzgQDIaJs06W-0cWu5Fs_3Wx4folevN6fNP7Y:1vxl9M:rf5ZPl9KqjNjIez_22XMXIrlAPcBoPw2-M-tovqwVmU', '2026-03-18 12:16:24.925198'),
('39rfmbmswdgw3owh8vu1tva9wqc5zt01', 'e30:1vvZZx:0In_6ZxHPzr1ztsCxKWtYmM4DU7hRRrd7oAaCt1t2jg', '2026-03-12 11:30:49.123253'),
('3se450spprln3yhud3kkokdzjtms11lg', '.eJxVjMEOwiAQBf-FsyFLSyn06N1vICxsBTVgSptojP-uJD3o9c28eTHrtjXardJiU2ATE4Ydfkd0_kq5kXBx-Vy4L3ldEvKm8J1WfiqBbsfd_QtEV-P37aEH3WtQ0qCkmbQfAwnR664jNYAxgxylUFIHh0QjUmcABj9LUKg8YYtWqjWVbOlxT8uTTfD-AI6iPu4:1vxND8:IpDmp6zdDhVQ5TMa2deC3Iwqa-KH5_rbKO2j-lxQBMs', '2026-03-17 10:42:42.984478'),
('4lcjeov5q3m3cq8i017bw3b2dw9vi9ze', '.eJxVjEEOwiAQRe_C2hCgjGKX7j0DGZjBogZMaRON8e5a04Vu_3v_PYXHeRr83Hj0mUQvtNj8bgHjhcsC6IzlVGWsZRpzkIsiV9rksRJfD6v7FxiwDUt2q6BTjCkimI4_R-OSJWsTGu3AdojgKNgQolN7grRzgQDIaJs06W-0cWu5Fs_3Wx4folevN6fNP7Y:1w2u85:q1zBJBUQSdeH2K73G1LVcjWiWSzAO5QGAyT4uSc4s7A', '2026-04-01 16:52:21.670509'),
('6z541ax3lyy7f7px1z5hnf4vmxqh3pip', '.eJxVjEEOwiAQRe_C2hCgjGKX7j0DGZjBogZMaRON8e5a04Vu_3v_PYXHeRr83Hj0mUQvtNj8bgHjhcsC6IzlVGWsZRpzkIsiV9rksRJfD6v7FxiwDUt2q6BTjCkimI4_R-OSJWsTGu3AdojgKNgQolN7grRzgQDIaJs06W-0cWu5Fs_3Wx4folevN6fNP7Y:1w3Tuh:q0Rjyo2kG6cxux3FxmPc7Bfgk8voRgjNd9zuNwAS0lE', '2026-04-03 07:04:55.735178'),
('6ziz6z9zvxvfjllo056ai0nb6hwyemkc', '.eJxVjMEOwiAQBf-FsyFLSyn06N1vICxsBTVgSptojP-uJD3o9c28eTHrtjXardJiU2ATE4Ydfkd0_kq5kXBx-Vy4L3ldEvKm8J1WfiqBbsfd_QtEV-P37aEH3WtQ0qCkmbQfAwnR664jNYAxgxylUFIHh0QjUmcABj9LUKg8YYtWqjWVbOlxT8uTTfD-AI6iPu4:1w1knq:V5pyOvzQftUagTgJu1C5b2goWpLpxoffgTqb5RYRt98', '2026-03-29 12:42:42.237881'),
('8wwhwa1vq3me7a3q9pyf71303lw8jroo', '.eJxVjEEOwiAQRe_C2hCgjGKX7j0DGZjBogZMaRON8e5a04Vu_3v_PYXHeRr83Hj0mUQvtNj8bgHjhcsC6IzlVGWsZRpzkIsiV9rksRJfD6v7FxiwDUt2q6BTjCkimI4_R-OSJWsTGu3AdojgKNgQolN7grRzgQDIaJs06W-0cWu5Fs_3Wx4folevN6fNP7Y:1w3nMB:gE9IMraE_jIkurFaYiQ3kCqCdBmyRLxWUkDB6enY_kM', '2026-04-04 03:50:35.187129'),
('a2k6qlax0csynlzwzcu9jqhzhmc53lbb', '.eJxVjEEOwiAQRe_C2hCgjGKX7j0DGZjBogZMaRON8e5a04Vu_3v_PYXHeRr83Hj0mUQvtNj8bgHjhcsC6IzlVGWsZRpzkIsiV9rksRJfD6v7FxiwDUt2q6BTjCkimI4_R-OSJWsTGu3AdojgKNgQolN7grRzgQDIaJs06W-0cWu5Fs_3Wx4folevN6fNP7Y:1vwLiF:WjpPOmMMVTjwIHxrvl4x8ML63EwfwoBvmxHi4yN_t7k', '2026-03-14 14:54:35.917410'),
('bvril7urkm3fs1vr1ohim2iowpecay37', '.eJxVjMsOwiAQRf-FtSHlMYou3fcbyMAMUm1KAu3K-O9K7Kbbc869b9F45rgy-Vpm9hOJmzDiJDxua_Zb4_pn6sgCxhcvXdATl0eRsSxrnYLsidxtk2Mhnu97ezjI2HK_PQ9gBsYUEbTh31C7ZMnahFo5sAYRHAUbQnTDlSBdXCAA0somRYrE5wt6BUAg:1vvaIj:N9VnOHG4I3RNEg-joIaMhr9LymjuIPKehkJePJB044c', '2026-03-12 12:17:05.763956'),
('j7efu252qdp0l2ooz7ifkau2dp8axwh9', '.eJxVjEEOwiAQRe_C2hCgjGKX7j0DGZjBogZMaRON8e5a04Vu_3v_PYXHeRr83Hj0mUQvtNj8bgHjhcsC6IzlVGWsZRpzkIsiV9rksRJfD6v7FxiwDUt2q6BTjCkimI4_R-OSJWsTGu3AdojgKNgQolN7grRzgQDIaJs06W-0cWu5Fs_3Wx4folevN6fNP7Y:1vxyAZ:mbgTXi5uLlHq3o0TLJXGw7loo3XQxGwD0CskpnYCuwo', '2026-03-19 02:10:31.254448'),
('m6qxqaofl5pktz520m2xbdetn9u8ojxe', '.eJxVjEEOwiAQRe_C2hCgjGKX7j0DGZjBogZMaRON8e5a04Vu_3v_PYXHeRr83Hj0mUQvtNj8bgHjhcsC6IzlVGWsZRpzkIsiV9rksRJfD6v7FxiwDUt2q6BTjCkimI4_R-OSJWsTGu3AdojgKNgQolN7grRzgQDIaJs06W-0cWu5Fs_3Wx4folevN6fNP7Y:1w3rwA:aGpQrXCzUfwNcbj7xsYXvWe0-r-n8FGTR6KaCLPb08c', '2026-04-04 08:44:02.758571'),
('namwkapicfkzei1wlbghz4tc65t0pj3y', '.eJxVjEEOwiAQRe_C2hCgjGKX7j0DGZjBogZMaRON8e5a04Vu_3v_PYXHeRr83Hj0mUQvtNj8bgHjhcsC6IzlVGWsZRpzkIsiV9rksRJfD6v7FxiwDUt2q6BTjCkimI4_R-OSJWsTGu3AdojgKNgQolN7grRzgQDIaJs06W-0cWu5Fs_3Wx4folevN6fNP7Y:1w2Qmz:-IIudrMGu1PUlw8lXlbH-3OYyosxdknwNZpjdDOxGO8', '2026-03-31 09:32:37.018734'),
('q98838rw2u1sncx32zlnfdkd9d6kvd4v', 'e30:1vvE04:C7wL7f3Ztf990qKraPev_7PW62KL4Bhv1PKSHvQ7zWU', '2026-03-11 12:28:20.932855'),
('qpa8mjoflkbl7nmrtu0rrcdf18l095ez', '.eJxVjEEOwiAQRe_C2hCgjGKX7j0DGZjBogZMaRON8e5a04Vu_3v_PYXHeRr83Hj0mUQvtNj8bgHjhcsC6IzlVGWsZRpzkIsiV9rksRJfD6v7FxiwDUt2q6BTjCkimI4_R-OSJWsTGu3AdojgKNgQolN7grRzgQDIaJs06W-0cWu5Fs_3Wx4folevN6fNP7Y:1vy0Ru:RPjpdWnOpzKFbrcGEIYSCCqEwZeJ0utF9GNkyPh_e2o', '2026-03-19 04:36:34.229452'),
('qpxen0y09cs8cz65uecvmzqhqjbs93kf', '.eJxVjMEOwiAQBf-FsyFLSyn06N1vICxsBTVgSptojP-uJD3o9c28eTHrtjXardJiU2ATE4Ydfkd0_kq5kXBx-Vy4L3ldEvKm8J1WfiqBbsfd_QtEV-P37aEH3WtQ0qCkmbQfAwnR664jNYAxgxylUFIHh0QjUmcABj9LUKg8YYtWqjWVbOlxT8uTTfD-AI6iPu4:1w3Van:8cpTQGAvLUBA8wdEsXfjuSHLa8SbsEgvHN-vr4t_K04', '2026-04-03 08:52:29.630850'),
('rr6rhfs497rgpd10o40o33h05wyyv1fw', '.eJxVjE0OwiAYBe_C2pBSoIUu3XsG8v2gRQ00pU00xrtrky50-2bevESAdRnDWuMcEotBKCcOvyMC3WLeCF8hX4qkkpc5odwUudMqT4Xj_bi7f4ER6vh9W-oQPWpyyrIH8r32DrADsK1WrEmjs-gVRq25jcp40_SKyJrOEPN5i9ZYayo5xMeU5qcYmvcHyaY_og:1w0ASl:_UOCnOfaL8zzRnRp-fVqE9T0BNAbCRungcsZVnEpWkk', '2026-03-25 03:42:23.015135'),
('wb9q6j5eshdk7fzv0s5n8gmzk3i23l8i', '.eJxVjEEOwiAQRe_C2hCgjGKX7j0DGZjBogZMaRON8e5a04Vu_3v_PYXHeRr83Hj0mUQvtNj8bgHjhcsC6IzlVGWsZRpzkIsiV9rksRJfD6v7FxiwDUt2q6BTjCkimI4_R-OSJWsTGu3AdojgKNgQolN7grRzgQDIaJs06W-0cWu5Fs_3Wx4folevN6fNP7Y:1w38KJ:Ozpqj5ANsPDBRsG4xyYcuKZaKrBp5W_sZxjR9A85NXg', '2026-04-02 08:01:55.472042'),
('xh29i1so6px3lu3ifgaoh09j84bya624', '.eJxVjMEOwiAQBf-FsyFLSyn06N1vICxsBTVgSptojP-uJD3o9c28eTHrtjXardJiU2ATE4Ydfkd0_kq5kXBx-Vy4L3ldEvKm8J1WfiqBbsfd_QtEV-P37aEH3WtQ0qCkmbQfAwnR664jNYAxgxylUFIHh0QjUmcABj9LUKg8YYtWqjWVbOlxT8uTTfD-AI6iPu4:1vxL5Q:Jc2NTIe0aSBtlMi2PJEyPkFufOZaPeFto-p5ViB8Jm4', '2026-03-17 08:26:36.338148'),
('xowo5ty3u1zi4amzxvzymvkqs2a62nxn', '.eJxVjEEOwiAQRe_C2hCgjGKX7j0DGZjBogZMaRON8e5a04Vu_3v_PYXHeRr83Hj0mUQvtNj8bgHjhcsC6IzlVGWsZRpzkIsiV9rksRJfD6v7FxiwDUt2q6BTjCkimI4_R-OSJWsTGu3AdojgKNgQolN7grRzgQDIaJs06W-0cWu5Fs_3Wx4folevN6fNP7Y:1w1gAN:73jWnFquIQjBkGSB2N5MlqkLTqqQy3xL2Hvzc4vfaE4', '2026-03-29 07:45:39.817931'),
('ydsmcc4rbenpgqg6vhmofg9tw66fozyn', '.eJxVjEEOwiAQRe_C2hCgjGKX7j0DGZjBogZMaRON8e5a04Vu_3v_PYXHeRr83Hj0mUQvtNj8bgHjhcsC6IzlVGWsZRpzkIsiV9rksRJfD6v7FxiwDUt2q6BTjCkimI4_R-OSJWsTGu3AdojgKNgQolN7grRzgQDIaJs06W-0cWu5Fs_3Wx4folevN6fNP7Y:1w1RZ1:1cBIwtBQwmaqUlaJD8C5DO-F0yH5Hz8W49dgIVoFvD0', '2026-03-28 16:10:07.253951'),
('z1ah4u2vmgfr6mxw6xrwr208ze73gn5c', '.eJxVjE0OwiAYBe_C2pBSoIUu3XsG8v2gRQ00pU00xrtrky50-2bevESAdRnDWuMcEotBKCcOvyMC3WLeCF8hX4qkkpc5odwUudMqT4Xj_bi7f4ER6vh9W-oQPWpyyrIH8r32DrADsK1WrEmjs-gVRq25jcp40_SKyJrOEPN5i9ZYayo5xMeU5qcYmvcHyaY_og:1vxRIa:vrqOpMF8VG2qqBr2IycN6HZ-xqyp34nvedp8ZzY1-zw', '2026-03-17 15:04:36.949528');

-- --------------------------------------------------------

--
-- Table structure for table `facilities`
--

CREATE TABLE `facilities` (
  `facility_id` int NOT NULL,
  `facility_name` varchar(100) NOT NULL,
  `type` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `facilities`
--

INSERT INTO `facilities` (`facility_id`, `facility_name`, `type`) VALUES
(1, 'Classroom 1', 'Classroom'),
(2, 'Classroom 2', 'Classroom'),
(3, 'Classroom 3', 'Classroom'),
(4, 'Classroom 4', 'Classroom'),
(5, 'Classroom 5', 'Classroom'),
(6, 'Classroom 6', 'Classroom'),
(7, 'Auditorium 1', 'Auditorium'),
(8, 'Auditorium 2', 'Auditorium'),
(9, 'Lab 1', 'Lab'),
(10, 'Lab 2', 'Lab');

-- --------------------------------------------------------

--
-- Table structure for table `lecturer_assignment`
--

CREATE TABLE `lecturer_assignment` (
  `id` int NOT NULL,
  `lecturer_id` int NOT NULL,
  `term_id` int NOT NULL,
  `subject_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `lecturer_assignment`
--

INSERT INTO `lecturer_assignment` (`id`, `lecturer_id`, `term_id`, `subject_id`) VALUES
(1, 33, 1, 1),
(2, 35, 1, 3),
(3, 21, 1, 4),
(4, 23, 1, 5),
(5, 31, 1, 2),
(6, 31, 2, 10),
(7, 30, 2, 73),
(8, 31, 2, 74),
(9, 31, 2, 75),
(10, 22, 2, 76),
(11, 30, 3, 18),
(12, 37, 3, 20),
(13, 38, 3, 21),
(14, 24, 3, 22),
(15, 25, 3, 23),
(16, 26, 3, 24),
(17, 32, 3, 77),
(18, 30, 4, 18),
(19, 37, 4, 20),
(20, 38, 4, 21),
(21, 24, 4, 22),
(22, 25, 4, 23),
(23, 26, 4, 24),
(24, 32, 4, 77),
(25, 37, 1, 6),
(26, 37, 1, 7),
(27, 21, 1, 8),
(28, 24, 1, 9),
(29, 31, 1, 10),
(30, 34, 1, 12),
(31, 36, 1, 14),
(32, 37, 1, 15),
(33, 24, 1, 16),
(34, 23, 1, 17),
(35, 32, 1, 11),
(36, 34, 2, 78),
(37, 39, 2, 79),
(38, 22, 2, 80),
(39, 25, 2, 81),
(40, 35, 2, 19);

-- --------------------------------------------------------

--
-- Table structure for table `lecturer_profiles`
--

CREATE TABLE `lecturer_profiles` (
  `id` int NOT NULL,
  `lc_id` varchar(12) NOT NULL,
  `specialization` longtext,
  `is_head` tinyint(1) NOT NULL,
  `max_hours_per_week` int NOT NULL,
  `dept_id` int DEFAULT NULL,
  `user_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `lecturer_profiles`
--

INSERT INTO `lecturer_profiles` (`id`, `lc_id`, `specialization`, `is_head`, `max_hours_per_week`, `dept_id`, `user_id`) VALUES
(14, 'LC262996', NULL, 0, 20, NULL, 18),
(15, 'LC263268', NULL, 0, 20, 1, 20),
(16, 'LC265377', NULL, 0, 20, 1, 21),
(17, 'LC269051', NULL, 0, 20, 1, 22),
(18, 'LC261361', NULL, 0, 20, 1, 23),
(19, 'LC267069', NULL, 0, 20, 1, 24),
(20, 'LC264656', NULL, 0, 20, 1, 25),
(21, 'LC264627', NULL, 0, 20, 1, 26),
(22, 'LC266472', NULL, 0, 20, 1, 27),
(23, 'LC261079', NULL, 0, 20, 1, 28),
(24, 'LC269147', NULL, 0, 20, 1, 29),
(25, 'LC266166', NULL, 0, 20, 2, 30),
(26, 'LC268442', NULL, 0, 20, 2, 31),
(27, 'LC265878', NULL, 0, 20, 2, 32),
(28, 'LC267068', NULL, 0, 20, 2, 33),
(29, 'LC269310', NULL, 0, 20, 2, 34),
(30, 'LC265664', NULL, 0, 20, 2, 35),
(31, 'LC268809', NULL, 0, 20, 2, 36),
(32, 'LC266321', NULL, 0, 20, 2, 37),
(33, 'LC267244', NULL, 0, 20, 2, 38),
(34, 'LC267714', NULL, 0, 20, 2, 39),
(35, 'LC267494', NULL, 0, 20, 2, 40);

-- --------------------------------------------------------

--
-- Table structure for table `lecturer_subjects`
--

CREATE TABLE `lecturer_subjects` (
  `id` int NOT NULL,
  `is_lead` tinyint(1) NOT NULL,
  `user_id` int NOT NULL,
  `subject_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `lecturer_subjects`
--

INSERT INTO `lecturer_subjects` (`id`, `is_lead`, `user_id`, `subject_id`) VALUES
(1, 0, 30, 69),
(2, 0, 30, 73),
(3, 0, 30, 46),
(4, 0, 30, 70),
(5, 0, 30, 18),
(16, 0, 31, 10),
(17, 0, 31, 70),
(18, 0, 31, 74),
(19, 0, 31, 18),
(20, 0, 31, 75),
(21, 0, 32, 87),
(22, 0, 32, 11),
(23, 0, 32, 77),
(24, 0, 32, 65),
(25, 0, 32, 54),
(26, 0, 33, 40),
(27, 0, 33, 1),
(28, 0, 33, 88),
(29, 0, 33, 39),
(30, 0, 33, 61),
(31, 0, 34, 78),
(32, 0, 34, 71),
(33, 0, 34, 84),
(34, 0, 34, 66),
(35, 0, 34, 12),
(36, 0, 35, 47),
(37, 0, 35, 55),
(38, 0, 35, 3),
(39, 0, 35, 48),
(40, 0, 35, 91),
(41, 0, 36, 14),
(42, 0, 36, 25),
(43, 0, 36, 63),
(44, 0, 36, 27),
(45, 0, 36, 28),
(46, 0, 37, 6),
(47, 0, 37, 7),
(48, 0, 37, 26),
(49, 0, 37, 20),
(50, 0, 37, 15),
(51, 0, 38, 21),
(52, 0, 38, 90),
(53, 0, 38, 50),
(54, 0, 38, 67),
(55, 0, 38, 33),
(56, 0, 39, 49),
(57, 0, 39, 79),
(58, 0, 39, 42),
(59, 0, 39, 85),
(60, 0, 39, 58),
(61, 0, 40, 69),
(62, 0, 40, 75),
(63, 0, 40, 66),
(64, 0, 40, 3),
(65, 0, 40, 7),
(66, 0, 20, 49),
(67, 0, 20, 79),
(68, 0, 20, 42),
(69, 0, 20, 85),
(70, 0, 20, 58),
(71, 0, 21, 64),
(72, 0, 21, 8),
(73, 0, 21, 56),
(74, 0, 21, 4),
(75, 0, 21, 30),
(76, 0, 22, 76),
(77, 0, 22, 89),
(78, 0, 22, 34),
(79, 0, 22, 29),
(80, 0, 22, 80),
(81, 0, 23, 17),
(82, 0, 23, 35),
(83, 0, 23, 59),
(84, 0, 23, 36),
(85, 0, 23, 5),
(86, 0, 24, 16),
(87, 0, 24, 51),
(88, 0, 24, 57),
(89, 0, 24, 9),
(91, 0, 24, 22),
(92, 0, 25, 81),
(93, 0, 25, 23),
(94, 0, 25, 43),
(95, 0, 25, 86),
(96, 0, 25, 31),
(97, 0, 26, 37),
(98, 0, 26, 60),
(99, 0, 26, 24),
(100, 0, 26, 52),
(101, 0, 26, 38),
(102, 0, 27, 83),
(103, 0, 27, 52),
(104, 0, 27, 53),
(105, 0, 27, 44),
(106, 0, 27, 72),
(108, 0, 28, 59),
(109, 0, 28, 45),
(110, 0, 28, 68),
(111, 0, 28, 26),
(112, 0, 28, 7),
(113, 0, 29, 77),
(114, 0, 29, 33),
(115, 0, 29, 40),
(116, 0, 29, 87),
(117, 0, 29, 75),
(118, 0, 31, 2),
(119, 0, 35, 19);

-- --------------------------------------------------------

--
-- Table structure for table `session`
--

CREATE TABLE `session` (
  `session_id` int NOT NULL,
  `start_time` time(6) NOT NULL,
  `end_time` time(6) NOT NULL,
  `day_of_week` varchar(3) NOT NULL,
  `facility_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `session`
--

INSERT INTO `session` (`session_id`, `start_time`, `end_time`, `day_of_week`, `facility_id`) VALUES
(1, '08:30:00.000000', '10:30:00.000000', 'Fri', 7),
(2, '10:45:00.000000', '12:45:00.000000', 'Fri', 7),
(3, '13:30:00.000000', '15:30:00.000000', 'Fri', 7),
(4, '15:45:00.000000', '17:45:00.000000', 'Fri', 7),
(5, '08:30:00.000000', '10:30:00.000000', 'Thu', 7),
(6, '10:45:00.000000', '12:45:00.000000', 'Thu', 7),
(7, '13:30:00.000000', '15:30:00.000000', 'Thu', 7),
(8, '15:45:00.000000', '17:45:00.000000', 'Thu', 7),
(9, '08:30:00.000000', '10:30:00.000000', 'Wed', 7),
(10, '10:45:00.000000', '12:45:00.000000', 'Wed', 7),
(11, '13:30:00.000000', '15:30:00.000000', 'Wed', 7),
(12, '15:45:00.000000', '17:45:00.000000', 'Wed', 7),
(13, '08:30:00.000000', '10:30:00.000000', 'Tue', 7),
(14, '10:45:00.000000', '12:45:00.000000', 'Tue', 7),
(15, '13:30:00.000000', '15:30:00.000000', 'Tue', 7),
(16, '15:45:00.000000', '17:45:00.000000', 'Tue', 7),
(17, '08:30:00.000000', '10:30:00.000000', 'Mon', 7),
(18, '10:45:00.000000', '12:45:00.000000', 'Mon', 7),
(19, '13:30:00.000000', '15:30:00.000000', 'Mon', 7),
(20, '15:45:00.000000', '17:45:00.000000', 'Mon', 7),
(21, '08:30:00.000000', '10:30:00.000000', 'Fri', 8),
(22, '10:45:00.000000', '12:45:00.000000', 'Fri', 8),
(23, '13:30:00.000000', '15:30:00.000000', 'Fri', 8),
(24, '15:45:00.000000', '17:45:00.000000', 'Fri', 8),
(25, '08:30:00.000000', '10:30:00.000000', 'Thu', 8),
(26, '10:45:00.000000', '12:45:00.000000', 'Thu', 8),
(27, '13:30:00.000000', '15:30:00.000000', 'Thu', 8),
(28, '15:45:00.000000', '17:45:00.000000', 'Thu', 8),
(29, '08:30:00.000000', '10:30:00.000000', 'Wed', 8),
(30, '10:45:00.000000', '12:45:00.000000', 'Wed', 8),
(31, '13:30:00.000000', '15:30:00.000000', 'Wed', 8),
(32, '15:45:00.000000', '17:45:00.000000', 'Wed', 8),
(33, '08:30:00.000000', '10:30:00.000000', 'Tue', 8),
(34, '10:45:00.000000', '12:45:00.000000', 'Tue', 8),
(35, '13:30:00.000000', '15:30:00.000000', 'Tue', 8),
(36, '15:45:00.000000', '17:45:00.000000', 'Tue', 8),
(37, '08:30:00.000000', '10:30:00.000000', 'Mon', 8),
(38, '10:45:00.000000', '12:45:00.000000', 'Mon', 8),
(39, '13:30:00.000000', '15:30:00.000000', 'Mon', 8),
(40, '15:45:00.000000', '17:45:00.000000', 'Mon', 8),
(41, '08:30:00.000000', '10:30:00.000000', 'Fri', 1),
(42, '10:45:00.000000', '12:45:00.000000', 'Fri', 1),
(43, '13:30:00.000000', '15:30:00.000000', 'Fri', 1),
(44, '15:45:00.000000', '17:45:00.000000', 'Fri', 1),
(45, '08:30:00.000000', '10:30:00.000000', 'Thu', 1),
(46, '10:45:00.000000', '12:45:00.000000', 'Thu', 1),
(47, '13:30:00.000000', '15:30:00.000000', 'Thu', 1),
(48, '15:45:00.000000', '17:45:00.000000', 'Thu', 1),
(49, '08:30:00.000000', '10:30:00.000000', 'Wed', 1),
(50, '10:45:00.000000', '12:45:00.000000', 'Wed', 1),
(51, '13:30:00.000000', '15:30:00.000000', 'Wed', 1),
(52, '15:45:00.000000', '17:45:00.000000', 'Wed', 1),
(53, '08:30:00.000000', '10:30:00.000000', 'Tue', 1),
(54, '10:45:00.000000', '12:45:00.000000', 'Tue', 1),
(55, '13:30:00.000000', '15:30:00.000000', 'Tue', 1),
(56, '15:45:00.000000', '17:45:00.000000', 'Tue', 1),
(57, '08:30:00.000000', '10:30:00.000000', 'Mon', 1),
(58, '10:45:00.000000', '12:45:00.000000', 'Mon', 1),
(59, '13:30:00.000000', '15:30:00.000000', 'Mon', 1),
(60, '15:45:00.000000', '17:45:00.000000', 'Mon', 1),
(61, '08:30:00.000000', '10:30:00.000000', 'Fri', 2),
(62, '10:45:00.000000', '12:45:00.000000', 'Fri', 2),
(63, '13:30:00.000000', '15:30:00.000000', 'Fri', 2),
(64, '15:45:00.000000', '17:45:00.000000', 'Fri', 2),
(65, '08:30:00.000000', '10:30:00.000000', 'Thu', 2),
(66, '10:45:00.000000', '12:45:00.000000', 'Thu', 2),
(67, '13:30:00.000000', '15:30:00.000000', 'Thu', 2),
(68, '15:45:00.000000', '17:45:00.000000', 'Thu', 2),
(69, '08:30:00.000000', '10:30:00.000000', 'Wed', 2),
(70, '10:45:00.000000', '12:45:00.000000', 'Wed', 2),
(71, '13:30:00.000000', '15:30:00.000000', 'Wed', 2),
(72, '15:45:00.000000', '17:45:00.000000', 'Wed', 2),
(73, '08:30:00.000000', '10:30:00.000000', 'Tue', 2),
(74, '10:45:00.000000', '12:45:00.000000', 'Tue', 2),
(75, '13:30:00.000000', '15:30:00.000000', 'Tue', 2),
(76, '15:45:00.000000', '17:45:00.000000', 'Tue', 2),
(77, '08:30:00.000000', '10:30:00.000000', 'Mon', 2),
(78, '10:45:00.000000', '12:45:00.000000', 'Mon', 2),
(79, '13:30:00.000000', '15:30:00.000000', 'Mon', 2),
(80, '15:45:00.000000', '17:45:00.000000', 'Mon', 2),
(81, '08:30:00.000000', '10:30:00.000000', 'Fri', 3),
(82, '10:45:00.000000', '12:45:00.000000', 'Fri', 3),
(83, '13:30:00.000000', '15:30:00.000000', 'Fri', 3),
(84, '15:45:00.000000', '17:45:00.000000', 'Fri', 3),
(85, '08:30:00.000000', '10:30:00.000000', 'Thu', 3),
(86, '10:45:00.000000', '12:45:00.000000', 'Thu', 3),
(87, '13:30:00.000000', '15:30:00.000000', 'Thu', 3),
(88, '15:45:00.000000', '17:45:00.000000', 'Thu', 3),
(89, '08:30:00.000000', '10:30:00.000000', 'Wed', 3),
(90, '10:45:00.000000', '12:45:00.000000', 'Wed', 3),
(91, '13:30:00.000000', '15:30:00.000000', 'Wed', 3),
(92, '15:45:00.000000', '17:45:00.000000', 'Wed', 3),
(93, '08:30:00.000000', '10:30:00.000000', 'Tue', 3),
(94, '10:45:00.000000', '12:45:00.000000', 'Tue', 3),
(95, '13:30:00.000000', '15:30:00.000000', 'Tue', 3),
(96, '15:45:00.000000', '17:45:00.000000', 'Tue', 3),
(97, '08:30:00.000000', '10:30:00.000000', 'Mon', 3),
(98, '10:45:00.000000', '12:45:00.000000', 'Mon', 3),
(99, '13:30:00.000000', '15:30:00.000000', 'Mon', 3),
(100, '15:45:00.000000', '17:45:00.000000', 'Mon', 3),
(101, '08:30:00.000000', '10:30:00.000000', 'Fri', 4),
(102, '10:45:00.000000', '12:45:00.000000', 'Fri', 4),
(103, '13:30:00.000000', '15:30:00.000000', 'Fri', 4),
(104, '15:45:00.000000', '17:45:00.000000', 'Fri', 4),
(105, '08:30:00.000000', '10:30:00.000000', 'Thu', 4),
(106, '10:45:00.000000', '12:45:00.000000', 'Thu', 4),
(107, '13:30:00.000000', '15:30:00.000000', 'Thu', 4),
(108, '15:45:00.000000', '17:45:00.000000', 'Thu', 4),
(109, '08:30:00.000000', '10:30:00.000000', 'Wed', 4),
(110, '10:45:00.000000', '12:45:00.000000', 'Wed', 4),
(111, '13:30:00.000000', '15:30:00.000000', 'Wed', 4),
(112, '15:45:00.000000', '17:45:00.000000', 'Wed', 4),
(113, '08:30:00.000000', '10:30:00.000000', 'Tue', 4),
(114, '10:45:00.000000', '12:45:00.000000', 'Tue', 4),
(115, '13:30:00.000000', '15:30:00.000000', 'Tue', 4),
(116, '15:45:00.000000', '17:45:00.000000', 'Tue', 4),
(117, '08:30:00.000000', '10:30:00.000000', 'Mon', 4),
(118, '10:45:00.000000', '12:45:00.000000', 'Mon', 4),
(119, '13:30:00.000000', '15:30:00.000000', 'Mon', 4),
(120, '15:45:00.000000', '17:45:00.000000', 'Mon', 4),
(121, '08:30:00.000000', '10:30:00.000000', 'Fri', 5),
(122, '10:45:00.000000', '12:45:00.000000', 'Fri', 5),
(123, '13:30:00.000000', '15:30:00.000000', 'Fri', 5),
(124, '15:45:00.000000', '17:45:00.000000', 'Fri', 5),
(125, '08:30:00.000000', '10:30:00.000000', 'Thu', 5),
(126, '10:45:00.000000', '12:45:00.000000', 'Thu', 5),
(127, '13:30:00.000000', '15:30:00.000000', 'Thu', 5),
(128, '15:45:00.000000', '17:45:00.000000', 'Thu', 5),
(129, '08:30:00.000000', '10:30:00.000000', 'Wed', 5),
(130, '10:45:00.000000', '12:45:00.000000', 'Wed', 5),
(131, '13:30:00.000000', '15:30:00.000000', 'Wed', 5),
(132, '15:45:00.000000', '17:45:00.000000', 'Wed', 5),
(133, '08:30:00.000000', '10:30:00.000000', 'Tue', 5),
(134, '10:45:00.000000', '12:45:00.000000', 'Tue', 5),
(135, '13:30:00.000000', '15:30:00.000000', 'Tue', 5),
(136, '15:45:00.000000', '17:45:00.000000', 'Tue', 5),
(137, '08:30:00.000000', '10:30:00.000000', 'Mon', 5),
(138, '10:45:00.000000', '12:45:00.000000', 'Mon', 5),
(139, '13:30:00.000000', '15:30:00.000000', 'Mon', 5),
(140, '15:45:00.000000', '17:45:00.000000', 'Mon', 5),
(141, '08:30:00.000000', '10:30:00.000000', 'Fri', 6),
(142, '10:45:00.000000', '12:45:00.000000', 'Fri', 6),
(143, '13:30:00.000000', '15:30:00.000000', 'Fri', 6),
(144, '15:45:00.000000', '17:45:00.000000', 'Fri', 6),
(145, '08:30:00.000000', '10:30:00.000000', 'Thu', 6),
(146, '10:45:00.000000', '12:45:00.000000', 'Thu', 6),
(147, '13:30:00.000000', '15:30:00.000000', 'Thu', 6),
(148, '15:45:00.000000', '17:45:00.000000', 'Thu', 6),
(149, '08:30:00.000000', '10:30:00.000000', 'Wed', 6),
(150, '10:45:00.000000', '12:45:00.000000', 'Wed', 6),
(151, '13:30:00.000000', '15:30:00.000000', 'Wed', 6),
(152, '15:45:00.000000', '17:45:00.000000', 'Wed', 6),
(153, '08:30:00.000000', '10:30:00.000000', 'Tue', 6),
(154, '10:45:00.000000', '12:45:00.000000', 'Tue', 6),
(155, '13:30:00.000000', '15:30:00.000000', 'Tue', 6),
(156, '15:45:00.000000', '17:45:00.000000', 'Tue', 6),
(157, '08:30:00.000000', '10:30:00.000000', 'Mon', 6),
(158, '10:45:00.000000', '12:45:00.000000', 'Mon', 6),
(159, '13:30:00.000000', '15:30:00.000000', 'Mon', 6),
(160, '15:45:00.000000', '17:45:00.000000', 'Mon', 6),
(161, '08:30:00.000000', '10:30:00.000000', 'Fri', 9),
(162, '10:45:00.000000', '12:45:00.000000', 'Fri', 9),
(163, '13:30:00.000000', '15:30:00.000000', 'Fri', 9),
(164, '15:45:00.000000', '17:45:00.000000', 'Fri', 9),
(165, '08:30:00.000000', '10:30:00.000000', 'Thu', 9),
(166, '10:45:00.000000', '12:45:00.000000', 'Thu', 9),
(167, '13:30:00.000000', '15:30:00.000000', 'Thu', 9),
(168, '15:45:00.000000', '17:45:00.000000', 'Thu', 9),
(169, '08:30:00.000000', '10:30:00.000000', 'Wed', 9),
(170, '10:45:00.000000', '12:45:00.000000', 'Wed', 9),
(171, '13:30:00.000000', '15:30:00.000000', 'Wed', 9),
(172, '15:45:00.000000', '17:45:00.000000', 'Wed', 9),
(173, '08:30:00.000000', '10:30:00.000000', 'Tue', 9),
(174, '10:45:00.000000', '12:45:00.000000', 'Tue', 9),
(175, '13:30:00.000000', '15:30:00.000000', 'Tue', 9),
(176, '15:45:00.000000', '17:45:00.000000', 'Tue', 9),
(177, '08:30:00.000000', '10:30:00.000000', 'Mon', 9),
(178, '10:45:00.000000', '12:45:00.000000', 'Mon', 9),
(179, '13:30:00.000000', '15:30:00.000000', 'Mon', 9),
(180, '15:45:00.000000', '17:45:00.000000', 'Mon', 9),
(181, '08:30:00.000000', '10:30:00.000000', 'Fri', 10),
(182, '10:45:00.000000', '12:45:00.000000', 'Fri', 10),
(183, '13:30:00.000000', '15:30:00.000000', 'Fri', 10),
(184, '15:45:00.000000', '17:45:00.000000', 'Fri', 10),
(185, '08:30:00.000000', '10:30:00.000000', 'Thu', 10),
(186, '10:45:00.000000', '12:45:00.000000', 'Thu', 10),
(187, '13:30:00.000000', '15:30:00.000000', 'Thu', 10),
(188, '15:45:00.000000', '17:45:00.000000', 'Thu', 10),
(189, '08:30:00.000000', '10:30:00.000000', 'Wed', 10),
(190, '10:45:00.000000', '12:45:00.000000', 'Wed', 10),
(191, '13:30:00.000000', '15:30:00.000000', 'Wed', 10),
(192, '15:45:00.000000', '17:45:00.000000', 'Wed', 10),
(193, '08:30:00.000000', '10:30:00.000000', 'Tue', 10),
(194, '10:45:00.000000', '12:45:00.000000', 'Tue', 10),
(195, '13:30:00.000000', '15:30:00.000000', 'Tue', 10),
(196, '15:45:00.000000', '17:45:00.000000', 'Tue', 10),
(197, '08:30:00.000000', '10:30:00.000000', 'Mon', 10),
(198, '10:45:00.000000', '12:45:00.000000', 'Mon', 10),
(199, '13:30:00.000000', '15:30:00.000000', 'Mon', 10),
(200, '15:45:00.000000', '17:45:00.000000', 'Mon', 10);

-- --------------------------------------------------------

--
-- Table structure for table `skipped_date`
--

CREATE TABLE `skipped_date` (
  `id` int NOT NULL,
  `date` date NOT NULL,
  `reason` varchar(255) NOT NULL,
  `term_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `student_profiles`
--

CREATE TABLE `student_profiles` (
  `id` int NOT NULL,
  `tp_id` varchar(12) NOT NULL,
  `user_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `student_profiles`
--

INSERT INTO `student_profiles` (`id`, `tp_id`, `user_id`) VALUES
(5, 'TP262993', 19),
(6, 'TP261093', 45),
(7, 'TP262280', 46),
(8, 'TP266752', 47),
(9, 'TP262800', 48),
(10, 'TP266706', 49),
(11, 'TP265355', 50),
(12, 'TP261853', 51),
(13, 'TP267094', 52),
(14, 'TP266492', 53),
(15, 'TP269483', 54);

-- --------------------------------------------------------

--
-- Table structure for table `subject`
--

CREATE TABLE `subject` (
  `subject_id` int NOT NULL,
  `subject_code` varchar(20) NOT NULL,
  `subject_name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `subject`
--

INSERT INTO `subject` (`subject_id`, `subject_code`, `subject_name`) VALUES
(1, 'CS', 'Communication Skills'),
(2, 'EAP', 'English For Academic Purposes'),
(3, 'EWA', 'Essential Of Web Applications'),
(4, 'MATH', 'Mathematics'),
(5, 'PDSM', 'Personal Development And Study Methods'),
(6, 'IB', 'Introduction To Business'),
(7, 'ICAN', 'Introduction To Computer Architecture And Networking'),
(8, 'IVIP', 'Introduction To Visual & Interactive Programming'),
(9, 'PSE', 'Public Speaking English'),
(10, 'ARS', 'Academic Research Skills'),
(11, 'CC', 'Co Curriculum (Foundation)'),
(12, 'DMDA', 'Discovering Media In The Digital Age'),
(13, 'FHT', 'Fundamentals Of Hospitality And Tourism'),
(14, 'FM', 'Further Mathematics'),
(15, 'IMA', 'Introduction To Multimedia Application'),
(16, 'PIT', 'Perspectives In Technology'),
(17, 'PBS', 'Psychology And Behavioural Science'),
(18, 'BMK2', 'Bahasa Melayu Komunikasi 2'),
(19, 'DTI', 'Digital Thinking And Innovation'),
(20, 'IDB', 'Introduction To Database'),
(21, 'INET', 'Introduction To Networking'),
(22, 'PEP', 'Penghayatan Etika Dan Peradaban'),
(23, 'PY', 'Python Programming'),
(24, 'SSCC', 'System Software And Computing Concepts'),
(25, 'FOE', 'Fundamentals Of Entrepreneurship'),
(26, 'ICS', 'Integrated Computer Systems'),
(27, 'IAC', 'Integrity And Anti Corruption'),
(28, 'IAI', 'Introduction To Artificial Intelligence'),
(29, 'OOP', 'Introduction To Object Oriented Programming'),
(30, 'MCC', 'Mathematical Concept For Computing'),
(31, 'SAD', 'Systems Analysis & Design'),
(32, 'AIM', 'AI Methods'),
(33, 'IP', 'Innovation Processes'),
(34, 'OODJ', 'Object Oriented Development With Java'),
(35, 'PCI', 'Philosophy And Current Issues'),
(36, 'PDA', 'Programming For Data Analysis'),
(37, 'SNA', 'System & Network Administration'),
(38, 'SDM', 'System Development Methods'),
(39, 'CSLLT', 'Computer System Low Level Techniques'),
(40, 'CP', 'Concurrent Programming'),
(41, 'DS', 'Data Structures'),
(42, 'ISEIMG', 'Imaging & Special Effects'),
(43, 'RMCT', 'Research Methods For Computing And Technology'),
(44, 'WA', 'Web Applications'),
(45, 'WPS', 'Workplace Professional Skills'),
(46, 'ALG', 'Algorithmics'),
(47, 'EPDA', 'Enterprise Programming For Distributed Application'),
(48, 'FAI', 'Further Artificial Intelligence'),
(49, 'IPCVPR', 'Image Processing Computer Vision And Pattern Recognition'),
(50, 'INV', 'Investigation'),
(51, 'PM', 'Project Management'),
(52, 'TASA', 'Text Analytics And Sentiment Analysis'),
(53, 'VB', 'Venture Building'),
(54, 'CIMO', 'Critical Issues in MIS Organizations'),
(55, 'ET', 'Emergent Technology'),
(56, 'KDBDA', 'Knowledge Discovery & Big Data Analytics'),
(57, 'PROJ', 'Project'),
(58, 'ISFT', 'Introduction To Security And Forensic Technologies'),
(59, 'PCTF', 'Practical CTF Strategies'),
(60, 'SRE', 'Switching And Routing Essentials'),
(61, 'CT', 'Computing Theory'),
(62, 'EHIR', 'Ethical Hacking & Incidence Response'),
(63, 'HCI', 'Human Computer Interaction'),
(64, 'ISS', 'Implementation Of Secure Systems'),
(65, 'CIAS', 'Cloud Infrastructure And Services'),
(66, 'DLID', 'Deep Learning For Intrusion Detection'),
(67, 'IOTCA', 'Internet Of Things Concepts & Applications'),
(68, 'VAPT', 'Vulnerability Assessment And Penetration Testing'),
(69, 'ACS', 'Advanced Cyber Security'),
(70, 'ASS', 'Advanced Software Security'),
(71, 'DBS', 'Database Security'),
(72, 'WMS', 'Wireless And Mobile Security'),
(73, 'AEC', 'Appreciation Of Ethics And Civilizations'),
(74, 'BMK1', 'Bahasa Melayu Komunikasi 1'),
(75, 'CA', 'Computer Architecture'),
(76, 'MSC', 'Mathematics And Statistics For Computing'),
(77, 'CCM', 'Co Curricular Module'),
(78, 'DBM', 'Database Management'),
(79, 'ISCC', 'Information Systems With Cloud Concepts'),
(80, 'OS', 'Operating Systems'),
(81, 'PWP', 'Programming With Python'),
(82, 'ADM', 'Algebra And Discrete Mathematics'),
(83, 'UIUX', 'Fundamentals Of UI UX Design'),
(84, 'DLCD', 'DevOps And Low Code Development'),
(85, 'ISESWE', 'Introduction To Software Engineering'),
(86, 'RWDD', 'Responsive Web Design And Development'),
(87, 'CAP', 'Capstone Project'),
(88, 'CSF', 'Cyber Security And Forensics'),
(89, 'NT', 'Networking Technologies'),
(90, 'INTN', 'Internship'),
(91, 'FARS', 'Academic Research Skills (Foundation)');

-- --------------------------------------------------------

--
-- Table structure for table `timetable_preference`
--

CREATE TABLE `timetable_preference` (
  `id` int NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `lecturer_id` int NOT NULL,
  `session_id` int NOT NULL,
  `subject_id` int NOT NULL,
  `term_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `timetable_preference`
--

INSERT INTO `timetable_preference` (`id`, `is_active`, `lecturer_id`, `session_id`, `subject_id`, `term_id`) VALUES
(1, 1, 33, 49, 1, 1),
(2, 1, 31, 70, 2, 1),
(3, 1, 35, 93, 3, 1),
(4, 1, 21, 114, 4, 1),
(5, 1, 23, 125, 5, 1),
(6, 1, 33, 141, 1, 1),
(7, 1, 31, 2, 2, 1),
(8, 1, 21, 26, 4, 1),
(9, 1, 23, 43, 5, 1),
(10, 1, 35, 167, 3, 1),
(11, 1, 31, 49, 10, 2),
(12, 1, 35, 70, 19, 2),
(13, 1, 30, 93, 73, 2),
(14, 1, 31, 114, 74, 2),
(15, 1, 31, 125, 75, 2),
(16, 1, 22, 146, 76, 2),
(17, 1, 31, 41, 10, 2),
(18, 1, 35, 62, 19, 2),
(19, 1, 31, 83, 75, 2),
(20, 1, 22, 104, 76, 2);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `academic_rules`
--
ALTER TABLE `academic_rules`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `academic_term`
--
ALTER TABLE `academic_term`
  ADD PRIMARY KEY (`term_id`),
  ADD KEY `academic_term_course_id_d7195d48_fk_course_course_id` (`course_id`);

--
-- Indexes for table `admin_profiles`
--
ALTER TABLE `admin_profiles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ad_id` (`ad_id`),
  ADD UNIQUE KEY `user_id` (`user_id`);

--
-- Indexes for table `auth_group`
--
ALTER TABLE `auth_group`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  ADD KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`);

--
-- Indexes for table `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`);

--
-- Indexes for table `auth_user`
--
ALTER TABLE `auth_user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  ADD KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`);

--
-- Indexes for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  ADD KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`);

--
-- Indexes for table `booking`
--
ALTER TABLE `booking`
  ADD PRIMARY KEY (`booking_id`),
  ADD KEY `booking_user_id_1bd7cb6e_fk_auth_user_id` (`user_id`),
  ADD KEY `booking_facility_id_42d1686e_fk_facilities_facility_id` (`facility_id`);

--
-- Indexes for table `campus_announcement`
--
ALTER TABLE `campus_announcement`
  ADD PRIMARY KEY (`announcement_id`),
  ADD KEY `campus_announcement_author_id_d318111a_fk_admin_profiles_id` (`author_id`);

--
-- Indexes for table `campus_announcementTarget`
--
ALTER TABLE `campus_announcementTarget`
  ADD PRIMARY KEY (`target_id`),
  ADD KEY `campus_announcementT_announcement_id_e00c8a39_fk_campus_an` (`announcement_id`);

--
-- Indexes for table `campus_attachments`
--
ALTER TABLE `campus_attachments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `campus_attachments_content_type_id_59434c3f_fk_django_co` (`content_type_id`);

--
-- Indexes for table `campus_attendanceMark`
--
ALTER TABLE `campus_attendanceMark`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `campus_attendanceMark_session_id_student_id_088e9a3f_uniq` (`session_id`,`student_id`),
  ADD KEY `campus_attendanceMark_student_id_41b3fc90_fk_auth_user_id` (`student_id`);

--
-- Indexes for table `campus_AttendanceSession`
--
ALTER TABLE `campus_AttendanceSession`
  ADD PRIMARY KEY (`id`),
  ADD KEY `campus_AttendanceSession_created_by_id_d4aa07a3_fk_auth_user_id` (`created_by_id`);

--
-- Indexes for table `campus_faq`
--
ALTER TABLE `campus_faq`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`),
  ADD KEY `campus_faq_author_id_40338233_fk_admin_profiles_id` (`author_id`);

--
-- Indexes for table `campus_faqreaction`
--
ALTER TABLE `campus_faqreaction`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `campus_faqreaction_faq_id_user_id_5459a873_uniq` (`faq_id`,`user_id`),
  ADD KEY `campus_faqreaction_user_id_fcac2efa_fk_auth_user_id` (`user_id`);

--
-- Indexes for table `campus_mapedge`
--
ALTER TABLE `campus_mapedge`
  ADD PRIMARY KEY (`id`),
  ADD KEY `campus_mapedge_from_node_id_38e6c578_fk_campus_mapnode_id` (`from_node_id`),
  ADD KEY `campus_mapedge_to_node_id_2d418755_fk_campus_mapnode_id` (`to_node_id`);

--
-- Indexes for table `campus_mapnode`
--
ALTER TABLE `campus_mapnode`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `node_id` (`node_id`);

--
-- Indexes for table `campus_subjectcomponent`
--
ALTER TABLE `campus_subjectcomponent`
  ADD PRIMARY KEY (`component_id`),
  ADD KEY `campus_subjectcompon_subject_id_1a51f80a_fk_subject_s` (`subject_id`);

--
-- Indexes for table `campus_supportticket`
--
ALTER TABLE `campus_supportticket`
  ADD PRIMARY KEY (`id`),
  ADD KEY `campus_supportticket_assigned_to_id_3f04047f_fk_auth_user_id` (`assigned_to_id`),
  ADD KEY `campus_supportticket_created_by_id_b8b775d6_fk_auth_user_id` (`created_by_id`);

--
-- Indexes for table `campus_ticketactivity`
--
ALTER TABLE `campus_ticketactivity`
  ADD PRIMARY KEY (`id`),
  ADD KEY `campus_ticketactivit_ticket_id_cb69c7b5_fk_campus_su` (`ticket_id`),
  ADD KEY `campus_ticketactivity_user_id_f186cdc8_fk_auth_user_id` (`user_id`);

--
-- Indexes for table `campus_ticketmessage`
--
ALTER TABLE `campus_ticketmessage`
  ADD PRIMARY KEY (`id`),
  ADD KEY `campus_ticketmessage_sender_id_2832b0bf_fk_auth_user_id` (`sender_id`),
  ADD KEY `campus_ticketmessage_ticket_id_598d09cd_fk_campus_su` (`ticket_id`);

--
-- Indexes for table `class_session`
--
ALTER TABLE `class_session`
  ADD PRIMARY KEY (`id`),
  ADD KEY `class_session_lecturer_id_e46e0ca8_fk_auth_user_id` (`lecturer_id`),
  ADD KEY `class_session_term_id_d48c351b_fk_academic_term_term_id` (`term_id`),
  ADD KEY `class_session_session_id_d7e4974d_fk_session_session_id` (`session_id`),
  ADD KEY `class_session_subject_component_id_4e50a4cf_fk_campus_su` (`subject_component_id`);

--
-- Indexes for table `course`
--
ALTER TABLE `course`
  ADD PRIMARY KEY (`course_id`),
  ADD UNIQUE KEY `course_code` (`course_code`),
  ADD KEY `course_dept_id_9e014c55_fk_departments_dept_id` (`dept_id`);

--
-- Indexes for table `course_enrollment`
--
ALTER TABLE `course_enrollment`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `student_id` (`student_id`),
  ADD KEY `course_enrollment_term_id_b4865087_fk_academic_term_term_id` (`term_id`);

--
-- Indexes for table `course_subject`
--
ALTER TABLE `course_subject`
  ADD PRIMARY KEY (`id`),
  ADD KEY `course_subject_course_id_217feed5_fk_course_course_id` (`course_id`),
  ADD KEY `course_subject_subject_id_938cf26b_fk_subject_subject_id` (`subject_id`);

--
-- Indexes for table `departments`
--
ALTER TABLE `departments`
  ADD PRIMARY KEY (`dept_id`),
  ADD UNIQUE KEY `dept_code` (`dept_code`),
  ADD UNIQUE KEY `head_id` (`head_id`);

--
-- Indexes for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  ADD KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`);

--
-- Indexes for table `django_content_type`
--
ALTER TABLE `django_content_type`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`);

--
-- Indexes for table `django_migrations`
--
ALTER TABLE `django_migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `django_session`
--
ALTER TABLE `django_session`
  ADD PRIMARY KEY (`session_key`),
  ADD KEY `django_session_expire_date_a5c62663` (`expire_date`);

--
-- Indexes for table `facilities`
--
ALTER TABLE `facilities`
  ADD PRIMARY KEY (`facility_id`),
  ADD UNIQUE KEY `facility_name` (`facility_name`);

--
-- Indexes for table `lecturer_assignment`
--
ALTER TABLE `lecturer_assignment`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `lecturer_assignment_term_id_subject_id_18e2672b_uniq` (`term_id`,`subject_id`),
  ADD KEY `lecturer_assignment_lecturer_id_2b0bbb97_fk_auth_user_id` (`lecturer_id`),
  ADD KEY `lecturer_assignment_subject_id_2c1fa45c_fk_subject_subject_id` (`subject_id`);

--
-- Indexes for table `lecturer_profiles`
--
ALTER TABLE `lecturer_profiles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `lc_id` (`lc_id`),
  ADD UNIQUE KEY `user_id` (`user_id`),
  ADD KEY `lecturer_profiles_dept_id_df93f1c7_fk_departments_dept_id` (`dept_id`);

--
-- Indexes for table `lecturer_subjects`
--
ALTER TABLE `lecturer_subjects`
  ADD PRIMARY KEY (`id`),
  ADD KEY `lecturer_subjects_user_id_c00072e6_fk_auth_user_id` (`user_id`),
  ADD KEY `lecturer_subjects_subject_id_7b9e00bf_fk_subject_subject_id` (`subject_id`);

--
-- Indexes for table `session`
--
ALTER TABLE `session`
  ADD PRIMARY KEY (`session_id`),
  ADD KEY `session_facility_id_1cd9cb0d_fk_facilities_facility_id` (`facility_id`);

--
-- Indexes for table `skipped_date`
--
ALTER TABLE `skipped_date`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `skipped_date_term_id_date_b3e1643b_uniq` (`term_id`,`date`);

--
-- Indexes for table `student_profiles`
--
ALTER TABLE `student_profiles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `tp_id` (`tp_id`),
  ADD UNIQUE KEY `user_id` (`user_id`);

--
-- Indexes for table `subject`
--
ALTER TABLE `subject`
  ADD PRIMARY KEY (`subject_id`),
  ADD UNIQUE KEY `subject_code` (`subject_code`);

--
-- Indexes for table `timetable_preference`
--
ALTER TABLE `timetable_preference`
  ADD PRIMARY KEY (`id`),
  ADD KEY `timetable_preference_lecturer_id_d227f3b4_fk_auth_user_id` (`lecturer_id`),
  ADD KEY `timetable_preference_session_id_2fe4a9eb_fk_session_session_id` (`session_id`),
  ADD KEY `timetable_preference_subject_id_cb2b0190_fk_subject_subject_id` (`subject_id`),
  ADD KEY `timetable_preference_term_id_1e4decd7_fk_academic_term_term_id` (`term_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `academic_rules`
--
ALTER TABLE `academic_rules`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `academic_term`
--
ALTER TABLE `academic_term`
  MODIFY `term_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `admin_profiles`
--
ALTER TABLE `admin_profiles`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `auth_group`
--
ALTER TABLE `auth_group`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_permission`
--
ALTER TABLE `auth_permission`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=153;

--
-- AUTO_INCREMENT for table `auth_user`
--
ALTER TABLE `auth_user`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55;

--
-- AUTO_INCREMENT for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=119;

--
-- AUTO_INCREMENT for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `booking`
--
ALTER TABLE `booking`
  MODIFY `booking_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `campus_announcement`
--
ALTER TABLE `campus_announcement`
  MODIFY `announcement_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `campus_announcementTarget`
--
ALTER TABLE `campus_announcementTarget`
  MODIFY `target_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `campus_attachments`
--
ALTER TABLE `campus_attachments`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `campus_attendanceMark`
--
ALTER TABLE `campus_attendanceMark`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `campus_AttendanceSession`
--
ALTER TABLE `campus_AttendanceSession`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `campus_faq`
--
ALTER TABLE `campus_faq`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `campus_faqreaction`
--
ALTER TABLE `campus_faqreaction`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `campus_mapedge`
--
ALTER TABLE `campus_mapedge`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `campus_mapnode`
--
ALTER TABLE `campus_mapnode`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `campus_subjectcomponent`
--
ALTER TABLE `campus_subjectcomponent`
  MODIFY `component_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=170;

--
-- AUTO_INCREMENT for table `campus_supportticket`
--
ALTER TABLE `campus_supportticket`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `campus_ticketactivity`
--
ALTER TABLE `campus_ticketactivity`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `campus_ticketmessage`
--
ALTER TABLE `campus_ticketmessage`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT for table `class_session`
--
ALTER TABLE `class_session`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `course`
--
ALTER TABLE `course`
  MODIFY `course_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `course_enrollment`
--
ALTER TABLE `course_enrollment`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `course_subject`
--
ALTER TABLE `course_subject`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=163;

--
-- AUTO_INCREMENT for table `departments`
--
ALTER TABLE `departments`
  MODIFY `dept_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `django_content_type`
--
ALTER TABLE `django_content_type`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT for table `django_migrations`
--
ALTER TABLE `django_migrations`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=56;

--
-- AUTO_INCREMENT for table `facilities`
--
ALTER TABLE `facilities`
  MODIFY `facility_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `lecturer_assignment`
--
ALTER TABLE `lecturer_assignment`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `lecturer_profiles`
--
ALTER TABLE `lecturer_profiles`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT for table `lecturer_subjects`
--
ALTER TABLE `lecturer_subjects`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=120;

--
-- AUTO_INCREMENT for table `session`
--
ALTER TABLE `session`
  MODIFY `session_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=201;

--
-- AUTO_INCREMENT for table `skipped_date`
--
ALTER TABLE `skipped_date`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `student_profiles`
--
ALTER TABLE `student_profiles`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `subject`
--
ALTER TABLE `subject`
  MODIFY `subject_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=92;

--
-- AUTO_INCREMENT for table `timetable_preference`
--
ALTER TABLE `timetable_preference`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `academic_term`
--
ALTER TABLE `academic_term`
  ADD CONSTRAINT `academic_term_course_id_d7195d48_fk_course_course_id` FOREIGN KEY (`course_id`) REFERENCES `course` (`course_id`);

--
-- Constraints for table `admin_profiles`
--
ALTER TABLE `admin_profiles`
  ADD CONSTRAINT `admin_profiles_user_id_13be83a2_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`);

--
-- Constraints for table `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`);

--
-- Constraints for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  ADD CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  ADD CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  ADD CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `booking`
--
ALTER TABLE `booking`
  ADD CONSTRAINT `booking_facility_id_42d1686e_fk_facilities_facility_id` FOREIGN KEY (`facility_id`) REFERENCES `facilities` (`facility_id`),
  ADD CONSTRAINT `booking_user_id_1bd7cb6e_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `campus_announcement`
--
ALTER TABLE `campus_announcement`
  ADD CONSTRAINT `campus_announcement_author_id_d318111a_fk_admin_profiles_id` FOREIGN KEY (`author_id`) REFERENCES `admin_profiles` (`id`);

--
-- Constraints for table `campus_announcementTarget`
--
ALTER TABLE `campus_announcementTarget`
  ADD CONSTRAINT `campus_announcementT_announcement_id_e00c8a39_fk_campus_an` FOREIGN KEY (`announcement_id`) REFERENCES `campus_announcement` (`announcement_id`);

--
-- Constraints for table `campus_attachments`
--
ALTER TABLE `campus_attachments`
  ADD CONSTRAINT `campus_attachments_content_type_id_59434c3f_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`);

--
-- Constraints for table `campus_attendanceMark`
--
ALTER TABLE `campus_attendanceMark`
  ADD CONSTRAINT `campus_attendanceMar_session_id_194ff134_fk_campus_At` FOREIGN KEY (`session_id`) REFERENCES `campus_AttendanceSession` (`id`),
  ADD CONSTRAINT `campus_attendanceMark_student_id_41b3fc90_fk_auth_user_id` FOREIGN KEY (`student_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `campus_AttendanceSession`
--
ALTER TABLE `campus_AttendanceSession`
  ADD CONSTRAINT `campus_AttendanceSession_created_by_id_d4aa07a3_fk_auth_user_id` FOREIGN KEY (`created_by_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `campus_faq`
--
ALTER TABLE `campus_faq`
  ADD CONSTRAINT `campus_faq_author_id_40338233_fk_admin_profiles_id` FOREIGN KEY (`author_id`) REFERENCES `admin_profiles` (`id`);

--
-- Constraints for table `campus_faqreaction`
--
ALTER TABLE `campus_faqreaction`
  ADD CONSTRAINT `campus_faqreaction_faq_id_1978d533_fk_campus_faq_id` FOREIGN KEY (`faq_id`) REFERENCES `campus_faq` (`id`),
  ADD CONSTRAINT `campus_faqreaction_user_id_fcac2efa_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `campus_mapedge`
--
ALTER TABLE `campus_mapedge`
  ADD CONSTRAINT `campus_mapedge_from_node_id_38e6c578_fk_campus_mapnode_id` FOREIGN KEY (`from_node_id`) REFERENCES `campus_mapnode` (`id`),
  ADD CONSTRAINT `campus_mapedge_to_node_id_2d418755_fk_campus_mapnode_id` FOREIGN KEY (`to_node_id`) REFERENCES `campus_mapnode` (`id`);

--
-- Constraints for table `campus_subjectcomponent`
--
ALTER TABLE `campus_subjectcomponent`
  ADD CONSTRAINT `campus_subjectcompon_subject_id_1a51f80a_fk_subject_s` FOREIGN KEY (`subject_id`) REFERENCES `subject` (`subject_id`);

--
-- Constraints for table `campus_supportticket`
--
ALTER TABLE `campus_supportticket`
  ADD CONSTRAINT `campus_supportticket_assigned_to_id_3f04047f_fk_auth_user_id` FOREIGN KEY (`assigned_to_id`) REFERENCES `auth_user` (`id`),
  ADD CONSTRAINT `campus_supportticket_created_by_id_b8b775d6_fk_auth_user_id` FOREIGN KEY (`created_by_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `campus_ticketactivity`
--
ALTER TABLE `campus_ticketactivity`
  ADD CONSTRAINT `campus_ticketactivit_ticket_id_cb69c7b5_fk_campus_su` FOREIGN KEY (`ticket_id`) REFERENCES `campus_supportticket` (`id`),
  ADD CONSTRAINT `campus_ticketactivity_user_id_f186cdc8_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `campus_ticketmessage`
--
ALTER TABLE `campus_ticketmessage`
  ADD CONSTRAINT `campus_ticketmessage_sender_id_2832b0bf_fk_auth_user_id` FOREIGN KEY (`sender_id`) REFERENCES `auth_user` (`id`),
  ADD CONSTRAINT `campus_ticketmessage_ticket_id_598d09cd_fk_campus_su` FOREIGN KEY (`ticket_id`) REFERENCES `campus_supportticket` (`id`);

--
-- Constraints for table `class_session`
--
ALTER TABLE `class_session`
  ADD CONSTRAINT `class_session_lecturer_id_e46e0ca8_fk_auth_user_id` FOREIGN KEY (`lecturer_id`) REFERENCES `auth_user` (`id`),
  ADD CONSTRAINT `class_session_session_id_d7e4974d_fk_session_session_id` FOREIGN KEY (`session_id`) REFERENCES `session` (`session_id`),
  ADD CONSTRAINT `class_session_subject_component_id_4e50a4cf_fk_campus_su` FOREIGN KEY (`subject_component_id`) REFERENCES `campus_subjectcomponent` (`component_id`),
  ADD CONSTRAINT `class_session_term_id_d48c351b_fk_academic_term_term_id` FOREIGN KEY (`term_id`) REFERENCES `academic_term` (`term_id`);

--
-- Constraints for table `course`
--
ALTER TABLE `course`
  ADD CONSTRAINT `course_dept_id_9e014c55_fk_departments_dept_id` FOREIGN KEY (`dept_id`) REFERENCES `departments` (`dept_id`);

--
-- Constraints for table `course_enrollment`
--
ALTER TABLE `course_enrollment`
  ADD CONSTRAINT `course_enrollment_student_id_5b9d7470_fk_auth_user_id` FOREIGN KEY (`student_id`) REFERENCES `auth_user` (`id`),
  ADD CONSTRAINT `course_enrollment_term_id_b4865087_fk_academic_term_term_id` FOREIGN KEY (`term_id`) REFERENCES `academic_term` (`term_id`);

--
-- Constraints for table `course_subject`
--
ALTER TABLE `course_subject`
  ADD CONSTRAINT `course_subject_course_id_217feed5_fk_course_course_id` FOREIGN KEY (`course_id`) REFERENCES `course` (`course_id`),
  ADD CONSTRAINT `course_subject_subject_id_938cf26b_fk_subject_subject_id` FOREIGN KEY (`subject_id`) REFERENCES `subject` (`subject_id`);

--
-- Constraints for table `departments`
--
ALTER TABLE `departments`
  ADD CONSTRAINT `departments_head_id_05e94922_fk_lecturer_profiles_id` FOREIGN KEY (`head_id`) REFERENCES `lecturer_profiles` (`id`);

--
-- Constraints for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  ADD CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `lecturer_assignment`
--
ALTER TABLE `lecturer_assignment`
  ADD CONSTRAINT `lecturer_assignment_lecturer_id_2b0bbb97_fk_auth_user_id` FOREIGN KEY (`lecturer_id`) REFERENCES `auth_user` (`id`),
  ADD CONSTRAINT `lecturer_assignment_subject_id_2c1fa45c_fk_subject_subject_id` FOREIGN KEY (`subject_id`) REFERENCES `subject` (`subject_id`),
  ADD CONSTRAINT `lecturer_assignment_term_id_ee9f8658_fk_academic_term_term_id` FOREIGN KEY (`term_id`) REFERENCES `academic_term` (`term_id`);

--
-- Constraints for table `lecturer_profiles`
--
ALTER TABLE `lecturer_profiles`
  ADD CONSTRAINT `lecturer_profiles_dept_id_df93f1c7_fk_departments_dept_id` FOREIGN KEY (`dept_id`) REFERENCES `departments` (`dept_id`),
  ADD CONSTRAINT `lecturer_profiles_user_id_8041d963_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `lecturer_subjects`
--
ALTER TABLE `lecturer_subjects`
  ADD CONSTRAINT `lecturer_subjects_subject_id_7b9e00bf_fk_subject_subject_id` FOREIGN KEY (`subject_id`) REFERENCES `subject` (`subject_id`),
  ADD CONSTRAINT `lecturer_subjects_user_id_c00072e6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `session`
--
ALTER TABLE `session`
  ADD CONSTRAINT `session_facility_id_1cd9cb0d_fk_facilities_facility_id` FOREIGN KEY (`facility_id`) REFERENCES `facilities` (`facility_id`);

--
-- Constraints for table `skipped_date`
--
ALTER TABLE `skipped_date`
  ADD CONSTRAINT `skipped_date_term_id_93518ab0_fk_academic_term_term_id` FOREIGN KEY (`term_id`) REFERENCES `academic_term` (`term_id`);

--
-- Constraints for table `student_profiles`
--
ALTER TABLE `student_profiles`
  ADD CONSTRAINT `student_profiles_user_id_37ebcf0c_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `timetable_preference`
--
ALTER TABLE `timetable_preference`
  ADD CONSTRAINT `timetable_preference_lecturer_id_d227f3b4_fk_auth_user_id` FOREIGN KEY (`lecturer_id`) REFERENCES `auth_user` (`id`),
  ADD CONSTRAINT `timetable_preference_session_id_2fe4a9eb_fk_session_session_id` FOREIGN KEY (`session_id`) REFERENCES `session` (`session_id`),
  ADD CONSTRAINT `timetable_preference_subject_id_cb2b0190_fk_subject_subject_id` FOREIGN KEY (`subject_id`) REFERENCES `subject` (`subject_id`),
  ADD CONSTRAINT `timetable_preference_term_id_1e4decd7_fk_academic_term_term_id` FOREIGN KEY (`term_id`) REFERENCES `academic_term` (`term_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
