from django.conf import settings
from django.conf.urls.static import static
from django.urls import path, include
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
    path("attendance/chart-data/", views.attendance_chart_data, name="attendance_chart_data"),

    #campus map
    path("navigation/", views.navigation, name="navigation"),
    path("editmap/", views.editmap, name="editmap"),
    path("navigation/map-data/", views.map_data, name="map_data"),
    path("save-map/", views.save_map, name="save_map"),
    path("upload-map-image/", views.upload_map_image, name="upload_map_image"),
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
    path("update-term/", views.update_term, name="update_term"),
    path("delete-term/", views.delete_term, name="delete_term"),
    path("check-email/", views.check_email_exists, name="check_email"),
    path("user/bulk-user-creation/", views.bulk_user_creation, name="bulk_user_creation"),
    path("user/crud/", views.user_crud, name="user_crud"),
    path("get-details/<int:user_id>/", views.get_details, name="get_details"),
    path("resend-invite/<int:user_id>/", views.resend_invite, name="resend_invite"),

    # Courses management
    path("academic/courses/", views.manage_courses, name="manage_courses"),
    path("academic/courses/subjects/", views.get_course_subjects, name="get_course_subjects"),
    path("academic/courses/available/", views.get_available_subjects, name="get_available_subjects"),
    path("academic/courses/assign/", views.assign_subject_to_course, name="assign_subject_to_course"),
    path("academic/courses/remove/", views.remove_subject_from_course, name="remove_subject_from_course"),

    # Subjects management
    path("academic/subjects/", views.manage_subjects, name="manage_subjects"),
    path("academic/subjects/detail/", views.get_subject_detail, name="get_subject_detail"),
    path("academic/subjects/create/", views.create_subject, name="create_subject"),
    path("academic/subjects/update/", views.update_subject, name="update_subject"),
    path("academic/subjects/delete/", views.delete_subject, name="delete_subject"),
    path("academic/subjects/check-usage/", views.check_subject_usage, name="check_subject_usage"),

    # Departments management
    path("academic/departments/", views.manage_departments, name="manage_departments"),
    path("academic/departments/lecturers/", views.get_department_lecturers, name="get_department_lecturers"),
    path("academic/departments/subjects/available/", views.get_available_subjects_for_lecturer, name="get_available_subjects_for_lecturer"),
    path("academic/departments/subjects/assign/", views.assign_subject_to_lecturer, name="assign_subject_to_lecturer"),
    path("academic/departments/subjects/remove/", views.remove_subject_from_lecturer, name="remove_subject_from_lecturer"),

    # Timetable scheduling
    path("academic/timetable/", views.manage_timetable, name="manage_timetable"),
    path("academic/timetable/data/", views.get_timetable_data, name="get_timetable_data"),
    path("academic/timetable/generate/", views.generate_timetable, name="generate_timetable"),
    path("academic/timetable/delete-week/", views.delete_week_timetable, name="delete_week_timetable"),
    path("academic/timetable/save-preference/", views.save_preference, name="save_preference"),
    path("academic/timetable/replicate/", views.replicate_preference, name="replicate_preference"),
    path("academic/timetable/skip-date/add/", views.add_skipped_date, name="add_skipped_date"),
    path("academic/timetable/skip-date/remove/", views.remove_skipped_date, name="remove_skipped_date"),
    path("academic/timetable/missing/", views.get_missing_classes, name="get_missing_classes"),
    path("academic/timetable/rearrange/", views.rearrange_missing_class, name="rearrange_missing_class"),

    #announcement function
    path('announcements/new/', views.announcements_form, name='announcements_form'),
    path('announcements/edit/<int:ann_id>/', views.announcements_form, name='announcements_edit'),
    path('announcements/manage/', views.announcement_manage, name='announcement_manage'),
    path('announcements/delete/<int:pk>/', views.announcement_delete, name='announcement_delete'),
    path('announcements/', views.announcement_list, name='announcement_list'),

    # Help center
    path('FAQs/', views.viewFAQ, name='viewFAQ'),
    path('FAQs/<slug:slug>/', views.faq_detail, name='faq_detail'),
    path('FAQs/<slug:slug>/vote/', views.faq_vote, name='faq_vote'),
    path('edit-faq/', views.edit_faq,name='edit_faq'),
    path('edit-faq/<slug:slug>/', views.edit_faq, name='edit_existing_faq'),
    path('delete-faq/<slug:slug>/', views.delete_faq, name='delete_faq'),
    
    path('support-center/', views.support_center,name='support_center'),
    
    path('support/tickets/', views.feedbacks,name='feedbacks'),
    path('support/tickets/<int:ticket_id>/', views.review_feedback,name='review_feedback'),
    path('support/tickets/new/', views.submit_feedback,name='submit_feedback'),
    path('support/tickets/<int:ticket_id>/reply/', views.post_reply_ajax, name='post_reply_ajax'),
    path('support/tickets/<int:ticket_id>/action/', views.ticket_action_ajax, name='ticket_action_ajax'),
    path('support/tickets/partial/', views.ticket_list_ajax, name='ticket_list_ajax'),
    path('support/tickets/take/<int:ticket_id>/', views.take_ownership, name='take_ownership'),
    path('support/tickets/<int:ticket_id>/sync/', views.sync_messages, name='sync_messages'),
    path('suggestions/', views.faq_suggestions,name='faq_suggestions'),

    path('smart-assistant/', views.smart_assistant,name='smart_assistant'),
    path('config-bot/', views.config_bot,name='config_bot'),
    path('system-log/', views.system_log,name='system_log'),
    

    #Facility
    path("facility/", views.facility_list, name="facility_list"),
    path("facility/book/<int:facility_id>/", views.booking_form, name="booking_form"),
    path("facility/my/", views.my_bookings, name="my_bookings"),
    path("facility/cancel/<int:booking_id>/", views.cancel_booking, name="cancel_booking"),
    path("dashboard/admin/review-booking/", views.review_booking_request, name="review_booking_request"),
    path("dashboard/admin/approve-booking/<int:booking_id>/", views.approve_booking, name="approve_booking"),
    path("dashboard/admin/reject-booking/<int:booking_id>/", views.reject_booking, name="reject_booking"),
    path("dashboard/admin/facility-status/", views.facility_status, name="facility_status"),

]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)

