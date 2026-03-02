from django.urls import path
from . import views
from django.contrib.auth import views as auth_views

urlpatterns = [
    path("", views.home, name="home"),
    path("about/", views.about, name="about"),
    path("help/", views.help, name="help"),
    path("account-error/", views.account_error, name="account_error"),
    path("dashboard/admin/", views.admin_dashboard, name="admin_dashboard"),
    path("dashboard/lecturer/", views.lecturer_dashboard, name="lecturer_dashboard"),
    path("dashboard/student/", views.student_dashboard, name="student_dashboard"),
    path("attendance/", views.attendance, name="attendance"),
    path("navigation/", views.navigation, name="navigation"),
    path("editmap/", views.editmap, name="editmap"),
    path("user/", views.user_management, name="user_management"),
    path("user/create_user/", views.create_user_manually, name="create_user_manually"),
    path("academic/", views.academic_management, name="academic_management"),
    path("academic/manage_term/", views.manage_academic_term, name="manage_academic_term"),
    path("get-courses/", views.get_courses_by_level, name="get_courses_by_level"),
    path("get-terms/", views.get_terms, name="get_terms"),
    path("check-email/", views.check_email_exists, name="check_email"),
    path("navigation/map-data/", views.map_data, name="map_data"),
    path('logout/', auth_views.LogoutView.as_view(), name='logout'),
    path('announcements/', views.announcements, name='announcements'),
]

