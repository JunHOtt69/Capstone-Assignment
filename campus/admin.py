from django.contrib import admin
from .models import academic_rules, academic_term, admin_profiles, course, course_enrollment, course_subject, departments, facilities, lecturer_profiles, lecturer_subjects, session, student_profiles, subject, SubjectComponent, faq, booking, SupportTicket, announcement
# Register your models here.

@admin.register(academic_rules)
class academic_rulesAdmin(admin.ModelAdmin):
    list_display = ('rule_name', 'value_days', 'description') 
    search_fields = ('rule_name', 'value_days', 'description')

@admin.register(academic_term)
class academic_termAdmin(admin.ModelAdmin):
    list_display = ('course', 'current_semester', 'is_active', 'start_date', 'end_date') 
    search_fields = ('course',)

@admin.register(admin_profiles)
class admin_profilesAdmin(admin.ModelAdmin):
    list_display = ('user', 'ad_id') 
    search_fields = ('ad_id',)

@admin.register(course)
class courseAdmin(admin.ModelAdmin):
    list_display = ('course_code', 'course_name', 'total_semester', 'semester_week', 'level', 'year_taken', 'specialization', 'internship', 'dept') 
    search_fields = ('course_code', 'course_name', 'dept',)

@admin.register(course_enrollment)
class course_enrollmentAdmin(admin.ModelAdmin):
    list_display = ('student', 'term', 'enrollment_status') 
    search_fields = ('student',)

@admin.register(course_subject)
class course_subjectAdmin(admin.ModelAdmin):
    list_display = ('course', 'subject', 'recommended_semester') 
    search_fields = ('subject',)
    
@admin.register(departments)
class departmentsAdmin(admin.ModelAdmin):
    list_display = ('dept_name', 'dept_code') 
    search_fields = ('dept_name', 'dept_code',)
    
@admin.register(facilities)
class facilitiesAdmin(admin.ModelAdmin):
    list_display = ('facility_name', 'type') 
    search_fields = ('facility_name', 'type')
    
@admin.register(lecturer_profiles)
class lecturer_profilesAdmin(admin.ModelAdmin):
    list_display = ('user', 'lc_id', 'dept', 'specialization') 
    search_fields = ('lc_id',)
    
@admin.register(lecturer_subjects)
class lecturer_subjectsAdmin(admin.ModelAdmin):
    list_display = ('user', 'subject') 
    search_fields = ('user', 'subject')
    
@admin.register(session)
class sessionAdmin(admin.ModelAdmin):
    list_display = ('facility', 'start_time', 'end_time', 'day_of_week') 
    search_fields = ('facility', 'day_of_week',)
    
@admin.register(student_profiles)
class student_profilesAdmin(admin.ModelAdmin):
    list_display = ('user', 'tp_id') 
    search_fields = ('tp_id',)

@admin.register(subject)
class subjectAdmin(admin.ModelAdmin):
    list_display = ('subject_name', 'subject_code') 
    search_fields = ('subject_name', 'subject_code')

@admin.register(SubjectComponent)
class SubjectComponentAdmin(admin.ModelAdmin):
    list_display = ('subject', 'hours_per_class', 'total_required_hours', 'class_type') 
    search_fields = ('subject', 'class_type')

@admin.register(faq)
class faqAdmin(admin.ModelAdmin):
    list_display = ('title', 'content', 'category', 'published_time', 'author') 
    search_fields = ('title', 'author')

@admin.register(booking)
class bookingAdmin(admin.ModelAdmin):
    list_display = ('user', 'facility', 'booking_date', 'start_time', 'end_time', 'purpose', 'status') 
    search_fields = ('user', 'facility')

@admin.register(SupportTicket)
class SupportTicketAdmin(admin.ModelAdmin):
    list_display = ('title', 'category', 'status', 'created_by', 'assigned_to', 'created_at') 
    search_fields = ('title', 'category', 'status', 'created_by', 'assigned_to',)

@admin.register(announcement)
class announcementAdmin(admin.ModelAdmin):
    list_display = ('subject', 'content', 'date_published', 'author', 'is_active', 'announcement_type') 
    search_fields = ('subject', 'content', 'author',)