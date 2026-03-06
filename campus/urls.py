from django.urls import path
from . import views
from django.contrib.auth import views as auth_views

urlpatterns = [
    #playground
    path('testing/', views.testing, name='testing'),
    
    path("", views.home, name="home"),
    path("about/", views.about, name="about"),
    path('logout/', auth_views.LogoutView.as_view(), name='logout'),

    #dashboard
    path("account-error/", views.account_error, name="account_error"),
    path("dashboard/admin/", views.admin_dashboard, name="admin_dashboard"),
    path("dashboard/lecturer/", views.lecturer_dashboard, name="lecturer_dashboard"),
    path("dashboard/student/", views.student_dashboard, name="student_dashboard"),

    #attendance function
    path("attendance/", views.attendance, name="attendance"),
    path("attendance/signup/",views.attendance_signup, name="attendance_signup"),
    path("attendance/lecturer-otp/", views.attendance_lecturer_otp, name="attendance_lecturer_otp"),

    #campus map
    path("navigation/", views.navigation, name="navigation"),
    path("editmap/", views.editmap, name="editmap"),
    path("navigation/map-data/", views.map_data, name="map_data"),
    path("navigation/map-data/", views.map_data, name="map_data"),
    path("save-map/", views.save_map, name="save_map"),
    path("point_of_interest/", views.point_of_interest, name="point_of_interest"),
    path("point_of_interest/data/", views.point_of_interest_data, name="point_of_interest_data"),
    path("point_of_interest/save/", views.point_of_interest_save, name="point_of_interest_save"),
    path("point_of_interest/upload/", views.point_of_interest_upload, name="point_of_interest_upload"),

    #admin management
    path("user/", views.user_management, name="user_management"),
    path("user/create_user/", views.create_user_manually, name="create_user_manually"),
    path("academic/", views.academic_management, name="academic_management"),
    path("academic/manage_term/", views.manage_academic_term, name="manage_academic_term"),
    path("get-courses/", views.get_courses_by_level, name="get_courses_by_level"),
    path("get-terms/", views.get_terms, name="get_terms"),
    path("check-email/", views.check_email_exists, name="check_email"),

    #announcement function
    path('announcements/', views.announcements, name='announcements'),

    # Help center
    path("help/", views.help, name="help"),
    path('FAQ/', views.viewFAQ, name='viewFAQ'),
    path('support-center/', views.support_center,name='support_center'),
    path('smart-assistant/', views.smart_assistant,name='smart_assistant'),
    path('review-feedback/', views.review_feedback,name='review_feedback'),
    path('submit-feedback/', views.submit_feedback,name='submit_feedback'),
    path('manage-faq/', views.manage_faq,name='manage_faq'),
    path('config-bot/', views.config_bot,name='config_bot'),
    path('system-log/', views.system_log,name='system_log'),
]

