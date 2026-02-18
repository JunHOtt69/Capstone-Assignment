# Smart Campus Management System

A robust campus management solution built with **Django** and a **MySQL (XAMPP)** backend. This system is designed to streamline academic administration, focusing on dynamic user management and academic scheduling.

## 🚀 Project Overview
The Smart Campus Management System provides a centralized platform for administrators to manage three distinct user roles: **Admins, Lecturers, and Students**. Each role has unique data requirements and database relationships within the system.

## 🛠 Tech Stack
* **Framework:** Django 5.x
* **Database:** MySQL (via XAMPP)
* **Frontend:** HTML5, CSS3 (CSS Counters for dynamic tables), JavaScript (ES6+)
* **Backend:** Python (Django)

## 📋 Key Features

### 1. Dynamic Multi-Role User Creation
The system features a custom-built interface that allows administrators to bulk-create users. The interface dynamically adapts based on the selected role:

| Role | Requirements | Database Impact |
| :--- | :--- | :--- |
| **Admin** | First Name, Last Name, Email | `auth_user`, `auth_group` |
| **Lecturer** | Basic Info + Department Specialization | `auth_user`, `lecturer_profiles` |
| **Student** | Basic Info + Academic Term Enrollment | `auth_user`, `course_enrollment` |

### 2. Smart Academic Management
* **Automated Intake Generation:** Automatically generates intake codes (e.g., `COURSE-YYYYMM`) based on course codes and start dates.
* **Facility & Session Tracking:** Manages campus facilities (Labs, Classrooms, etc.) and schedules class sessions linked to specific lecturers.
* **Course & Subject Mapping:** Handles complex relationships between courses, subjects, and the lecturers assigned to teach them.

## 🗄 Database Schema Highlights
The system extends the default Django authentication system to handle campus-specific logic:
* `lecturer_profiles`: Extends User data with departments and specializations.
* `course_enrollment`: Tracks student progress through academic terms.
* `academic_term`: Manages semesters, intake codes, and active status.
* `facilities`: Includes metadata for campus locations, including coordinates and booking status.

## 🔧 Installation & Setup
1. **Clone the repository:**
   ```bash
   git clone gg