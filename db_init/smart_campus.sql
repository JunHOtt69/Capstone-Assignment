-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: db
-- Generation Time: Mar 21, 2026 at 09:11 AM
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
) ;

-- --------------------------------------------------------

--
-- Table structure for table `admin_profiles`
--

CREATE TABLE `admin_profiles` (
  `id` int NOT NULL,
  `ad_id` varchar(12) NOT NULL,
  `user_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_group`
--

CREATE TABLE `auth_group` (
  `id` int NOT NULL,
  `name` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
(109, 'Can add class_session', 16, 'add_class_session'),
(110, 'Can change class_session', 16, 'change_class_session'),
(111, 'Can delete class_session', 16, 'delete_class_session'),
(112, 'Can view class_session', 16, 'view_class_session'),
(113, 'Can add subject component', 33, 'add_subjectcomponent'),
(114, 'Can change subject component', 33, 'change_subjectcomponent'),
(115, 'Can delete subject component', 33, 'delete_subjectcomponent'),
(116, 'Can view subject component', 33, 'view_subjectcomponent'),
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
(148, 'Can view lecturer_assignment', 24, 'view_lecturer_assignment');

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

-- --------------------------------------------------------

--
-- Table structure for table `auth_user_groups`
--

CREATE TABLE `auth_user_groups` (
  `id` bigint NOT NULL,
  `user_id` int NOT NULL,
  `group_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
) ;

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
  `subject_id` int NOT NULL
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
(1, 'contenttypes', '0001_initial', '2026-03-21 09:11:16.181651'),
(2, 'auth', '0001_initial', '2026-03-21 09:11:17.475079'),
(3, 'admin', '0001_initial', '2026-03-21 09:11:17.811365'),
(4, 'admin', '0002_logentry_remove_auto_add', '2026-03-21 09:11:17.824061'),
(5, 'admin', '0003_logentry_add_action_flag_choices', '2026-03-21 09:11:17.837040'),
(6, 'contenttypes', '0002_remove_content_type_name', '2026-03-21 09:11:18.121528'),
(7, 'auth', '0002_alter_permission_name_max_length', '2026-03-21 09:11:18.258129'),
(8, 'auth', '0003_alter_user_email_max_length', '2026-03-21 09:11:18.287413'),
(9, 'auth', '0004_alter_user_username_opts', '2026-03-21 09:11:18.300098'),
(10, 'auth', '0005_alter_user_last_login_null', '2026-03-21 09:11:18.438659'),
(11, 'auth', '0006_require_contenttypes_0002', '2026-03-21 09:11:18.443938'),
(12, 'auth', '0007_alter_validators_add_error_messages', '2026-03-21 09:11:18.457171'),
(13, 'auth', '0008_alter_user_username_max_length', '2026-03-21 09:11:18.617664'),
(14, 'auth', '0009_alter_user_last_name_max_length', '2026-03-21 09:11:18.765411'),
(15, 'auth', '0010_alter_group_name_max_length', '2026-03-21 09:11:18.794249'),
(16, 'auth', '0011_update_proxy_permissions', '2026-03-21 09:11:18.810314'),
(17, 'auth', '0012_alter_user_first_name_max_length', '2026-03-21 09:11:18.974519'),
(18, 'campus', '0001_initial', '2026-03-21 09:11:27.569225'),
(19, 'sessions', '0001_initial', '2026-03-21 09:11:27.641189');

-- --------------------------------------------------------

--
-- Table structure for table `django_session`
--

CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `facilities`
--

CREATE TABLE `facilities` (
  `facility_id` int NOT NULL,
  `facility_name` varchar(100) NOT NULL,
  `type` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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

-- --------------------------------------------------------

--
-- Table structure for table `subject`
--

CREATE TABLE `subject` (
  `subject_id` int NOT NULL,
  `subject_code` varchar(20) NOT NULL,
  `subject_name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
  ADD KEY `class_session_subject_id_4bdbf2f4_fk_subject_subject_id` (`subject_id`);

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
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `academic_term`
--
ALTER TABLE `academic_term`
  MODIFY `term_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `admin_profiles`
--
ALTER TABLE `admin_profiles`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_group`
--
ALTER TABLE `auth_group`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_permission`
--
ALTER TABLE `auth_permission`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=149;

--
-- AUTO_INCREMENT for table `auth_user`
--
ALTER TABLE `auth_user`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `booking`
--
ALTER TABLE `booking`
  MODIFY `booking_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `campus_announcement`
--
ALTER TABLE `campus_announcement`
  MODIFY `announcement_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `campus_announcementTarget`
--
ALTER TABLE `campus_announcementTarget`
  MODIFY `target_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `campus_attachments`
--
ALTER TABLE `campus_attachments`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

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
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

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
  MODIFY `component_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `campus_supportticket`
--
ALTER TABLE `campus_supportticket`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `campus_ticketactivity`
--
ALTER TABLE `campus_ticketactivity`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `campus_ticketmessage`
--
ALTER TABLE `campus_ticketmessage`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `class_session`
--
ALTER TABLE `class_session`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `course`
--
ALTER TABLE `course`
  MODIFY `course_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `course_enrollment`
--
ALTER TABLE `course_enrollment`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `course_subject`
--
ALTER TABLE `course_subject`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `departments`
--
ALTER TABLE `departments`
  MODIFY `dept_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `django_content_type`
--
ALTER TABLE `django_content_type`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT for table `django_migrations`
--
ALTER TABLE `django_migrations`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `facilities`
--
ALTER TABLE `facilities`
  MODIFY `facility_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `lecturer_assignment`
--
ALTER TABLE `lecturer_assignment`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `lecturer_profiles`
--
ALTER TABLE `lecturer_profiles`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `lecturer_subjects`
--
ALTER TABLE `lecturer_subjects`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `session`
--
ALTER TABLE `session`
  MODIFY `session_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `skipped_date`
--
ALTER TABLE `skipped_date`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `student_profiles`
--
ALTER TABLE `student_profiles`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `subject`
--
ALTER TABLE `subject`
  MODIFY `subject_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `timetable_preference`
--
ALTER TABLE `timetable_preference`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

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
  ADD CONSTRAINT `class_session_subject_id_4bdbf2f4_fk_subject_subject_id` FOREIGN KEY (`subject_id`) REFERENCES `subject` (`subject_id`),
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
