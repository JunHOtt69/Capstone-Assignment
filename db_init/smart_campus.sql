-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: db
-- Generation Time: Mar 28, 2026 at 06:34 PM
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
(29, 'Can add course', 17, 'add_course'),
(30, 'Can change course', 17, 'change_course'),
(31, 'Can delete course', 17, 'delete_course'),
(32, 'Can view course', 17, 'view_course'),
(33, 'Can add departments', 20, 'add_departments'),
(34, 'Can change departments', 20, 'change_departments'),
(35, 'Can delete departments', 20, 'delete_departments'),
(36, 'Can view departments', 20, 'view_departments'),
(37, 'Can add facilities', 21, 'add_facilities'),
(38, 'Can change facilities', 21, 'change_facilities'),
(39, 'Can delete facilities', 21, 'delete_facilities'),
(40, 'Can view facilities', 21, 'view_facilities'),
(41, 'Can add map node', 28, 'add_mapnode'),
(42, 'Can change map node', 28, 'change_mapnode'),
(43, 'Can delete map node', 28, 'delete_mapnode'),
(44, 'Can view map node', 28, 'view_mapnode'),
(45, 'Can add subject', 32, 'add_subject'),
(46, 'Can change subject', 32, 'change_subject'),
(47, 'Can delete subject', 32, 'delete_subject'),
(48, 'Can view subject', 32, 'view_subject'),
(49, 'Can add admin_profiles', 9, 'add_admin_profiles'),
(50, 'Can change admin_profiles', 9, 'change_admin_profiles'),
(51, 'Can delete admin_profiles', 9, 'delete_admin_profiles'),
(52, 'Can view admin_profiles', 9, 'view_admin_profiles'),
(53, 'Can add announcement', 10, 'add_announcement'),
(54, 'Can change announcement', 10, 'change_announcement'),
(55, 'Can delete announcement', 10, 'delete_announcement'),
(56, 'Can view announcement', 10, 'view_announcement'),
(57, 'Can add announcement target', 11, 'add_announcementtarget'),
(58, 'Can change announcement target', 11, 'change_announcementtarget'),
(59, 'Can delete announcement target', 11, 'delete_announcementtarget'),
(60, 'Can view announcement target', 11, 'view_announcementtarget'),
(61, 'Can add attachments', 12, 'add_attachments'),
(62, 'Can change attachments', 12, 'change_attachments'),
(63, 'Can delete attachments', 12, 'delete_attachments'),
(64, 'Can view attachments', 12, 'view_attachments'),
(65, 'Can add attendance session', 14, 'add_attendancesession'),
(66, 'Can change attendance session', 14, 'change_attendancesession'),
(67, 'Can delete attendance session', 14, 'delete_attendancesession'),
(68, 'Can view attendance session', 14, 'view_attendancesession'),
(69, 'Can add academic_term', 8, 'add_academic_term'),
(70, 'Can change academic_term', 8, 'change_academic_term'),
(71, 'Can delete academic_term', 8, 'delete_academic_term'),
(72, 'Can view academic_term', 8, 'view_academic_term'),
(73, 'Can add course_enrollment', 18, 'add_course_enrollment'),
(74, 'Can change course_enrollment', 18, 'change_course_enrollment'),
(75, 'Can delete course_enrollment', 18, 'delete_course_enrollment'),
(76, 'Can view course_enrollment', 18, 'view_course_enrollment'),
(77, 'Can add booking', 15, 'add_booking'),
(78, 'Can change booking', 15, 'change_booking'),
(79, 'Can delete booking', 15, 'delete_booking'),
(80, 'Can view booking', 15, 'view_booking'),
(81, 'Can add faq', 22, 'add_faq'),
(82, 'Can change faq', 22, 'change_faq'),
(83, 'Can delete faq', 22, 'delete_faq'),
(84, 'Can view faq', 22, 'view_faq'),
(85, 'Can add lecturer_profiles', 25, 'add_lecturer_profiles'),
(86, 'Can change lecturer_profiles', 25, 'change_lecturer_profiles'),
(87, 'Can delete lecturer_profiles', 25, 'delete_lecturer_profiles'),
(88, 'Can view lecturer_profiles', 25, 'view_lecturer_profiles'),
(89, 'Can add map edge', 27, 'add_mapedge'),
(90, 'Can change map edge', 27, 'change_mapedge'),
(91, 'Can delete map edge', 27, 'delete_mapedge'),
(92, 'Can view map edge', 27, 'view_mapedge'),
(93, 'Can add session', 29, 'add_session'),
(94, 'Can change session', 29, 'change_session'),
(95, 'Can delete session', 29, 'delete_session'),
(96, 'Can view session', 29, 'view_session'),
(97, 'Can add student_profiles', 31, 'add_student_profiles'),
(98, 'Can change student_profiles', 31, 'change_student_profiles'),
(99, 'Can delete student_profiles', 31, 'delete_student_profiles'),
(100, 'Can view student_profiles', 31, 'view_student_profiles'),
(101, 'Can add lecturer_subjects', 26, 'add_lecturer_subjects'),
(102, 'Can change lecturer_subjects', 26, 'change_lecturer_subjects'),
(103, 'Can delete lecturer_subjects', 26, 'delete_lecturer_subjects'),
(104, 'Can view lecturer_subjects', 26, 'view_lecturer_subjects'),
(105, 'Can add course_subject', 19, 'add_course_subject'),
(106, 'Can change course_subject', 19, 'change_course_subject'),
(107, 'Can delete course_subject', 19, 'delete_course_subject'),
(108, 'Can view course_subject', 19, 'view_course_subject'),
(109, 'Can add subject component', 33, 'add_subjectcomponent'),
(110, 'Can change subject component', 33, 'change_subjectcomponent'),
(111, 'Can delete subject component', 33, 'delete_subjectcomponent'),
(112, 'Can view subject component', 33, 'view_subjectcomponent'),
(113, 'Can add class_session', 16, 'add_class_session'),
(114, 'Can change class_session', 16, 'change_class_session'),
(115, 'Can delete class_session', 16, 'delete_class_session'),
(116, 'Can view class_session', 16, 'view_class_session'),
(117, 'Can add support ticket', 34, 'add_supportticket'),
(118, 'Can change support ticket', 34, 'change_supportticket'),
(119, 'Can delete support ticket', 34, 'delete_supportticket'),
(120, 'Can view support ticket', 34, 'view_supportticket'),
(121, 'Can add ticket activity', 35, 'add_ticketactivity'),
(122, 'Can change ticket activity', 35, 'change_ticketactivity'),
(123, 'Can delete ticket activity', 35, 'delete_ticketactivity'),
(124, 'Can view ticket activity', 35, 'view_ticketactivity'),
(125, 'Can add ticket message', 36, 'add_ticketmessage'),
(126, 'Can change ticket message', 36, 'change_ticketmessage'),
(127, 'Can delete ticket message', 36, 'delete_ticketmessage'),
(128, 'Can view ticket message', 36, 'view_ticketmessage'),
(129, 'Can add timetable_preference', 37, 'add_timetable_preference'),
(130, 'Can change timetable_preference', 37, 'change_timetable_preference'),
(131, 'Can delete timetable_preference', 37, 'delete_timetable_preference'),
(132, 'Can view timetable_preference', 37, 'view_timetable_preference'),
(133, 'Can add attendance mark', 13, 'add_attendancemark'),
(134, 'Can change attendance mark', 13, 'change_attendancemark'),
(135, 'Can delete attendance mark', 13, 'delete_attendancemark'),
(136, 'Can view attendance mark', 13, 'view_attendancemark'),
(137, 'Can add faq reaction', 23, 'add_faqreaction'),
(138, 'Can change faq reaction', 23, 'change_faqreaction'),
(139, 'Can delete faq reaction', 23, 'delete_faqreaction'),
(140, 'Can view faq reaction', 23, 'view_faqreaction'),
(141, 'Can add skipped_date', 30, 'add_skipped_date'),
(142, 'Can change skipped_date', 30, 'change_skipped_date'),
(143, 'Can delete skipped_date', 30, 'delete_skipped_date'),
(144, 'Can view skipped_date', 30, 'view_skipped_date'),
(145, 'Can add lecturer_assignment', 24, 'add_lecturer_assignment'),
(146, 'Can change lecturer_assignment', 24, 'change_lecturer_assignment'),
(147, 'Can delete lecturer_assignment', 24, 'delete_lecturer_assignment'),
(148, 'Can view lecturer_assignment', 24, 'view_lecturer_assignment'),
(149, 'Can add attendance otp', 38, 'add_attendanceotp'),
(150, 'Can change attendance otp', 38, 'change_attendanceotp'),
(151, 'Can delete attendance otp', 38, 'delete_attendanceotp'),
(152, 'Can view attendance otp', 38, 'view_attendanceotp');

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
(1, 'pbkdf2_sha256$1200000$UAbSOp08WUZRugSUUb45Fj$+MbbjoFnxUwEYdUScmy4OuKrOH+dhiOD6cAOpz2BKio=', '2026-03-28 09:01:51.081959', 1, 'limjunhong1015@gmail.com', 'Lim', 'Jun Hong', 'limjunhong1015@gmail.com', 1, 1, '2026-02-26 11:30:16.196000'),
(18, 'pbkdf2_sha256$1200000$Jys4B4WnS6Y77PYnj420fW$tPY6U2PF03NNZQNsw5ckwdeFj+qfVYvLVOjHsmtcnFA=', '2026-03-28 09:00:39.331381', 0, 'mokyusheng@gmail.com', 'Mok', 'Yu Sheng', 'mokyusheng@gmail.com', 1, 1, '2026-03-01 17:06:16.433000'),
(19, 'pbkdf2_sha256$1200000$FHRt0htUwRbwCLQ4fT38uT$QFjmLyJ4q18hLmP7VLchgNwmL57O+yiu+k7H75gRdWE=', '2026-03-27 05:00:00.000000', 0, 'ljack7599@gmail.com', 'Lee', 'Zhen Sheng', 'ljack7599@gmail.com', 0, 1, '2026-03-01 17:13:09.153000'),
(20, 'pbkdf2_sha256$1200000$cNMpCmuRr6d7O2xvLNKH39$gmTeHGRqa5VKP8cYfWKJnzh1y1P1p1uxaqnxaFOOah4=', NULL, 0, 'siti.aminah@gmail.com', 'Siti', 'Aminah', 'siti.aminah@gmail.com', 1, 1, '2026-03-18 06:25:55.892000'),
(21, 'pbkdf2_sha256$1200000$mWqGAd6zErZh3s0VQq9rbF$4Jp+nXX5JMCBYknzPJXPKY63uor0PX92NyjDJk9YHZY=', NULL, 0, 'ravi.s@gmail.com', 'Ravi', 'Subramaniam', 'ravi.s@gmail.com', 1, 1, '2026-03-18 06:25:55.942000'),
(22, 'pbkdf2_sha256$1200000$st5seVLsMgg2l9U2dXSnL7$5feWVmVCJBSE04+tlcJoTBQ5TuAOi+gPEs8xjXCkHhI=', '2026-03-18 07:19:57.988000', 0, 'mei.ling@gmail.com', 'Mei', 'Ling', 'mei.ling@gmail.com', 1, 1, '2026-03-18 06:56:23.606000'),
(23, 'pbkdf2_sha256$1200000$er0xYlsBw1M9ifgvBOferi$Lx3A/ma0EFuntm7WDIYcm0wRppgmr0J6rU40/LihFwg=', '2026-03-18 07:20:10.168000', 0, 'ahmad.f@gmail.com', 'Ahmad', 'Fadzil', 'ahmad.f@gmail.com', 1, 1, '2026-03-18 06:56:23.632000'),
(24, 'pbkdf2_sha256$1200000$DryeY7sxwqaW7GHQWPvT8Z$AXnHiA3UqtgKs1h+Oy6+U/PGiqj8+M3TO5AKGehEh+c=', '2026-03-18 07:32:25.006000', 0, 'priyanka.d@gmail.com', 'Priyanka', 'Devi', 'priyanka.d@gmail.com', 1, 1, '2026-03-18 06:56:23.642000'),
(25, 'pbkdf2_sha256$1200000$h6natAm7NKThhzmLKNqrG6$4F8rDpzALZKKyVW4i0Kp7dVx7VAHO09FbRw1glkVbwk=', '2026-03-24 16:00:44.744236', 0, 'wei.kang@gmail.com', 'Wei', 'Kang', 'wei.kang@gmail.com', 1, 1, '2026-03-18 06:56:23.652000'),
(26, 'pbkdf2_sha256$1200000$uWUJaCGPj7a68hHKTOwJDI$/FNmmbM24m39FnhP+pggP+ytsmPm9yRxGYOgrsaVr4E=', '2026-03-18 07:32:44.680000', 0, 'nurul.izzah@gmail.com', 'Nurul', 'Izzah', 'nurul.izzah@gmail.com', 1, 1, '2026-03-18 06:56:23.665000'),
(27, 'pbkdf2_sha256$1200000$2J4BQ8QWkrv2X7jS13BV8a$5ah5aootUAKugPoIas4Yz+dlmqh2Q7gAlPzOB3w701E=', '2026-03-18 07:32:56.988000', 0, 'sanjay.k@gmail.com', 'Sanjay', 'Kumar', 'sanjay.k@gmail.com', 1, 1, '2026-03-18 06:56:23.676000'),
(28, 'pbkdf2_sha256$1200000$EVdSE1Uq2QQRGT1f580OSL$ZE71wIT4Qj7P1hFCnWiVe7mlKdIJYJ3MV91TujJiWcY=', NULL, 0, 'zhi.hao@gmail.com', 'Zhi', 'Hao', 'zhi.hao@gmail.com', 1, 1, '2026-03-18 06:56:23.685000'),
(29, 'pbkdf2_sha256$1200000$DELLJU2ziElJf9Xvu5AEQT$zpGt0jOs3g0KQ6/iDRfSLx7r0ocRA1RFLBUQlHpmhYU=', NULL, 0, 'tamsergefrank@gmail.com', 'Tam', 'Serge Frank', 'tamsergefrank@gmail.com', 1, 1, '2026-03-18 06:56:23.697000'),
(30, 'pbkdf2_sha256$1200000$iCpf6255fdhQtCUR3Jyxn5$lFSOvIlbsrXFIqXc2djcpEbDKu/L9KIo39KiEdkzBMg=', NULL, 0, 'siti.z@gmail.com', 'Siti', 'Zubaidah', 'siti.z@gmail.com', 1, 1, '2026-03-18 06:56:23.708000'),
(31, 'pbkdf2_sha256$1200000$c1clDq00VuK1SQipx9WGa5$3KyH2MxcZOAfwLYQUpViurhyvVfnOKqID9Eqvgvjv48=', NULL, 0, 'kenji.t@gmail.com', 'Kenji', 'Tanaka', 'kenji.t@gmail.com', 1, 1, '2026-03-18 06:56:23.720000'),
(32, 'pbkdf2_sha256$1200000$pt7FNNkQBiK4P3ZegQbF7a$MzlbSbI4rK951rg6FRROnvBlIqi9WfDpINF36AYZA0c=', NULL, 0, 'liam.o@gmail.com', 'Liam', 'O\'Sullivan', 'liam.o@gmail.com', 1, 1, '2026-03-18 06:56:23.734000'),
(33, 'pbkdf2_sha256$1200000$uIZDIQ58hDOensY9a2aSFK$357daxaY3irKODOA8jGCtI7ZRe7DS43vfQxVIWMq7E8=', NULL, 0, 'xavier.d@gmail.com', 'Xavier', 'Deschamps', 'xavier.d@gmail.com', 1, 1, '2026-03-18 06:56:23.748000'),
(34, 'pbkdf2_sha256$1200000$CpHlju4cxGBHeGRSKcpgm3$Iv5uxnu7TDVfPy3ZH9xYpUhvdbPqzjDscVRt6ZrHiW4=', NULL, 0, 'thanh.n@gmail.com', 'Thanh', 'Nguyen', 'thanh.n@gmail.com', 1, 1, '2026-03-18 06:56:23.763000'),
(35, 'pbkdf2_sha256$1200000$Hj4NOfQb98ahp14WK7stFM$eS1BRh/MYTGhnsH6VjUZ1VodJAZVJGxSP+Da4M2bPj4=', '2026-03-28 09:03:31.823953', 0, 'elena.p@gmail.com', 'Elena', 'Petrova', 'elena.p@gmail.com', 1, 1, '2026-03-18 06:56:23.784000'),
(36, 'pbkdf2_sha256$1200000$i5yWrAMTk7IQAExsdg2BRH$9gff7EqbdqM79x51ge/W+CsP/bqNGIEUfEyKeWM2qf0=', NULL, 0, 'hans.m@gmail.com', 'Hans', 'Miller', 'hans.m@gmail.com', 1, 1, '2026-03-18 06:56:23.801000'),
(37, 'pbkdf2_sha256$1200000$hslUN1Yq2xl3Rmi8p8f3mg$c4UJKLOdPARhj3bAZ0EDTkX92iv63ynzUchPotwrz2Y=', NULL, 0, 'arjun.m@gmail.com', 'Arjun', 'Malhotra', 'arjun.m@gmail.com', 1, 1, '2026-03-18 06:56:23.816000'),
(38, 'pbkdf2_sha256$1200000$9aKczMiAYolKPU4MRKJxS9$cy+DqMZ221fkpXcmXgYZUeHYq/2exdsOOYW1lQ0huZ8=', NULL, 0, 'farrah.z@gmail.com', 'Farrah', 'Zulkifli', 'farrah.z@gmail.com', 1, 1, '2026-03-18 06:56:23.832000'),
(39, 'pbkdf2_sha256$1200000$WWlQokPSlmpwdRWVfl7ZVn$OqjzZT8DQbLX9//91Jv+3Z79vf1Psx0BSfTwpMoJbpI=', NULL, 0, 'ming.zhe@gmail.com', 'Ming', 'Zhe', 'ming.zhe@gmail.com', 1, 1, '2026-03-18 06:56:23.847000'),
(40, 'pbkdf2_sha256$1200000$j1wM21OzXyrQSAqzWy8pSz$PkmEXI3Lsy6o21bfZ8r24qfv5MwMgM9bsUYT+HgPPt8=', NULL, 0, 's.connor@gmail.com', 'Sarah', 'Connor', 's.connor@gmail.com', 1, 1, '2026-03-18 06:56:23.862000'),
(42, 'pbkdf2_sha256$1200000$aMCyY8W6vzyaR9bqH7WiWt$ZLWfICef1cjtb15I9Zr/Yw3yGDx/vdjVJqb4f/DHZmk=', '2026-03-25 09:38:53.436863', 0, 'aidenlee@admin.campus.edu', 'Aiden', 'Lee', 'aidenlee@admin.campus.edu', 1, 1, '2026-03-18 17:01:35.761000'),
(43, 'pbkdf2_sha256$1200000$hx48aZkm1zXRRJPOgdiiyA$AdTVah0fZCEl9RY8+VBgMCh4K3FimnC5O4yH28lCtkA=', '2026-03-28 18:26:40.615958', 0, 'sofiamartinez@admin.campus.edu', 'Sofia', 'Martinez', 'sofiamartinez@admin.campus.edu', 1, 1, '2026-03-18 17:01:35.779000'),
(44, 'pbkdf2_sha256$1200000$6AFZy4CkbapHmHUXzPVeSZ$SwEmhWwl8Jyj7pGg06brTXeDi8GJmgYFSxXMXhGUgGY=', '2026-03-28 09:02:27.282355', 0, 'rajpatel@admin.campus.edu', 'Raj', 'Patel', 'rajpatel@admin.campus.edu', 1, 1, '2026-03-18 17:01:35.790000'),
(45, 'pbkdf2_sha256$1200000$rVWDO6mTpreqIKxKrVt4Tl$0k4K3YoqFAUoYL4ZzYDa2UabC/sFYtFWH/SqryG9AxM=', '2026-03-27 16:13:05.878133', 0, 'junhong@student.campus.edu', 'Jun', 'Hong', 'junhong@student.campus.edu', 0, 1, '2026-03-18 17:01:35.804000'),
(46, 'pbkdf2_sha256$1200000$X5rhzqoDKeGQU3DRC2d5PE$zchp2sNbZHfQK3OJM+ctqJQiNKgIa0oI0qyHIGitejw=', NULL, 0, 'weichen@student.campus.edu', 'Wei', 'Chen', 'weichen@student.campus.edu', 0, 1, '2026-03-18 17:01:35.826000'),
(47, 'pbkdf2_sha256$1200000$MzWajAVyKCTJ0mq5lw76AT$gW64WTZc0C58xQDU6RAq0gpQu3id4orBuXRXn9RYziY=', NULL, 0, 'amirhassan@student.campus.edu', 'Amir', 'Hassan', 'amirhassan@student.campus.edu', 0, 1, '2026-03-18 17:01:35.841000'),
(48, 'pbkdf2_sha256$1200000$EG4Nxlycg9CHNLzNPYg25T$Nuf+11YplnKb6ynaPoUUwcgsP+jz+YrJPCIRkqxV7vU=', NULL, 0, 'emilyjohnson@student.campus.edu', 'Emily', 'Johnson', 'emilyjohnson@student.campus.edu', 0, 1, '2026-03-18 17:01:35.853000'),
(49, 'pbkdf2_sha256$1200000$rUcAC6nuyZGn6plTJA2t2Q$TuJ20nae9x84dVJDz3+CWrBbMsn6m+QlkygiZphBgOQ=', '2026-03-27 16:06:44.431626', 0, 'sitinurhaliza@student.campus.edu', 'Siti', 'Nurhaliza', 'sitinurhaliza@student.campus.edu', 0, 1, '2026-03-18 17:01:35.863000'),
(50, 'pbkdf2_sha256$1200000$JLliAPRqjEARcGQxif8ifS$pysy2Qafazfki53wlIgFt8ut1MDc2JtcE2Q1ASHMfNY=', NULL, 0, 'kenjitanaka@student.campus.edu', 'Kenji', 'Tanaka', 'kenjitanaka@student.campus.edu', 0, 1, '2026-03-18 17:01:35.875000'),
(51, 'pbkdf2_sha256$1200000$UgfUVMG4LatAY1H5RNxWvw$KeTT98vxfKWeQ/F/t8YEBte+fxTwy0QfjUfzO6NaCKA=', NULL, 0, 'davidsmith@student.campus.edu', 'David', 'Smith', 'davidsmith@student.campus.edu', 0, 1, '2026-03-18 17:01:35.890000'),
(52, 'pbkdf2_sha256$1200000$uE1xlpZoGfQFic1az1Oc0Z$4JhUKY+rWpckflqamW1vmm2Zl+WDFyaVIpSAaZKnU60=', NULL, 0, 'fatimakhan@student.campus.edu', 'Fatima', 'Khan', 'fatimakhan@student.campus.edu', 0, 1, '2026-03-18 17:01:35.905000'),
(53, 'pbkdf2_sha256$1200000$tyNvZ8OZoeKwLUEwpKEKJg$Re8vxCWaBIu3PIAQwb9Cs7JuLfdp4zz88LXWq0Y5HXU=', NULL, 0, 'lucassilva@student.campus.edu', 'Lucas', 'Silva', 'lucassilva@student.campus.edu', 0, 1, '2026-03-18 17:01:35.927000'),
(54, 'pbkdf2_sha256$1200000$YAtqSbXaAjGUdHETt5JFGd$lAM+veDHR7hmwJZVv7nUY/PI5lsZn9Ehctt/GbRnHLU=', NULL, 0, 'nguyenminh@student.campus.edu', 'Nguyen', 'Minh', 'nguyenminh@student.campus.edu', 0, 1, '2026-03-18 17:01:35.953000'),
(63, '!WWkEQnzs66L3wzECTQRm2szMAK8Mbd3xzyyKWpXW', NULL, 0, 'lauhoeyik@gmail.com', 'Lau', 'Hoe Yik ', 'lauhoeyik@gmail.com', 1, 1, '2026-03-24 07:23:07.220882');

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
(1, 1, 1),
(2, 18, 2),
(3, 19, 3),
(4, 20, 2),
(5, 21, 2),
(6, 22, 2),
(7, 23, 2),
(8, 24, 2),
(9, 25, 2),
(10, 26, 2),
(11, 27, 2),
(12, 28, 2),
(13, 29, 2),
(14, 30, 2),
(15, 31, 2),
(16, 32, 2),
(17, 33, 2),
(18, 34, 2),
(19, 35, 2),
(20, 36, 2),
(21, 37, 2),
(22, 38, 2),
(23, 39, 2),
(24, 40, 2),
(25, 42, 1),
(26, 43, 1),
(27, 44, 1),
(28, 45, 3),
(29, 46, 3),
(30, 47, 3),
(31, 48, 3),
(32, 49, 3),
(33, 50, 3),
(34, 51, 3),
(35, 52, 3),
(36, 53, 3),
(37, 54, 3),
(46, 63, 1);

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
-- Table structure for table `campus_academic_rules`
--

CREATE TABLE `campus_academic_rules` (
  `id` int NOT NULL,
  `rule_name` varchar(100) NOT NULL,
  `value_days` int NOT NULL,
  `description` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `campus_academic_rules`
--

INSERT INTO `campus_academic_rules` (`id`, `rule_name`, `value_days`, `description`) VALUES
(1, 'Study Weeks', 14, '2 Week of study week before exams starting'),
(2, 'Examination Period', 14, '2 week of examination week'),
(3, 'Late Policy', 15, 'unit: minute'),
(4, 'Maximum Booking Duration', 2, 'A student can book a facility for maximum 2 hours per session'),
(5, 'Buffer Time', 15, 'The transition time between two different class sessions'),
(6, 'Advance Booking Limit', 3, 'Day in advance a facility can be reserved'),
(7, 'Mid-Semester Break', 7, '1 week of mid-semester break');

-- --------------------------------------------------------

--
-- Table structure for table `campus_academic_term`
--

CREATE TABLE `campus_academic_term` (
  `term_id` int NOT NULL,
  `intake_code` varchar(25) NOT NULL,
  `current_semester` smallint UNSIGNED NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `course_id` int NOT NULL
) ;

--
-- Dumping data for table `campus_academic_term`
--

INSERT INTO `campus_academic_term` (`term_id`, `intake_code`, `current_semester`, `is_active`, `start_date`, `end_date`, `course_id`) VALUES
(1, 'F-ICT-GEN-202601', 1, 1, '2026-01-05', '2026-04-27', 1),
(2, 'D-ICT-SE-202601', 1, 1, '2026-01-05', '2026-05-11', 4),
(3, 'B-CS-AI-202601', 1, 1, '2026-01-05', '2026-05-11', 2),
(4, 'B-CS-CYB-202601', 1, 1, '2026-01-05', '2026-05-11', 3);

-- --------------------------------------------------------

--
-- Table structure for table `campus_admin_profiles`
--

CREATE TABLE `campus_admin_profiles` (
  `id` int NOT NULL,
  `ad_id` varchar(12) NOT NULL,
  `user_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `campus_admin_profiles`
--

INSERT INTO `campus_admin_profiles` (`id`, `ad_id`, `user_id`) VALUES
(1, 'AD262069', 1),
(5, 'AD264013', 42),
(6, 'AD263133', 43),
(7, 'AD266020', 44),
(16, 'AD266510', 63);

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
(4, 'Greeting hari raya', 'Selamat Hari Raya Aidilfitri to all our staff and students! Wishing you a joyous celebration filled with peace, prosperity, and cherished moments with loved ones!', '2026-03-19 18:19:26.507000', 1, 'BANNER', 1),
(5, 'Student View only', 'New Feature Alert: Explore the campus like never before with our interactive Navigation Map! Find your way to lecture halls, cafes, and labs directly from your Student Dashboard. Try it now!', '2026-03-20 08:51:47.788000', 1, 'BANNER', 1),
(7, 'Only Visitor View', 'Welcome To APU Smart Campus Management System. Visit Us at Our Open Day! 28 | 29 Mar & 4 | 5 Apr 2026', '2026-03-20 09:15:03.161000', 1, 'BANNER', 1),
(10, 'Selamat Hari Raya Aidilfitri: Campus Holiday Notice', '<p>Dear Staff and Students,</p><p>In celebration of the upcoming <strong>Hari Raya Aidilfitri</strong>, please be informed that the campus will be closed for the festive break.</p><ol><li data-list=\"bullet\"><span class=\"ql-ui\" contenteditable=\"false\"></span><strong>Holiday Start</strong>: Friday, 20th March 2026</li><li data-list=\"bullet\"><span class=\"ql-ui\" contenteditable=\"false\"></span><strong>Campus Reopens</strong>: Wednesday, 25th March 2026</li></ol><p>All classes and administrative operations will be suspended during this period. We encourage everyone to take this time to rest, celebrate with loved ones, and stay safe.</p><p>To those traveling back to their hometowns, we wish you a safe journey (<em>Balik Kampung</em>). To all our Muslim friends and colleagues, <strong>Selamat Hari Raya Aidilfitri, Maaf Zahir dan Batin.</strong></p><p><br></p><p>Warm regards, </p><p><strong>Campus Administration</strong></p>', '2026-03-20 13:07:02.860000', 1, 'NORMAL', 1),
(11, 'This is announcement.', '<p>This is announcements. Lorem ipsum dolor, sit amet consectetur adipisicing elit. Eligendi quisquam iste accusamus consectetur aspernatur hic, aliquid modi nihil veniam corrupti fugiat, molestias, eum harum. Cupiditate, ipsam quibusdam! Eius aut temporibus officiis nesciunt, quaerat voluptate. Totam, facilis dolor ipsam aliquam, nemo dolores animi repudiandae minus reiciendis asperiores dolore, in voluptatum?</p><p><br></p><p>Pariatur, consectetur excepturi cum blanditiis recusandae consequuntur. Soluta blanditiis cupiditate facilis iste provident sed veritatis natus ad, nesciunt architecto rerum eligendi maxime porro ipsa reiciendis vero minima.</p><p><br></p><p>A consequatur placeat minima ex, facilis quasi veniam odio laboriosam magni et similique necessitatibus itaque nesciunt, aliquam asperiores reiciendis eveniet atque iure ducimus laudantium quia ratione maxime deserunt accusantium. Earum obcaecati modi labore beatae incidunt vel, quaerat veniam, sed totam, pariatur ea animi saepe ratione explicabo debitis blanditiis! Deleniti, mollitia ea harum corrupti obcaecati, voluptates magnam odio neque distinctio quam dicta provident beatae, sunt suscipit! Necessitatibus ad nemo dolore culpa iste ea est odio illum facere quia quidem similique rerum temporibus ipsam doloribus, illo excepturi sequi dolores voluptatem aliquam itaque repellendus repudiandae. Maiores quidem blanditiis consequatur unde deserunt hic enim illum corrupti similique. Iure quam odio hic tenetur quibusdam iste facilis quisquam illum quaerat? Sint assumenda perferendis obcaecati autem facilis, dolores praesentium velit exercitationem?</p>', '2026-03-20 13:28:36.626000', 1, 'NORMAL', 1);

-- --------------------------------------------------------

--
-- Table structure for table `campus_announcementtarget`
--

CREATE TABLE `campus_announcementtarget` (
  `target_id` int NOT NULL,
  `is_for_students` tinyint(1) NOT NULL,
  `is_for_lecturer` tinyint(1) NOT NULL,
  `is_for_admins` tinyint(1) NOT NULL,
  `is_visitor_visible` tinyint(1) NOT NULL,
  `academic_term` varchar(50) DEFAULT NULL,
  `announcement_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `campus_announcementtarget`
--

INSERT INTO `campus_announcementtarget` (`target_id`, `is_for_students`, `is_for_lecturer`, `is_for_admins`, `is_visitor_visible`, `academic_term`, `announcement_id`) VALUES
(4, 1, 1, 1, 0, NULL, 4),
(5, 0, 0, 0, 0, '1,3,2', 5),
(7, 0, 0, 0, 1, NULL, 7),
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
) ;

--
-- Dumping data for table `campus_attachments`
--

INSERT INTO `campus_attachments` (`id`, `object_id`, `file`, `uploaded_at`, `content_type_id`) VALUES
(1, 5, 'attachments/faq_5_688b3fae.jpeg', '2026-03-08 06:18:32.637000', 26),
(2, 14, 'attachments/faq_14_c32a7302.png', '2026-03-09 14:48:57.812000', 26),
(3, 1, 'attachments/supportticket_1_20260312093214.jpeg', '2026-03-12 09:32:14.444000', 30),
(4, 2, 'attachments/supportticket_2_20260312155655.jpeg', '2026-03-12 15:56:55.380000', 30),
(17, 32, 'attachments/ticketmessage_32_20260313125547.docx', '2026-03-13 12:55:47.864000', 31),
(18, 42, 'attachments/ticketmessage_42_20260317094659.docx', '2026-03-17 09:46:59.106000', 31),
(19, 42, 'attachments/ticketmessage_42_20260317094659.png', '2026-03-17 09:46:59.130000', 31),
(20, 9, 'attachments/announcement_9_20260320130434.png', '2026-03-20 13:04:34.169000', 36),
(21, 10, 'attachments/announcement_10_20260320130702.png', '2026-03-20 13:07:02.906000', 36),
(22, 11, 'attachments/announcement_11_20260320132836.jpg', '2026-03-20 13:28:36.675000', 36),
(23, 11, 'attachments/announcement_11_20260320132836_M6yM63J.jpg', '2026-03-20 13:28:36.721000', 36),
(24, 11, 'attachments/announcement_11_20260320132836_HwNczdx.jpg', '2026-03-20 13:28:36.770000', 36),
(25, 11, 'attachments/announcement_11_20260320132836_RweQ8zl.jpg', '2026-03-20 13:28:36.826000', 36),
(26, 11, 'attachments/announcement_11_20260320132836_Vwdgu7F.jpg', '2026-03-20 13:28:36.882000', 36);

-- --------------------------------------------------------

--
-- Table structure for table `campus_attendancemark`
--

CREATE TABLE `campus_attendancemark` (
  `id` bigint NOT NULL,
  `status` varchar(10) NOT NULL,
  `student_id` int NOT NULL,
  `session_id` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `campus_attendancemark`
--

INSERT INTO `campus_attendancemark` (`id`, `status`, `student_id`, `session_id`) VALUES
(12, 'PRESENT', 49, 1);

-- --------------------------------------------------------

--
-- Table structure for table `campus_attendanceotp`
--

CREATE TABLE `campus_attendanceotp` (
  `id` bigint NOT NULL,
  `otp_code` varchar(4) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `attendance_session_id` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `campus_attendancesession`
--

CREATE TABLE `campus_attendancesession` (
  `id` bigint NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `class_event_id` int NOT NULL,
  `is_open` tinyint(1) NOT NULL,
  `lecturer_id` int NOT NULL,
  `closed_at` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `campus_attendancesession`
--

INSERT INTO `campus_attendancesession` (`id`, `created_at`, `class_event_id`, `is_open`, `lecturer_id`, `closed_at`) VALUES
(1, '2026-03-27 07:04:51.525183', 567, 0, 35, '2026-03-28 09:05:36.395898'),
(2, '2026-03-27 10:58:28.852824', 428, 0, 35, '2026-03-27 05:00:00.000000'),
(3, '2026-03-27 17:05:41.043375', 699, 0, 35, '2026-03-27 17:05:49.708310'),
(4, '2026-03-27 17:06:55.554543', 262, 0, 35, '2026-03-27 17:07:08.033032');

-- --------------------------------------------------------

--
-- Table structure for table `campus_booking`
--

CREATE TABLE `campus_booking` (
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
-- Dumping data for table `campus_booking`
--

INSERT INTO `campus_booking` (`booking_id`, `booking_date`, `start_time`, `end_time`, `purpose`, `status`, `created_at`, `user_id`, `facility_id`) VALUES
(1, '2026-03-12', '10:00:00.000000', '12:30:00.000000', 'group discussion', 'Cancelled', '2026-03-11 09:55:10.061000', 19, 1),
(2, '2026-03-13', '09:30:00.000000', '13:30:00.000000', 'Lab exercise', 'Cancelled', '2026-03-12 07:17:30.871000', 19, 2),
(3, '2026-03-18', '08:30:00.000000', '16:40:00.000000', 'Event', 'Rejected', '2026-03-12 08:40:10.135000', 19, 3),
(4, '2026-03-17', '06:40:00.000000', '20:40:00.000000', 'Lab exercise', 'Cancelled', '2026-03-13 08:38:14.527000', 19, 2),
(5, '2026-03-19', '07:45:00.000000', '09:45:00.000000', 'group discussion', 'Cancelled', '2026-03-13 08:45:14.269000', 19, 1),
(6, '2026-03-23', '07:20:00.000000', '21:20:00.000000', 'group discussion', 'Cancelled', '2026-03-13 09:18:04.149000', 19, 1),
(7, '2026-03-15', '05:20:00.000000', '07:20:00.000000', 'group discussion', 'Cancelled', '2026-03-13 09:19:47.686000', 19, 1),
(8, '2026-03-15', '15:15:00.000000', '17:15:00.000000', '', 'Rejected', '2026-03-13 09:59:21.045000', 19, 1),
(9, '2026-03-20', '10:30:00.000000', '12:30:00.000000', 'group discussion', 'Expired', '2026-03-17 13:24:45.366000', 19, 1),
(10, '2026-03-20', '13:00:00.000000', '15:20:00.000000', 'group discussion', 'Expired', '2026-03-17 15:16:26.652000', 19, 1),
(11, '2026-03-25', '10:50:00.000000', '14:50:00.000000', '', 'Cancelled', '2026-03-25 06:50:29.651887', 19, 1),
(12, '2026-03-26', '16:05:00.000000', '17:05:00.000000', '', 'Cancelled', '2026-03-25 07:05:25.392313', 19, 1),
(13, '2026-03-28', '09:35:00.000000', '10:35:00.000000', 'AVBCasdwqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq', 'Cancelled', '2026-03-25 07:30:00.909374', 19, 1),
(14, '2026-03-28', '10:35:00.000000', '12:35:00.000000', '', 'Cancelled', '2026-03-25 07:31:09.404579', 19, 1),
(15, '2026-03-28', '08:49:00.000000', '08:50:00.000000', '', 'Rejected', '2026-03-25 08:46:02.084424', 19, 2),
(16, '2026-03-28', '08:49:00.000000', '08:53:00.000000', '', 'Rejected', '2026-03-25 08:49:22.199067', 19, 2),
(17, '2026-03-27', '08:53:00.000000', '09:53:00.000000', '', 'Cancelled', '2026-03-25 08:53:28.801291', 19, 1),
(18, '2026-03-27', '08:58:00.000000', '09:59:00.000000', '', 'Cancelled', '2026-03-25 08:59:04.479305', 19, 1),
(19, '2026-03-27', '11:01:00.000000', '12:01:00.000000', '', 'Rejected', '2026-03-25 09:01:48.281271', 19, 2),
(20, '2026-03-27', '12:45:00.000000', '14:45:00.000000', '', 'Approved', '2026-03-25 09:04:54.625878', 19, 1),
(21, '2026-03-27', '15:30:00.000000', '17:30:00.000000', '', 'Cancelled', '2026-03-25 09:06:23.213044', 19, 4),
(22, '2026-03-27', '11:06:00.000000', '12:06:00.000000', '', 'Cancelled', '2026-03-25 09:06:48.420504', 19, 2),
(23, '2026-03-27', '16:15:00.000000', '17:30:00.000000', 'For study', 'Pending', '2026-03-25 14:14:24.062091', 19, 1);

-- --------------------------------------------------------

--
-- Table structure for table `campus_class_session`
--

CREATE TABLE `campus_class_session` (
  `id` int NOT NULL,
  `date` date DEFAULT NULL,
  `status` varchar(20) NOT NULL,
  `lecturer_id` int NOT NULL,
  `term_id` int DEFAULT NULL,
  `session_id` int NOT NULL,
  `subject_component_id` int NOT NULL,
  `semester` smallint UNSIGNED NOT NULL
) ;

--
-- Dumping data for table `campus_class_session`
--

INSERT INTO `campus_class_session` (`id`, `date`, `status`, `lecturer_id`, `term_id`, `session_id`, `subject_component_id`, `semester`) VALUES
(90, '2026-01-07', 'scheduled', 33, 1, 49, 1, 1),
(91, '2026-01-07', 'scheduled', 31, 1, 70, 3, 1),
(92, '2026-01-06', 'scheduled', 35, 1, 93, 5, 1),
(93, '2026-01-06', 'scheduled', 21, 1, 114, 7, 1),
(94, '2026-01-08', 'scheduled', 23, 1, 125, 9, 1),
(95, '2026-01-09', 'scheduled', 33, 1, 141, 2, 1),
(96, '2026-01-09', 'scheduled', 31, 1, 42, 4, 1),
(97, '2026-01-08', 'scheduled', 21, 1, 66, 8, 1),
(98, '2026-01-09', 'scheduled', 23, 1, 83, 10, 1),
(99, '2026-01-08', 'scheduled', 35, 1, 167, 6, 1),
(100, '2026-01-05', 'scheduled', 31, 2, 17, 19, 1),
(101, '2026-01-05', 'scheduled', 35, 2, 38, 34, 1),
(102, '2026-01-07', 'scheduled', 30, 2, 109, 130, 1),
(103, '2026-01-06', 'scheduled', 31, 2, 133, 131, 1),
(104, '2026-01-06', 'scheduled', 31, 2, 154, 100, 1),
(105, '2026-01-07', 'scheduled', 22, 2, 10, 102, 1),
(106, '2026-01-08', 'scheduled', 31, 2, 45, 20, 1),
(107, '2026-01-09', 'scheduled', 35, 2, 61, 35, 1),
(108, '2026-01-08', 'scheduled', 31, 2, 86, 101, 1),
(109, '2026-01-09', 'scheduled', 22, 2, 102, 103, 1),
(110, '2026-01-05', 'scheduled', 30, 3, 37, 126, 1),
(111, '2026-01-07', 'scheduled', 35, 3, 129, 34, 1),
(112, '2026-01-05', 'scheduled', 37, 3, 158, 36, 1),
(113, '2026-01-06', 'scheduled', 38, 3, 13, 38, 1),
(114, '2026-01-07', 'scheduled', 24, 3, 30, 127, 1),
(115, '2026-01-06', 'scheduled', 25, 3, 54, 40, 1),
(116, '2026-01-08', 'scheduled', 26, 3, 65, 42, 1),
(117, '2026-01-09', 'scheduled', 35, 3, 103, 35, 1),
(118, '2026-01-09', 'scheduled', 26, 3, 81, 43, 1),
(119, '2026-01-07', 'scheduled', 37, 3, 191, 37, 1),
(120, '2026-01-08', 'scheduled', 38, 3, 187, 39, 1),
(121, '2026-01-08', 'scheduled', 25, 3, 168, 41, 1),
(122, '2026-01-05', 'scheduled', 32, 3, 179, 104, 1),
(123, '2026-01-07', 'scheduled', 30, 4, 130, 126, 1),
(124, '2026-01-05', 'scheduled', 35, 4, 157, 34, 1),
(125, '2026-01-09', 'scheduled', 37, 4, 1, 36, 1),
(126, '2026-01-06', 'scheduled', 38, 4, 34, 38, 1),
(127, '2026-01-05', 'scheduled', 24, 4, 58, 127, 1),
(128, '2026-01-06', 'scheduled', 25, 4, 73, 40, 1),
(129, '2026-01-05', 'scheduled', 26, 4, 99, 42, 1),
(130, '2026-01-07', 'scheduled', 35, 4, 111, 35, 1),
(131, '2026-01-06', 'scheduled', 26, 4, 135, 43, 1),
(132, '2026-01-08', 'scheduled', 38, 4, 188, 39, 1),
(133, '2026-01-09', 'scheduled', 25, 4, 163, 41, 1),
(134, '2026-01-07', 'scheduled', 32, 4, 192, 104, 1),
(135, '2026-01-14', 'scheduled', 30, 4, 130, 126, 1),
(136, '2026-01-12', 'scheduled', 35, 4, 157, 34, 1),
(137, '2026-01-16', 'scheduled', 37, 4, 1, 36, 1),
(138, '2026-01-13', 'scheduled', 38, 4, 34, 38, 1),
(139, '2026-01-12', 'scheduled', 24, 4, 58, 127, 1),
(140, '2026-01-13', 'scheduled', 25, 4, 73, 40, 1),
(141, '2026-01-12', 'scheduled', 26, 4, 99, 42, 1),
(142, '2026-01-14', 'scheduled', 35, 4, 111, 34, 1),
(143, '2026-01-13', 'scheduled', 26, 4, 135, 42, 1),
(144, '2026-01-15', 'scheduled', 38, 4, 188, 39, 1),
(145, '2026-01-16', 'scheduled', 25, 4, 163, 41, 1),
(146, '2026-01-14', 'scheduled', 32, 4, 192, 104, 1),
(147, '2026-01-21', 'scheduled', 30, 4, 130, 126, 1),
(148, '2026-01-19', 'scheduled', 35, 4, 157, 34, 1),
(149, '2026-01-23', 'scheduled', 37, 4, 1, 36, 1),
(150, '2026-01-20', 'scheduled', 38, 4, 34, 38, 1),
(151, '2026-01-19', 'scheduled', 24, 4, 58, 127, 1),
(152, '2026-01-20', 'scheduled', 25, 4, 73, 40, 1),
(153, '2026-01-19', 'scheduled', 26, 4, 99, 42, 1),
(154, '2026-01-21', 'scheduled', 35, 4, 111, 34, 1),
(155, '2026-01-20', 'scheduled', 26, 4, 135, 42, 1),
(156, '2026-01-22', 'scheduled', 38, 4, 188, 39, 1),
(157, '2026-01-23', 'scheduled', 25, 4, 163, 41, 1),
(158, '2026-01-21', 'scheduled', 32, 4, 192, 104, 1),
(159, '2026-01-28', 'scheduled', 30, 4, 130, 126, 1),
(160, '2026-01-26', 'scheduled', 35, 4, 157, 34, 1),
(161, '2026-01-30', 'scheduled', 37, 4, 1, 36, 1),
(162, '2026-01-27', 'scheduled', 38, 4, 34, 38, 1),
(163, '2026-01-26', 'scheduled', 24, 4, 58, 127, 1),
(164, '2026-01-27', 'scheduled', 25, 4, 73, 40, 1),
(165, '2026-01-26', 'scheduled', 26, 4, 99, 42, 1),
(166, '2026-01-28', 'scheduled', 35, 4, 111, 34, 1),
(167, '2026-01-27', 'scheduled', 26, 4, 135, 42, 1),
(168, '2026-01-29', 'scheduled', 38, 4, 188, 39, 1),
(169, '2026-01-30', 'scheduled', 25, 4, 163, 41, 1),
(170, '2026-01-28', 'scheduled', 32, 4, 192, 104, 1),
(171, '2026-02-04', 'scheduled', 30, 4, 130, 126, 1),
(172, '2026-02-02', 'scheduled', 35, 4, 157, 34, 1),
(173, '2026-02-06', 'scheduled', 37, 4, 1, 36, 1),
(174, '2026-02-03', 'scheduled', 38, 4, 34, 38, 1),
(175, '2026-02-02', 'scheduled', 24, 4, 58, 127, 1),
(176, '2026-02-03', 'scheduled', 25, 4, 73, 40, 1),
(177, '2026-02-02', 'scheduled', 26, 4, 99, 42, 1),
(178, '2026-02-04', 'scheduled', 35, 4, 111, 34, 1),
(179, '2026-02-03', 'scheduled', 26, 4, 135, 42, 1),
(180, '2026-02-05', 'scheduled', 38, 4, 188, 39, 1),
(181, '2026-02-06', 'scheduled', 25, 4, 163, 41, 1),
(182, '2026-02-04', 'scheduled', 32, 4, 192, 104, 1),
(183, '2026-02-11', 'scheduled', 30, 4, 130, 126, 1),
(184, '2026-02-09', 'scheduled', 35, 4, 157, 34, 1),
(185, '2026-02-13', 'scheduled', 37, 4, 1, 36, 1),
(186, '2026-02-10', 'scheduled', 38, 4, 34, 38, 1),
(187, '2026-02-09', 'scheduled', 24, 4, 58, 127, 1),
(188, '2026-02-10', 'scheduled', 25, 4, 73, 40, 1),
(189, '2026-02-09', 'scheduled', 26, 4, 99, 42, 1),
(190, '2026-02-11', 'scheduled', 35, 4, 111, 34, 1),
(191, '2026-02-10', 'scheduled', 26, 4, 135, 42, 1),
(192, '2026-02-12', 'scheduled', 38, 4, 188, 39, 1),
(193, '2026-02-13', 'scheduled', 25, 4, 163, 41, 1),
(194, '2026-02-11', 'scheduled', 32, 4, 192, 104, 1),
(195, '2026-02-18', 'scheduled', 30, 4, 130, 126, 1),
(196, '2026-02-16', 'scheduled', 35, 4, 157, 34, 1),
(197, '2026-02-20', 'scheduled', 37, 4, 1, 36, 1),
(198, '2026-02-17', 'scheduled', 38, 4, 34, 38, 1),
(199, '2026-02-16', 'scheduled', 24, 4, 58, 127, 1),
(200, '2026-02-17', 'scheduled', 25, 4, 73, 40, 1),
(201, '2026-02-16', 'scheduled', 26, 4, 99, 42, 1),
(202, '2026-02-18', 'scheduled', 35, 4, 111, 34, 1),
(203, '2026-02-17', 'scheduled', 26, 4, 135, 42, 1),
(204, '2026-02-19', 'scheduled', 38, 4, 188, 39, 1),
(205, '2026-02-20', 'scheduled', 25, 4, 163, 41, 1),
(206, '2026-02-18', 'scheduled', 32, 4, 192, 104, 1),
(207, '2026-02-25', 'scheduled', 30, 4, 130, 126, 1),
(208, '2026-02-23', 'scheduled', 35, 4, 157, 34, 1),
(209, '2026-02-27', 'scheduled', 37, 4, 1, 36, 1),
(210, '2026-02-24', 'scheduled', 38, 4, 34, 38, 1),
(211, '2026-02-23', 'scheduled', 24, 4, 58, 127, 1),
(212, '2026-02-24', 'scheduled', 25, 4, 73, 40, 1),
(213, '2026-02-23', 'scheduled', 26, 4, 99, 42, 1),
(214, '2026-02-25', 'scheduled', 35, 4, 111, 34, 1),
(215, '2026-02-24', 'scheduled', 26, 4, 135, 42, 1),
(216, '2026-02-26', 'scheduled', 38, 4, 188, 39, 1),
(217, '2026-02-27', 'scheduled', 25, 4, 163, 41, 1),
(218, '2026-02-25', 'scheduled', 32, 4, 192, 104, 1),
(219, '2026-03-04', 'scheduled', 30, 4, 130, 126, 1),
(220, '2026-03-02', 'scheduled', 35, 4, 157, 34, 1),
(221, '2026-03-06', 'scheduled', 37, 4, 1, 36, 1),
(222, '2026-03-03', 'scheduled', 38, 4, 34, 38, 1),
(223, '2026-03-02', 'scheduled', 24, 4, 58, 127, 1),
(224, '2026-03-03', 'scheduled', 25, 4, 73, 40, 1),
(225, '2026-03-02', 'scheduled', 26, 4, 99, 42, 1),
(226, '2026-03-04', 'scheduled', 35, 4, 111, 34, 1),
(227, '2026-03-03', 'scheduled', 26, 4, 135, 42, 1),
(228, '2026-03-05', 'scheduled', 38, 4, 188, 39, 1),
(229, '2026-03-06', 'scheduled', 25, 4, 163, 41, 1),
(230, '2026-03-04', 'scheduled', 32, 4, 192, 104, 1),
(231, '2026-03-11', 'scheduled', 30, 4, 130, 126, 1),
(232, '2026-03-09', 'scheduled', 35, 4, 157, 34, 1),
(233, '2026-03-13', 'scheduled', 37, 4, 1, 36, 1),
(234, '2026-03-10', 'scheduled', 38, 4, 34, 38, 1),
(235, '2026-03-09', 'scheduled', 24, 4, 58, 127, 1),
(236, '2026-03-10', 'scheduled', 25, 4, 73, 40, 1),
(237, '2026-03-09', 'scheduled', 26, 4, 99, 42, 1),
(238, '2026-03-11', 'scheduled', 35, 4, 111, 34, 1),
(239, '2026-03-10', 'scheduled', 26, 4, 135, 42, 1),
(240, '2026-03-12', 'scheduled', 38, 4, 188, 39, 1),
(241, '2026-03-13', 'scheduled', 25, 4, 163, 41, 1),
(242, '2026-03-11', 'scheduled', 32, 4, 192, 104, 1),
(243, '2026-03-18', 'scheduled', 30, 4, 130, 126, 1),
(244, '2026-03-16', 'scheduled', 35, 4, 157, 34, 1),
(245, '2026-03-20', 'scheduled', 37, 4, 1, 36, 1),
(246, '2026-03-17', 'scheduled', 38, 4, 34, 38, 1),
(247, '2026-03-16', 'scheduled', 24, 4, 58, 127, 1),
(248, '2026-03-17', 'scheduled', 25, 4, 73, 40, 1),
(249, '2026-03-16', 'scheduled', 26, 4, 99, 42, 1),
(250, '2026-03-18', 'scheduled', 35, 4, 111, 34, 1),
(251, '2026-03-17', 'scheduled', 26, 4, 135, 42, 1),
(252, '2026-03-19', 'scheduled', 38, 4, 188, 39, 1),
(253, '2026-03-20', 'scheduled', 25, 4, 163, 41, 1),
(254, '2026-03-18', 'scheduled', 32, 4, 192, 104, 1),
(255, '2026-03-25', 'scheduled', 30, 4, 130, 126, 1),
(256, '2026-03-23', 'scheduled', 35, 4, 157, 34, 1),
(257, '2026-03-27', 'scheduled', 37, 4, 1, 36, 1),
(258, '2026-03-24', 'scheduled', 38, 4, 34, 38, 1),
(259, '2026-03-23', 'scheduled', 24, 4, 58, 127, 1),
(260, '2026-03-24', 'scheduled', 25, 4, 73, 40, 1),
(261, '2026-03-23', 'scheduled', 26, 4, 99, 42, 1),
(262, '2026-03-25', 'scheduled', 35, 4, 111, 34, 1),
(263, '2026-03-24', 'scheduled', 26, 4, 135, 42, 1),
(264, '2026-03-26', 'scheduled', 38, 4, 188, 39, 1),
(265, '2026-03-27', 'scheduled', 25, 4, 163, 41, 1),
(266, '2026-03-25', 'scheduled', 32, 4, 192, 104, 1),
(267, '2026-04-01', 'scheduled', 30, 4, 130, 126, 1),
(268, '2026-03-30', 'scheduled', 35, 4, 157, 34, 1),
(269, '2026-04-03', 'scheduled', 37, 4, 1, 36, 1),
(270, '2026-03-31', 'scheduled', 38, 4, 34, 38, 1),
(271, '2026-03-30', 'scheduled', 24, 4, 58, 127, 1),
(272, '2026-03-31', 'scheduled', 25, 4, 73, 40, 1),
(273, '2026-03-30', 'scheduled', 26, 4, 99, 42, 1),
(274, '2026-04-01', 'scheduled', 35, 4, 111, 34, 1),
(275, '2026-03-31', 'scheduled', 26, 4, 135, 42, 1),
(276, '2026-04-02', 'scheduled', 38, 4, 188, 39, 1),
(277, '2026-04-03', 'scheduled', 25, 4, 163, 41, 1),
(278, '2026-04-01', 'scheduled', 32, 4, 192, 104, 1),
(291, '2026-01-12', 'scheduled', 30, 3, 37, 126, 1),
(292, '2026-01-14', 'scheduled', 35, 3, 129, 34, 1),
(293, '2026-01-12', 'scheduled', 37, 3, 158, 36, 1),
(294, '2026-01-13', 'scheduled', 38, 3, 13, 38, 1),
(295, '2026-01-14', 'scheduled', 24, 3, 30, 127, 1),
(296, '2026-01-13', 'scheduled', 25, 3, 54, 40, 1),
(297, '2026-01-15', 'scheduled', 26, 3, 65, 42, 1),
(298, '2026-01-16', 'scheduled', 35, 3, 103, 34, 1),
(299, '2026-01-16', 'scheduled', 26, 3, 81, 42, 1),
(300, '2026-01-14', 'scheduled', 37, 3, 191, 37, 1),
(301, '2026-01-15', 'scheduled', 38, 3, 187, 39, 1),
(302, '2026-01-15', 'scheduled', 25, 3, 168, 41, 1),
(303, '2026-01-12', 'scheduled', 32, 3, 179, 104, 1),
(304, '2026-01-19', 'scheduled', 30, 3, 37, 126, 1),
(305, '2026-01-21', 'scheduled', 35, 3, 129, 34, 1),
(306, '2026-01-19', 'scheduled', 37, 3, 158, 36, 1),
(307, '2026-01-20', 'scheduled', 38, 3, 13, 38, 1),
(308, '2026-01-21', 'scheduled', 24, 3, 30, 127, 1),
(309, '2026-01-20', 'scheduled', 25, 3, 54, 40, 1),
(310, '2026-01-22', 'scheduled', 26, 3, 65, 42, 1),
(311, '2026-01-23', 'scheduled', 35, 3, 103, 34, 1),
(312, '2026-01-23', 'scheduled', 26, 3, 81, 42, 1),
(313, '2026-01-21', 'scheduled', 37, 3, 191, 37, 1),
(314, '2026-01-22', 'scheduled', 38, 3, 187, 39, 1),
(315, '2026-01-22', 'scheduled', 25, 3, 168, 41, 1),
(316, '2026-01-19', 'scheduled', 32, 3, 179, 104, 1),
(317, '2026-01-26', 'scheduled', 30, 3, 37, 126, 1),
(318, '2026-01-28', 'scheduled', 35, 3, 129, 34, 1),
(319, '2026-01-26', 'scheduled', 37, 3, 158, 36, 1),
(320, '2026-01-27', 'scheduled', 38, 3, 13, 38, 1),
(321, '2026-01-28', 'scheduled', 24, 3, 30, 127, 1),
(322, '2026-01-27', 'scheduled', 25, 3, 54, 40, 1),
(323, '2026-01-29', 'scheduled', 26, 3, 65, 42, 1),
(324, '2026-01-30', 'scheduled', 35, 3, 103, 34, 1),
(325, '2026-01-30', 'scheduled', 26, 3, 81, 42, 1),
(326, '2026-01-28', 'scheduled', 37, 3, 191, 37, 1),
(327, '2026-01-29', 'scheduled', 38, 3, 187, 39, 1),
(328, '2026-01-29', 'scheduled', 25, 3, 168, 41, 1),
(329, '2026-01-26', 'scheduled', 32, 3, 179, 104, 1),
(330, '2026-02-02', 'scheduled', 30, 3, 37, 126, 1),
(331, '2026-02-04', 'scheduled', 35, 3, 129, 34, 1),
(332, '2026-02-02', 'scheduled', 37, 3, 158, 36, 1),
(333, '2026-02-03', 'scheduled', 38, 3, 13, 38, 1),
(334, '2026-02-04', 'scheduled', 24, 3, 30, 127, 1),
(335, '2026-02-03', 'scheduled', 25, 3, 54, 40, 1),
(336, '2026-02-05', 'scheduled', 26, 3, 65, 42, 1),
(337, '2026-02-06', 'scheduled', 35, 3, 103, 34, 1),
(338, '2026-02-06', 'scheduled', 26, 3, 81, 42, 1),
(339, '2026-02-04', 'scheduled', 37, 3, 191, 37, 1),
(340, '2026-02-05', 'scheduled', 38, 3, 187, 39, 1),
(341, '2026-02-05', 'scheduled', 25, 3, 168, 41, 1),
(342, '2026-02-02', 'scheduled', 32, 3, 179, 104, 1),
(343, '2026-02-09', 'scheduled', 30, 3, 37, 126, 1),
(344, '2026-02-11', 'scheduled', 35, 3, 129, 34, 1),
(345, '2026-02-09', 'scheduled', 37, 3, 158, 36, 1),
(346, '2026-02-10', 'scheduled', 38, 3, 13, 38, 1),
(347, '2026-02-11', 'scheduled', 24, 3, 30, 127, 1),
(348, '2026-02-10', 'scheduled', 25, 3, 54, 40, 1),
(349, '2026-02-12', 'scheduled', 26, 3, 65, 42, 1),
(350, '2026-02-13', 'scheduled', 35, 3, 103, 34, 1),
(351, '2026-02-13', 'scheduled', 26, 3, 81, 42, 1),
(352, '2026-02-11', 'scheduled', 37, 3, 191, 37, 1),
(353, '2026-02-12', 'scheduled', 38, 3, 187, 39, 1),
(354, '2026-02-12', 'scheduled', 25, 3, 168, 41, 1),
(355, '2026-02-09', 'scheduled', 32, 3, 179, 104, 1),
(356, '2026-02-16', 'scheduled', 30, 3, 37, 126, 1),
(357, '2026-02-18', 'scheduled', 35, 3, 129, 34, 1),
(358, '2026-02-16', 'scheduled', 37, 3, 158, 36, 1),
(359, '2026-02-17', 'scheduled', 38, 3, 13, 38, 1),
(360, '2026-02-18', 'scheduled', 24, 3, 30, 127, 1),
(361, '2026-02-17', 'scheduled', 25, 3, 54, 40, 1),
(362, '2026-02-19', 'scheduled', 26, 3, 65, 42, 1),
(363, '2026-02-20', 'scheduled', 35, 3, 103, 34, 1),
(364, '2026-02-20', 'scheduled', 26, 3, 81, 42, 1),
(365, '2026-02-18', 'scheduled', 37, 3, 191, 37, 1),
(366, '2026-02-19', 'scheduled', 38, 3, 187, 39, 1),
(367, '2026-02-19', 'scheduled', 25, 3, 168, 41, 1),
(368, '2026-02-16', 'scheduled', 32, 3, 179, 104, 1),
(369, '2026-02-23', 'scheduled', 30, 3, 37, 126, 1),
(370, '2026-02-25', 'scheduled', 35, 3, 129, 34, 1),
(371, '2026-02-23', 'scheduled', 37, 3, 158, 36, 1),
(372, '2026-02-24', 'scheduled', 38, 3, 13, 38, 1),
(373, '2026-02-25', 'scheduled', 24, 3, 30, 127, 1),
(374, '2026-02-24', 'scheduled', 25, 3, 54, 40, 1),
(375, '2026-02-26', 'scheduled', 26, 3, 65, 42, 1),
(376, '2026-02-27', 'scheduled', 35, 3, 103, 34, 1),
(377, '2026-02-27', 'scheduled', 26, 3, 81, 42, 1),
(378, '2026-02-25', 'scheduled', 37, 3, 191, 37, 1),
(379, '2026-02-26', 'scheduled', 38, 3, 187, 39, 1),
(380, '2026-02-26', 'scheduled', 25, 3, 168, 41, 1),
(381, '2026-02-23', 'scheduled', 32, 3, 179, 104, 1),
(382, '2026-03-02', 'scheduled', 30, 3, 37, 126, 1),
(383, '2026-03-04', 'scheduled', 35, 3, 129, 34, 1),
(384, '2026-03-02', 'scheduled', 37, 3, 158, 36, 1),
(385, '2026-03-03', 'scheduled', 38, 3, 13, 38, 1),
(386, '2026-03-04', 'scheduled', 24, 3, 30, 127, 1),
(387, '2026-03-03', 'scheduled', 25, 3, 54, 40, 1),
(388, '2026-03-05', 'scheduled', 26, 3, 65, 42, 1),
(389, '2026-03-06', 'scheduled', 35, 3, 103, 34, 1),
(390, '2026-03-06', 'scheduled', 26, 3, 81, 42, 1),
(391, '2026-03-04', 'scheduled', 37, 3, 191, 37, 1),
(392, '2026-03-05', 'scheduled', 38, 3, 187, 39, 1),
(393, '2026-03-05', 'scheduled', 25, 3, 168, 41, 1),
(394, '2026-03-02', 'scheduled', 32, 3, 179, 104, 1),
(395, '2026-03-09', 'scheduled', 30, 3, 37, 126, 1),
(396, '2026-03-11', 'scheduled', 35, 3, 129, 34, 1),
(397, '2026-03-09', 'scheduled', 37, 3, 158, 36, 1),
(398, '2026-03-10', 'scheduled', 38, 3, 13, 38, 1),
(399, '2026-03-11', 'scheduled', 24, 3, 30, 127, 1),
(400, '2026-03-10', 'scheduled', 25, 3, 54, 40, 1),
(401, '2026-03-12', 'scheduled', 26, 3, 65, 42, 1),
(402, '2026-03-13', 'scheduled', 35, 3, 103, 34, 1),
(403, '2026-03-13', 'scheduled', 26, 3, 81, 42, 1),
(404, '2026-03-11', 'scheduled', 37, 3, 191, 37, 1),
(405, '2026-03-12', 'scheduled', 38, 3, 187, 39, 1),
(406, '2026-03-12', 'scheduled', 25, 3, 168, 41, 1),
(407, '2026-03-09', 'scheduled', 32, 3, 179, 104, 1),
(408, '2026-03-16', 'scheduled', 30, 3, 37, 126, 1),
(409, '2026-03-18', 'scheduled', 35, 3, 129, 34, 1),
(410, '2026-03-16', 'scheduled', 37, 3, 158, 36, 1),
(411, '2026-03-17', 'scheduled', 38, 3, 13, 38, 1),
(412, '2026-03-18', 'scheduled', 24, 3, 30, 127, 1),
(413, '2026-03-17', 'scheduled', 25, 3, 54, 40, 1),
(414, '2026-03-19', 'scheduled', 26, 3, 65, 42, 1),
(415, '2026-03-20', 'scheduled', 35, 3, 103, 34, 1),
(416, '2026-03-20', 'scheduled', 26, 3, 81, 42, 1),
(417, '2026-03-18', 'scheduled', 37, 3, 191, 37, 1),
(418, '2026-03-19', 'scheduled', 38, 3, 187, 39, 1),
(419, '2026-03-19', 'scheduled', 25, 3, 168, 41, 1),
(420, '2026-03-16', 'scheduled', 32, 3, 179, 104, 1),
(421, '2026-03-23', 'scheduled', 30, 3, 37, 126, 1),
(422, '2026-03-25', 'scheduled', 35, 3, 129, 34, 1),
(423, '2026-03-23', 'scheduled', 37, 3, 158, 36, 1),
(424, '2026-03-24', 'scheduled', 38, 3, 13, 38, 1),
(425, '2026-03-25', 'scheduled', 24, 3, 30, 127, 1),
(426, '2026-03-24', 'scheduled', 25, 3, 54, 40, 1),
(427, '2026-03-26', 'scheduled', 26, 3, 65, 42, 1),
(428, '2026-03-27', 'scheduled', 35, 3, 103, 34, 1),
(429, '2026-03-27', 'scheduled', 26, 3, 81, 42, 1),
(430, '2026-03-25', 'scheduled', 37, 3, 191, 37, 1),
(431, '2026-03-26', 'scheduled', 38, 3, 187, 39, 1),
(432, '2026-03-26', 'scheduled', 25, 3, 168, 41, 1),
(433, '2026-03-23', 'scheduled', 32, 3, 179, 104, 1),
(434, '2026-03-30', 'scheduled', 30, 3, 37, 126, 1),
(435, '2026-04-01', 'scheduled', 35, 3, 129, 34, 1),
(436, '2026-03-30', 'scheduled', 37, 3, 158, 36, 1),
(437, '2026-03-31', 'scheduled', 38, 3, 13, 38, 1),
(438, '2026-04-01', 'scheduled', 24, 3, 30, 127, 1),
(439, '2026-03-31', 'scheduled', 25, 3, 54, 40, 1),
(440, '2026-04-02', 'scheduled', 26, 3, 65, 42, 1),
(441, '2026-04-03', 'scheduled', 35, 3, 103, 34, 1),
(442, '2026-04-03', 'scheduled', 26, 3, 81, 42, 1),
(443, '2026-04-01', 'scheduled', 37, 3, 191, 37, 1),
(444, '2026-04-02', 'scheduled', 38, 3, 187, 39, 1),
(445, '2026-04-02', 'scheduled', 25, 3, 168, 41, 1),
(446, '2026-03-30', 'scheduled', 32, 3, 179, 104, 1),
(447, '2026-04-06', 'scheduled', 30, 3, 37, 126, 1),
(448, '2026-04-08', 'scheduled', 35, 3, 129, 34, 1),
(449, '2026-04-06', 'scheduled', 37, 3, 158, 36, 1),
(450, '2026-04-07', 'scheduled', 38, 3, 13, 38, 1),
(451, '2026-04-08', 'scheduled', 24, 3, 30, 127, 1),
(452, '2026-04-07', 'scheduled', 25, 3, 54, 40, 1),
(453, '2026-04-09', 'scheduled', 26, 3, 65, 42, 1),
(454, '2026-04-10', 'scheduled', 35, 3, 103, 34, 1),
(455, '2026-04-10', 'scheduled', 26, 3, 81, 42, 1),
(456, '2026-04-08', 'scheduled', 37, 3, 191, 37, 1),
(457, '2026-04-09', 'scheduled', 38, 3, 187, 39, 1),
(458, '2026-04-09', 'scheduled', 25, 3, 168, 41, 1),
(459, '2026-04-06', 'scheduled', 32, 3, 179, 104, 1),
(460, '2026-01-12', 'scheduled', 31, 2, 17, 19, 1),
(461, '2026-01-12', 'scheduled', 35, 2, 38, 34, 1),
(462, '2026-01-14', 'scheduled', 30, 2, 109, 130, 1),
(463, '2026-01-13', 'scheduled', 31, 2, 133, 131, 1),
(464, '2026-01-13', 'scheduled', 31, 2, 154, 100, 1),
(465, '2026-01-14', 'scheduled', 22, 2, 10, 102, 1),
(466, '2026-01-15', 'scheduled', 31, 2, 45, 19, 1),
(467, '2026-01-16', 'scheduled', 35, 2, 61, 34, 1),
(468, '2026-01-15', 'scheduled', 31, 2, 86, 100, 1),
(469, '2026-01-16', 'scheduled', 22, 2, 102, 102, 1),
(470, '2026-01-19', 'scheduled', 31, 2, 17, 19, 1),
(471, '2026-01-19', 'scheduled', 35, 2, 38, 34, 1),
(472, '2026-01-21', 'scheduled', 30, 2, 109, 130, 1),
(473, '2026-01-20', 'scheduled', 31, 2, 133, 131, 1),
(474, '2026-01-20', 'scheduled', 31, 2, 154, 100, 1),
(475, '2026-01-21', 'scheduled', 22, 2, 10, 102, 1),
(476, '2026-01-22', 'scheduled', 31, 2, 45, 19, 1),
(477, '2026-01-23', 'scheduled', 35, 2, 61, 34, 1),
(478, '2026-01-22', 'scheduled', 31, 2, 86, 100, 1),
(479, '2026-01-23', 'scheduled', 22, 2, 102, 102, 1),
(480, '2026-01-26', 'scheduled', 31, 2, 17, 19, 1),
(481, '2026-01-26', 'scheduled', 35, 2, 38, 34, 1),
(482, '2026-01-28', 'scheduled', 30, 2, 109, 130, 1),
(483, '2026-01-27', 'scheduled', 31, 2, 133, 131, 1),
(484, '2026-01-27', 'scheduled', 31, 2, 154, 100, 1),
(485, '2026-01-28', 'scheduled', 22, 2, 10, 102, 1),
(486, '2026-01-29', 'scheduled', 31, 2, 45, 19, 1),
(487, '2026-01-30', 'scheduled', 35, 2, 61, 34, 1),
(488, '2026-01-29', 'scheduled', 31, 2, 86, 100, 1),
(489, '2026-01-30', 'scheduled', 22, 2, 102, 102, 1),
(490, '2026-02-02', 'scheduled', 31, 2, 17, 19, 1),
(491, '2026-02-02', 'scheduled', 35, 2, 38, 34, 1),
(492, '2026-02-04', 'scheduled', 30, 2, 109, 130, 1),
(493, '2026-02-03', 'scheduled', 31, 2, 133, 131, 1),
(494, '2026-02-03', 'scheduled', 31, 2, 154, 100, 1),
(495, '2026-02-04', 'scheduled', 22, 2, 10, 102, 1),
(496, '2026-02-05', 'scheduled', 31, 2, 45, 19, 1),
(497, '2026-02-06', 'scheduled', 35, 2, 61, 34, 1),
(498, '2026-02-05', 'scheduled', 31, 2, 86, 100, 1),
(499, '2026-02-06', 'scheduled', 22, 2, 102, 102, 1),
(500, '2026-02-09', 'scheduled', 31, 2, 17, 19, 1),
(501, '2026-02-09', 'scheduled', 35, 2, 38, 34, 1),
(502, '2026-02-11', 'scheduled', 30, 2, 109, 130, 1),
(503, '2026-02-10', 'scheduled', 31, 2, 133, 131, 1),
(504, '2026-02-10', 'scheduled', 31, 2, 154, 100, 1),
(505, '2026-02-11', 'scheduled', 22, 2, 10, 102, 1),
(506, '2026-02-12', 'scheduled', 31, 2, 45, 19, 1),
(507, '2026-02-13', 'scheduled', 35, 2, 61, 34, 1),
(508, '2026-02-12', 'scheduled', 31, 2, 86, 100, 1),
(509, '2026-02-13', 'scheduled', 22, 2, 102, 102, 1),
(510, '2026-02-16', 'scheduled', 31, 2, 17, 19, 1),
(511, '2026-02-16', 'scheduled', 35, 2, 38, 34, 1),
(512, '2026-02-18', 'scheduled', 30, 2, 109, 130, 1),
(513, '2026-02-17', 'scheduled', 31, 2, 133, 131, 1),
(514, '2026-02-17', 'scheduled', 31, 2, 154, 100, 1),
(515, '2026-02-18', 'scheduled', 22, 2, 10, 102, 1),
(516, '2026-02-19', 'scheduled', 31, 2, 45, 19, 1),
(517, '2026-02-20', 'scheduled', 35, 2, 61, 34, 1),
(518, '2026-02-19', 'scheduled', 31, 2, 86, 100, 1),
(519, '2026-02-20', 'scheduled', 22, 2, 102, 102, 1),
(520, '2026-02-23', 'scheduled', 31, 2, 17, 19, 1),
(521, '2026-02-23', 'scheduled', 35, 2, 38, 34, 1),
(522, '2026-02-25', 'scheduled', 30, 2, 109, 130, 1),
(523, '2026-02-24', 'scheduled', 31, 2, 133, 131, 1),
(524, '2026-02-24', 'scheduled', 31, 2, 154, 100, 1),
(525, '2026-02-25', 'scheduled', 22, 2, 10, 102, 1),
(526, '2026-02-26', 'scheduled', 31, 2, 45, 19, 1),
(527, '2026-02-27', 'scheduled', 35, 2, 61, 34, 1),
(528, '2026-02-26', 'scheduled', 31, 2, 86, 100, 1),
(529, '2026-02-27', 'scheduled', 22, 2, 102, 102, 1),
(530, '2026-03-02', 'scheduled', 31, 2, 17, 19, 1),
(531, '2026-03-02', 'scheduled', 35, 2, 38, 34, 1),
(532, '2026-03-04', 'scheduled', 30, 2, 109, 130, 1),
(533, '2026-03-03', 'scheduled', 31, 2, 133, 131, 1),
(534, '2026-03-03', 'scheduled', 31, 2, 154, 100, 1),
(535, '2026-03-04', 'scheduled', 22, 2, 10, 102, 1),
(536, '2026-03-05', 'scheduled', 31, 2, 45, 19, 1),
(537, '2026-03-06', 'scheduled', 35, 2, 61, 34, 1),
(538, '2026-03-05', 'scheduled', 31, 2, 86, 100, 1),
(539, '2026-03-06', 'scheduled', 22, 2, 102, 102, 1),
(540, '2026-03-09', 'scheduled', 31, 2, 17, 19, 1),
(541, '2026-03-09', 'scheduled', 35, 2, 38, 34, 1),
(542, '2026-03-11', 'scheduled', 30, 2, 109, 130, 1),
(543, '2026-03-10', 'scheduled', 31, 2, 133, 131, 1),
(544, '2026-03-10', 'scheduled', 31, 2, 154, 100, 1),
(545, '2026-03-11', 'scheduled', 22, 2, 10, 102, 1),
(546, '2026-03-12', 'scheduled', 31, 2, 45, 19, 1),
(547, '2026-03-13', 'scheduled', 35, 2, 61, 34, 1),
(548, '2026-03-12', 'scheduled', 31, 2, 86, 100, 1),
(549, '2026-03-13', 'scheduled', 22, 2, 102, 102, 1),
(550, '2026-03-16', 'scheduled', 31, 2, 17, 19, 1),
(551, '2026-03-16', 'scheduled', 35, 2, 38, 34, 1),
(552, '2026-03-18', 'scheduled', 30, 2, 109, 130, 1),
(553, '2026-03-17', 'scheduled', 31, 2, 133, 131, 1),
(554, '2026-03-17', 'scheduled', 31, 2, 154, 100, 1),
(555, '2026-03-18', 'scheduled', 22, 2, 10, 102, 1),
(556, '2026-03-19', 'scheduled', 31, 2, 45, 19, 1),
(557, '2026-03-20', 'scheduled', 35, 2, 61, 34, 1),
(558, '2026-03-19', 'scheduled', 31, 2, 86, 100, 1),
(559, '2026-03-20', 'scheduled', 22, 2, 102, 102, 1),
(560, '2026-03-23', 'scheduled', 31, 2, 17, 19, 1),
(561, '2026-03-23', 'scheduled', 35, 2, 38, 34, 1),
(562, '2026-03-25', 'scheduled', 30, 2, 109, 130, 1),
(563, '2026-03-24', 'scheduled', 31, 2, 133, 131, 1),
(564, '2026-03-24', 'scheduled', 31, 2, 154, 100, 1),
(565, '2026-03-25', 'scheduled', 22, 2, 10, 102, 1),
(566, '2026-03-26', 'scheduled', 31, 2, 45, 19, 1),
(567, '2026-03-27', 'scheduled', 35, 2, 61, 34, 1),
(568, '2026-03-26', 'scheduled', 31, 2, 86, 100, 1),
(569, '2026-03-27', 'scheduled', 22, 2, 102, 102, 1),
(570, '2026-03-30', 'scheduled', 31, 2, 17, 19, 1),
(571, '2026-03-30', 'scheduled', 35, 2, 38, 34, 1),
(572, '2026-04-01', 'scheduled', 30, 2, 109, 130, 1),
(573, '2026-03-31', 'scheduled', 31, 2, 133, 131, 1),
(574, '2026-03-31', 'scheduled', 31, 2, 154, 100, 1),
(575, '2026-04-01', 'scheduled', 22, 2, 10, 102, 1),
(576, '2026-04-02', 'scheduled', 31, 2, 45, 19, 1),
(577, '2026-04-03', 'scheduled', 35, 2, 61, 34, 1),
(578, '2026-04-02', 'scheduled', 31, 2, 86, 100, 1),
(579, '2026-04-03', 'scheduled', 22, 2, 102, 102, 1),
(580, '2026-04-06', 'scheduled', 31, 2, 17, 19, 1),
(581, '2026-04-06', 'scheduled', 35, 2, 38, 34, 1),
(582, '2026-04-08', 'scheduled', 30, 2, 109, 130, 1),
(583, '2026-04-07', 'scheduled', 31, 2, 133, 131, 1),
(584, '2026-04-07', 'scheduled', 31, 2, 154, 100, 1),
(585, '2026-04-08', 'scheduled', 22, 2, 10, 102, 1),
(586, '2026-04-09', 'scheduled', 31, 2, 45, 19, 1),
(587, '2026-04-10', 'scheduled', 35, 2, 61, 34, 1),
(588, '2026-04-09', 'scheduled', 31, 2, 86, 100, 1),
(589, '2026-04-10', 'scheduled', 22, 2, 102, 102, 1),
(590, '2026-01-14', 'scheduled', 33, 1, 49, 1, 1),
(591, '2026-01-14', 'scheduled', 31, 1, 70, 3, 1),
(592, '2026-01-13', 'scheduled', 35, 1, 93, 5, 1),
(593, '2026-01-13', 'scheduled', 21, 1, 114, 7, 1),
(594, '2026-01-15', 'scheduled', 23, 1, 125, 9, 1),
(595, '2026-01-16', 'scheduled', 33, 1, 141, 1, 1),
(596, '2026-01-16', 'scheduled', 31, 1, 42, 3, 1),
(597, '2026-01-15', 'scheduled', 21, 1, 66, 7, 1),
(598, '2026-01-16', 'scheduled', 23, 1, 83, 9, 1),
(599, '2026-01-15', 'scheduled', 35, 1, 167, 6, 1),
(600, '2026-01-21', 'scheduled', 33, 1, 49, 1, 1),
(601, '2026-01-21', 'scheduled', 31, 1, 70, 3, 1),
(602, '2026-01-20', 'scheduled', 35, 1, 93, 5, 1),
(603, '2026-01-20', 'scheduled', 21, 1, 114, 7, 1),
(604, '2026-01-22', 'scheduled', 23, 1, 125, 9, 1),
(605, '2026-01-23', 'scheduled', 33, 1, 141, 1, 1),
(606, '2026-01-23', 'scheduled', 31, 1, 42, 3, 1),
(607, '2026-01-22', 'scheduled', 21, 1, 66, 7, 1),
(608, '2026-01-23', 'scheduled', 23, 1, 83, 9, 1),
(609, '2026-01-22', 'scheduled', 35, 1, 167, 6, 1),
(610, '2026-01-28', 'scheduled', 33, 1, 49, 1, 1),
(611, '2026-01-28', 'scheduled', 31, 1, 70, 3, 1),
(612, '2026-01-27', 'scheduled', 35, 1, 93, 5, 1),
(613, '2026-01-27', 'scheduled', 21, 1, 114, 7, 1),
(614, '2026-01-29', 'scheduled', 23, 1, 125, 9, 1),
(615, '2026-01-30', 'scheduled', 33, 1, 141, 1, 1),
(616, '2026-01-30', 'scheduled', 31, 1, 42, 3, 1),
(617, '2026-01-29', 'scheduled', 21, 1, 66, 7, 1),
(618, '2026-01-30', 'scheduled', 23, 1, 83, 9, 1),
(619, '2026-01-29', 'scheduled', 35, 1, 167, 6, 1),
(620, '2026-02-04', 'scheduled', 33, 1, 49, 1, 1),
(621, '2026-02-04', 'scheduled', 31, 1, 70, 3, 1),
(622, '2026-02-03', 'scheduled', 35, 1, 93, 5, 1),
(623, '2026-02-03', 'scheduled', 21, 1, 114, 7, 1),
(624, '2026-02-05', 'scheduled', 23, 1, 125, 9, 1),
(625, '2026-02-06', 'scheduled', 33, 1, 141, 1, 1),
(626, '2026-02-06', 'scheduled', 31, 1, 42, 3, 1),
(627, '2026-02-05', 'scheduled', 21, 1, 66, 7, 1),
(628, '2026-02-06', 'scheduled', 23, 1, 83, 9, 1),
(629, '2026-02-05', 'scheduled', 35, 1, 167, 6, 1),
(630, '2026-02-11', 'scheduled', 33, 1, 49, 1, 1),
(631, '2026-02-11', 'scheduled', 31, 1, 70, 3, 1),
(632, '2026-02-10', 'scheduled', 35, 1, 93, 5, 1),
(633, '2026-02-10', 'scheduled', 21, 1, 114, 7, 1),
(634, '2026-02-12', 'scheduled', 23, 1, 125, 9, 1),
(635, '2026-02-13', 'scheduled', 33, 1, 141, 1, 1),
(636, '2026-02-13', 'scheduled', 31, 1, 42, 3, 1),
(637, '2026-02-12', 'scheduled', 21, 1, 66, 7, 1),
(638, '2026-02-13', 'scheduled', 23, 1, 83, 9, 1),
(639, '2026-02-12', 'scheduled', 35, 1, 167, 6, 1),
(640, '2026-02-18', 'scheduled', 33, 1, 49, 1, 1),
(641, '2026-02-18', 'scheduled', 31, 1, 70, 3, 1),
(642, '2026-02-17', 'scheduled', 35, 1, 93, 5, 1),
(643, '2026-02-17', 'scheduled', 21, 1, 114, 7, 1),
(644, '2026-02-19', 'scheduled', 23, 1, 125, 9, 1),
(645, '2026-02-20', 'scheduled', 33, 1, 141, 1, 1),
(646, '2026-02-20', 'scheduled', 31, 1, 42, 3, 1),
(647, '2026-02-19', 'scheduled', 21, 1, 66, 7, 1),
(648, '2026-02-20', 'scheduled', 23, 1, 83, 9, 1),
(649, '2026-02-19', 'scheduled', 35, 1, 167, 6, 1),
(650, '2026-02-25', 'scheduled', 33, 1, 49, 1, 1),
(651, '2026-02-25', 'scheduled', 31, 1, 70, 3, 1),
(652, '2026-02-24', 'scheduled', 35, 1, 93, 5, 1),
(653, '2026-02-24', 'scheduled', 21, 1, 114, 7, 1),
(654, '2026-02-26', 'scheduled', 23, 1, 125, 9, 1),
(655, '2026-02-27', 'scheduled', 33, 1, 141, 1, 1),
(656, '2026-02-27', 'scheduled', 31, 1, 42, 3, 1),
(657, '2026-02-26', 'scheduled', 21, 1, 66, 7, 1),
(658, '2026-02-27', 'scheduled', 23, 1, 83, 9, 1),
(659, '2026-02-26', 'scheduled', 35, 1, 167, 6, 1),
(660, '2026-03-04', 'scheduled', 33, 1, 49, 1, 1),
(661, '2026-03-04', 'scheduled', 31, 1, 70, 3, 1),
(662, '2026-03-03', 'scheduled', 35, 1, 93, 5, 1),
(663, '2026-03-03', 'scheduled', 21, 1, 114, 7, 1),
(664, '2026-03-05', 'scheduled', 23, 1, 125, 9, 1),
(665, '2026-03-06', 'scheduled', 33, 1, 141, 1, 1),
(666, '2026-03-06', 'scheduled', 31, 1, 42, 3, 1),
(667, '2026-03-05', 'scheduled', 21, 1, 66, 7, 1),
(668, '2026-03-06', 'scheduled', 23, 1, 83, 9, 1),
(669, '2026-03-05', 'scheduled', 35, 1, 167, 6, 1),
(670, '2026-03-11', 'scheduled', 33, 1, 49, 1, 1),
(671, '2026-03-11', 'scheduled', 31, 1, 70, 3, 1),
(672, '2026-03-10', 'scheduled', 35, 1, 93, 5, 1),
(673, '2026-03-10', 'scheduled', 21, 1, 114, 7, 1),
(674, '2026-03-12', 'scheduled', 23, 1, 125, 9, 1),
(675, '2026-03-13', 'scheduled', 33, 1, 141, 1, 1),
(676, '2026-03-13', 'scheduled', 31, 1, 42, 3, 1),
(677, '2026-03-12', 'scheduled', 21, 1, 66, 7, 1),
(678, '2026-03-13', 'scheduled', 23, 1, 83, 9, 1),
(679, '2026-03-12', 'scheduled', 35, 1, 167, 6, 1),
(680, '2026-03-18', 'scheduled', 33, 1, 49, 1, 1),
(681, '2026-03-18', 'scheduled', 31, 1, 70, 3, 1),
(682, '2026-03-17', 'scheduled', 35, 1, 93, 5, 1),
(683, '2026-03-17', 'scheduled', 21, 1, 114, 7, 1),
(684, '2026-03-19', 'scheduled', 23, 1, 125, 9, 1),
(685, '2026-03-20', 'scheduled', 33, 1, 141, 1, 1),
(686, '2026-03-20', 'scheduled', 31, 1, 42, 3, 1),
(687, '2026-03-19', 'scheduled', 21, 1, 66, 7, 1),
(688, '2026-03-20', 'scheduled', 23, 1, 83, 9, 1),
(689, '2026-03-19', 'scheduled', 35, 1, 167, 6, 1),
(690, '2026-03-25', 'scheduled', 33, 1, 49, 1, 1),
(691, '2026-03-25', 'scheduled', 31, 1, 70, 3, 1),
(692, '2026-03-24', 'scheduled', 35, 1, 93, 5, 1),
(693, '2026-03-24', 'scheduled', 21, 1, 114, 7, 1),
(694, '2026-03-26', 'scheduled', 23, 1, 125, 9, 1),
(695, '2026-03-27', 'scheduled', 33, 1, 141, 1, 1),
(696, '2026-03-27', 'scheduled', 31, 1, 42, 3, 1),
(697, '2026-03-26', 'scheduled', 21, 1, 66, 7, 1),
(698, '2026-03-27', 'scheduled', 23, 1, 83, 9, 1),
(699, '2026-03-26', 'scheduled', 35, 1, 167, 6, 1),
(733, '2026-04-08', 'scheduled', 30, 4, 130, 126, 1),
(734, '2026-04-06', 'scheduled', 35, 4, 157, 34, 1),
(735, '2026-04-10', 'scheduled', 37, 4, 1, 36, 1),
(736, '2026-04-07', 'scheduled', 38, 4, 34, 38, 1),
(737, '2026-04-06', 'scheduled', 24, 4, 58, 127, 1),
(738, '2026-04-07', 'scheduled', 25, 4, 73, 40, 1),
(739, '2026-04-06', 'scheduled', 26, 4, 99, 42, 1),
(740, '2026-04-08', 'scheduled', 35, 4, 111, 35, 1),
(741, '2026-04-07', 'scheduled', 26, 4, 135, 43, 1),
(742, '2026-04-09', 'scheduled', 38, 4, 188, 39, 1),
(743, '2026-04-10', 'scheduled', 25, 4, 163, 41, 1),
(744, '2026-04-08', 'scheduled', 32, 4, 192, 104, 1);

-- --------------------------------------------------------

--
-- Table structure for table `campus_course`
--

CREATE TABLE `campus_course` (
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
-- Dumping data for table `campus_course`
--

INSERT INTO `campus_course` (`course_id`, `course_code`, `course_name`, `total_credits_to_graduate`, `total_semester`, `semester_week`, `level`, `year_taken`, `specialization`, `internship`, `dept_id`) VALUES
(1, 'F-ICT-GEN', 'Foundation Programme (Computing & Technology Route)', 50, 3, 12, 'Foundation', 1, NULL, 0, 1),
(2, 'B-CS-AI', 'Bachelor of Computer Science (Hons) (Artificial Intelligence)', 50, 7, 14, 'Degree', 3, 'Artificial Intelligence', 1, 2),
(3, 'B-CS-CYB', 'Bachelor of Science (Honours) in Computer Science (Cyber Security)', 50, 7, 14, 'Degree', 3, 'Cyber Security', 1, 2),
(4, 'D-ICT-SE', 'Diploma in Information & Communication Technology with a specialism in Software Engineering', 50, 6, 14, 'Diploma', 2, 'Software Engineering', 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `campus_course_enrollment`
--

CREATE TABLE `campus_course_enrollment` (
  `id` int NOT NULL,
  `enrollment_status` varchar(20) NOT NULL,
  `student_id` int NOT NULL,
  `term_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `campus_course_enrollment`
--

INSERT INTO `campus_course_enrollment` (`id`, `enrollment_status`, `student_id`, `term_id`) VALUES
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
-- Table structure for table `campus_course_subject`
--

CREATE TABLE `campus_course_subject` (
  `id` int NOT NULL,
  `recommended_semester` int NOT NULL,
  `course_id` int NOT NULL,
  `subject_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `campus_course_subject`
--

INSERT INTO `campus_course_subject` (`id`, `recommended_semester`, `course_id`, `subject_id`) VALUES
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
-- Table structure for table `campus_departments`
--

CREATE TABLE `campus_departments` (
  `dept_id` int NOT NULL,
  `dept_name` varchar(100) NOT NULL,
  `dept_code` varchar(10) NOT NULL,
  `head_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `campus_departments`
--

INSERT INTO `campus_departments` (`dept_id`, `dept_name`, `dept_code`, `head_id`) VALUES
(1, 'Information & Communication Technology', 'ICT', NULL),
(2, 'Computer Science', 'CS', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `campus_facilities`
--

CREATE TABLE `campus_facilities` (
  `facility_id` int NOT NULL,
  `facility_name` varchar(100) NOT NULL,
  `type` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `campus_facilities`
--

INSERT INTO `campus_facilities` (`facility_id`, `facility_name`, `type`) VALUES
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
) ;

--
-- Dumping data for table `campus_faq`
--

INSERT INTO `campus_faq` (`id`, `title`, `content`, `category`, `published_time`, `last_edit`, `is_visitor_visible`, `is_ad_visible`, `is_lc_visible`, `is_tp_visible`, `view_count`, `n_likes`, `n_dislikes`, `slug`, `author_id`) VALUES
(2, 'a', '<p>a</p>', 'GEN', '2026-03-08 05:29:50.563000', '2026-03-08 13:59:59.756000', 0, 0, 0, 0, 2, 0, 0, 'a', 1),
(10, 'Studnet View Only', '<p>Student View</p>', 'ATT', '2026-03-08 14:40:44.998000', '2026-03-08 14:40:44.998000', 0, 0, 0, 1, 0, 0, 0, 'studnet-view-only', 1),
(11, 'Admin View Only', '<p>Admin View Only\r\nEdited\r\n</p>', 'ANN', '2026-03-08 14:42:11.000000', '2026-03-08 17:00:07.546000', 0, 1, 0, 0, 5, 1, 0, 'admin-view-only', 1),
(12, 'Lecturer View only', '<p>Lecturer view only</p>', 'GEN', '2026-03-08 14:42:31.296000', '2026-03-09 14:45:43.546000', 0, 0, 1, 0, 4, 0, 0, 'lecturer-view-only', 1),
(13, 'Visitor View Only', '<p>Welcome Visitor </p>', 'BOK', '2026-03-08 14:42:55.721000', '2026-03-11 02:07:49.324000', 1, 0, 0, 0, 17, 1, 0, 'visitor-view-only', 1),
(14, 'A long time ago', '<p><img src=\"/media/attachments/faq_14_c32a7302.png\"/></p><p>Testing </p><p>wwwwwwwwq\r\nass</p>', 'MAP', '2026-03-09 14:48:57.758000', '2026-03-09 14:48:57.822000', 0, 0, 1, 1, 1, 0, 0, 'a-long-time-ago', 1),
(15, 'Test Staff post', '<p>Only staff able to view it</p>', 'GEN', '2026-03-23 14:58:19.062000', '2026-03-23 14:58:19.063000', 0, 1, 1, 0, 2, 1, 0, 'test-staff-post', 1),
(18, 'a', '<p>Identical title with unique slug</p>', 'GEN', '2026-03-24 08:43:53.673239', '2026-03-24 08:43:53.673282', 1, 1, 1, 1, 1, 0, 0, 'a-1', 1);

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

--
-- Dumping data for table `campus_faqreaction`
--

INSERT INTO `campus_faqreaction` (`id`, `value`, `created_at`, `updated_at`, `faq_id`, `user_id`) VALUES
(1, 1, '2026-03-24 04:31:46.569874', '2026-03-24 04:31:46.569909', 11, 1),
(2, 1, '2026-03-24 04:31:48.988579', '2026-03-24 04:31:48.988606', 15, 1),
(3, 1, '2026-03-24 04:31:51.435411', '2026-03-24 04:31:51.435451', 13, 1);

-- --------------------------------------------------------

--
-- Table structure for table `campus_lecturer_assignment`
--

CREATE TABLE `campus_lecturer_assignment` (
  `id` int NOT NULL,
  `lecturer_id` int NOT NULL,
  `term_id` int NOT NULL,
  `subject_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `campus_lecturer_assignment`
--

INSERT INTO `campus_lecturer_assignment` (`id`, `lecturer_id`, `term_id`, `subject_id`) VALUES
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
(40, 35, 2, 19),
(41, 35, 4, 19);

-- --------------------------------------------------------

--
-- Table structure for table `campus_lecturer_profiles`
--

CREATE TABLE `campus_lecturer_profiles` (
  `id` int NOT NULL,
  `lc_id` varchar(12) NOT NULL,
  `specialization` longtext,
  `is_head` tinyint(1) NOT NULL,
  `max_hours_per_week` int NOT NULL,
  `dept_id` int DEFAULT NULL,
  `user_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `campus_lecturer_profiles`
--

INSERT INTO `campus_lecturer_profiles` (`id`, `lc_id`, `specialization`, `is_head`, `max_hours_per_week`, `dept_id`, `user_id`) VALUES
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
-- Table structure for table `campus_lecturer_subjects`
--

CREATE TABLE `campus_lecturer_subjects` (
  `id` int NOT NULL,
  `is_lead` tinyint(1) NOT NULL,
  `user_id` int NOT NULL,
  `subject_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `campus_lecturer_subjects`
--

INSERT INTO `campus_lecturer_subjects` (`id`, `is_lead`, `user_id`, `subject_id`) VALUES
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
-- Table structure for table `campus_mapedge`
--

CREATE TABLE `campus_mapedge` (
  `id` bigint NOT NULL,
  `from_node_id` bigint NOT NULL,
  `to_node_id` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `campus_mapedge`
--

INSERT INTO `campus_mapedge` (`id`, `from_node_id`, `to_node_id`) VALUES
(1, 1, 10),
(2, 10, 11),
(3, 2, 11),
(4, 11, 12),
(5, 12, 13),
(6, 13, 14),
(7, 14, 25),
(8, 14, 15),
(9, 15, 3),
(10, 12, 16),
(11, 16, 19),
(12, 19, 6),
(13, 19, 24),
(14, 16, 17),
(15, 17, 4),
(16, 17, 18),
(17, 18, 5),
(18, 19, 20),
(19, 20, 7),
(20, 20, 21),
(21, 21, 22),
(22, 22, 8),
(23, 22, 23),
(24, 23, 9);

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

--
-- Dumping data for table `campus_mapnode`
--

INSERT INTO `campus_mapnode` (`id`, `node_id`, `name`, `node_type`, `x`, `y`) VALUES
(1, 'N1', 'Classroom 1', 'terminal', 170, 158),
(2, 'N2', 'Classroom 2', 'terminal', 263, 157),
(3, 'N4', 'Classroom 4', 'terminal', 729, 101),
(4, 'N5', 'Classroom 5', 'terminal', 568, 216),
(5, 'N6', 'Classroom 6', 'terminal', 731, 215),
(6, 'N7', 'Auditorium 1', 'terminal', 470, 290),
(7, 'N8', 'Audiotorium 2', 'terminal', 469, 467),
(8, 'N9', 'Lab 2', 'terminal', 261, 506),
(9, 'N10', 'Lab 1', 'terminal', 168, 508),
(10, 'N11', 'Pathway N11', 'pathway', 170, 180),
(11, 'N12', 'Pathway N12', 'pathway', 262, 180),
(12, 'N13', 'Pathway N13', 'pathway', 434, 179),
(13, 'N14', 'Pathway N14', 'pathway', 433, 124),
(14, 'N15', 'Pathway N15', 'pathway', 567, 124),
(15, 'N16', 'Pathway N16', 'pathway', 731, 124),
(16, 'N17', 'Pathway N17', 'pathway', 434, 237),
(17, 'N18', 'Pathway N18', 'pathway', 568, 238),
(18, 'N19', 'Pathway N19', 'pathway', 729, 238),
(19, 'N20', 'Pathway N20', 'pathway', 434, 290),
(20, 'N21', 'Pathway N21', 'pathway', 434, 467),
(21, 'N22', 'Pathway N22', 'pathway', 434, 532),
(22, 'N23', 'Pathway N23', 'pathway', 262, 533),
(23, 'N24', 'Pathway N24', 'pathway', 168, 533),
(24, 'N25', 'Cafeteria', 'terminal', 395, 290),
(25, 'N26', 'Classroom 3', 'terminal', 568, 101);

-- --------------------------------------------------------

--
-- Table structure for table `campus_session`
--

CREATE TABLE `campus_session` (
  `session_id` int NOT NULL,
  `start_time` time(6) NOT NULL,
  `end_time` time(6) NOT NULL,
  `day_of_week` varchar(3) NOT NULL,
  `facility_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `campus_session`
--

INSERT INTO `campus_session` (`session_id`, `start_time`, `end_time`, `day_of_week`, `facility_id`) VALUES
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
-- Table structure for table `campus_skipped_date`
--

CREATE TABLE `campus_skipped_date` (
  `id` int NOT NULL,
  `date` date NOT NULL,
  `reason` varchar(255) NOT NULL,
  `term_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `campus_student_profiles`
--

CREATE TABLE `campus_student_profiles` (
  `id` int NOT NULL,
  `tp_id` varchar(12) NOT NULL,
  `user_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `campus_student_profiles`
--

INSERT INTO `campus_student_profiles` (`id`, `tp_id`, `user_id`) VALUES
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
-- Table structure for table `campus_subject`
--

CREATE TABLE `campus_subject` (
  `subject_id` int NOT NULL,
  `subject_code` varchar(20) NOT NULL,
  `subject_name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `campus_subject`
--

INSERT INTO `campus_subject` (`subject_id`, `subject_code`, `subject_name`) VALUES
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
(1, 'Testing feedback submission', 'ANN', '<p>aThis is description</p><ol><li data-list=\"ordered\"><span class=\"ql-ui\" contenteditable=\"false\"></span>sdqwa</li><li data-list=\"ordered\"><span class=\"ql-ui\" contenteditable=\"false\"></span><span class=\"ql-size-large\">List 2</span></li></ol><p><img src=\"/media/attachments/supportticket_1_20260312093214.jpeg\"/></p><p><br/></p>', 'resolved', '2026-03-12 09:32:13.610000', '2026-03-27 19:20:02.423482', 1, 18),
(2, 'More style', 'MAP', '<p><span class=\"ql-size-small\">Testing</span></p><p>Testing</p><p><span class=\"ql-size-large\">Testing</span></p><p><span class=\"ql-size-huge\">Testing</span></p><p><strong>Testing</strong></p><p><em>Testing</em></p><p><u>Testing</u></p><p>Testing</p><p><a href=\"https://heroicons.com/outline\" rel=\"noopener noreferrer\" target=\"_blank\">Testing</a></p><p><img src=\"/media/attachments/supportticket_2_20260312155655.jpeg\"/></p>', 'resolved', '2026-03-12 15:56:54.888000', '2026-03-13 16:33:51.740000', NULL, 18),
(3, 'Announcement not working', 'ANN', '<p>What is the announcement placement banner for? announcement didnt work. </p>', 'in_progress', '2026-03-15 12:47:22.320000', '2026-03-15 12:48:20.295000', 1, 19),
(4, 'Just testing', 'GEN', '<p>ujsJust testing</p>', 'resolved', '2026-03-15 15:44:50.412000', '2026-03-15 16:16:26.962000', 1, 19),
(5, 'Testing Again', 'BOK', '<p>Testing AGAINNN</p>', 'resolved', '2026-03-15 16:17:18.252000', '2026-03-15 16:17:40.081000', 1, 19),
(6, 'Navigation too good', 'MAP', '<p>Mok yu sheng well done </p>', 'in_progress', '2026-03-17 08:52:21.731000', '2026-03-17 09:44:09.226000', 1, 19);

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
(1, 'escalation', 'Open', 'Escalated / In Progress', '2026-03-13 16:02:27.433000', 2, 18),
(2, 'escalation', 'Open', 'Escalated / In Progress', '2026-03-13 16:02:34.091000', 2, 18),
(3, 'escalation', 'Open', 'Escalated / In Progress', '2026-03-13 16:02:47.173000', 2, 18),
(4, 'escalation', NULL, NULL, '2026-03-13 16:24:32.563000', 2, 18),
(5, 'status_change', 'Open', 'Closed', '2026-03-13 16:25:55.426000', 2, 18),
(6, 'status_change', 'Closed', 'Resolved', '2026-03-13 16:33:51.748000', 2, 18),
(7, 'escalation', NULL, NULL, '2026-03-13 16:43:56.810000', 1, 18),
(8, 'escalation', NULL, NULL, '2026-03-13 17:11:18.222000', 1, 18),
(9, 'status_change', 'Open', 'In Progress', '2026-03-15 12:40:56.750000', 1, 1),
(10, 'status_change', 'Open', 'In Progress', '2026-03-15 12:48:20.306000', 3, 1),
(11, 'closure_request', NULL, 'rejected', '2026-03-15 13:52:55.457000', 3, 19),
(12, 'closure_request', NULL, 'rejected', '2026-03-15 15:39:49.165000', 3, 19),
(13, 'closure_request', NULL, 'rejected', '2026-03-15 15:42:50.595000', 3, 19),
(14, 'rejected_closure', NULL, NULL, '2026-03-15 15:42:59.091000', 3, 1),
(15, 'status_change', 'Open', 'In Pprogress', '2026-03-15 16:15:44.029000', 4, 1),
(16, 'status_change', 'In Progress', 'Resolved', '2026-03-15 16:16:26.972000', 4, 1),
(17, 'status_change', 'Open', 'In Pprogress', '2026-03-15 16:17:25.084000', 5, 1),
(18, 'status_change', 'In Progress', 'Resolved', '2026-03-15 16:17:40.088000', 5, 19),
(19, 'escalation', NULL, NULL, '2026-03-15 16:18:19.541000', 3, 19),
(20, 'closure_request', NULL, 'rejected', '2026-03-17 09:40:54.444000', 6, 19),
(21, 'status_change', 'Open', 'In Pprogress', '2026-03-17 09:44:09.231000', 6, 1),
(22, 'rejected_closure', NULL, NULL, '2026-03-17 09:45:54.160000', 6, 1),
(23, 'status_change', 'In Progress', 'Resolved', '2026-03-27 19:20:02.427590', 1, 1);

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
(32, '<p>HELO</p>', '2026-03-13 12:55:47.836000', 0, 18, 2),
(33, '<p>Hello</p><p><br></p>', '2026-03-13 14:35:41.498000', 0, 18, 2),
(34, '<p>testing</p>', '2026-03-13 14:48:25.452000', 0, 18, 2),
(35, '<p>Testing</p><p><br></p>', '2026-03-13 14:58:23.476000', 0, 18, 2),
(36, '<p>Halo</p>', '2026-03-13 16:43:46.807000', 0, 18, 1),
(37, '<p>Testing here</p>', '2026-03-13 16:43:52.026000', 0, 18, 1),
(38, '<p>abc</p>', '2026-03-17 08:56:12.392000', 0, 19, 6),
(39, '<p>abc</p><p>abc</p>', '2026-03-17 09:39:20.924000', 0, 19, 6),
(40, '<p>hello</p>', '2026-03-17 09:40:31.305000', 1, 1, 6),
(41, '<p>halo</p>', '2026-03-17 09:40:48.401000', 1, 1, 6),
(42, '<p>Why i cannot request to close ticket? </p><p><img src=\"/media/attachments/ticketmessage_42_20260317094659.png\"/></p>', '2026-03-17 09:46:55.579000', 0, 19, 6),
(43, '<p>Hi</p>', '2026-03-25 14:12:18.057210', 0, 19, 6),
(44, '<p>I need help</p>', '2026-03-25 14:12:54.330613', 0, 19, 6),
(45, '<p>what happened?</p>', '2026-03-27 19:19:41.691305', 1, 1, 6);

-- --------------------------------------------------------

--
-- Table structure for table `campus_timetable_preference`
--

CREATE TABLE `campus_timetable_preference` (
  `id` int NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `lecturer_id` int NOT NULL,
  `session_id` int NOT NULL,
  `subject_component_id` int NOT NULL,
  `term_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `campus_timetable_preference`
--

INSERT INTO `campus_timetable_preference` (`id`, `is_active`, `lecturer_id`, `session_id`, `subject_component_id`, `term_id`) VALUES
(1, 1, 33, 49, 1, 1),
(2, 1, 31, 70, 3, 1),
(3, 1, 35, 93, 5, 1),
(4, 1, 21, 114, 7, 1),
(5, 1, 23, 125, 9, 1),
(6, 1, 33, 141, 2, 1),
(7, 1, 31, 42, 4, 1),
(8, 1, 21, 66, 8, 1),
(9, 1, 23, 83, 10, 1),
(10, 1, 35, 167, 6, 1),
(11, 1, 31, 17, 19, 2),
(12, 1, 35, 38, 34, 2),
(13, 1, 30, 109, 130, 2),
(14, 1, 31, 133, 131, 2),
(15, 1, 31, 154, 100, 2),
(16, 1, 22, 10, 102, 2),
(17, 1, 31, 45, 20, 2),
(18, 1, 35, 61, 35, 2),
(19, 1, 31, 86, 101, 2),
(20, 1, 22, 102, 103, 2),
(21, 1, 30, 37, 126, 3),
(22, 1, 35, 129, 34, 3),
(23, 1, 37, 158, 36, 3),
(24, 1, 38, 13, 38, 3),
(25, 1, 24, 30, 127, 3),
(26, 1, 25, 54, 40, 3),
(27, 1, 26, 65, 42, 3),
(28, 1, 35, 103, 35, 3),
(29, 1, 26, 81, 43, 3),
(30, 1, 37, 191, 37, 3),
(31, 1, 38, 187, 39, 3),
(32, 1, 25, 168, 41, 3),
(33, 1, 32, 179, 104, 3),
(34, 1, 30, 130, 126, 4),
(35, 1, 35, 157, 34, 4),
(36, 1, 37, 1, 36, 4),
(37, 1, 38, 34, 38, 4),
(38, 1, 24, 58, 127, 4),
(39, 1, 25, 73, 40, 4),
(40, 1, 26, 99, 42, 4),
(41, 1, 35, 111, 35, 4),
(42, 1, 26, 135, 43, 4),
(43, 1, 38, 188, 39, 4),
(44, 1, 25, 163, 41, 4),
(45, 1, 32, 192, 104, 4);

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
) ;

--
-- Dumping data for table `django_admin_log`
--

INSERT INTO `django_admin_log` (`id`, `action_time`, `object_id`, `object_repr`, `action_flag`, `change_message`, `content_type_id`, `user_id`) VALUES
(1, '2026-03-24 07:23:07.244029', '63', 'lauhoeyik@gmail.com', 1, 'Created admin account with ID AD266510', 4, 1),
(2, '2026-03-24 08:43:53.683067', '18', 'faq object (18)', 1, 'Created new FAQ: a', 22, 1),
(3, '2026-03-27 17:25:24.669420', '4', 'B-CS-CYB-202601 - Sem 1', 3, 'Deleted 12 scheduled session(s) for week 2026-04-06', 8, 1),
(4, '2026-03-27 17:36:33.084151', '4', 'B-CS-CYB-202601 - Sem 1', 1, 'Generated timetable: 11 session(s) created, 2 error(s)', 8, 1),
(5, '2026-03-27 17:36:49.349609', '4', 'B-CS-CYB-202601 - Sem 1', 3, 'Deleted 11 scheduled session(s) for week 2026-04-06', 8, 1),
(6, '2026-03-27 17:36:51.952416', '4', 'B-CS-CYB-202601 - Sem 1', 1, 'Generated timetable: 11 session(s) created, 2 error(s)', 8, 1),
(7, '2026-03-27 17:41:09.377635', '4', 'B-CS-CYB-202601 - Sem 1', 3, 'Deleted 11 scheduled session(s) for week 2026-04-06', 8, 1),
(8, '2026-03-27 17:41:14.849415', '4', 'B-CS-CYB-202601 - Sem 1', 1, 'Generated timetable: 11 session(s) created, 2 error(s)', 8, 1),
(9, '2026-03-27 17:43:17.580359', '4', 'B-CS-CYB-202601 - Sem 1', 3, 'Deleted 11 scheduled session(s) for week 2026-04-06', 8, 1),
(10, '2026-03-27 17:43:23.267057', '4', 'B-CS-CYB-202601 - Sem 1', 1, 'Replicated preference to 1 week(s), 12 session(s) created', 8, 1),
(11, '2026-03-27 19:20:02.431812', '1', '[RESOLVED] Testing feedback submission', 2, 'Resolved ticket #T1: Testing feedback submission', 34, 1);

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
(9, 'campus', 'admin_profiles'),
(10, 'campus', 'announcement'),
(11, 'campus', 'announcementtarget'),
(12, 'campus', 'attachments'),
(13, 'campus', 'attendancemark'),
(38, 'campus', 'attendanceotp'),
(14, 'campus', 'attendancesession'),
(15, 'campus', 'booking'),
(16, 'campus', 'class_session'),
(17, 'campus', 'course'),
(18, 'campus', 'course_enrollment'),
(19, 'campus', 'course_subject'),
(20, 'campus', 'departments'),
(21, 'campus', 'facilities'),
(22, 'campus', 'faq'),
(23, 'campus', 'faqreaction'),
(24, 'campus', 'lecturer_assignment'),
(25, 'campus', 'lecturer_profiles'),
(26, 'campus', 'lecturer_subjects'),
(27, 'campus', 'mapedge'),
(28, 'campus', 'mapnode'),
(29, 'campus', 'session'),
(30, 'campus', 'skipped_date'),
(31, 'campus', 'student_profiles'),
(32, 'campus', 'subject'),
(33, 'campus', 'subjectcomponent'),
(34, 'campus', 'supportticket'),
(35, 'campus', 'ticketactivity'),
(36, 'campus', 'ticketmessage'),
(37, 'campus', 'timetable_preference'),
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
(1, 'contenttypes', '0001_initial', '2026-03-24 04:28:51.710938'),
(2, 'auth', '0001_initial', '2026-03-24 04:28:53.218020'),
(3, 'admin', '0001_initial', '2026-03-24 04:28:53.572680'),
(4, 'admin', '0002_logentry_remove_auto_add', '2026-03-24 04:28:53.585117'),
(5, 'admin', '0003_logentry_add_action_flag_choices', '2026-03-24 04:28:53.619633'),
(6, 'contenttypes', '0002_remove_content_type_name', '2026-03-24 04:28:53.890706'),
(7, 'auth', '0002_alter_permission_name_max_length', '2026-03-24 04:28:54.030774'),
(8, 'auth', '0003_alter_user_email_max_length', '2026-03-24 04:28:54.074242'),
(9, 'auth', '0004_alter_user_username_opts', '2026-03-24 04:28:54.093840'),
(10, 'auth', '0005_alter_user_last_login_null', '2026-03-24 04:28:54.232300'),
(11, 'auth', '0006_require_contenttypes_0002', '2026-03-24 04:28:54.237570'),
(12, 'auth', '0007_alter_validators_add_error_messages', '2026-03-24 04:28:54.249220'),
(13, 'auth', '0008_alter_user_username_max_length', '2026-03-24 04:28:54.394743'),
(14, 'auth', '0009_alter_user_last_name_max_length', '2026-03-24 04:28:54.542114'),
(15, 'auth', '0010_alter_group_name_max_length', '2026-03-24 04:28:54.570800'),
(16, 'auth', '0011_update_proxy_permissions', '2026-03-24 04:28:54.588766'),
(17, 'auth', '0012_alter_user_first_name_max_length', '2026-03-24 04:28:54.730380'),
(18, 'campus', '0001_initial', '2026-03-24 04:29:03.950500'),
(19, 'sessions', '0001_initial', '2026-03-24 04:29:04.030275'),
(20, 'campus', '0002_alter_booking_status', '2026-03-24 13:46:57.020162'),
(21, 'campus', '0003_remove_attendancemark_marked_at_and_more', '2026-03-24 14:09:24.681014'),
(22, 'campus', '0004_attendancesession_closed_at_and_more', '2026-03-25 05:47:21.849365'),
(23, 'campus', '0005_alter_academic_term_intake_code', '2026-03-26 10:16:45.458635'),
(24, 'campus', '0006_class_session_semestersemester', '2026-03-27 17:19:57.268396'),
(25, 'campus', '0007_rename_semestersemester_class_session_semester', '2026-03-27 17:20:33.754269');

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
('0epqg2lgmg2s9hs2ravf2py8hn0bci4k', 'e30:1vvDyh:rQYMMnzEesB1g0RPbsq1PZ6YjjWMEavlB1qicAtYDzE', '2026-03-11 12:26:55.402000'),
('0m06ot4fpnhdtr6336vau1a8bhw81od6', '.eJxVjE0OwiAYBe_C2pBSoIUu3XsG8v2gRQ00pU00xrtrky50-2bevESAdRnDWuMcEotBKCcOvyMC3WLeCF8hX4qkkpc5odwUudMqT4Xj_bi7f4ER6vh9W-oQPWpyyrIH8r32DrADsK1WrEmjs-gVRq25jcp40_SKyJrOEPN5i9ZYayo5xMeU5qcYmvcHyaY_og:1w5lNV:TougQzIS1Y2oNKkRg2IVG4hlEzcaT7J62r7HdGu3CxM', '2026-04-09 14:08:05.785109'),
('2ma87up2v1sdyc49h9qa7zdyc0a81u7m', '.eJxVjEEOwiAQRe_C2hCgjGKX7j0DGZjBogZMaRON8e5a04Vu_3v_PYXHeRr83Hj0mUQvtNj8bgHjhcsC6IzlVGWsZRpzkIsiV9rksRJfD6v7FxiwDUt2q6BTjCkimI4_R-OSJWsTGu3AdojgKNgQolN7grRzgQDIaJs06W-0cWu5Fs_3Wx4folevN6fNP7Y:1vxl9M:rf5ZPl9KqjNjIez_22XMXIrlAPcBoPw2-M-tovqwVmU', '2026-03-18 12:16:24.925000'),
('39rfmbmswdgw3owh8vu1tva9wqc5zt01', 'e30:1vvZZx:0In_6ZxHPzr1ztsCxKWtYmM4DU7hRRrd7oAaCt1t2jg', '2026-03-12 11:30:49.123000'),
('3se450spprln3yhud3kkokdzjtms11lg', '.eJxVjMEOwiAQBf-FsyFLSyn06N1vICxsBTVgSptojP-uJD3o9c28eTHrtjXardJiU2ATE4Ydfkd0_kq5kXBx-Vy4L3ldEvKm8J1WfiqBbsfd_QtEV-P37aEH3WtQ0qCkmbQfAwnR664jNYAxgxylUFIHh0QjUmcABj9LUKg8YYtWqjWVbOlxT8uTTfD-AI6iPu4:1vxND8:IpDmp6zdDhVQ5TMa2deC3Iwqa-KH5_rbKO2j-lxQBMs', '2026-03-17 10:42:42.984000'),
('4lcjeov5q3m3cq8i017bw3b2dw9vi9ze', '.eJxVjEEOwiAQRe_C2hCgjGKX7j0DGZjBogZMaRON8e5a04Vu_3v_PYXHeRr83Hj0mUQvtNj8bgHjhcsC6IzlVGWsZRpzkIsiV9rksRJfD6v7FxiwDUt2q6BTjCkimI4_R-OSJWsTGu3AdojgKNgQolN7grRzgQDIaJs06W-0cWu5Fs_3Wx4folevN6fNP7Y:1w2u85:q1zBJBUQSdeH2K73G1LVcjWiWSzAO5QGAyT4uSc4s7A', '2026-04-01 16:52:21.670000'),
('4mhhe1l30nruyr3vzihn7yqsk7pdpq27', '.eJxVjMEOwiAQBf-FsyG4UGh79O43EBYWixpooE00xn_XJj3o9c28eTHr1mWya6NqU2AjU5Idfkd0_kZ5I-Hq8qVwX_JSE_JN4Ttt_FwC3U-7-xeYXJu-716h90jQSY1kjAggtBioCzr2BAoMRpD6aAZNLigRyUXZC9AdDR4I4xZt1Foq2dJjTvXJRvH-AML1P60:1w6YMq:kQuIiIle1aX8nQf08EGOo8bpK45PuYb5MRYIWeQueYI', '2026-04-11 18:26:40.697881'),
('5fse8tlaari8m3tmyr651dc1fbqnuutj', '.eJxVjMEOwiAQBf-FsyFLSyn06N1vICxsBTVgSptojP-uJD3o9c28eTHrtjXardJiU2ATE4Ydfkd0_kq5kXBx-Vy4L3ldEvKm8J1WfiqBbsfd_QtEV-P37aEH3WtQ0qCkmbQfAwnR664jNYAxgxylUFIHh0QjUmcABj9LUKg8YYtWqjWVbOlxT8uTTfD-AI6iPu4:1w54QK:dLNNgy2eH7lkd9MhoQF_IhPTIH2FR2znqkndkzMGLRE', '2026-04-07 16:16:08.934888'),
('6z541ax3lyy7f7px1z5hnf4vmxqh3pip', '.eJxVjEEOwiAQRe_C2hCgjGKX7j0DGZjBogZMaRON8e5a04Vu_3v_PYXHeRr83Hj0mUQvtNj8bgHjhcsC6IzlVGWsZRpzkIsiV9rksRJfD6v7FxiwDUt2q6BTjCkimI4_R-OSJWsTGu3AdojgKNgQolN7grRzgQDIaJs06W-0cWu5Fs_3Wx4folevN6fNP7Y:1w3Tuh:q0Rjyo2kG6cxux3FxmPc7Bfgk8voRgjNd9zuNwAS0lE', '2026-04-03 07:04:55.735000'),
('6ziz6z9zvxvfjllo056ai0nb6hwyemkc', '.eJxVjMEOwiAQBf-FsyFLSyn06N1vICxsBTVgSptojP-uJD3o9c28eTHrtjXardJiU2ATE4Ydfkd0_kq5kXBx-Vy4L3ldEvKm8J1WfiqBbsfd_QtEV-P37aEH3WtQ0qCkmbQfAwnR664jNYAxgxylUFIHh0QjUmcABj9LUKg8YYtWqjWVbOlxT8uTTfD-AI6iPu4:1w1knq:V5pyOvzQftUagTgJu1C5b2goWpLpxoffgTqb5RYRt98', '2026-03-29 12:42:42.237000'),
('6zlk5elh787ggsxj9tzktn52hrlvbmf2', '.eJxVjEEOwiAQRe_C2hCgjGKX7j0DGZjBogZMaRON8e5a04Vu_3v_PYXHeRr83Hj0mUQvtNj8bgHjhcsC6IzlVGWsZRpzkIsiV9rksRJfD6v7FxiwDUt2q6BTjCkimI4_R-OSJWsTGu3AdojgKNgQolN7grRzgQDIaJs06W-0cWu5Fs_3Wx4folevN6fNP7Y:1w5lRH:pjJNR5beuKFenyY8qU-LKR1vL1wrzZg-kNogSUHvH1k', '2026-04-09 14:11:59.279972'),
('8rfvpd1cz3z3548qsa4cvsypxdvs9ami', '.eJxVjMEOwiAQBf-FsyFAFyo9evcbyAJbixow0CYa47_bJj3o9c28eTOHyzy5pVF1KbKBgWKH39FjuFHeSLxivhQeSp5r8nxT-E4bP5dI99Pu_gUmbNP67k1UMRoE0XkPpheGtLZ-RAlSBauUjEIFCSMpK1ALC6sCiCSN9sfQbdFGraWSHT0fqb7YID5fkj4-mA:1w5KhR:wefb4G1BczYBw9YWTSW0yUaKoN2sH2jewjL7eN0I2xE', '2026-04-08 09:38:53.448165'),
('8wwhwa1vq3me7a3q9pyf71303lw8jroo', '.eJxVjEEOwiAQRe_C2hCgjGKX7j0DGZjBogZMaRON8e5a04Vu_3v_PYXHeRr83Hj0mUQvtNj8bgHjhcsC6IzlVGWsZRpzkIsiV9rksRJfD6v7FxiwDUt2q6BTjCkimI4_R-OSJWsTGu3AdojgKNgQolN7grRzgQDIaJs06W-0cWu5Fs_3Wx4folevN6fNP7Y:1w3nMB:gE9IMraE_jIkurFaYiQ3kCqCdBmyRLxWUkDB6enY_kM', '2026-04-04 03:50:35.187000'),
('a2k6qlax0csynlzwzcu9jqhzhmc53lbb', '.eJxVjEEOwiAQRe_C2hCgjGKX7j0DGZjBogZMaRON8e5a04Vu_3v_PYXHeRr83Hj0mUQvtNj8bgHjhcsC6IzlVGWsZRpzkIsiV9rksRJfD6v7FxiwDUt2q6BTjCkimI4_R-OSJWsTGu3AdojgKNgQolN7grRzgQDIaJs06W-0cWu5Fs_3Wx4folevN6fNP7Y:1vwLiF:WjpPOmMMVTjwIHxrvl4x8ML63EwfwoBvmxHi4yN_t7k', '2026-03-14 14:54:35.917000'),
('aa0l6ihveltg85webdeerdfqjk89987w', '.eJxVjEEOwiAQRe_C2hA6hdbp0r1nIMBMLWrAQJtojHe3TbrQ7X_vv7ewbpknu1QuNpIYhDbi8Dt6F26cNkJXly5ZhpzmEr3cFLnTKs-Z-H7a3b_A5Oq0vhsYoTfYam5QG27Rm2NPwQEDAFLH7dhpdIaU6QOQx9XwYBA75YIC3qKVa405WX4-YnmJQX2-jWg-xQ:1w69o1:7zGGHZehcQYzxpvcG1HWlHgokvYyRgVkif5fuGxsBwI', '2026-04-10 16:13:05.893348'),
('bvril7urkm3fs1vr1ohim2iowpecay37', '.eJxVjMsOwiAQRf-FtSHlMYou3fcbyMAMUm1KAu3K-O9K7Kbbc869b9F45rgy-Vpm9hOJmzDiJDxua_Zb4_pn6sgCxhcvXdATl0eRsSxrnYLsidxtk2Mhnu97ezjI2HK_PQ9gBsYUEbTh31C7ZMnahFo5sAYRHAUbQnTDlSBdXCAA0somRYrE5wt6BUAg:1vvaIj:N9VnOHG4I3RNEg-joIaMhr9LymjuIPKehkJePJB044c', '2026-03-12 12:17:05.763000'),
('cga4vban2kh6tmv3wwtfunqu7cfqbq8o', '.eJxVjMEOwiAQBf-FsyFLSyn06N1vICxsBTVgSptojP-uJD3o9c28eTHrtjXardJiU2ATE4Ydfkd0_kq5kXBx-Vy4L3ldEvKm8J1WfiqBbsfd_QtEV-P37aEH3WtQ0qCkmbQfAwnR664jNYAxgxylUFIHh0QjUmcABj9LUKg8YYtWqjWVbOlxT8uTTfD-AI6iPu4:1w5zIe:yN-RhLONj74EvHxAPTBTB4H3C5SN7oPKfvSEAeYm9Ik', '2026-04-10 05:00:00.000000'),
('ejf7two11vdhl9756f1xypzfqw2i2w0t', '.eJxVjMEOwiAQBf-FsyFLSyn06N1vICxsBTVgSptojP-uJD3o9c28eTHrtjXardJiU2ATE4Ydfkd0_kq5kXBx-Vy4L3ldEvKm8J1WfiqBbsfd_QtEV-P37aEH3WtQ0qCkmbQfAwnR664jNYAxgxylUFIHh0QjUmcABj9LUKg8YYtWqjWVbOlxT8uTTfD-AI6iPu4:1w4iNf:bh4vR9ywOB3fO_DNnMKqKhRm2oETItv8vh-QPSxD1B4', '2026-04-06 16:43:55.310000'),
('fpwv85d155fgpy4ohil9a6wotrryfz41', '.eJxVjEEOwiAQRe_C2hCgjGKX7j0DGZjBogZMaRON8e5a04Vu_3v_PYXHeRr83Hj0mUQvtNj8bgHjhcsC6IzlVGWsZRpzkIsiV9rksRJfD6v7FxiwDUt2q6BTjCkimI4_R-OSJWsTGu3AdojgKNgQolN7grRzgQDIaJs06W-0cWu5Fs_3Wx4folevN6fNP7Y:1w5NpR:REXWzdr6MumKVElaGsyo3xMJzpzRbzuugCD11iQYBhA', '2026-04-08 12:59:21.843949'),
('if37ux039gkbnt0q63qv716tdv1qivum', 'e30:1w6CXg:dl4QdyAtuSBfqjvmwLAOGXhBqCzxb7p8EYgI1CKkS20', '2026-04-10 19:08:24.907380'),
('j7efu252qdp0l2ooz7ifkau2dp8axwh9', '.eJxVjEEOwiAQRe_C2hCgjGKX7j0DGZjBogZMaRON8e5a04Vu_3v_PYXHeRr83Hj0mUQvtNj8bgHjhcsC6IzlVGWsZRpzkIsiV9rksRJfD6v7FxiwDUt2q6BTjCkimI4_R-OSJWsTGu3AdojgKNgQolN7grRzgQDIaJs06W-0cWu5Fs_3Wx4folevN6fNP7Y:1vxyAZ:mbgTXi5uLlHq3o0TLJXGw7loo3XQxGwD0CskpnYCuwo', '2026-03-19 02:10:31.254000'),
('l14qjq0hc0z9m7bykdq98h6wcs9mcqw7', '.eJxVjEEOwiAQRe_C2hAog3S6dO8ZCGWmFjVgSptojHfXmi50-9_77yl8WObRL5Unn0h0wlix-x37EC-cV0LnkE9FxpLnKfVyVeRGqzwW4uthc_8CY6jj5x0HcgodWUsRoDVaRUVg2z2xRghoNBM6oAYjDT1qYzVozWgaF6BR32jlWlPJnu-3ND1Ep15voco-ug:1w6BEn:uOXxdpSgq9mq6wrK_HWPrA82bCUfK10RI3A3KQquRjM', '2026-04-10 17:44:49.749756'),
('mykg7ht8ye5g7dzdzxvnjtnwo139moct', '.eJxVjE0OwiAYBe_C2pBSoIUu3XsG8v2gRQ00pU00xrtrky50-2bevESAdRnDWuMcEotBKCcOvyMC3WLeCF8hX4qkkpc5odwUudMqT4Xj_bi7f4ER6vh9W-oQPWpyyrIH8r32DrADsK1WrEmjs-gVRq25jcp40_SKyJrOEPN5i9ZYayo5xMeU5qcYmvcHyaY_og:1w60lr:tGt_s-r2_X4FLU3tndNT346dyAdI67dfXFOGAHoK-kk', '2026-04-10 06:34:15.725434'),
('namwkapicfkzei1wlbghz4tc65t0pj3y', '.eJxVjEEOwiAQRe_C2hCgjGKX7j0DGZjBogZMaRON8e5a04Vu_3v_PYXHeRr83Hj0mUQvtNj8bgHjhcsC6IzlVGWsZRpzkIsiV9rksRJfD6v7FxiwDUt2q6BTjCkimI4_R-OSJWsTGu3AdojgKNgQolN7grRzgQDIaJs06W-0cWu5Fs_3Wx4folevN6fNP7Y:1w2Qmz:-IIudrMGu1PUlw8lXlbH-3OYyosxdknwNZpjdDOxGO8', '2026-03-31 09:32:37.018000'),
('ocjvr420oey94cghc6qwwyya4as4rf1d', '.eJxVjMEOwiAQBf-FsyG4UGh79O43EBYWixpooE00xn_XJj3o9c28eTHr1mWya6NqU2AjU5Idfkd0_kZ5I-Hq8qVwX_JSE_JN4Ttt_FwC3U-7-xeYXJu-716h90jQSY1kjAggtBioCzr2BAoMRpD6aAZNLigRyUXZC9AdDR4I4xZt1Foq2dJjTvXJRvH-AML1P60:1w5Kj9:buW7S0jdSKoMNm4ZwFk5sn5JVLPFJVwuYNP26HDD5LI', '2026-04-08 09:40:39.420383'),
('p8gn46h0ia5hye33te7ia4acxcbnmhxs', '.eJxVjE0OwiAYBe_C2pBSoIUu3XsG8v2gRQ00pU00xrtrky50-2bevESAdRnDWuMcEotBKCcOvyMC3WLeCF8hX4qkkpc5odwUudMqT4Xj_bi7f4ER6vh9W-oQPWpyyrIH8r32DrADsK1WrEmjs-gVRq25jcp40_SKyJrOEPN5i9ZYayo5xMeU5qcYmvcHyaY_og:1w6CjQ:1CT5bHJ1ex4y50ErNFcvLW2Ud8Rh7S_1KUjpeheEN94', '2026-04-10 19:20:32.431888'),
('q98838rw2u1sncx32zlnfdkd9d6kvd4v', 'e30:1vvE04:C7wL7f3Ztf990qKraPev_7PW62KL4Bhv1PKSHvQ7zWU', '2026-03-11 12:28:20.932000'),
('qpa8mjoflkbl7nmrtu0rrcdf18l095ez', '.eJxVjEEOwiAQRe_C2hCgjGKX7j0DGZjBogZMaRON8e5a04Vu_3v_PYXHeRr83Hj0mUQvtNj8bgHjhcsC6IzlVGWsZRpzkIsiV9rksRJfD6v7FxiwDUt2q6BTjCkimI4_R-OSJWsTGu3AdojgKNgQolN7grRzgQDIaJs06W-0cWu5Fs_3Wx4folevN6fNP7Y:1vy0Ru:RPjpdWnOpzKFbrcGEIYSCCqEwZeJ0utF9GNkyPh_e2o', '2026-03-19 04:36:34.229000'),
('qpxen0y09cs8cz65uecvmzqhqjbs93kf', '.eJxVjMEOwiAQBf-FsyFLSyn06N1vICxsBTVgSptojP-uJD3o9c28eTHrtjXardJiU2ATE4Ydfkd0_kq5kXBx-Vy4L3ldEvKm8J1WfiqBbsfd_QtEV-P37aEH3WtQ0qCkmbQfAwnR664jNYAxgxylUFIHh0QjUmcABj9LUKg8YYtWqjWVbOlxT8uTTfD-AI6iPu4:1w3Van:8cpTQGAvLUBA8wdEsXfjuSHLa8SbsEgvHN-vr4t_K04', '2026-04-03 08:52:29.630000'),
('rr6rhfs497rgpd10o40o33h05wyyv1fw', '.eJxVjE0OwiAYBe_C2pBSoIUu3XsG8v2gRQ00pU00xrtrky50-2bevESAdRnDWuMcEotBKCcOvyMC3WLeCF8hX4qkkpc5odwUudMqT4Xj_bi7f4ER6vh9W-oQPWpyyrIH8r32DrADsK1WrEmjs-gVRq25jcp40_SKyJrOEPN5i9ZYayo5xMeU5qcYmvcHyaY_og:1w0ASl:_UOCnOfaL8zzRnRp-fVqE9T0BNAbCRungcsZVnEpWkk', '2026-03-25 03:42:23.015000'),
('sd8vx5yqq78l4e7y04ehb03da332j4im', '.eJxVjEEOwiAQRe_C2hCgjGKX7j0DGZjBogZMaRON8e5a04Vu_3v_PYXHeRr83Hj0mUQvtNj8bgHjhcsC6IzlVGWsZRpzkIsiV9rksRJfD6v7FxiwDUt2q6BTjCkimI4_R-OSJWsTGu3AdojgKNgQolN7grRzgQDIaJs06W-0cWu5Fs_3Wx4folevN6fNP7Y:1w53Qq:f4PjbnnQ9L3IFQkLOMQNStQHWEXvDnX6HOTsiYYySo0', '2026-04-07 15:12:36.461728'),
('w04579vwqexplvbi5a1yf49hg4r0xy0w', '.eJxVjEEOwiAQRe_C2hAog3S6dO8ZCGWmFjVgSptojHfXmi50-9_77yl8WObRL5Unn0h0wlix-x37EC-cV0LnkE9FxpLnKfVyVeRGqzwW4uthc_8CY6jj5x0HcgodWUsRoDVaRUVg2z2xRghoNBM6oAYjDT1qYzVozWgaF6BR32jlWlPJnu-3ND1Ep15voco-ug:1w6PZr:10IFFpebzzQzuhLavkqgpFywu-W5cFbsV4vzYAIOJ98', '2026-04-11 09:03:31.838238'),
('wb9q6j5eshdk7fzv0s5n8gmzk3i23l8i', '.eJxVjEEOwiAQRe_C2hCgjGKX7j0DGZjBogZMaRON8e5a04Vu_3v_PYXHeRr83Hj0mUQvtNj8bgHjhcsC6IzlVGWsZRpzkIsiV9rksRJfD6v7FxiwDUt2q6BTjCkimI4_R-OSJWsTGu3AdojgKNgQolN7grRzgQDIaJs06W-0cWu5Fs_3Wx4folevN6fNP7Y:1w38KJ:Ozpqj5ANsPDBRsG4xyYcuKZaKrBp5W_sZxjR9A85NXg', '2026-04-02 08:01:55.472000'),
('xh29i1so6px3lu3ifgaoh09j84bya624', '.eJxVjMEOwiAQBf-FsyFLSyn06N1vICxsBTVgSptojP-uJD3o9c28eTHrtjXardJiU2ATE4Ydfkd0_kq5kXBx-Vy4L3ldEvKm8J1WfiqBbsfd_QtEV-P37aEH3WtQ0qCkmbQfAwnR664jNYAxgxylUFIHh0QjUmcABj9LUKg8YYtWqjWVbOlxT8uTTfD-AI6iPu4:1vxL5Q:Jc2NTIe0aSBtlMi2PJEyPkFufOZaPeFto-p5ViB8Jm4', '2026-03-17 08:26:36.338000'),
('xowo5ty3u1zi4amzxvzymvkqs2a62nxn', '.eJxVjEEOwiAQRe_C2hCgjGKX7j0DGZjBogZMaRON8e5a04Vu_3v_PYXHeRr83Hj0mUQvtNj8bgHjhcsC6IzlVGWsZRpzkIsiV9rksRJfD6v7FxiwDUt2q6BTjCkimI4_R-OSJWsTGu3AdojgKNgQolN7grRzgQDIaJs06W-0cWu5Fs_3Wx4folevN6fNP7Y:1w1gAN:73jWnFquIQjBkGSB2N5MlqkLTqqQy3xL2Hvzc4vfaE4', '2026-03-29 07:45:39.817000'),
('ydsmcc4rbenpgqg6vhmofg9tw66fozyn', '.eJxVjEEOwiAQRe_C2hCgjGKX7j0DGZjBogZMaRON8e5a04Vu_3v_PYXHeRr83Hj0mUQvtNj8bgHjhcsC6IzlVGWsZRpzkIsiV9rksRJfD6v7FxiwDUt2q6BTjCkimI4_R-OSJWsTGu3AdojgKNgQolN7grRzgQDIaJs06W-0cWu5Fs_3Wx4folevN6fNP7Y:1w1RZ1:1cBIwtBQwmaqUlaJD8C5DO-F0yH5Hz8W49dgIVoFvD0', '2026-03-28 16:10:07.253000'),
('z1ah4u2vmgfr6mxw6xrwr208ze73gn5c', '.eJxVjE0OwiAYBe_C2pBSoIUu3XsG8v2gRQ00pU00xrtrky50-2bevESAdRnDWuMcEotBKCcOvyMC3WLeCF8hX4qkkpc5odwUudMqT4Xj_bi7f4ER6vh9W-oQPWpyyrIH8r32DrADsK1WrEmjs-gVRq25jcp40_SKyJrOEPN5i9ZYayo5xMeU5qcYmvcHyaY_og:1vxRIa:vrqOpMF8VG2qqBr2IycN6HZ-xqyp34nvedp8ZzY1-zw', '2026-03-17 15:04:36.949000');

--
-- Indexes for dumped tables
--

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
-- Indexes for table `campus_academic_rules`
--
ALTER TABLE `campus_academic_rules`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `campus_academic_term`
--
ALTER TABLE `campus_academic_term`
  ADD PRIMARY KEY (`term_id`),
  ADD UNIQUE KEY `campus_academic_term_intake_code_e61305fd_uniq` (`intake_code`),
  ADD KEY `campus_academic_term_course_id_a0d75fd4_fk_campus_co` (`course_id`);

--
-- Indexes for table `campus_admin_profiles`
--
ALTER TABLE `campus_admin_profiles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ad_id` (`ad_id`),
  ADD UNIQUE KEY `user_id` (`user_id`);

--
-- Indexes for table `campus_announcement`
--
ALTER TABLE `campus_announcement`
  ADD PRIMARY KEY (`announcement_id`),
  ADD KEY `campus_announcement_author_id_d318111a_fk_campus_ad` (`author_id`);

--
-- Indexes for table `campus_announcementtarget`
--
ALTER TABLE `campus_announcementtarget`
  ADD PRIMARY KEY (`target_id`),
  ADD KEY `campus_announcementt_announcement_id_a25b76f0_fk_campus_an` (`announcement_id`);

--
-- Indexes for table `campus_attachments`
--
ALTER TABLE `campus_attachments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `campus_attachments_content_type_id_59434c3f_fk_django_co` (`content_type_id`);

--
-- Indexes for table `campus_attendancemark`
--
ALTER TABLE `campus_attendancemark`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `campus_attendancemark_session_id_student_id_178e55e6_uniq` (`session_id`,`student_id`),
  ADD KEY `campus_attendancemark_student_id_ac2e7a90_fk_auth_user_id` (`student_id`);

--
-- Indexes for table `campus_attendanceotp`
--
ALTER TABLE `campus_attendanceotp`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `attendance_session_id` (`attendance_session_id`);

--
-- Indexes for table `campus_attendancesession`
--
ALTER TABLE `campus_attendancesession`
  ADD PRIMARY KEY (`id`),
  ADD KEY `campus_attendanceses_class_event_id_d217138a_fk_campus_cl` (`class_event_id`),
  ADD KEY `campus_attendancesession_lecturer_id_254dc75f_fk_auth_user_id` (`lecturer_id`);

--
-- Indexes for table `campus_booking`
--
ALTER TABLE `campus_booking`
  ADD PRIMARY KEY (`booking_id`),
  ADD KEY `campus_booking_user_id_893751c1_fk_auth_user_id` (`user_id`),
  ADD KEY `campus_booking_facility_id_8b6fce9f_fk_campus_fa` (`facility_id`);

--
-- Indexes for table `campus_class_session`
--
ALTER TABLE `campus_class_session`
  ADD PRIMARY KEY (`id`),
  ADD KEY `campus_class_session_lecturer_id_9a41197d_fk_auth_user_id` (`lecturer_id`),
  ADD KEY `campus_class_session_term_id_9436f186_fk_campus_ac` (`term_id`),
  ADD KEY `campus_class_session_session_id_b4678409_fk_campus_se` (`session_id`),
  ADD KEY `campus_class_session_subject_component_id_f4aa4dbe_fk_campus_su` (`subject_component_id`);

--
-- Indexes for table `campus_course`
--
ALTER TABLE `campus_course`
  ADD PRIMARY KEY (`course_id`),
  ADD UNIQUE KEY `course_code` (`course_code`),
  ADD KEY `campus_course_dept_id_b3f101e4_fk_campus_departments_dept_id` (`dept_id`);

--
-- Indexes for table `campus_course_enrollment`
--
ALTER TABLE `campus_course_enrollment`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `student_id` (`student_id`),
  ADD KEY `campus_course_enroll_term_id_a88afb27_fk_campus_ac` (`term_id`);

--
-- Indexes for table `campus_course_subject`
--
ALTER TABLE `campus_course_subject`
  ADD PRIMARY KEY (`id`),
  ADD KEY `campus_course_subjec_course_id_bb2d419c_fk_campus_co` (`course_id`),
  ADD KEY `campus_course_subjec_subject_id_55d08705_fk_campus_su` (`subject_id`);

--
-- Indexes for table `campus_departments`
--
ALTER TABLE `campus_departments`
  ADD PRIMARY KEY (`dept_id`),
  ADD UNIQUE KEY `dept_code` (`dept_code`),
  ADD UNIQUE KEY `head_id` (`head_id`);

--
-- Indexes for table `campus_facilities`
--
ALTER TABLE `campus_facilities`
  ADD PRIMARY KEY (`facility_id`),
  ADD UNIQUE KEY `facility_name` (`facility_name`);

--
-- Indexes for table `campus_faq`
--
ALTER TABLE `campus_faq`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`),
  ADD KEY `campus_faq_author_id_40338233_fk_campus_admin_profiles_id` (`author_id`);

--
-- Indexes for table `campus_faqreaction`
--
ALTER TABLE `campus_faqreaction`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `campus_faqreaction_faq_id_user_id_5459a873_uniq` (`faq_id`,`user_id`),
  ADD KEY `campus_faqreaction_user_id_fcac2efa_fk_auth_user_id` (`user_id`);

--
-- Indexes for table `campus_lecturer_assignment`
--
ALTER TABLE `campus_lecturer_assignment`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `campus_lecturer_assignment_term_id_subject_id_0db1672e_uniq` (`term_id`,`subject_id`),
  ADD KEY `campus_lecturer_assignment_lecturer_id_07050814_fk_auth_user_id` (`lecturer_id`),
  ADD KEY `campus_lecturer_assi_subject_id_b1dedcaa_fk_campus_su` (`subject_id`);

--
-- Indexes for table `campus_lecturer_profiles`
--
ALTER TABLE `campus_lecturer_profiles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `lc_id` (`lc_id`),
  ADD UNIQUE KEY `user_id` (`user_id`),
  ADD KEY `campus_lecturer_prof_dept_id_1f8499bd_fk_campus_de` (`dept_id`);

--
-- Indexes for table `campus_lecturer_subjects`
--
ALTER TABLE `campus_lecturer_subjects`
  ADD PRIMARY KEY (`id`),
  ADD KEY `campus_lecturer_subjects_user_id_f9a50ebd_fk_auth_user_id` (`user_id`),
  ADD KEY `campus_lecturer_subj_subject_id_2d6d967b_fk_campus_su` (`subject_id`);

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
-- Indexes for table `campus_session`
--
ALTER TABLE `campus_session`
  ADD PRIMARY KEY (`session_id`),
  ADD KEY `campus_session_facility_id_eb601308_fk_campus_fa` (`facility_id`);

--
-- Indexes for table `campus_skipped_date`
--
ALTER TABLE `campus_skipped_date`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `campus_skipped_date_term_id_date_ae8d6057_uniq` (`term_id`,`date`);

--
-- Indexes for table `campus_student_profiles`
--
ALTER TABLE `campus_student_profiles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `tp_id` (`tp_id`),
  ADD UNIQUE KEY `user_id` (`user_id`);

--
-- Indexes for table `campus_subject`
--
ALTER TABLE `campus_subject`
  ADD PRIMARY KEY (`subject_id`),
  ADD UNIQUE KEY `subject_code` (`subject_code`);

--
-- Indexes for table `campus_subjectcomponent`
--
ALTER TABLE `campus_subjectcomponent`
  ADD PRIMARY KEY (`component_id`),
  ADD KEY `campus_subjectcompon_subject_id_1a51f80a_fk_campus_su` (`subject_id`);

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
-- Indexes for table `campus_timetable_preference`
--
ALTER TABLE `campus_timetable_preference`
  ADD PRIMARY KEY (`id`),
  ADD KEY `campus_timetable_preference_lecturer_id_f3cd9494_fk_auth_user_id` (`lecturer_id`),
  ADD KEY `campus_timetable_pre_session_id_43c99b4c_fk_campus_se` (`session_id`),
  ADD KEY `campus_timetable_pre_subject_component_id_b12e467d_fk_campus_su` (`subject_component_id`),
  ADD KEY `campus_timetable_pre_term_id_c9849668_fk_campus_ac` (`term_id`);

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
-- AUTO_INCREMENT for dumped tables
--

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
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=67;

--
-- AUTO_INCREMENT for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `campus_academic_rules`
--
ALTER TABLE `campus_academic_rules`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `campus_academic_term`
--
ALTER TABLE `campus_academic_term`
  MODIFY `term_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `campus_admin_profiles`
--
ALTER TABLE `campus_admin_profiles`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `campus_announcement`
--
ALTER TABLE `campus_announcement`
  MODIFY `announcement_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `campus_announcementtarget`
--
ALTER TABLE `campus_announcementtarget`
  MODIFY `target_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `campus_attachments`
--
ALTER TABLE `campus_attachments`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `campus_attendancemark`
--
ALTER TABLE `campus_attendancemark`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `campus_attendanceotp`
--
ALTER TABLE `campus_attendanceotp`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=239;

--
-- AUTO_INCREMENT for table `campus_attendancesession`
--
ALTER TABLE `campus_attendancesession`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `campus_booking`
--
ALTER TABLE `campus_booking`
  MODIFY `booking_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `campus_class_session`
--
ALTER TABLE `campus_class_session`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `campus_course`
--
ALTER TABLE `campus_course`
  MODIFY `course_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `campus_course_enrollment`
--
ALTER TABLE `campus_course_enrollment`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `campus_course_subject`
--
ALTER TABLE `campus_course_subject`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=163;

--
-- AUTO_INCREMENT for table `campus_departments`
--
ALTER TABLE `campus_departments`
  MODIFY `dept_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `campus_facilities`
--
ALTER TABLE `campus_facilities`
  MODIFY `facility_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `campus_faq`
--
ALTER TABLE `campus_faq`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `campus_faqreaction`
--
ALTER TABLE `campus_faqreaction`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `campus_lecturer_assignment`
--
ALTER TABLE `campus_lecturer_assignment`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT for table `campus_lecturer_profiles`
--
ALTER TABLE `campus_lecturer_profiles`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT for table `campus_lecturer_subjects`
--
ALTER TABLE `campus_lecturer_subjects`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=120;

--
-- AUTO_INCREMENT for table `campus_mapedge`
--
ALTER TABLE `campus_mapedge`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `campus_mapnode`
--
ALTER TABLE `campus_mapnode`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `campus_session`
--
ALTER TABLE `campus_session`
  MODIFY `session_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=201;

--
-- AUTO_INCREMENT for table `campus_skipped_date`
--
ALTER TABLE `campus_skipped_date`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `campus_student_profiles`
--
ALTER TABLE `campus_student_profiles`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `campus_subject`
--
ALTER TABLE `campus_subject`
  MODIFY `subject_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=92;

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
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `campus_ticketmessage`
--
ALTER TABLE `campus_ticketmessage`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- AUTO_INCREMENT for table `campus_timetable_preference`
--
ALTER TABLE `campus_timetable_preference`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

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
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- Constraints for dumped tables
--

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
-- Constraints for table `campus_academic_term`
--
ALTER TABLE `campus_academic_term`
  ADD CONSTRAINT `campus_academic_term_course_id_a0d75fd4_fk_campus_co` FOREIGN KEY (`course_id`) REFERENCES `campus_course` (`course_id`);

--
-- Constraints for table `campus_admin_profiles`
--
ALTER TABLE `campus_admin_profiles`
  ADD CONSTRAINT `campus_admin_profiles_user_id_611f85f4_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `campus_announcement`
--
ALTER TABLE `campus_announcement`
  ADD CONSTRAINT `campus_announcement_author_id_d318111a_fk_campus_ad` FOREIGN KEY (`author_id`) REFERENCES `campus_admin_profiles` (`id`);

--
-- Constraints for table `campus_announcementtarget`
--
ALTER TABLE `campus_announcementtarget`
  ADD CONSTRAINT `campus_announcementt_announcement_id_a25b76f0_fk_campus_an` FOREIGN KEY (`announcement_id`) REFERENCES `campus_announcement` (`announcement_id`);

--
-- Constraints for table `campus_attachments`
--
ALTER TABLE `campus_attachments`
  ADD CONSTRAINT `campus_attachments_content_type_id_59434c3f_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`);

--
-- Constraints for table `campus_attendancemark`
--
ALTER TABLE `campus_attendancemark`
  ADD CONSTRAINT `campus_attendancemar_session_id_919aa781_fk_campus_at` FOREIGN KEY (`session_id`) REFERENCES `campus_attendancesession` (`id`),
  ADD CONSTRAINT `campus_attendancemark_student_id_ac2e7a90_fk_auth_user_id` FOREIGN KEY (`student_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `campus_attendanceotp`
--
ALTER TABLE `campus_attendanceotp`
  ADD CONSTRAINT `campus_attendanceotp_attendance_session_i_582a20e6_fk_campus_at` FOREIGN KEY (`attendance_session_id`) REFERENCES `campus_attendancesession` (`id`);

--
-- Constraints for table `campus_attendancesession`
--
ALTER TABLE `campus_attendancesession`
  ADD CONSTRAINT `campus_attendanceses_class_event_id_d217138a_fk_campus_cl` FOREIGN KEY (`class_event_id`) REFERENCES `campus_class_session` (`id`),
  ADD CONSTRAINT `campus_attendancesession_lecturer_id_254dc75f_fk_auth_user_id` FOREIGN KEY (`lecturer_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `campus_booking`
--
ALTER TABLE `campus_booking`
  ADD CONSTRAINT `campus_booking_facility_id_8b6fce9f_fk_campus_fa` FOREIGN KEY (`facility_id`) REFERENCES `campus_facilities` (`facility_id`),
  ADD CONSTRAINT `campus_booking_user_id_893751c1_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `campus_class_session`
--
ALTER TABLE `campus_class_session`
  ADD CONSTRAINT `campus_class_session_lecturer_id_9a41197d_fk_auth_user_id` FOREIGN KEY (`lecturer_id`) REFERENCES `auth_user` (`id`),
  ADD CONSTRAINT `campus_class_session_session_id_b4678409_fk_campus_se` FOREIGN KEY (`session_id`) REFERENCES `campus_session` (`session_id`),
  ADD CONSTRAINT `campus_class_session_subject_component_id_f4aa4dbe_fk_campus_su` FOREIGN KEY (`subject_component_id`) REFERENCES `campus_subjectcomponent` (`component_id`),
  ADD CONSTRAINT `campus_class_session_term_id_9436f186_fk_campus_ac` FOREIGN KEY (`term_id`) REFERENCES `campus_academic_term` (`term_id`);

--
-- Constraints for table `campus_course`
--
ALTER TABLE `campus_course`
  ADD CONSTRAINT `campus_course_dept_id_b3f101e4_fk_campus_departments_dept_id` FOREIGN KEY (`dept_id`) REFERENCES `campus_departments` (`dept_id`);

--
-- Constraints for table `campus_course_enrollment`
--
ALTER TABLE `campus_course_enrollment`
  ADD CONSTRAINT `campus_course_enroll_term_id_a88afb27_fk_campus_ac` FOREIGN KEY (`term_id`) REFERENCES `campus_academic_term` (`term_id`),
  ADD CONSTRAINT `campus_course_enrollment_student_id_e57b286b_fk_auth_user_id` FOREIGN KEY (`student_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `campus_course_subject`
--
ALTER TABLE `campus_course_subject`
  ADD CONSTRAINT `campus_course_subjec_course_id_bb2d419c_fk_campus_co` FOREIGN KEY (`course_id`) REFERENCES `campus_course` (`course_id`),
  ADD CONSTRAINT `campus_course_subjec_subject_id_55d08705_fk_campus_su` FOREIGN KEY (`subject_id`) REFERENCES `campus_subject` (`subject_id`);

--
-- Constraints for table `campus_departments`
--
ALTER TABLE `campus_departments`
  ADD CONSTRAINT `campus_departments_head_id_c2cea74f_fk_campus_le` FOREIGN KEY (`head_id`) REFERENCES `campus_lecturer_profiles` (`id`);

--
-- Constraints for table `campus_faq`
--
ALTER TABLE `campus_faq`
  ADD CONSTRAINT `campus_faq_author_id_40338233_fk_campus_admin_profiles_id` FOREIGN KEY (`author_id`) REFERENCES `campus_admin_profiles` (`id`);

--
-- Constraints for table `campus_faqreaction`
--
ALTER TABLE `campus_faqreaction`
  ADD CONSTRAINT `campus_faqreaction_faq_id_1978d533_fk_campus_faq_id` FOREIGN KEY (`faq_id`) REFERENCES `campus_faq` (`id`),
  ADD CONSTRAINT `campus_faqreaction_user_id_fcac2efa_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `campus_lecturer_assignment`
--
ALTER TABLE `campus_lecturer_assignment`
  ADD CONSTRAINT `campus_lecturer_assi_subject_id_b1dedcaa_fk_campus_su` FOREIGN KEY (`subject_id`) REFERENCES `campus_subject` (`subject_id`),
  ADD CONSTRAINT `campus_lecturer_assi_term_id_dd0fb51e_fk_campus_ac` FOREIGN KEY (`term_id`) REFERENCES `campus_academic_term` (`term_id`),
  ADD CONSTRAINT `campus_lecturer_assignment_lecturer_id_07050814_fk_auth_user_id` FOREIGN KEY (`lecturer_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `campus_lecturer_profiles`
--
ALTER TABLE `campus_lecturer_profiles`
  ADD CONSTRAINT `campus_lecturer_prof_dept_id_1f8499bd_fk_campus_de` FOREIGN KEY (`dept_id`) REFERENCES `campus_departments` (`dept_id`),
  ADD CONSTRAINT `campus_lecturer_profiles_user_id_239c2b09_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `campus_lecturer_subjects`
--
ALTER TABLE `campus_lecturer_subjects`
  ADD CONSTRAINT `campus_lecturer_subj_subject_id_2d6d967b_fk_campus_su` FOREIGN KEY (`subject_id`) REFERENCES `campus_subject` (`subject_id`),
  ADD CONSTRAINT `campus_lecturer_subjects_user_id_f9a50ebd_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `campus_mapedge`
--
ALTER TABLE `campus_mapedge`
  ADD CONSTRAINT `campus_mapedge_from_node_id_38e6c578_fk_campus_mapnode_id` FOREIGN KEY (`from_node_id`) REFERENCES `campus_mapnode` (`id`),
  ADD CONSTRAINT `campus_mapedge_to_node_id_2d418755_fk_campus_mapnode_id` FOREIGN KEY (`to_node_id`) REFERENCES `campus_mapnode` (`id`);

--
-- Constraints for table `campus_session`
--
ALTER TABLE `campus_session`
  ADD CONSTRAINT `campus_session_facility_id_eb601308_fk_campus_fa` FOREIGN KEY (`facility_id`) REFERENCES `campus_facilities` (`facility_id`);

--
-- Constraints for table `campus_skipped_date`
--
ALTER TABLE `campus_skipped_date`
  ADD CONSTRAINT `campus_skipped_date_term_id_4390469b_fk_campus_ac` FOREIGN KEY (`term_id`) REFERENCES `campus_academic_term` (`term_id`);

--
-- Constraints for table `campus_student_profiles`
--
ALTER TABLE `campus_student_profiles`
  ADD CONSTRAINT `campus_student_profiles_user_id_565efb49_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `campus_subjectcomponent`
--
ALTER TABLE `campus_subjectcomponent`
  ADD CONSTRAINT `campus_subjectcompon_subject_id_1a51f80a_fk_campus_su` FOREIGN KEY (`subject_id`) REFERENCES `campus_subject` (`subject_id`);

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
-- Constraints for table `campus_timetable_preference`
--
ALTER TABLE `campus_timetable_preference`
  ADD CONSTRAINT `campus_timetable_pre_session_id_43c99b4c_fk_campus_se` FOREIGN KEY (`session_id`) REFERENCES `campus_session` (`session_id`),
  ADD CONSTRAINT `campus_timetable_pre_subject_component_id_b12e467d_fk_campus_su` FOREIGN KEY (`subject_component_id`) REFERENCES `campus_subjectcomponent` (`component_id`),
  ADD CONSTRAINT `campus_timetable_pre_term_id_c9849668_fk_campus_ac` FOREIGN KEY (`term_id`) REFERENCES `campus_academic_term` (`term_id`),
  ADD CONSTRAINT `campus_timetable_preference_lecturer_id_f3cd9494_fk_auth_user_id` FOREIGN KEY (`lecturer_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  ADD CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
