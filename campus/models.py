from django.db import models
from django.contrib.auth.models import User
from django.contrib.contenttypes.fields import GenericForeignKey, GenericRelation
from django.contrib.contenttypes.models import ContentType
from django.utils.dateparse import parse_date
from django.utils.text import slugify
from datetime import date
from django.conf import settings
from django.utils import timezone
from datetime import timedelta
import os
# Create your models here.

class academic_rules(models.Model):
    id = models.AutoField(primary_key = True)
    rule_name = models.CharField(max_length=100)
    value_days = models.IntegerField()
    description = models.TextField()

    class Meta:
        db_table = 'academic_rules'

class academic_term(models.Model):
    term_id = models.AutoField(primary_key = True)
    course = models.ForeignKey('course', on_delete=models.CASCADE)
    intake_code = models.CharField(max_length=25)
    current_semester = models.PositiveSmallIntegerField()
    is_active = models.BooleanField(default = True)
    start_date = models.DateField()
    end_date = models.DateField()

    def __str__(self):
        return f"{self.intake_code} - Sem {self.current_semester}"
    
    class Meta:
        db_table = 'academic_term'
    
    def save(self, *args, **kwargs):
        if not self.term_id:
            self.current_semester = 1
            # asdqw
        if self.start_date and self.course:
            course_code = getattr(self.course, 'course_code', '')
            
            if isinstance(self.start_date, str):
                d = parse_date(self.start_date)
            else:
                d = self.start_date

            if d and course_code:
                date_str = d.strftime('%Y%m')

                if not self.intake_code or self.intake_code.endswith('-'):
                    self.intake_code = f"{self.course.course_code}-{date_str}"
            
        super().save(*args, **kwargs)

class admin_profiles(models.Model):
    id = models.AutoField(primary_key = True)
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='admin_profile')
    ad_id = models.CharField(max_length=12, unique=True)
    
    class Meta:
        db_table = 'admin_profiles'
    
    def __str__(self):
        full_name = self.user.get_full_name().strip()
        if full_name:
            return full_name
        return self.ad_id

class class_session(models.Model):
    STATUS_CHOICES = [
        ('scheduled', 'Scheduled'),
        ('cancelled', 'Cancelled'),
        ('rearranged', 'Rearranged'),
    ]
    id = models.AutoField(primary_key = True)
    session	= models.ForeignKey('session', on_delete=models.CASCADE)
    subject	= models.ForeignKey('subject', on_delete=models.CASCADE)
    lecturer = models.ForeignKey(User, on_delete=models.CASCADE)
    term = models.ForeignKey('academic_term', on_delete=models.CASCADE, null=True, blank=True)
    date = models.DateField(null=True, blank=True)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='scheduled')

    class Meta:
        db_table = 'class_session'

    def __str__(self):
        return f"{self.subject} - {self.date} ({self.status})"

class course(models.Model):
    LEVEL_CHOICES = [
        ('Foundation', 'Foundation'),
        ('Diploma', 'Diploma'),
        ('Degree', 'Degree')
    ]
    course_id = models.AutoField(primary_key = True)
    course_code = models.CharField(max_length=20, unique=True)
    course_name = models.CharField(max_length=255)
    total_credits_to_graduate = models.IntegerField(default=0)
    total_semester = models.IntegerField(default = 0)
    semester_week = models.IntegerField(default = 12)
    level = models.CharField(max_length = 20, choices = LEVEL_CHOICES)
    year_taken = models.IntegerField(default = 1)
    specialization = models.CharField(max_length=100, null=True, blank=True)
    internship = models.BooleanField(default = False)
    dept = models.ForeignKey('departments', on_delete=models.CASCADE)

    class Meta:
        db_table = 'course'

class course_enrollment(models.Model):
    id = models.AutoField(primary_key = True)
    student	= models.OneToOneField(User, on_delete=models.CASCADE, related_name='course_enrollment')
    term	= models.ForeignKey('academic_term', on_delete=models.CASCADE)
    enrollment_status = models.CharField(max_length=20)
    class Meta:
        db_table = 'course_enrollment'

class course_subject(models.Model):
    id = models.AutoField(primary_key = True)
    course	= models.ForeignKey('course', on_delete=models.CASCADE)
    subject	= models.ForeignKey('subject', on_delete=models.CASCADE)
    recommended_semester = models.IntegerField()
    class Meta:
        db_table = 'course_subject'

class departments(models.Model):
    dept_id = models.AutoField(primary_key = True)
    dept_name	= models.CharField(max_length=100)
    dept_code	= models.CharField(max_length=10, unique=True)
    head = models.OneToOneField(
        'lecturer_profiles',
        on_delete= models.SET_NULL,
        null=True,
        blank=True,
        related_name='headed_department'
    )
    class Meta:
        db_table = 'departments'

class facilities(models.Model):
    FACILITY_TYPES = [
        ('Lab', 'Lab'),
        ('Classroom', 'Classroom'),
        ('Auditorium', 'Auditorium'),
        ('Office','Office'),
        ('Cafeteria','Cafeteria'),
        ('Library', 'Library'),
        ('Study Room', 'Library Study Room')
    ]
    facility_id = models.AutoField(primary_key = True)
    facility_name = models.CharField(max_length=100, unique=True)
    type = models.CharField(max_length=20, choices=FACILITY_TYPES)
    
    class Meta:
        db_table = 'facilities'

class lecturer_profiles(models.Model):
    id = models.AutoField(primary_key = True)
    user	= models.OneToOneField(User, on_delete=models.CASCADE, related_name='lecturer_profile')
    lc_id	= models.CharField(max_length=12, unique=True)
    dept	= models.ForeignKey('departments', on_delete=models.CASCADE, null=True, blank=True)
    specialization = models.TextField(null=True, blank=True)
    is_head	= models.BooleanField(default = False)
    max_hours_per_week = models.IntegerField(default=20)
    class Meta:
        db_table = 'lecturer_profiles'

class lecturer_subjects(models.Model):
    id = models.AutoField(primary_key = True)
    user	= models.ForeignKey(User, on_delete=models.CASCADE)
    subject	= models.ForeignKey('subject', on_delete=models.CASCADE)
    is_lead = models.BooleanField(default=False)
    class Meta:
        db_table = 'lecturer_subjects'

class session(models.Model):
    DAY_CHOICES = [
        ('MON', 'Monday'),
        ('TUE', 'Tuesday'),
        ('WED', 'Wednesday'),
        ('THU', 'Thursday'),
        ('FRI', 'Friday')
    ]
    session_id	= models.AutoField(primary_key = True)
    facility	= models.ForeignKey('facilities', on_delete=models.CASCADE)
    start_time = models.TimeField()
    end_time = models.TimeField()
    day_of_week	= models.CharField(max_length=3, choices=DAY_CHOICES)
    class Meta:
        db_table = 'session'

class student_profiles(models.Model):
    id = models.AutoField(primary_key = True)
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='student_profile')
    tp_id = models.CharField(max_length=12, unique=True)
    
    class Meta:
        db_table = 'student_profiles'

class subject(models.Model):
    CLASS_TYPE_CHOICES = [
        ('Lecture', 'Lecture'),
        ('Tutorial', 'Tutorial'),
    ]
    subject_id = models.AutoField(primary_key=True)
    subject_code = models.CharField(max_length=20, unique=True)
    subject_name = models.CharField(max_length=255)
    

    class Meta:
        db_table = 'subject'

    def __str__(self):
        return f"{self.subject_code} - {self.subject_name}"

class SubjectComponent(models.Model):
    CLASS_TYPE_CHOICES = [
        ('Lecture', 'Lecture'),
        ('Tutorial', 'Tutorial'),
        ('Lab', 'Lab'),
        ('Practical', 'Practical'),
        ('Fieldwork', 'Fieldwork'),
    ]
    component_id = models.AutoField(primary_key=True)
    subject = models.ForeignKey(
        subject, 
        on_delete=models.CASCADE, 
        related_name='components'
    )
    hours_per_class = models.IntegerField(default=2)
    total_required_hours = models.IntegerField(default=0)
    class_type = models.CharField(max_length=20, choices=CLASS_TYPE_CHOICES, default='Lecture')

    def __str__(self):
        return f"{self.subject.subject_code}-{self.class_type}"
    
class MapNode(models.Model):
    NODE_TYPES = [
        ('terminal', 'Terminal (Visible)'),
        ('pathway', 'Pathway (Invisible)'),
    ]
    
    node_id = models.CharField(max_length=10, unique=True, help_text="e.g., 'A' or 'P1'")
    name = models.CharField(max_length=100, blank=True)
    node_type = models.CharField(max_length=10, choices=NODE_TYPES, default='terminal')
    x = models.IntegerField()
    y = models.IntegerField()

    def __str__(self):
        return f"{self.node_id} - {self.name if self.name else 'Pathway'}"

class MapEdge(models.Model):
    from_node = models.ForeignKey(MapNode, related_name='edges_from', on_delete=models.CASCADE)
    to_node = models.ForeignKey(MapNode, related_name='edges_to', on_delete=models.CASCADE)
    
    def __str__(self):
        return f"{self.from_node.node_id} to {self.to_node.node_id}"
    
class faq(models.Model):
    CATEGORY_CHOICES = [
        ('GEN', 'General'),
        ('ANN', 'Announcements'),
        ('ATT', 'Attendance'),
        ('MAP', 'Campus Navigation'),
        ('BOK', 'Facility Booking'),
    ]

    id = models.AutoField(primary_key = True)
    title = models.CharField(max_length=255)
    content = models.TextField()
    category = models.CharField(max_length=3, choices= CATEGORY_CHOICES, default='GEN')
    published_time = models.DateTimeField(auto_now_add=True)
    last_edit = models.DateTimeField(auto_now=True)
    is_visitor_visible = models.BooleanField(default= False)
    is_ad_visible = models.BooleanField(default= False)
    is_lc_visible = models.BooleanField(default= False)
    is_tp_visible = models.BooleanField(default= False)
    author = models.ForeignKey(
        'admin_profiles',
        on_delete= models.SET_NULL,
        null=True,
        blank=True,
        related_name='authored_faqs'
    )
    view_count =models.PositiveIntegerField(default=0)
    n_likes = models.PositiveIntegerField(default=0)
    n_dislikes = models.PositiveIntegerField(default=0)
    slug = models.SlugField(unique=True, blank=True)

    def save(self, *args, **kwargs):
        # Generate slug if it doesn't exist
        if not self.slug:
            self.slug = slugify(self.title)
        
        # Call the real save method
        super().save(*args, **kwargs)

class FAQReaction(models.Model):
    LIKE = 1
    DISLIKE = -1
    REACTION_CHOICES = [
        (LIKE, 'Like'),
        (DISLIKE, 'Dislike'),
    ]

    faq = models.ForeignKey('faq', on_delete=models.CASCADE, related_name='reactions')
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='faq_reactions')
    value = models.SmallIntegerField(choices=REACTION_CHOICES)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        unique_together = ('faq', 'user')

    def __str__(self):
        return f"{self.user_id}:{self.faq_id}:{self.value}"

class attachments(models.Model):
    id = models.AutoField(primary_key = True)
    content_type = models.ForeignKey(ContentType, on_delete=models.CASCADE)
    object_id = models.PositiveIntegerField()
    file = models.FileField(upload_to='attachments/')
    uploaded_at = models.DateTimeField(auto_now_add=True)

    @property
    def filename(self):
        return os.path.basename(self.file.name)

    @property
    def extension(self):
        ext = os.path.splitext(self.file.name)[1].replace('.', '').upper()
        if ext == 'JPEG':
            return 'JPG'
        return ext

    @property
    def filesize(self):
        try:
            size = self.file.size
            for unit in ['B', 'KB', 'MB', 'GB', 'TB']:
                if size < 1024.0:
                    return f"{size:.0f} {unit}" if unit == 'B' else f"{size:.1f} {unit}"
                size /= 1024.0
            return f"{size:.1f} PB"
        except (ValueError, OSError, AttributeError):
            return "Unknown"

    @property
    def is_supported_icon(self):
        supported = ['PDF', 'DOCX', 'XLSX', 'PNG', 'JPG', 'MP4', 'MOV', 'RAR']
        return self.extension in supported

class AttendanceSession(models.Model):
    otp = models.CharField(max_length=4)
    created_by = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name="created_attendance_sessions")
    created_at = models.DateTimeField(default=timezone.now)
    expires_at = models.DateTimeField()
    is_active = models.BooleanField(default=True)

    def __str__(self):
        return f"OTP {self.otp} (active={self.is_active})"

class AttendanceMark(models.Model):
    STATUS_CHOICES = (
        ("PRESENT", "Present"),
        ("LATE", "Late"),
    )
    session = models.ForeignKey(AttendanceSession, on_delete=models.CASCADE, related_name="marks")
    student = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name="attendance_marks")
    status = models.CharField(max_length=10, choices=STATUS_CHOICES)
    marked_at = models.DateTimeField(default=timezone.now)

    class Meta:
        unique_together = ("session", "student")

    def __str__(self):
        return f"{self.student} - {self.status}"

class booking(models.Model):
    booking_id = models.AutoField(primary_key=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    facility = models.ForeignKey('facilities', on_delete=models.CASCADE)

    booking_date = models.DateField()
    start_time = models.TimeField()
    end_time = models.TimeField()

    purpose = models.TextField(blank=True, null=True)

    status = models.CharField(
        max_length=20,
        choices=[
            ('Pending','Pending'),
            ('Approved','Approved'),
            ('Rejected', 'Rejected'),
            ('Cancelled','Cancelled')
        ],
        default='Pending'
    )

    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'booking'

class SupportTicket(models.Model):
    CATEGORY_CHOICES = [
        ('GEN', 'General'),
        ('ANN', 'Announcements'),
        ('ATT', 'Attendance'),
        ('MAP', 'Campus Navigation'),
        ('BOK', 'Facility Booking'),
    ]

    STATUS_CHOICES = [
        ('open', 'Open'),
        ('in_progress', 'In Progress'),
        ('resolved', 'Resolved'),
        ('closed', 'Closed'),
        ('expired', 'Expired'),
    ]

    title = models.CharField(max_length=255)
    category = models.CharField(max_length=3, choices= CATEGORY_CHOICES, default='GEN')
    description = models.TextField()
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='open')
    
    created_by = models.ForeignKey(User, on_delete=models.CASCADE, related_name='tickets_created')
    assigned_to = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True, limit_choices_to={'is_staff': True}, related_name='tickets_handled')
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    all_attachments = GenericRelation(attachments)

    def __str__(self):
        return f"[{self.status.upper()}] {self.title}"
    
    @property
    def creator_name(self):
        full_name = self.created_by.get_full_name()
        return full_name if full_name else self.created_by.username

    @property
    def is_inactive(self):
        return self.status in ['closed', 'resolved', 'expired']

    @property
    def is_escalated(self):
        return self.activities.filter(action='escalation').exists()

    @property 
    def is_close_requested(self):
        return self.activities.filter(action="closure_request").exists()

class TicketMessage(models.Model):
    ticket = models.ForeignKey(SupportTicket, on_delete=models.CASCADE, related_name='messages')
    sender = models.ForeignKey(User, on_delete=models.CASCADE)
    content = models.TextField()
    sent_at = models.DateTimeField(auto_now_add=True)
    
    is_admin_reply = models.BooleanField(default=False)
    
    all_attachments = GenericRelation(attachments)

    @property 
    def sender_name(self):
        full_name = self.sender.get_full_name()
        return full_name if full_name else self.user.username

class TicketActivity(models.Model):
    ACTION_CHOICES = [
        ('status_change', 'Updated Status'),
        ('escalation', 'Escalated Ticket '),
        ('closure_request', 'Closure Requested'),
        ('rejected_closure', 'Rejected Closure Requested'),
    ]

    ticket = models.ForeignKey(SupportTicket, on_delete=models.CASCADE, related_name='activities')
    user = models.ForeignKey(User, on_delete=models.SET_NULL, null=True)
    action = models.CharField(max_length=20, choices=ACTION_CHOICES)
    old_value = models.CharField(max_length=255, null=True, blank=True)
    new_value = models.CharField(max_length=255, null=True, blank=True)
    timestamp = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['-timestamp']

    @property
    def creator_name(self):
        full_name = self.user.get_full_name()
        return full_name if full_name else self.user.username

    @property 
    def is_admin(self):
        return self.user.groups.filter(name="admin").exists()

class timetable_preference(models.Model):
    id = models.AutoField(primary_key=True)
    term = models.ForeignKey('academic_term', on_delete=models.CASCADE, related_name='timetable_preferences')
    subject = models.ForeignKey('subject', on_delete=models.CASCADE)
    lecturer = models.ForeignKey(User, on_delete=models.CASCADE)
    session = models.ForeignKey('session', on_delete=models.CASCADE)
    is_active = models.BooleanField(default=True)

    class Meta:
        db_table = 'timetable_preference'

    def __str__(self):
        return f"{self.term} - {self.subject} ({self.session.day_of_week})"

class lecturer_assignment(models.Model):
    id = models.AutoField(primary_key=True)
    term = models.ForeignKey('academic_term', on_delete=models.CASCADE, related_name='lecturer_assignments')
    subject = models.ForeignKey('subject', on_delete=models.CASCADE)
    lecturer = models.ForeignKey(User, on_delete=models.CASCADE)

    class Meta:
        db_table = 'lecturer_assignment'
        unique_together = ('term', 'subject')

    def __str__(self):
        return f"{self.term} - {self.subject} -> {self.lecturer.get_full_name()}"

class skipped_date(models.Model):
    id = models.AutoField(primary_key=True)
    term = models.ForeignKey('academic_term', on_delete=models.CASCADE, related_name='skipped_dates')
    date = models.DateField()
    reason = models.CharField(max_length=255, default='Public Holiday')

    class Meta:
        db_table = 'skipped_date'
        unique_together = ('term', 'date')

    def __str__(self):
        return f"{self.date} - {self.reason}"
    
class announcement(models.Model):
    ANNOUNCEMENT_TYPES = [
        ('BANNER', 'Rolling Banner'),
        ('NORMAL', 'Normal News'),
    ]

    announcement_id = models.AutoField(primary_key=True)
    subject = models.CharField(max_length=255)
    content = models.TextField()
    date_published = models.DateTimeField(default=timezone.now)
    is_active = models.BooleanField(default=True)
    author = models.ForeignKey(
        'admin_profiles',
        on_delete= models.SET_NULL,
        null=True,
        blank=True,
        related_name='authored_ann'
    )

    announcement_type = models.CharField(
        max_length=10, 
        choices=ANNOUNCEMENT_TYPES, 
        default='NORMAL'
    )

    def __str__(self):
        return self.subject

class announcementTarget(models.Model):
    target_id = models.AutoField(primary_key=True)
    announcement = models.ForeignKey(
        announcement, 
        on_delete=models.CASCADE, 
        related_name='targets'
    )
    is_for_students = models.BooleanField(default=True)
    is_for_lecturer = models.BooleanField(default=True)
    is_for_admins = models.BooleanField(default=True)
    academic_term = models.CharField(max_length=50, blank=True, null=True)

    def __str__(self):
        return f"Target for {self.announcement.subject}: {self.user_group}"