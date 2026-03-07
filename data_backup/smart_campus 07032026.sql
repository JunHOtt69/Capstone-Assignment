-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: db
-- Generation Time: Mar 07, 2026 at 01:16 PM
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

--
-- Dumping data for table `academic_term`
--

INSERT INTO `academic_term` (`term_id`, `course_id`, `intake_code`, `current_semester`, `is_active`, `start_date`, `end_date`) VALUES
(1, 1, 'F-ICT-GEN-202601', 1, 1, '2026-01-05', '2026-04-27'),
(2, 4, 'D-ICT-SE-202601', 1, 1, '2026-01-05', '2026-05-11'),
(3, 2, 'B-CS-AI-202601', 1, 1, '2026-01-05', '2026-05-11'),
(4, 3, 'B-CS-CYB-202601', 1, 1, '2026-01-05', '2026-05-11');

--
-- Dumping data for table `admin_profiles`
--

INSERT INTO `admin_profiles` (`id`, `user_id`, `ad_id`) VALUES
(1, 1, 'AD262069');

--
-- Dumping data for table `auth_group`
--

INSERT INTO `auth_group` (`id`, `name`) VALUES
(1, 'admin'),
(2, 'lecturer'),
(3, 'student');

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
(104, 'Can view faq', 26, 'view_faq');

--
-- Dumping data for table `auth_user`
--

INSERT INTO `auth_user` (`id`, `email`, `username`, `password`, `first_name`, `last_name`, `is_active`, `is_staff`, `is_superuser`, `last_login`, `date_joined`) VALUES
(1, 'limjunhong1015@gmail.com', 'limjunhong1015@gmail.com', 'pbkdf2_sha256$1200000$ZgIbRoHmmBmVAfw6p3BEeB$eMGNFxeWZUz/MiOV7d1WeATz4q/Rrq5gaS2lIF80dUA=', 'Lim', 'Jun Hong', 1, 1, 1, '2026-03-05 13:36:57.869553', '2026-02-26 11:30:16.196969'),
(18, 'mokyusheng@gmail.com', 'mokyusheng@gmail.com', 'pbkdf2_sha256$1200000$Jys4B4WnS6Y77PYnj420fW$tPY6U2PF03NNZQNsw5ckwdeFj+qfVYvLVOjHsmtcnFA=', 'Mok', 'Yu Sheng', 1, 1, 0, '2026-03-04 12:15:25.611275', '2026-03-01 17:06:16.433234'),
(19, 'ljack7599@gmail.com', 'ljack7599@gmail.com', 'pbkdf2_sha256$1200000$FHRt0htUwRbwCLQ4fT38uT$QFjmLyJ4q18hLmP7VLchgNwmL57O+yiu+k7H75gRdWE=', 'Lee', 'Zhen Sheng', 1, 0, 0, '2026-03-04 06:17:45.268093', '2026-03-01 17:13:09.153354');

--
-- Dumping data for table `auth_user_groups`
--

INSERT INTO `auth_user_groups` (`id`, `user_id`, `group_id`) VALUES
(32, 1, 1),
(49, 18, 2),
(50, 19, 3);

--
-- Dumping data for table `course`
--

INSERT INTO `course` (`course_id`, `course_code`, `course_name`, `total_credits_to_graduate`, `total_semester`, `semester_week`, `level`, `year_taken`, `specialization`, `internship`, `dept_id`) VALUES
(1, 'F-ICT-GEN', 'Foundation Programme (Computing & Technology Route)', 50, 3, 12, 'Foundation', 1, NULL, 0, 1),
(2, 'B-CS-AI', 'Bachelor of Computer Science (Hons) (Artificial Intelligence)', 50, 6, 14, 'Degree', 3, 'Artificial Intelligence', 1, 2),
(3, 'B-CS-CYB', 'Bachelor of Science (Honours) in Computer Science (Cyber Security)', 50, 6, 14, 'Degree', 3, 'Cyber Security', 1, 2),
(4, 'D-ICT-SE', 'Diploma in Information & Communication Technology with a specialism in Software Engineering', 50, 5, 14, 'Diploma', 2, 'Software Engineering', 1, 1);

--
-- Dumping data for table `course_enrollment`
--

INSERT INTO `course_enrollment` (`id`, `student_id`, `term_id`, `enrollment_status`) VALUES
(5, 19, 2, 'Active');

--
-- Dumping data for table `departments`
--

INSERT INTO `departments` (`dept_id`, `dept_name`, `dept_code`, `head_id`) VALUES
(1, 'Information & Communication Technology', 'ICT', NULL),
(2, 'Computer Science', 'CS', NULL);

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
(25, 'campus', 'attachments'),
(23, 'campus', 'attendancemark'),
(24, 'campus', 'attendancesession'),
(9, 'campus', 'class_session'),
(10, 'campus', 'course'),
(11, 'campus', 'course_enrollment'),
(12, 'campus', 'course_subject'),
(13, 'campus', 'departments'),
(14, 'campus', 'facilities'),
(26, 'campus', 'faq'),
(15, 'campus', 'lecturer_profiles'),
(16, 'campus', 'lecturer_subjects'),
(17, 'campus', 'mapedge'),
(18, 'campus', 'mapnode'),
(19, 'campus', 'session'),
(22, 'campus', 'student_profiles'),
(20, 'campus', 'subject'),
(5, 'contenttypes', 'contenttype'),
(6, 'sessions', 'session');

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
(21, 'campus', '0003_lecturer_profiles_lc_id_admin_profiles_and_more', '2026-02-26 11:05:46.432978'),
(22, 'campus', '0004_departments_head_alter_admin_profiles_user_and_more', '2026-03-07 13:11:04.731816'),
(23, 'campus', '0005_attendance_models', '2026-03-07 13:12:18.910810'),
(24, 'campus', '0006_attachments_faq', '2026-03-07 13:12:23.001625');

--
-- Dumping data for table `django_session`
--

INSERT INTO `django_session` (`session_key`, `session_data`, `expire_date`) VALUES
('0epqg2lgmg2s9hs2ravf2py8hn0bci4k', 'e30:1vvDyh:rQYMMnzEesB1g0RPbsq1PZ6YjjWMEavlB1qicAtYDzE', '2026-03-11 12:26:55.402248'),
('2ma87up2v1sdyc49h9qa7zdyc0a81u7m', '.eJxVjEEOwiAQRe_C2hCgjGKX7j0DGZjBogZMaRON8e5a04Vu_3v_PYXHeRr83Hj0mUQvtNj8bgHjhcsC6IzlVGWsZRpzkIsiV9rksRJfD6v7FxiwDUt2q6BTjCkimI4_R-OSJWsTGu3AdojgKNgQolN7grRzgQDIaJs06W-0cWu5Fs_3Wx4folevN6fNP7Y:1vxl9M:rf5ZPl9KqjNjIez_22XMXIrlAPcBoPw2-M-tovqwVmU', '2026-03-18 12:16:24.925198'),
('39rfmbmswdgw3owh8vu1tva9wqc5zt01', 'e30:1vvZZx:0In_6ZxHPzr1ztsCxKWtYmM4DU7hRRrd7oAaCt1t2jg', '2026-03-12 11:30:49.123253'),
('3se450spprln3yhud3kkokdzjtms11lg', '.eJxVjMEOwiAQBf-FsyFLSyn06N1vICxsBTVgSptojP-uJD3o9c28eTHrtjXardJiU2ATE4Ydfkd0_kq5kXBx-Vy4L3ldEvKm8J1WfiqBbsfd_QtEV-P37aEH3WtQ0qCkmbQfAwnR664jNYAxgxylUFIHh0QjUmcABj9LUKg8YYtWqjWVbOlxT8uTTfD-AI6iPu4:1vxND8:IpDmp6zdDhVQ5TMa2deC3Iwqa-KH5_rbKO2j-lxQBMs', '2026-03-17 10:42:42.984478'),
('a2k6qlax0csynlzwzcu9jqhzhmc53lbb', '.eJxVjEEOwiAQRe_C2hCgjGKX7j0DGZjBogZMaRON8e5a04Vu_3v_PYXHeRr83Hj0mUQvtNj8bgHjhcsC6IzlVGWsZRpzkIsiV9rksRJfD6v7FxiwDUt2q6BTjCkimI4_R-OSJWsTGu3AdojgKNgQolN7grRzgQDIaJs06W-0cWu5Fs_3Wx4folevN6fNP7Y:1vwLiF:WjpPOmMMVTjwIHxrvl4x8ML63EwfwoBvmxHi4yN_t7k', '2026-03-14 14:54:35.917410'),
('bvril7urkm3fs1vr1ohim2iowpecay37', '.eJxVjMsOwiAQRf-FtSHlMYou3fcbyMAMUm1KAu3K-O9K7Kbbc869b9F45rgy-Vpm9hOJmzDiJDxua_Zb4_pn6sgCxhcvXdATl0eRsSxrnYLsidxtk2Mhnu97ezjI2HK_PQ9gBsYUEbTh31C7ZMnahFo5sAYRHAUbQnTDlSBdXCAA0somRYrE5wt6BUAg:1vvaIj:N9VnOHG4I3RNEg-joIaMhr9LymjuIPKehkJePJB044c', '2026-03-12 12:17:05.763956'),
('j7efu252qdp0l2ooz7ifkau2dp8axwh9', '.eJxVjEEOwiAQRe_C2hCgjGKX7j0DGZjBogZMaRON8e5a04Vu_3v_PYXHeRr83Hj0mUQvtNj8bgHjhcsC6IzlVGWsZRpzkIsiV9rksRJfD6v7FxiwDUt2q6BTjCkimI4_R-OSJWsTGu3AdojgKNgQolN7grRzgQDIaJs06W-0cWu5Fs_3Wx4folevN6fNP7Y:1vxyAZ:mbgTXi5uLlHq3o0TLJXGw7loo3XQxGwD0CskpnYCuwo', '2026-03-19 02:10:31.254448'),
('l6xr0mahbpsck5vdv419ipsslrde5yf2', '.eJxVjEEOwiAQRe_C2hCgQ8Uu3XsGMjCDRQ2Y0iYa4921xoVu_3v_PYTHZR790njymcQgtNj8bgHjmcsK6ITlWGWsZZ5ykKsiv7TJQyW-7L_uX2DENq7ZXtlOMaaI1nT8PhqXgAASGu0sdIjWUYAQolM7smnrAllLRkPSpD_Rxq3lWjzfrnm6i6FX4JR6vgDoF0C4:1vy8sr:56MMAflO6K5RC7IUsqJineqsao8pmmBk4EwdOpLITkw', '2026-03-12 13:36:57.902859'),
('q98838rw2u1sncx32zlnfdkd9d6kvd4v', 'e30:1vvE04:C7wL7f3Ztf990qKraPev_7PW62KL4Bhv1PKSHvQ7zWU', '2026-03-11 12:28:20.932855'),
('qpa8mjoflkbl7nmrtu0rrcdf18l095ez', '.eJxVjEEOwiAQRe_C2hCgjGKX7j0DGZjBogZMaRON8e5a04Vu_3v_PYXHeRr83Hj0mUQvtNj8bgHjhcsC6IzlVGWsZRpzkIsiV9rksRJfD6v7FxiwDUt2q6BTjCkimI4_R-OSJWsTGu3AdojgKNgQolN7grRzgQDIaJs06W-0cWu5Fs_3Wx4folevN6fNP7Y:1vy0Ru:RPjpdWnOpzKFbrcGEIYSCCqEwZeJ0utF9GNkyPh_e2o', '2026-03-19 04:36:34.229452'),
('sldjyl7w25dl7rbiy8mxg214cyia0t1t', '.eJxVjE0OwiAYBe_C2pBSoIUu3XsG8v2gRQ00pU00xrtrky50-2bevESAdRnDWuMcEotBKCcOvyMC3WLeCF8hX4qkkpc5odwUudMqT4Xj_bi7f4ER6vh9W-oQPWpyyrIH8r32DrADsK1WrEmjs-gVRq25jcp40_SKyJrOEPN5i9ZYayo5xMeU5qcYmvcHyaY_og:1vxMfG:T_c_7_lQP1y5PD4stJC611vFF94j2-W4-tKNMwIs9vY', '2026-03-17 10:07:42.495564'),
('xh29i1so6px3lu3ifgaoh09j84bya624', '.eJxVjMEOwiAQBf-FsyFLSyn06N1vICxsBTVgSptojP-uJD3o9c28eTHrtjXardJiU2ATE4Ydfkd0_kq5kXBx-Vy4L3ldEvKm8J1WfiqBbsfd_QtEV-P37aEH3WtQ0qCkmbQfAwnR664jNYAxgxylUFIHh0QjUmcABj9LUKg8YYtWqjWVbOlxT8uTTfD-AI6iPu4:1vxL5Q:Jc2NTIe0aSBtlMi2PJEyPkFufOZaPeFto-p5ViB8Jm4', '2026-03-17 08:26:36.338148'),
('z1ah4u2vmgfr6mxw6xrwr208ze73gn5c', '.eJxVjE0OwiAYBe_C2pBSoIUu3XsG8v2gRQ00pU00xrtrky50-2bevESAdRnDWuMcEotBKCcOvyMC3WLeCF8hX4qkkpc5odwUudMqT4Xj_bi7f4ER6vh9W-oQPWpyyrIH8r32DrADsK1WrEmjs-gVRq25jcp40_SKyJrOEPN5i9ZYayo5xMeU5qcYmvcHyaY_og:1vxRIa:vrqOpMF8VG2qqBr2IycN6HZ-xqyp34nvedp8ZzY1-zw', '2026-03-17 15:04:36.949528');

--
-- Dumping data for table `lecturer_profiles`
--

INSERT INTO `lecturer_profiles` (`id`, `user_id`, `lc_id`, `dept_id`, `specialization`, `is_head`) VALUES
(14, 18, 'LC262996', NULL, NULL, 0);

--
-- Dumping data for table `student_profiles`
--

INSERT INTO `student_profiles` (`id`, `user_id`, `tp_id`) VALUES
(5, 19, 'TP262993');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
