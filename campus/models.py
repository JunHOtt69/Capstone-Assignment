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
    id = models.AutoField(primary_key = True)
    session	= models.ForeignKey('session', on_delete=models.CASCADE)
    subject	= models.ForeignKey('subject', on_delete=models.CASCADE)
    lecturer	= models.ForeignKey(User, on_delete=models.CASCADE)

    class Meta:
        db_table = 'class_session'

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
    capacity = models.IntegerField(default = 0)
    building = models.CharField(max_length=50)
    level = models.IntegerField(default = 1)
    coordinate = models.DecimalField(max_digits=9, decimal_places=6)
    is_bookable = models.BooleanField(default=False)
    class Meta:
        db_table = 'facilities'

class lecturer_profiles(models.Model):
    id = models.AutoField(primary_key = True)
    user	= models.OneToOneField(User, on_delete=models.CASCADE, related_name='lecturer_profile')
    lc_id	= models.CharField(max_length=12, unique=True)
    dept	= models.ForeignKey('departments', on_delete=models.CASCADE, null=True, blank=True)
    specialization = models.TextField(null=True, blank=True)
    is_head	= models.BooleanField(default = False)
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
    subject_id = models.AutoField(primary_key = True)
    subject_code = models.CharField(max_length=20, unique=True)
    subject_name = models.CharField(max_length=255)
    credit_hour = models.IntegerField(default=0)
    class Meta:
        db_table = 'subject'

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
            ('Cancelled','Cancelled')
        ],
        default='Pending'
    )

    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'booking'

class SupportTicket(models.Model):
    CATEGORY_CHOICES = [
        ('', 'Please Select a Category'),
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

    # This allows us to use ticket.attachments.all()
    all_attachments = GenericRelation(attachments)

    def check_expiry(self):
        if self.status == 'open' and self.created_at < timezone.now() - timedelta(days=7):
            self.status = 'expired'
            self.save()

    def __str__(self):
        return f"[{self.status.upper()}] {self.title}"

class TicketMessage(models.Model):
    ticket = models.ForeignKey(SupportTicket, on_delete=models.CASCADE, related_name='messages')
    sender = models.ForeignKey(User, on_delete=models.CASCADE)
    content = models.TextField()
    sent_at = models.DateTimeField(auto_now_add=True)
    
    # Identify if it's an admin reply or user reply
    is_admin_reply = models.BooleanField(default=False)
    
    all_attachments = GenericRelation(attachments)

class CannedResponse(models.Model):
    title = models.CharField(max_length=100) # e.g., "General Acknowledgment"
    message = models.TextField()

    def __str__(self):
        return self.title