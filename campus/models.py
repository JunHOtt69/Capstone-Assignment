from django.db import models
from django.contrib.auth.models import User
from django.utils.dateparse import parse_date
from datetime import date
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
    student	= models.ForeignKey(User, on_delete=models.CASCADE)
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
    user	= models.ForeignKey(User, on_delete=models.CASCADE)
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

class subject(models.Model):
    subject_id = models.AutoField(primary_key = True)
    subject_code = models.CharField(max_length=20, unique=True)
    subject_name = models.CharField(max_length=255)
    credit_hour = models.IntegerField(default=0)
    class Meta:
        db_table = 'subject'