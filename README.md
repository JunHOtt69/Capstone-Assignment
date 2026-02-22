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

# 🚀 Quick Start Guide

## 1️⃣ Installation

Follow these steps to get the project onto your computer:

### 📁 Open Folder
Go to the folder on your computer where you want to save the project.

### 💻 Open Terminal
Click on the address bar at the top of your file explorer, type:

```bash
cmd
```

Then press **Enter**.

### 📥 Clone the Project
Paste the following command and press Enter:

```bash
git clone https://github.com/JunHOtt69/Capstone-Assignment.git
```

### 🖥 Open in VS Code
Navigate into the project folder and open it:

```bash
cd Capstone-Assignment
code .
```

---

# 🛠 Development Workflow

⚠️ **Important:**  
Do NOT work directly on the `main` branch.

Follow this workflow for every new feature.

---

## 🔹 Step 1: Create Your Own Branch

Before writing any code, create a new branch:

```bash
git checkout -b your-name-feature-name
```

Example:

```bash
git checkout -b junhong-navbar-design
```

---

## 🔹 Step 2: Save Your Progress (Commit)

After finishing a small piece of work (e.g., fixing a CSS bug or adding a UI element):

### Stage Changes
```bash
git add .
```

### Commit Changes
```bash
git commit -m "Brief description of what you did"
```

Example:

```bash
git commit -m "Add responsive navbar layout"
```

---

## 🔹 Step 3: Upload to GitHub (Push)

When you're ready to back up or share your work:

```bash
git push -u origin your-name-feature-name
```

---

## 🔹 Step 4: Merge via Pull Request

Since the `main` branch is protected:

1. Go to the GitHub repository.
2. Click **"Compare & pull request"**
3. Wait for review before merging into `main`.

---

# ✅ Workflow Summary

```bash
git checkout -b your-branch-name
git add .
git commit -m "Your message"
git push -u origin your-branch-name
```

Repeat this cycle for every feature 🚀

## First Time Setup

1. Start XAMPP MySQL
2. Create database named `smart_campus`
3. Run:

```bash
python manage.py migrate
python manage.py loaddata seed.json
python manage.py runserver
```