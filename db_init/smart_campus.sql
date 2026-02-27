-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 27, 2026 at 12:37 PM
-- Server version: 12.1.2-MariaDB
-- PHP Version: 8.2.12

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
  `id` int(11) NOT NULL,
  `rule_name` varchar(100) NOT NULL,
  `value_days` int(11) NOT NULL,
  `description` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
  `term_id` int(11) NOT NULL,
  `course_id` int(11) NOT NULL,
  `intake_code` varchar(25) NOT NULL,
  `current_semester` int(2) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `academic_term`
--

INSERT INTO `academic_term` (`term_id`, `course_id`, `intake_code`, `current_semester`, `is_active`, `start_date`, `end_date`) VALUES
(1, 1, 'F-ICT-GEN-202601', 1, 1, '2026-01-05', '2026-04-27'),
(2, 4, 'D-ICT-SE-202601', 1, 1, '2026-01-05', '2026-05-11'),
(3, 2, 'B-CS-AI-202601', 1, 1, '2026-01-05', '2026-05-11'),
(4, 3, 'B-CS-CYB-202601', 1, 1, '2026-01-05', '2026-05-11');

-- --------------------------------------------------------

--
-- Table structure for table `admin_profiles`
--

CREATE TABLE `admin_profiles` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `ad_id` varchar(12) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin_profiles`
--

INSERT INTO `admin_profiles` (`id`, `user_id`, `ad_id`) VALUES
(1, 1, 'AD262069');

-- --------------------------------------------------------

--
-- Table structure for table `auth_group`
--

CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
  `id` bigint(20) NOT NULL,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_permission`
--

CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
(80, 'Can view map edge', 17, 'view_mapedge');

-- --------------------------------------------------------

--
-- Table structure for table `auth_user`
--

CREATE TABLE `auth_user` (
  `id` int(11) NOT NULL,
  `email` varchar(254) NOT NULL,
  `username` varchar(150) NOT NULL,
  `password` varchar(128) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `is_staff` tinyint(1) NOT NULL DEFAULT 0,
  `is_superuser` tinyint(1) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `date_joined` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `auth_user`
--

INSERT INTO `auth_user` (`id`, `email`, `username`, `password`, `first_name`, `last_name`, `is_active`, `is_staff`, `is_superuser`, `last_login`, `date_joined`) VALUES
(1, 'limjunhong1015@gmail.com', 'limjunhong1015@gmail.com', 'pbkdf2_sha256$1200000$ZgIbRoHmmBmVAfw6p3BEeB$eMGNFxeWZUz/MiOV7d1WeATz4q/Rrq5gaS2lIF80dUA=', 'Lim', 'Jun Hong', 1, 1, 1, '2026-02-26 12:17:05.756404', '2026-02-26 11:30:16.196969'),
(4, 'kugresyt@gmail.com', 'kugresyt@gmail.com', '!uU5brheGBbk7E2Kqh4P1DqIsb3grNtEWGnzmUoTc', 'Mok', 'Yu Sheng', 1, 1, 0, NULL, '2026-02-26 11:47:17.711838'),
(7, 'ljack7599@gmail.com', 'ljack7599@gmail.com', '!HhaYdPlyExDjq89RnN2w1mN6Lo9rRpeKRwjk9auu', 'Lee', 'Zhen Sheng', 1, 0, 0, NULL, '2026-02-26 11:58:57.118875');

-- --------------------------------------------------------

--
-- Table structure for table `auth_user_groups`
--

CREATE TABLE `auth_user_groups` (
  `id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `auth_user_groups`
--

INSERT INTO `auth_user_groups` (`id`, `user_id`, `group_id`) VALUES
(32, 1, 1),
(35, 4, 2),
(38, 7, 3);

-- --------------------------------------------------------

--
-- Table structure for table `auth_user_user_permissions`
--

CREATE TABLE `auth_user_user_permissions` (
  `id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `campus_mapedge`
--

CREATE TABLE `campus_mapedge` (
  `id` bigint(20) NOT NULL,
  `from_node_id` bigint(20) NOT NULL,
  `to_node_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `campus_mapnode`
--

CREATE TABLE `campus_mapnode` (
  `id` bigint(20) NOT NULL,
  `node_id` varchar(10) NOT NULL,
  `name` varchar(100) NOT NULL,
  `node_type` varchar(10) NOT NULL,
  `x` int(11) NOT NULL,
  `y` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `class_session`
--

CREATE TABLE `class_session` (
  `id` int(11) NOT NULL,
  `session_id` int(11) NOT NULL,
  `subject_id` int(11) NOT NULL,
  `lecturer_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `course`
--

CREATE TABLE `course` (
  `course_id` int(11) NOT NULL,
  `course_code` varchar(20) NOT NULL,
  `course_name` varchar(255) NOT NULL,
  `total_credits_to_graduate` int(3) NOT NULL DEFAULT 0,
  `total_semester` int(2) NOT NULL DEFAULT 0,
  `semester_week` int(2) NOT NULL DEFAULT 12,
  `level` enum('Foundation','Diploma','Degree') NOT NULL COMMENT 'Fixed academic levels',
  `year_taken` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Usually 1, 2, or 3',
  `specialization` varchar(100) DEFAULT NULL,
  `internship` tinyint(1) NOT NULL DEFAULT 0,
  `dept_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `course`
--

INSERT INTO `course` (`course_id`, `course_code`, `course_name`, `total_credits_to_graduate`, `total_semester`, `semester_week`, `level`, `year_taken`, `specialization`, `internship`, `dept_id`) VALUES
(1, 'F-ICT-GEN', 'Foundation Programme (Computing & Technology Route)', 50, 3, 12, 'Foundation', 1, NULL, 0, 1),
(2, 'B-CS-AI', 'Bachelor of Computer Science (Hons) (Artificial Intelligence)', 50, 6, 14, 'Degree', 3, 'Artificial Intelligence', 1, 2),
(3, 'B-CS-CYB', 'Bachelor of Science (Honours) in Computer Science (Cyber Security)', 50, 6, 14, 'Degree', 3, 'Cyber Security', 1, 2),
(4, 'D-ICT-SE', 'Diploma in Information & Communication Technology with a specialism in Software Engineering', 50, 5, 14, 'Diploma', 2, 'Software Engineering', 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `course_enrollment`
--

CREATE TABLE `course_enrollment` (
  `id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `term_id` int(11) NOT NULL,
  `enrollment_status` varchar(20) NOT NULL DEFAULT 'Enrolled'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `course_enrollment`
--

INSERT INTO `course_enrollment` (`id`, `student_id`, `term_id`, `enrollment_status`) VALUES
(3, 7, 2, 'Active');

-- --------------------------------------------------------

--
-- Table structure for table `course_subject`
--

CREATE TABLE `course_subject` (
  `id` int(11) NOT NULL,
  `course_id` int(11) NOT NULL,
  `subject_id` int(11) NOT NULL,
  `recommended_semester` int(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `departments`
--

CREATE TABLE `departments` (
  `dept_id` int(11) NOT NULL,
  `dept_name` varchar(100) NOT NULL,
  `dept_code` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `departments`
--

INSERT INTO `departments` (`dept_id`, `dept_name`, `dept_code`) VALUES
(1, 'Information & Communication Technology', 'ICT'),
(2, 'Computer Science', 'CS');

-- --------------------------------------------------------

--
-- Table structure for table `django_admin_log`
--

CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext DEFAULT NULL,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) UNSIGNED NOT NULL CHECK (`action_flag` >= 0),
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `django_content_type`
--

CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
(9, 'campus', 'class_session'),
(10, 'campus', 'course'),
(11, 'campus', 'course_enrollment'),
(12, 'campus', 'course_subject'),
(13, 'campus', 'departments'),
(14, 'campus', 'facilities'),
(15, 'campus', 'lecturer_profiles'),
(16, 'campus', 'lecturer_subjects'),
(17, 'campus', 'mapedge'),
(18, 'campus', 'mapnode'),
(19, 'campus', 'session'),
(20, 'campus', 'subject'),
(5, 'contenttypes', 'contenttype'),
(6, 'sessions', 'session');

-- --------------------------------------------------------

--
-- Table structure for table `django_migrations`
--

CREATE TABLE `django_migrations` (
  `id` bigint(20) NOT NULL,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
(19, 'campus', '0001_initial', '2026-02-26 11:04:42.287495'),
(20, 'campus', '0002_mapnode_mapedge', '2026-02-26 11:04:42.366115'),
(21, 'campus', '0003_lecturer_profiles_lc_id_admin_profiles_and_more', '2026-02-26 11:05:46.432978');

-- --------------------------------------------------------

--
-- Table structure for table `django_session`
--

CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `django_session`
--

INSERT INTO `django_session` (`session_key`, `session_data`, `expire_date`) VALUES
('0epqg2lgmg2s9hs2ravf2py8hn0bci4k', 'e30:1vvDyh:rQYMMnzEesB1g0RPbsq1PZ6YjjWMEavlB1qicAtYDzE', '2026-03-11 12:26:55.402248'),
('39rfmbmswdgw3owh8vu1tva9wqc5zt01', 'e30:1vvZZx:0In_6ZxHPzr1ztsCxKWtYmM4DU7hRRrd7oAaCt1t2jg', '2026-03-12 11:30:49.123253'),
('bvril7urkm3fs1vr1ohim2iowpecay37', '.eJxVjMsOwiAQRf-FtSHlMYou3fcbyMAMUm1KAu3K-O9K7Kbbc869b9F45rgy-Vpm9hOJmzDiJDxua_Zb4_pn6sgCxhcvXdATl0eRsSxrnYLsidxtk2Mhnu97ezjI2HK_PQ9gBsYUEbTh31C7ZMnahFo5sAYRHAUbQnTDlSBdXCAA0somRYrE5wt6BUAg:1vvaIj:N9VnOHG4I3RNEg-joIaMhr9LymjuIPKehkJePJB044c', '2026-03-12 12:17:05.763956'),
('q98838rw2u1sncx32zlnfdkd9d6kvd4v', 'e30:1vvE04:C7wL7f3Ztf990qKraPev_7PW62KL4Bhv1PKSHvQ7zWU', '2026-03-11 12:28:20.932855');

-- --------------------------------------------------------

--
-- Table structure for table `facilities`
--

CREATE TABLE `facilities` (
  `facility_id` int(11) NOT NULL,
  `facility_name` varchar(100) NOT NULL,
  `type` enum('Lab','Classroom','Auditorium','Office','Cafeteria','Library','Study Room') NOT NULL,
  `capacity` int(11) NOT NULL DEFAULT 0,
  `building` varchar(50) NOT NULL,
  `level` int(11) NOT NULL DEFAULT 1,
  `coordinate` decimal(9,6) NOT NULL,
  `is_bookable` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `lecturer_profiles`
--

CREATE TABLE `lecturer_profiles` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `lc_id` varchar(12) NOT NULL,
  `dept_id` int(11) DEFAULT NULL,
  `specialization` text DEFAULT NULL,
  `is_head` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `lecturer_profiles`
--

INSERT INTO `lecturer_profiles` (`id`, `user_id`, `lc_id`, `dept_id`, `specialization`, `is_head`) VALUES
(6, 4, 'LC267929', NULL, NULL, 0);

-- --------------------------------------------------------

--
-- Table structure for table `lecturer_subjects`
--

CREATE TABLE `lecturer_subjects` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `subject_id` int(11) NOT NULL,
  `is_lead` tinyint(1) NOT NULL DEFAULT 0 COMMENT '1 if they are the Module Leader'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `session`
--

CREATE TABLE `session` (
  `session_id` int(11) NOT NULL,
  `facility_id` int(11) NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `day_of_week` enum('Mon','Tue','Wed','Thu','Fri') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `student_profiles`
--

CREATE TABLE `student_profiles` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `tp_id` varchar(12) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `student_profiles`
--

INSERT INTO `student_profiles` (`id`, `user_id`, `tp_id`) VALUES
(3, 7, 'TP269627');

-- --------------------------------------------------------

--
-- Table structure for table `subject`
--

CREATE TABLE `subject` (
  `subject_id` int(11) NOT NULL,
  `subject_code` varchar(20) NOT NULL,
  `subject_name` varchar(255) NOT NULL,
  `credit_hour` int(2) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
  ADD KEY `fk_academic_term_course` (`course_id`);

--
-- Indexes for table `admin_profiles`
--
ALTER TABLE `admin_profiles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ad_id` (`ad_id`),
  ADD KEY `fk_admin_profiles_auth_user` (`user_id`);

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
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

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
-- Indexes for table `class_session`
--
ALTER TABLE `class_session`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_class_session_lecturer` (`lecturer_id`),
  ADD KEY `fk_class_session_session` (`session_id`),
  ADD KEY `fk_class_session_subject` (`subject_id`);

--
-- Indexes for table `course`
--
ALTER TABLE `course`
  ADD PRIMARY KEY (`course_id`),
  ADD UNIQUE KEY `course_code` (`course_code`),
  ADD KEY `fk_course_departments` (`dept_id`);

--
-- Indexes for table `course_enrollment`
--
ALTER TABLE `course_enrollment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_course_enrollment_academic_term` (`term_id`),
  ADD KEY `fk_course_enrollment_auth_user` (`student_id`);

--
-- Indexes for table `course_subject`
--
ALTER TABLE `course_subject`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_course_subject_subject` (`subject_id`);

--
-- Indexes for table `departments`
--
ALTER TABLE `departments`
  ADD PRIMARY KEY (`dept_id`),
  ADD UNIQUE KEY `dept_code` (`dept_code`);

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
-- Indexes for table `lecturer_profiles`
--
ALTER TABLE `lecturer_profiles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `lc_id` (`lc_id`),
  ADD KEY `fk_lecturer_profiles_auth_user` (`user_id`),
  ADD KEY `fk_lecturer_profiles_departments` (`dept_id`);

--
-- Indexes for table `lecturer_subjects`
--
ALTER TABLE `lecturer_subjects`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_lecturer_subjects_auth_user` (`user_id`),
  ADD KEY `fk_lecturer_subjects_subject` (`subject_id`);

--
-- Indexes for table `session`
--
ALTER TABLE `session`
  ADD PRIMARY KEY (`session_id`),
  ADD KEY `fk_session_facilities` (`facility_id`);

--
-- Indexes for table `student_profiles`
--
ALTER TABLE `student_profiles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `tp_id` (`tp_id`),
  ADD KEY `fk_student_profiles_auth_user` (`user_id`);

--
-- Indexes for table `subject`
--
ALTER TABLE `subject`
  ADD PRIMARY KEY (`subject_id`),
  ADD UNIQUE KEY `subject_code` (`subject_code`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `academic_rules`
--
ALTER TABLE `academic_rules`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `academic_term`
--
ALTER TABLE `academic_term`
  MODIFY `term_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `admin_profiles`
--
ALTER TABLE `admin_profiles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `auth_group`
--
ALTER TABLE `auth_group`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_permission`
--
ALTER TABLE `auth_permission`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=81;

--
-- AUTO_INCREMENT for table `auth_user`
--
ALTER TABLE `auth_user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `campus_mapedge`
--
ALTER TABLE `campus_mapedge`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `campus_mapnode`
--
ALTER TABLE `campus_mapnode`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `class_session`
--
ALTER TABLE `class_session`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `course`
--
ALTER TABLE `course`
  MODIFY `course_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `course_enrollment`
--
ALTER TABLE `course_enrollment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `course_subject`
--
ALTER TABLE `course_subject`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `departments`
--
ALTER TABLE `departments`
  MODIFY `dept_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `django_content_type`
--
ALTER TABLE `django_content_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `django_migrations`
--
ALTER TABLE `django_migrations`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `facilities`
--
ALTER TABLE `facilities`
  MODIFY `facility_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `lecturer_profiles`
--
ALTER TABLE `lecturer_profiles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `lecturer_subjects`
--
ALTER TABLE `lecturer_subjects`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `session`
--
ALTER TABLE `session`
  MODIFY `session_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `student_profiles`
--
ALTER TABLE `student_profiles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `subject`
--
ALTER TABLE `subject`
  MODIFY `subject_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `academic_term`
--
ALTER TABLE `academic_term`
  ADD CONSTRAINT `fk_academic_term_course` FOREIGN KEY (`course_id`) REFERENCES `course` (`course_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `admin_profiles`
--
ALTER TABLE `admin_profiles`
  ADD CONSTRAINT `fk_admin_profiles_auth_user` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

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
  ADD CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  ADD CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `campus_mapedge`
--
ALTER TABLE `campus_mapedge`
  ADD CONSTRAINT `campus_mapedge_from_node_id_38e6c578_fk_campus_mapnode_id` FOREIGN KEY (`from_node_id`) REFERENCES `campus_mapnode` (`id`),
  ADD CONSTRAINT `campus_mapedge_to_node_id_2d418755_fk_campus_mapnode_id` FOREIGN KEY (`to_node_id`) REFERENCES `campus_mapnode` (`id`);

--
-- Constraints for table `class_session`
--
ALTER TABLE `class_session`
  ADD CONSTRAINT `fk_class_session_lecturer` FOREIGN KEY (`lecturer_id`) REFERENCES `auth_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_class_session_session` FOREIGN KEY (`session_id`) REFERENCES `session` (`session_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_class_session_subject` FOREIGN KEY (`subject_id`) REFERENCES `subject` (`subject_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `course`
--
ALTER TABLE `course`
  ADD CONSTRAINT `fk_course_departments` FOREIGN KEY (`dept_id`) REFERENCES `departments` (`dept_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `course_enrollment`
--
ALTER TABLE `course_enrollment`
  ADD CONSTRAINT `fk_course_enrollment_academic_term` FOREIGN KEY (`term_id`) REFERENCES `academic_term` (`term_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_course_enrollment_auth_user` FOREIGN KEY (`student_id`) REFERENCES `auth_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `course_subject`
--
ALTER TABLE `course_subject`
  ADD CONSTRAINT `fk_course_subject_course` FOREIGN KEY (`course_id`) REFERENCES `course` (`course_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_course_subject_subject` FOREIGN KEY (`subject_id`) REFERENCES `subject` (`subject_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  ADD CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `lecturer_profiles`
--
ALTER TABLE `lecturer_profiles`
  ADD CONSTRAINT `fk_lecturer_profiles_auth_user` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_lecturer_profiles_departments` FOREIGN KEY (`dept_id`) REFERENCES `departments` (`dept_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `lecturer_subjects`
--
ALTER TABLE `lecturer_subjects`
  ADD CONSTRAINT `fk_lecturer_subjects_auth_user` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_lecturer_subjects_subject` FOREIGN KEY (`subject_id`) REFERENCES `subject` (`subject_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `session`
--
ALTER TABLE `session`
  ADD CONSTRAINT `fk_session_facilities` FOREIGN KEY (`facility_id`) REFERENCES `facilities` (`facility_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `student_profiles`
--
ALTER TABLE `student_profiles`
  ADD CONSTRAINT `fk_student_profiles_auth_user` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
