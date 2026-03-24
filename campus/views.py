from django.shortcuts import render, redirect, get_object_or_404
from django.template.loader import render_to_string
from django.http import JsonResponse
from django.db import transaction, DatabaseError
from django.db.models import Q, Count, F
from django.core.mail import EmailMultiAlternatives
from django.core.files.base import ContentFile
from django.core.exceptions import PermissionDenied
from django.utils.encoding import force_bytes
from django.utils import timezone
from django.utils.dateparse import parse_date
from django.utils.http import urlsafe_base64_encode, urlsafe_base64_decode
from django.utils.html import strip_tags
from django.urls import reverse_lazy
from django.urls import reverse
#from django.utils.decorators import method_decorator
from django.contrib import messages
from django.contrib.admin.models import LogEntry, ADDITION, CHANGE, DELETION
from django.contrib.contenttypes.models import ContentType
from django.contrib.auth.tokens import default_token_generator
from django.contrib.auth.decorators import login_required
from django.views.decorators.http import require_POST
from django.contrib.auth import logout
from django.contrib.auth.views import LoginView, PasswordResetView, PasswordResetConfirmView
from django.contrib.auth import get_user_model
from django.contrib.auth.models import User, Group
from django.conf import settings
from datetime import timedelta, date
from bs4 import BeautifulSoup
import os
import uuid
import datetime
import random
import json
import base64
import math
from .forms import UserRowForm, AcademicTermForm, newFAQForm, SupportTicketForm,newAnnouncemeentForm
from .models import course, academic_term, academic_rules, departments, lecturer_profiles, course_enrollment, admin_profiles, student_profiles, MapNode, MapEdge, faq, FAQReaction, AttendanceSession, AttendanceMark, attachments, SupportTicket, TicketMessage, TicketActivity, announcement, announcementTarget
from .decorators import role_required
from .models import facilities, booking
from .models import (
    class_session, session, subject, course_subject, lecturer_subjects, 
    timetable_preference, lecturer_assignment, skipped_date, SubjectComponent
)

#playground
def testing(request):
    return render(request, 'testing.html')

#logging function
def record_admin_action(user_id, content_type_id, object_id, object_repr, action_flag, message=""):
    """
    Manually records an action into the django_admin_log.
    """
    LogEntry.objects.log_action(
        user_id=user_id,
        content_type_id=content_type_id,
        object_id=object_id,
        object_repr=object_repr, # e.g., "Math 101 - Section A"
        action_flag=action_flag, # Use ADDITION, CHANGE, or DELETION
        change_message=message    # e.g., "Updated room from L1 to L5"
    )

#logout user when password resetting
class SmartPasswordResetConfirmView(PasswordResetConfirmView):
    def dispatch(self, *args, **kwargs):
        if self.request.user.is_authenticated:
            logout(self.request)
            messages.info(self.request, "You have been logged out to securely set up the new account password.")
            return redirect(self.request.path)
        
        return super().dispatch(*args, **kwargs)
    
    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        uidb64 = self.kwargs.get('uidb64')
        
        try:
            uid = urlsafe_base64_decode(uidb64).decode()
            target_user = User.objects.get(pk=uid)
            
            context['is_new_user'] = not target_user.has_usable_password()
        except (TypeError, ValueError, OverflowError, User.DoesNotExist):
            context['is_new_user'] = False
            
        return context
        

class CustomPasswordResetView(PasswordResetView):
    template_name = 'registration/password_reset_form.html'
    success_url = "/accounts/password_reset/done/"
    
    def form_valid(self, form):
        email = form.cleaned_data["email"]
        User = get_user_model()
        users = User.objects.filter(username=email, is_active=True)

        for user in users:
            uidb64 = urlsafe_base64_encode(force_bytes(user.pk))
            token=default_token_generator.make_token(user)
            path = reverse("password_reset_confirm", kwargs={"uidb64": uidb64, "token": token})
            link = self.request.build_absolute_uri(path)

            from_email = None
            group = user.groups.first()
            role = group.name if group else "User"
            subject = "Reset your Smart Campus password"
            text_content = f"""Hi {user.first_name},
We received a request to reset the password for your {role} account associated with Asia Pacific University.
Note: This link is time-sensitive and will expire in 15 minutes.
{link}
If you did not request a password reset, please disregard this email or contact IT support if you have concerns about your account security.
"""
            html_content = render_to_string("emails/forget_password_email.html",{
                "first_name": user.first_name,
                "role": role,
                "reset_link": link,
            })

            msg = EmailMultiAlternatives(subject, text_content, from_email, [email])
            msg.attach_alternative(html_content, "text/html")
            msg.send()
            
        return super().form_valid(form)

# if applying role based view on class:
#@method_decorator(role_required(allowed_roles=['admin']), name='dispatch')
class RoleBasedLoginView(LoginView):
    template_name = "registration/login.html"

    def form_valid(self, form):
        response = super().form_valid(form)
        remember_me = form.cleaned_data.get('remember_me')

        if remember_me: 
            self.request.session.set_expiry(1 * 7 * 24 * 60 * 60)
        else:
            self.request.session.set_expiry(0)

        return response
    
    def get_success_url(self):
        user = self.request.user
        target = redirect_user_by_role(user)
        if(target == "account_error"):
            logout(self.request)
            return reverse_lazy("account_error")
        return reverse_lazy(target) 

#redirect user to their dashboard:
def redirect_user_by_role(user):
    if user.groups.filter(name="admin").exists():
        return "admin_dashboard"
    if user.groups.filter(name="lecturer").exists():
        return "lecturer_dashboard"
    if user.groups.filter(name="student").exists():
        return "student_dashboard"
    return "account_error"

#unauthorize redirection
# Create your views here.
def home(request): 
    if request.user.is_authenticated:
        return redirect(redirect_user_by_role(request.user))
    return render(request, "home.html")

def about(request): 
    return render(request, "about.html") 

@login_required
def account_error(request):
    return render(request, "account_error.html")

@role_required(allowed_roles=['admin'])
def admin_dashboard(request):
    return render(request, "dashboards/admin_dashboard.html")

@role_required(allowed_roles=['lecturer'])
def lecturer_dashboard(request):
    return render(request, "dashboards/lecturer_dashboard.html")

@role_required(allowed_roles=['student'])
def student_dashboard(request):
    return render(request, "dashboards/student_dashboard.html")

#attendance function
@login_required
@role_required(['student'])
def attendance(request):
    marks = AttendanceMark.objects.filter(student=request.user).order_by("-marked_at")

    total_marks = marks.count()
    present_count = marks.filter(status="PRESENT").count()
    late_count = marks.filter(status="LATE").count()

    overall_percentage = round((present_count / total_marks) * 100, 1) if total_marks > 0 else 0

    intake_code = "N/A"
    if hasattr(request.user, "student_profile"):
        intake_code = request.user.student_profile.tp_id

    current_sem = "N/A"
    current_courses = []
    previous_sem_data = []

    enrollment = course_enrollment.objects.filter(student=request.user).select_related("term").first()

    if enrollment and enrollment.term:
        current_sem = enrollment.term.current_semester
        current_course = enrollment.term.course

        course_subjects = course_subject.objects.filter(
            course=current_course,
            recommended_semester=current_sem
        ).select_related("subject")

        current_courses = [
            {
                "name": cs.subject.subject_name,
                "percentage": overall_percentage
            }
            for cs in course_subjects
        ]

#Previous semesters subjects
        for sem in range(1, current_sem):
            prev_subjects = course_subject.objects.filter(
                course=current_course,
                recommended_semester=sem
            ).select_related("subject")

            previous_sem_data.append({
                "semester": sem,
                "percentage": overall_percentage,
                "courses": [
                    {
                        "name": ps.subject.subject_name,
                        "percentage": overall_percentage
                    }
                    for ps in prev_subjects
                ]
            })

    full_name = f"{request.user.first_name} {request.user.last_name}".strip()

    if not full_name:
        full_name = request.user.username

    context = {
        "student": {
            "name": full_name,
            "intake_code": intake_code,
        },
        "overall_percentage": overall_percentage,
        "current_sem": current_sem,
        "current_courses": current_courses,
        "sem_percentage": overall_percentage,
        "previous_sem_data": previous_sem_data,
    }

    return render(request, "attendance.html", context)

@login_required
@role_required(['student'])
def attendance_signup(request):
    if request.method == "POST":
        input_otp = (request.POST.get("otp") or "").strip()

        session = AttendanceSession.objects.filter(is_active=True).order_by("-created_at").first()

        if not session:
            return JsonResponse({"ok": False, "message": "OTP not available yet. Please ask lecturer to generate OTP."})

        if timezone.now() > session.expires_at:
            session.is_active = False
            session.save()
            return JsonResponse({"ok": False, "message": "OTP expired. Please ask lecturer to generate a new OTP."})

        if input_otp != session.otp:
            return JsonResponse({"ok": False, "message": "Invalid code. Please try again."})

        if AttendanceMark.objects.filter(session=session, student=request.user).exists():
            return JsonResponse({"ok": False, "message": "Attendance already recorded for this class."})

        late_after = session.created_at + timedelta(minutes=10)
        status = "LATE" if timezone.now() > late_after else "PRESENT"

        AttendanceMark.objects.create(session=session, student=request.user, status=status)

        return JsonResponse({"ok": True, "message": f"Attendance successful! Status: {status}."})

    return render(request, "attendance_signup.html")

@login_required
@role_required(['lecturer'])
def attendance_lecturer_otp(request):
    OTP_TTL_MIN = 5

    session = AttendanceSession.objects.filter(is_active=True).order_by("-created_at").first()

    if session and timezone.now() > session.expires_at:
        session.is_active = False
        session.save()
        session = None

    if request.method == "POST":
        AttendanceSession.objects.filter(is_active=True).update(is_active=False)

        otp = f"{random.randint(0, 9999):04d}"
        now = timezone.now()
        session = AttendanceSession.objects.create(
            otp=otp,
            created_by=request.user,
            created_at=now,
            expires_at=now + timedelta(minutes=OTP_TTL_MIN),
            is_active=True
        )

    present = late = absent = 0
    total_students = User.objects.filter(groups__name="student").distinct().count()

    if session:
        present = AttendanceMark.objects.filter(session=session,status="PRESENT").count()
        late = AttendanceMark.objects.filter(session=session, status="LATE").count()
        absent = max(total_students - present - late, 0)

    return render(request, "attendance_lecturer_otp.html", {
        "session": session,
        "OTP_TTL_MIN": OTP_TTL_MIN,
        "present": present,
        "late": late,
        "absent": absent,
    })

@login_required
@role_required(['lecturer'])
def attendance_chart_data(request):
    session = AttendanceSession.objects.filter(is_active=True).order_by("-created_at").first()

    present = late = absent = 0
    total_students = User.objects.filter(groups__name="student").distinct().count()

    if session:
        if timezone.now() > session.expires_at:
            session.is_active = False
            session.save()
        else:
            present = AttendanceMark.objects.filter(session=session, status="PRESENT").count()
            late = AttendanceMark.objects.filter(session=session, status="LATE").count()
            absent = max(total_students - present - late, 0)

    return JsonResponse({
        "present": present,
        "late": late,
        "absent": absent,
    })

#management function
@role_required(allowed_roles=['admin'])
def user_management(request):
    return render(request, "user_management.html")

#function for create_user_manually
def build_set_password_link(request, user):
    uidb64 = urlsafe_base64_encode(force_bytes(user.pk))
    token = default_token_generator.make_token(user)
    path = reverse("password_reset_confirm", kwargs = {"uidb64": uidb64, "token": token})
    return request.build_absolute_uri(path)

def check_email_exists(request):
    emails = [e.lower() for e in request.GET.getlist('emails[]')]
    existing = User.objects.filter(
        Q(username__in = emails) | Q (email__in = emails)
    )
    
    taken_set = {val.lower() for val in existing.values_list('username', flat=True)} | \
                {val.lower() for val in existing.values_list('email', flat=True)}

    taken_details = []

    for index, email in enumerate(emails):
        if email in taken_set:
            taken_details.append({
                'email': email,
                'index': index + 1 
            })
    
    return JsonResponse({
        'is_taken' : len(taken_details) > 0,
        'taken_emails' : taken_details,
    })

def generate_user_id(role):
    prefixes = {
        'admin' : 'AD',
        'lecturer': 'LC',
        'student': 'TP'
    }

    prefix = prefixes.get(role)
    year = datetime.datetime.now().strftime("%y")
    
    model_map = {
        'admin': admin_profiles,
        'lecturer': lecturer_profiles,
        'student': student_profiles,
    }

    targetModel = model_map.get(role)

    field_map = {
        'admin': 'ad_id',
        'lecturer': 'lc_id',
        'student': 'tp_id',
    }

    field_name = field_map.get(role)

    while True:
        random_digits = random.randint(1000, 9999)
        new_id = f"{prefix}{year}{random_digits}"

        exists = targetModel.objects.filter(**{field_name: new_id}).exists()

        if not exists:
            return new_id

@role_required(allowed_roles=['admin'])
@transaction.atomic 
def create_user_manually(request):
    groups = {g.name: str(g.id) for g in Group.objects.filter(name__in=['admin', 'lecturer', 'student'])}
    dept = list(departments.objects.values('dept_id', 'dept_name'))
    available_term = list(academic_term.objects.values('term_id', 'intake_code').order_by('-start_date'))
    id_to_name = {v: k for k, v in groups.items()}
    
    context = {
        "groups" : groups,
        "dept" : dept,
        "available_term" : available_term,
        "form":  None,
        "selected_role": None,
        "error" : None,
    }

    if request.method == 'POST':
        context["form"] = UserRowForm(request.POST)
        first_names = request.POST.getlist('first_name')
        last_names = request.POST.getlist('last_name')
        emails = request.POST.getlist('email')
        role_id = request.POST.get('user_role')
        request.session['selected_role_id'] = role_id

        try:
            users_to_invite = []

            with transaction.atomic():
                for i in range(len(first_names)):
                    email = emails[i]
                    
                    if User.objects.filter(Q(username = email) | Q(email=email)).exists():
                        raise Exception(f"The email {email} is already registered.")

                    new_user = User.objects.create_user(
                        username = email,
                        email = email,
                        password = None,
                        first_name = first_names[i],
                        last_name = last_names[i],
                    )

                    users_to_invite.append({
                        'email': emails[i],
                        'first_name': first_names[i],
                        'user': new_user
                    })

                    unique_id = generate_user_id(id_to_name.get(str(role_id)))
                    new_user.set_unusable_password()
                    new_user.save()

                    #schedule email after transaction succeeds
                    
                    if str(role_id) == str(groups.get('admin')):
                        new_user.is_staff = True
                        new_user.save()

                        admin_profiles.objects.create(
                            user = new_user,
                            ad_id = unique_id
                        )
                    
                    group = Group.objects.get(id=role_id)
                    new_user.groups.add(group)

                    if str(role_id) == str(groups.get('lecturer')):
                        new_user.is_staff = True
                        new_user.save()
                        dept_val = request.POST.get(f'department_{i+1}')
                        dept_obj = None

                        try: 
                            if(dept_val and dept_val.strip()):
                                dept_obj = departments.objects.filter(dept_id= dept_val).first()
                            lecturer_profiles.objects.create(
                                # passing the user object, instead of the id, because the id is automatically incremented, django will handle the id extraction
                                user = new_user,
                                lc_id = unique_id,
                                dept = dept_obj
                            )
                        except departments.DoesNotExist:
                            messages.error(request, f"The selected department for lecturer {i+1} does not exists. ")

                    elif str(role_id) == str(groups.get('student')):
                        term_val = request.POST.get(f'term_{i+1}')

                        student_profiles.objects.create(
                            user = new_user,
                            tp_id = unique_id
                        )

                        try: 
                            term_obj = academic_term.objects.filter(term_id=term_val).first()
                            course_enrollment.objects.create(
                                student = new_user,
                                term = term_obj,
                                enrollment_status = 'Active'
                            )
                        except academic_term.DoesNotExist:
                            raise Exception(f"The selected academic term for student {i+1} does not exists. ")

            email_errors = []
            for invite in users_to_invite:
                try: 
                    user = invite['user']
                    link = build_set_password_link(request, user)
                    subject = "Set your Smart Campus password"
                    from_email=None
                    to = [invite['email']]
                    
                    html_content = render_to_string(
                        'emails/set_password_email.html',
                        {
                            "first_name" : invite['first_name'],
                            "reset_link": link,
                        },
                    )
                    text_content = f"""
    Hi{invite['first_name']},
    Your administrative account for the Smart Campus Management System has been successfully created.

    To get started, please click the button below to set your account password.
    {link}

    If you have any issues accessing your account, please contact the IT Helpdesk.
    """
                    msg = EmailMultiAlternatives(subject, text_content, from_email, to)
                    msg.attach_alternative(html_content, "text/html")
                    msg.send()
                    print(f"New User Created. Set Password: {link}")
                    
                except Exception as e: 
                    email_errors.append(f"{invite['email']}: {e}")
                    
            if email_errors:
                messages.warning(
                    request,
                    "Users were created, but email could not be sent. Please check email settings / resend."
                )
                print("Email sending errors:", email_errors)
            else:
                messages.success(request, f'Successfully created {len(first_names)} user(s)!')

            return redirect('create_user_manually')
        
        except Exception as e:
            # If anything fails, print to console and show error to user
            print(f"Error during user creation: {e}")
            messages.error(request, f"An error occurred: {str(e)}")
            context["selected_role"] = request.session.get('role_id')
            context['error'] = f"An error occurred: {str(e)}"
            return render(request, "partials/create_user_manually.html", context)

    else: 
        context["form"] = UserRowForm()
        context["selected_role"] = request.session.get('selected_role_id')

    return render(request, "partials/create_user_manually.html", context)


#user crud
@role_required(allowed_roles=['admin'])
@transaction.atomic 
def user_crud(request):
    if request.method == "POST":
        action = request.POST.get('action')
        active_role = request.POST.get('active_role', 'admin')
        user_id = request.POST.get('user_id')
        user = get_object_or_404(User, id=user_id)
        user_fullname = user.get_full_name()
        
        print('Action: ', action)
        print("email", request.POST.get('email'))
        try:
            if action == "delete":
                user.delete()
                messages.success(request, f"User {user_fullname} has been permanently deleted.")

            elif action == 'save':
                user.first_name = request.POST.get('first_name')
                user.last_name = request.POST.get('last_name')
                new_email = request.POST.get('email')
                
                user.email = new_email
                user.username = new_email
                user.save()

                extra_id = request.POST.get('extra_id')

                if extra_id:
                    if hasattr(user, 'lecturer_profile'):
                        prof = user.lecturer_profile
                        prof.dept = departments.objects.get(dept_id=extra_id)
                        prof.save()
                    elif hasattr(user, 'student_profile'):
                        enrollment = user.course_enrollment
                        enrollment.term = academic_term.objects.get(term_id=extra_id)
                        enrollment.save()

                messages.success(request, f"User {user_fullname} updated successfully!")

        except Exception as e:
            messages.error(request, f"Error updating user: {str(e)}")

        return redirect(f"{reverse('user_crud')}?role={active_role}")

    elif request.method == "GET":
        role = request.GET.get('role', 'admin')
        query = request.GET.get('q', '')

        if role == 'lecturer':
            user_list = User.objects.filter(groups__name__icontains='lecturer').select_related('lecturer_profile__dept')
        elif role == 'student':
            user_list = User.objects.filter(groups__name__icontains='student').select_related('course_enrollment__term')
        else:
            user_list = User.objects.filter(groups__name__icontains='admin')

        if query:
            words = query.split()
            for word in words:
                user_list = user_list.filter(
                    Q(first_name__icontains=word) | 
                    Q(last_name__icontains=word) | 
                    Q(email__icontains=word)
                )

        context = {
            'users': user_list,
            'active_role': role,
            'search_query': query,
            "depts": departments.objects.all(),
            "terms": academic_term.objects.all(),
        }
        if request.headers.get('x-requested-with') == 'XMLHttpRequest':
            return render(request, 'partials/user_list.html', context)
    
    return render(request, "partials/user_crud.html", context)

@role_required(allowed_roles=['admin'])
def get_details(request, user_id):
    user = get_object_or_404(User, id=user_id)
    role = 'admin'
    data = {
        'first_name': user.first_name,
        'last_name': user.last_name,
        'email': user.email,
    }

    if hasattr(user, 'lecturer_profile'):
        data.update({
            'role': 'lecturer',
            'dept_id': user.lecturer_profile.dept.dept_id if user.lecturer_profile.dept else "",
            'dept_name': user.lecturer_profile.dept.dept_name if user.lecturer_profile.dept else 'N/A',
            'is_head': user.lecturer_profile.is_head,
        })
    elif hasattr(user, 'student_profile'):
        enrollment = getattr(user, 'course_enrollment', None)
        data.update({
            'role': 'student',
            'intake_id': enrollment.term.term_id if enrollment else '',
            'intake_code': enrollment.term.intake_code,
        })
    else:
        data['role'] = 'admin'

    return JsonResponse(data)

@role_required(allowed_roles=['admin'])
def resend_invite(request, user_id):
    user = get_object_or_404(User, id=user_id)
    
    try:
        link = build_set_password_link(request, user)
        subject = "Set your Smart Campus password"
        html_content = render_to_string('emails/set_password_email.html', {
            "first_name": user.first_name,
            "reset_link": link,
        })
        
        msg = EmailMultiAlternatives(subject, "Please set your password.", None, [user.email])
        msg.attach_alternative(html_content, "text/html")
        msg.send()
        print(f"Link to reset email {user.email}:{link.strip()}")

        return JsonResponse({
            'success': True, 
            'message': f"Invitation resent to {user.email}"
        })
        
    except Exception as e:
        return JsonResponse({
            'success': False, 
            'message': f"Mail error: {str(e)}"
        }, status=500)

@role_required(allowed_roles=['admin'])
@transaction.atomic
def bulk_user_creation(request):
    if request.method == 'POST':
        try:
            json_data = request.POST.get('user_data')
            data = json.loads(json_data)

            groups = {g.name.lower(): g for g in Group.objects.filter(name__in=['admin', 'lecturer', 'student'])}
            
            users_to_invite = []
            skipped_users = []
            created_count = 0
            row_num = 0

            for index, row in enumerate(data):
                row_num = index + 1
                email = row.get('email', '').strip()
                role_name = row.get('role', '').lower().strip()
                first_name = row.get('first_name', '').strip()
                last_name = row.get('last_name', '').strip()
                group = groups.get(role_name)
                dept_code = row.get('department', '').strip()
                intake_code = row.get('intake', '').strip()

                error_reason = None

                if not email:
                    error_reason = "Email is missing."
                elif role_name not in groups:
                    error_reason = f"Invalid role '{role_name}'. Must be admin, lecturer, or student."
                elif not first_name and not last_name:
                    error_reason = "Both First Name and Last Name are required."
                
                elif role_name == 'admin':
                    if dept_code or intake_code:
                        error_reason = "Admins should not have Department or Intake codes assigned."

                elif role_name == 'lecturer':
                    if not dept_code:
                        error_reason = f"Lecturer must have a Department code."

                    else:
                        dept_obj = departments.objects.filter(dept_code=dept_code).first() 
                        if not dept_obj:
                            error_reason = f"Department code '{dept_code}' does not exist in the system."

                    if not error_reason and intake_code:
                        error_reason = "Lecturers cannot be assigned to an Intake code."

                elif role_name == 'student':
                    if not intake_code:
                        error_reason = "Students must have an Intake code."
                    else:
                        term = academic_term.objects.filter(intake_code=intake_code).first()
                        if not term:
                            error_reason = f"Intake code '{intake_code}' is invalid or not found."

                    if not error_reason and dept_code:
                            error_reason = "Students should use Intake codes, not Department codes."

                if error_reason:
                    skipped_users.append({
                        'row': row_num,
                        'email': email if email else "Null",
                        'reason': error_reason
                    })
                    continue

                new_user = User.objects.create_user(
                    username=email, 
                    email=email,
                    first_name=first_name, 
                    last_name=last_name
                )
 
                new_user.groups.add(group)
                new_user.set_unusable_password()
                
                if role_name in ['admin', 'lecturer']:
                    new_user.is_staff = True
                
                new_user.save()
                new_user.groups.add(group)

                unique_id = generate_user_id(role_name)

                if role_name == 'admin':
                    admin_profiles.objects.create(
                        user=new_user, 
                        ad_id=unique_id
                    )

                elif role_name == 'lecturer':
                    dept_obj = departments.objects.filter(dept_code=dept_code).first() 
                    lecturer_profiles.objects.create(
                        user=new_user, 
                        lc_id=unique_id, 
                        dept=dept_obj
                    )

                elif role_name == 'student':
                    student_profiles.objects.create(user=new_user, tp_id=unique_id)
                    
                    term_obj = academic_term.objects.filter(intake_code=intake_code).first()

                    if term_obj:
                        course_enrollment.objects.create(
                            student=new_user,
                            term=term_obj,
                            enrollment_status='Active'
                        )

                users_to_invite.append({
                    'email': email,
                    'first_name': first_name,
                    'user': new_user
                })
                
                created_count += 1

            for invite in users_to_invite:
                try:
                    link = build_set_password_link(request, invite['user'])
                    subject = "Set your Smart Campus password"
                    html_content = render_to_string('emails/set_password_email.html', {
                        "first_name": invite['first_name'],
                        "reset_link": link,
                    })
                    msg = EmailMultiAlternatives(subject, "Please set your password.", None, [invite['email']])
                    msg.attach_alternative(html_content, "text/html")
                    msg.send()

                    print(f"Link to reset email {invite['email']}:{link.strip()}")
                except Exception as e:
                    print(f"Mail error for {invite['email']}: {e}")
            
            if created_count > 0:
                messages.success(request, f'Successfully created {created_count} user(s)!')

            if skipped_users:
                error_lines = [
                    f"Row {item['row']} ({item['email']}): {item['reason']}" 
                    for item in skipped_users
                ]
                
                full_error_message = "Some rows were skipped:\n" + "\n".join(error_lines)
                
                messages.error(request, full_error_message)
            return redirect("bulk_user_creation")

        except Exception as e:
            messages.error(request, str(e))
            return redirect("bulk_user_creation")
    
    return render(request, 'partials/bulk_user_creation.html')


#manage academic function
@role_required(allowed_roles=['admin'])  
def academic_management(request):
    return render(request, "academic_management.html")

@role_required(allowed_roles=['admin'])  
@transaction.atomic
def manage_academic_term(request):
    levels = [{'id': c[0], 'name': c[1]} for c in course.LEVEL_CHOICES]
    
    if request.method == 'POST':
        form = AcademicTermForm(request.POST)
        if form.is_valid():
            new_term = form.save()

            record_admin_action(
                user_id=request.user.id,
                content_type_id=ContentType.objects.get_for_model(academic_term).pk,
                object_id=new_term.pk,
                object_repr=str(new_term),
                action_flag=ADDITION,
                message=f"Created new Academic Term: {new_term.intake_code}"
            )

            messages.success(request, "Academic Term created successfully!")

            return redirect('manage_academic_term')
        else: 
            print(f"Error during academic term creation: {form.errors}")
            messages.error(request, f"An error occurred: {form.errors}")

    else: form = AcademicTermForm()
    
    context = {
        "form": form,
        "levels": levels,
    }
        
    return render(request, "partials/manage_academic_term.html", context)

@role_required(allowed_roles=['admin'])
def get_terms(request):
    terms = list(academic_term.objects.select_related('course').values(
        'term_id',
        'intake_code', 
        'course__course_name',
        'current_semester', 
        'start_date', 
        'end_date', 
        'is_active'
    ).order_by('-start_date'))

    target_rules = ['Study Weeks', 'Examination Period']
    rules = list(academic_rules.objects.filter(rule_name__in = target_rules).values('rule_name', 'value_days'))

    data = {
        'terms' : terms,
        'rules' : rules,
    }

    return JsonResponse(data)

@role_required(allowed_roles=['admin'])
@require_POST
def update_term(request):
    try:
        data = json.loads(request.body)
        term_id = data.get('term_id')
        term = get_object_or_404(academic_term, term_id=term_id)

        if 'current_semester' in data:
            semester = int(data['current_semester'])
            if semester < 1:
                return JsonResponse({'success': False, 'error': 'Semester must be at least 1.'}, status=400)
            term.current_semester = semester

        if 'is_active' in data:
            term.is_active = bool(data['is_active'])

        if 'start_date' in data:
            parsed = parse_date(data['start_date'])
            if not parsed:
                return JsonResponse({'success': False, 'error': 'Invalid start date.'}, status=400)
            term.start_date = parsed

        if 'end_date' in data:
            parsed = parse_date(data['end_date'])
            if not parsed:
                return JsonResponse({'success': False, 'error': 'Invalid end date.'}, status=400)
            term.end_date = parsed

        if term.start_date and term.end_date and term.start_date >= term.end_date:
            return JsonResponse({'success': False, 'error': 'End date must be after start date.'}, status=400)

        term.save()

        record_admin_action(
            user_id=request.user.id,
            content_type_id=ContentType.objects.get_for_model(academic_term).pk,
            object_id=term.pk,
            object_repr=str(term),
            action_flag=CHANGE,
            message=f"Updated Academic Term: {term.intake_code}"
        )

        return JsonResponse({'success': True})
    except (ValueError, TypeError) as e:
        return JsonResponse({'success': False, 'error': str(e)}, status=400)

@role_required(allowed_roles=['admin'])
@require_POST
def delete_term(request):
    try:
        data = json.loads(request.body)
        term_id = data.get('term_id')
        term = get_object_or_404(academic_term, term_id=term_id)

        enrollments = course_enrollment.objects.filter(term=term).count()
        sessions = class_session.objects.filter(term=term).count()

        if enrollments > 0 or sessions > 0:
            return JsonResponse({
                'success': False,
                'error': f'Cannot delete: this term has {enrollments} enrollment(s) and {sessions} class session(s) linked to it.'
            }, status=400)

        record_admin_action(
            user_id=request.user.id,
            content_type_id=ContentType.objects.get_for_model(academic_term).pk,
            object_id=term.pk,
            object_repr=str(term),
            action_flag=DELETION,
            message=f"Deleted Academic Term: {term.intake_code}"
        )

        term.delete()
        return JsonResponse({'success': True})
    except (ValueError, TypeError) as e:
        return JsonResponse({'success': False, 'error': str(e)}, status=400)

@role_required(allowed_roles=['admin'])
def get_courses_by_level(request):
    level = request.GET.get('level')
    courses = course.objects.filter(level=level).values('course_id', 'course_code',  'course_name', 'semester_week')
    return JsonResponse(list(courses), safe=False)


#navigation, campus map
def map_data(request):
    """Fetch map nodes and edges from database"""
    try:
        nodes = MapNode.objects.all()
        edges = MapEdge.objects.all()
        
        if not nodes.exists():
            # Return empty data structure if no data in DB
            return JsonResponse({"nodes": [], "edges": [], "pois": []})
        
        # Return with 'id' and 'type' for backward compatibility with campus_map.js
        nodes_list = [
            {
                "id": node.node_id,           # Use 'id' for campus_map.js
                "name": node.name,
                "type": node.node_type,       # Use 'type' for campus_map.js
                "x": node.x,
                "y": node.y,
                # Also include node_id and node_type for edit_map.js
                "node_id": node.node_id,
                "node_type": node.node_type,
            }
            for node in nodes
        ]
        
        edges_list = [
            {
                "from": edge.from_node.node_id,
                "to": edge.to_node.node_id
            }
            for edge in edges
        ]
        
        data = {"nodes": nodes_list, "edges": edges_list, "pois": []}
        return JsonResponse(data)
    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)

def navigation(request): 
    return render(request, "navigation.html")

@login_required
@role_required(allowed_roles=['student', 'lecturer'])
def navigate_to_class(request):
    """Find the user's current or next class and redirect to navigation with the classroom pre-selected."""
    now = timezone.localtime()
    today = now.date()
    current_time = now.time()

    day_map = {0: 'MON', 1: 'TUE', 2: 'WED', 3: 'THU', 4: 'FRI', 5: 'SAT', 6: 'SUN'}
    today_day = day_map.get(today.weekday())

    if today_day not in ('MON', 'TUE', 'WED', 'THU', 'FRI'):
        messages.info(request, "No classes scheduled on weekends.")
        return redirect('navigation')

    user = request.user
    user_groups = set(user.groups.values_list('name', flat=True))

    # Build queryset for today's scheduled classes
    if 'student' in user_groups:
        enrollment = course_enrollment.objects.filter(student=user).select_related('term').first()
        if not enrollment or not enrollment.term:
            messages.info(request, "You are not enrolled in any active term.")
            return redirect('navigation')
        today_classes = class_session.objects.filter(
            term=enrollment.term,
            date=today,
            status='scheduled',
            session__day_of_week=today_day,
        ).select_related('session__facility', 'subject_component__subject')
    elif 'lecturer' in user_groups:
        today_classes = class_session.objects.filter(
            lecturer=user,
            date=today,
            status='scheduled',
            session__day_of_week=today_day,
        ).select_related('session__facility', 'subject_component__subject', 'term')
    else:
        messages.info(request, "Navigate to Classroom is only available for students and lecturers.")
        return redirect('navigation')

    # Find current class (in progress, including late) or next upcoming class
    current_class = None
    next_class = None

    for cs in today_classes.order_by('session__start_time'):
        s = cs.session
        if s.start_time <= current_time <= s.end_time:
            # Class is currently in progress (user may be on time or late)
            current_class = cs
        elif s.start_time > current_time:
            if next_class is None:
                next_class = cs

    target_class = current_class or next_class

    if not target_class:
        messages.info(request, "No more classes scheduled for today.")
        return redirect('navigation')

    facility_name = target_class.session.facility.facility_name
    subject_name = target_class.subject_component.subject.subject_name
    start_time = target_class.session.start_time.strftime('%H:%M')
    end_time = target_class.session.end_time.strftime('%H:%M')
    term_name = str(target_class.term) if target_class.term else ''

    s = target_class.session
    is_current = s.start_time <= current_time <= s.end_time

    from urllib.parse import urlencode
    url_params = {
        'destination': facility_name,
        'subject': subject_name,
        'start_time': start_time,
        'end_time': end_time,
        'is_current': '1' if is_current else '0',
    }
    if 'lecturer' in user_groups and term_name:
        url_params['term'] = term_name
    params = urlencode(url_params)
    return redirect(f"{reverse('navigation')}?{params}")

@role_required(allowed_roles=['admin'])
def editmap(request): 
    return render(request, "editmap.html")

def save_map(request):
    """Save map nodes and edges to database"""
    if request.method != 'POST':
        return JsonResponse({"error": "POST required"}, status=400)
    
    try:
        data = json.loads(request.body)
        nodes_data = data.get('nodes', [])
        edges_data = data.get('edges', [])
        image_data = data.get('image_data', None)
        
        # Save new map image if provided
        if image_data:
            try:
                import base64
                from io import BytesIO
                
                # Remove data URL prefix (data:image/png;base64,)
                if 'base64,' in image_data:
                    image_data = image_data.split('base64,')[1]
                
                # Decode base64 image
                image_bytes = base64.b64decode(image_data)
                
                # Delete old map images
                static_dir = os.path.join(settings.BASE_DIR, 'campus', 'static', 'myapp', 'images')
                os.makedirs(static_dir, exist_ok=True)
                
                old_extensions = ['png', 'jpg', 'jpeg', 'svg']
                for ext in old_extensions:
                    old_file = os.path.join(static_dir, f'campus-map.{ext}')
                    if os.path.exists(old_file):
                        try:
                            os.remove(old_file)
                        except Exception as e:
                            print(f"Warning: Could not delete old file {old_file}: {e}")
                
                # Save new image
                file_path = os.path.join(static_dir, 'campus-map.png')
                with open(file_path, 'wb') as f:
                    f.write(image_bytes)
                    
            except Exception as e:
                return JsonResponse({"error": f"Failed to save image: {str(e)}"}, status=400)
        
        with transaction.atomic():
            # Clear existing data
            MapNode.objects.all().delete()
            MapEdge.objects.all().delete()
            
            # Create new nodes
            nodes_map = {}
            for node in nodes_data:
                map_node = MapNode.objects.create(
                    node_id=node['node_id'],
                    name=node.get('name', ''),
                    node_type=node.get('node_type', 'terminal'),
                    x=node['x'],
                    y=node['y']
                )
                nodes_map[node['node_id']] = map_node
            
            # Create edges
            for edge in edges_data:
                from_node = nodes_map.get(edge['from'])
                to_node = nodes_map.get(edge['to'])
                
                if from_node and to_node:
                    MapEdge.objects.create(
                        from_node=from_node,
                        to_node=to_node
                    )
        
        message = "Map saved successfully!"
        if image_data:
            message = "Map and image saved successfully!"
        
        record_admin_action(
            user_id=request.user.id,
            content_type_id=ContentType.objects.get_for_model(MapNode).pk,
            object_id=0,
            object_repr="Campus Map",
            action_flag=CHANGE,
            message=f"Updated campus map: {len(nodes_data)} node(s), {len(edges_data)} edge(s){' + new image' if image_data else ''}"
        )
        
        return JsonResponse({"message": message})
    except Exception as e:
        return JsonResponse({"error": str(e)}, status=400)

def upload_map_image(request):
    """Upload and save a new campus map image"""
    if request.method != 'POST':
        return JsonResponse({"error": "POST required"}, status=400)
    
    if not request.FILES.get('image'):
        return JsonResponse({"error": "No image file provided"}, status=400)
    
    try:
        image_file = request.FILES['image']
        
        # Validate file type
        allowed_types = ['image/png', 'image/jpeg', 'image/jpg', 'image/svg+xml']
        if image_file.content_type not in allowed_types:
            return JsonResponse({
                "error": "Invalid file type. Only PNG, JPG, and SVG are allowed."
            }, status=400)
        
        # Save the file
        static_dir = os.path.join(settings.BASE_DIR, 'campus', 'static', 'myapp', 'images')
        os.makedirs(static_dir, exist_ok=True)
        
        # Delete old map images before saving the new one
        old_extensions = ['png', 'jpg', 'jpeg', 'svg']
        for ext in old_extensions:
            old_file = os.path.join(static_dir, f'campus-map.{ext}')
            if os.path.exists(old_file):
                try:
                    os.remove(old_file)
                except Exception as e:
                    print(f"Warning: Could not delete old file {old_file}: {e}")
        
        # Always save as campus-map.png (since cropped images are PNG)
        file_path = os.path.join(static_dir, 'campus-map.png')
        
        # Write the file
        with open(file_path, 'wb+') as destination:
            for chunk in image_file.chunks():
                destination.write(chunk)
        
        # Return success with the new image URL
        from django.templatetags.static import static
        image_url = static('myapp/images/campus-map.png')
        
        return JsonResponse({
            "success": True,
            "message": "Map image uploaded successfully!",
            "image_url": image_url
        })
        
    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)
    
def point_of_interest(request):
    return render(request, "point_of_interest.html")


def point_of_interest_data(request):
    """Return JSON structure of categories and images."""
    data_path = os.path.join(settings.BASE_DIR, 'campus', 'poi_data.json')
    if not os.path.exists(data_path):
        # try to create a default structure
        default = {
            "centrepoint": {"label": "CENTREPOINT & ATRIUM", "images": [f"centrepoint-{i+1}" for i in range(8)]},
            "auditoriums": {"label": "AUDITORIUMS", "images": [f"auditoriums-{i+1}" for i in range(8)]},
            "classrooms": {"label": "CLASSROOMS", "images": [f"classrooms-{i+1}" for i in range(8)]},
            "itlabs": {"label": "IT LABS", "images": [f"itlabs-{i+1}" for i in range(8)]},
            "library": {"label": "LIBRARY", "images": [f"library-{i+1}" for i in range(8)]},
            "cafeteria": {"label": "CAFETERIA", "images": [f"cafeteria-{i+1}" for i in range(8)]}
        }
        try:
            with open(data_path, 'w') as f:
                json.dump(default, f, indent=2)
        except Exception:
            pass
        return JsonResponse(default)

    try:
        with open(data_path, 'r') as f:
            data = json.load(f)
        return JsonResponse(data)
    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)


@login_required
def point_of_interest_save(request):
    """Save modified poi_data.json (admin-only)."""
    if not request.user.is_staff:
        return JsonResponse({"error": "forbidden"}, status=403)

    if request.method != 'POST':
        return JsonResponse({"error": "POST required"}, status=405)

    data_path = os.path.join(settings.BASE_DIR, 'campus', 'poi_data.json')
    try:
        payload = json.loads(request.body.decode('utf-8'))
        # basic validation: must be a dict of category-> {label, images}
        if not isinstance(payload, dict):
            return JsonResponse({"error": "invalid payload"}, status=400)
        # write file
        with open(data_path, 'w') as f:
            json.dump(payload, f, indent=2)
        
        record_admin_action(
            user_id=request.user.id,
            content_type_id=ContentType.objects.get_for_model(User).pk,
            object_id=0,
            object_repr="Point of Interest Data",
            action_flag=CHANGE,
            message="Updated point of interest categories/images"
        )
        
        return JsonResponse({"status": "ok"})
    except Exception as e:
        return JsonResponse({"error": str(e)}, status=400)


@login_required
def point_of_interest_upload(request):
    """Receive an uploaded image file (multipart/form-data) and store it under media/poi/. Returns JSON with `url`."""
    if not request.user.is_staff:
        return JsonResponse({"error": "forbidden"}, status=403)

    if request.method != 'POST':
        return JsonResponse({"error": "POST required"}, status=405)

    upload = request.FILES.get('file')
    if not upload:
        return JsonResponse({"error": "no file"}, status=400)

    media_root = getattr(settings, 'MEDIA_ROOT', os.path.join(settings.BASE_DIR, 'media'))
    media_url = getattr(settings, 'MEDIA_URL', '/media/')
    save_dir = os.path.join(media_root, 'poi')
    os.makedirs(save_dir, exist_ok=True)

    # create unique filename
    orig = upload.name
    ext = os.path.splitext(orig)[1] or '.jpg'
    filename = f"{uuid.uuid4().hex}{ext}"
    path = os.path.join(save_dir, filename)

    try:
        with open(path, 'wb') as f:
            for chunk in upload.chunks():
                f.write(chunk)
        url = os.path.join(media_url, 'poi', filename).replace('\\', '/')
        
        record_admin_action(
            user_id=request.user.id,
            content_type_id=ContentType.objects.get_for_model(User).pk,
            object_id=0,
            object_repr="POI Image Upload",
            action_flag=ADDITION,
            message=f"Uploaded POI image: {orig}"
        )
        
        return JsonResponse({"url": url})
    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)

#FAQ function
@role_required(allowed_roles=['admin', 'lecturer', 'student'])
def support_center(request):
    return render(request, 'help/support_center.html')

@role_required(allowed_roles=['lecturer', 'student'])
def smart_assistant(request):
    return render(request, 'help/smart_assistant.html')

def check_and_notify_expired():
    expiry_threshold = timezone.now() - timedelta(days=7)
    stale_tickets = SupportTicket.objects.filter(
        status='open', 
        created_at__lt=expiry_threshold
    )
    superusers = User.objects.filter(is_superuser=True)

    if stale_tickets.exists():
        for ticket in stale_tickets:
            ticket.status = 'expired'
            ticket.save()  

            try:
                recipient1 = ticket.created_by
                template = 'ticket_expired.html'
                context = {
                    "first_name": recipient1.first_name or recipient1.username,
                    "ticket_title": ticket.title,
                    "ticketId": ticket.id,
                    "ticket_status": ticket.status,
                }
                
                subject = f"Your support ticket - #T{ticket.id} has expired"

                if recipient1 and recipient1.email:
                    send_ticket_update_email(recipient1, subject, ticket, context, template)
                
                if(superusers):
                    template3 = 'ticket_expired.html'
                    user_name = f"{ticket.created_by.first_name} {ticket.created_by.last_name}".strip()
                    context3 = {
                        "user_name": user_name,
                        "ticket_title": ticket.title,
                        "ticketId": ticket.id,
                    }
                    
                    subject = f"Feedback Ticket has expired - #T{ticket.id}"

                    for admin in superusers:
                        if admin.email:
                            send_ticket_update_email(admin, subject, ticket, context3, template3)

            except Exception as e:
                print(f"SMTP Error: {e}")  

@role_required(allowed_roles=['admin', 'lecturer', 'student'])
def feedbacks(request):
    check_and_notify_expired()
            
    sort_by = '-created_at'
    tickets = SupportTicket.objects.all().order_by(sort_by)
    categories = SupportTicket.CATEGORY_CHOICES
    status = SupportTicket.STATUS_CHOICES

    if request.user.groups.filter(name='admin').exists():
        query = Q(assigned_to=request.user)
    else:
        query = Q(created_by=request.user)
    my_tickets = tickets.filter(query).distinct()

    category_counts = dict(SupportTicket.objects.values_list('category').annotate(total=Count('id')))

    status_counts = dict(SupportTicket.objects.values_list('status').annotate(total=Count('id')))

    my_category_counts = dict(
        SupportTicket.objects.filter(query)
            .values_list('category')
            .annotate(total=Count('id'))
    )

    my_status_counts = dict(
        SupportTicket.objects.filter(query)
            .values_list('status')
            .annotate(total=Count('id'))
    )

    context = {
        'tickets': tickets,
        'categories': categories,
        'status': status,
        'my_tickets': my_tickets,
        'category_counts': category_counts,
        'status_counts': status_counts,
        'my_category_counts': my_category_counts,
        'my_status_counts': my_status_counts 
    }

    return render(request, "help/ticket_list.html", context)

@role_required(allowed_roles=['lecturer', 'student'])
@transaction.atomic
def submit_feedback(request): 
    if request.method == 'POST':
        form = SupportTicketForm(request.POST, request.FILES)
        if form.is_valid():
            ticket = form.save(commit=False)
            ticket.created_by = request.user
            ticket.save()

            extract_and_save_images(ticket)

            files = request.FILES.getlist('extra_attachments')
            for f in files:
                save_manual_attachment(ticket, f)

            messages.success(request, "Ticket Submit Successfully")
            return redirect('review_feedback', ticket_id=ticket.id)
    else:
        form = SupportTicketForm()
    
    context = {"form" : form,}
    
    return render(request, "help/submit_feedback.html", context)

@login_required
@transaction.atomic
def review_feedback(request, ticket_id): 
    ticket = get_object_or_404(SupportTicket, id=ticket_id)
    activities = ticket.activities.all().order_by('timestamp')

    if request.method == "POST" and request.headers.get('x-requested-with') == 'XMLHttpRequest':
        content = request.POST.get('content', '').strip()
        
        if content and content != "<p><br></p>":
            message = TicketMessage.objects.create(
                ticket=ticket,
                sender=request.user,
                content=content,
                is_admin_reply=request.user.groups.filter(name='admin').exists()
            )
            
            cluster = {
                'is_self': True,
                'messages': [message],
            }

            html = render_to_string('partials/messages.html', {
                'cluster': cluster,
            })

            return JsonResponse({'status': 'success', 'html': html})
        
        return JsonResponse({'status': 'error', 'message': 'Invalid content'}, status=400)

    is_admin = request.user.groups.filter(name='admin').exists()

    if not is_admin and ticket.created_by != request.user:
        raise PermissionDenied("You do not have permission to view this ticket.")
    
    raw_messages = ticket.messages.all().order_by('sent_at').prefetch_related('all_attachments')
    grouped_messages = []

    if raw_messages.exists():
        current_cluster = {
            'sender': raw_messages[0].sender,
            'is_admin': raw_messages[0].is_admin_reply,
            'is_self': raw_messages[0].sender == request.user,
            'messages': [raw_messages[0]],
            'last_sent': raw_messages[0].sent_at
        }

        for i in range(1, len(raw_messages)):
            msg = raw_messages[i]
            prev_msg = raw_messages[i-1]
            
            time_diff = msg.sent_at - prev_msg.sent_at
            
            if msg.sender == current_cluster['sender'] and time_diff < timedelta(minutes=10):
                current_cluster['messages'].append(msg)
                current_cluster['last_sent'] = msg.sent_at
            else:
                grouped_messages.append(current_cluster)
                current_cluster = {
                    'sender': msg.sender,
                    'is_admin': msg.is_admin_reply,
                    'is_self': msg.sender == request.user,
                    'messages': [msg],
                    'last_sent': msg.sent_at
                }
        grouped_messages.append(current_cluster)

    has_escalated = activities.filter(action='escalation').exists()
    has_closure_request = activities.filter(
            action='closure_request'
        ).exclude(
            new_value='rejected'
        ).exclude(
            new_value='accepted'
        ).exists()
    
    context = {
        "ticket": ticket,
        "grouped_messages": grouped_messages,
        "ticket_attachments": ticket.all_attachments.all(),
        'is_admin': is_admin,
        'activities': activities,
        'has_escalated': has_escalated,
        'has_closure_request': has_closure_request,
    }

    return render(request, "help/review_feedback.html", context)

def send_ticket_update_email(recipient, sub, ticket, context, template):
    subject = sub
    from_email = settings.DEFAULT_FROM_EMAIL
    
    ticket_url = f"http://localhost:8000/support/tickets/{ticket.id}/"

    context['ticket_URL'] = ticket_url

    html_content = render_to_string(f"emails/{template}", context)
    text_content = strip_tags(html_content) 

    msg = EmailMultiAlternatives(subject, text_content, from_email, [recipient.email])
    msg.attach_alternative(html_content, "text/html")
    msg.send()

@role_required(allowed_roles=['admin'])
@transaction.atomic
def take_ownership(request, ticket_id):
    if request.method == 'POST':
        ticket = get_object_or_404(SupportTicket, id=ticket_id)
        
        if ticket.assigned_to:
            return JsonResponse({'status': 'error', 'message': 'Ticket already assigned'}, status=400)
        
        ticket.assigned_to = request.user
        ticket.status = 'in_progress'
        ticket.save()

        TicketActivity.objects.create(
            ticket=ticket,
            user=request.user,
            action='status_change',
            old_value='Open',
            new_value='In Pprogress'
        )

        recipient = ticket.created_by

        try:
            template = 'ticket_update.html'
            context = {
                "first_name": recipient.first_name or recipient.username,
                "ticket_title": ticket.title,
                "ticketId": ticket.id,
                "ticket_status": ticket.status
            }
            subject = f"Update on your support ticket #T{ticket.id}"
            if recipient and recipient.email:
                send_ticket_update_email(recipient, subject, ticket, context, template)

        except Exception as e:
                print(f"SMTP Error: {e}")
                
        messages.success(request, "You have successfully taken ownership of this support ticket")
        return JsonResponse({'status': 'success'})
    return JsonResponse({'status': 'error'}, status=405)

@login_required
def ticket_list_ajax(request):
    check_and_notify_expired()
    sort_by = request.GET.get('sort', '-created_at')
    categories = request.GET.getlist('category')
    statuses = request.GET.getlist('status')
    table_type = request.GET.get('table', 'available')

    if table_type == 'my':
        if request.user.groups.filter(name='admin').exists():
            query = Q(assigned_to=request.user)
        else:
            query = Q(created_by=request.user)
        tickets = SupportTicket.objects.filter(query)

    else: tickets = SupportTicket.objects.all()

    if categories: 
        tickets = tickets.filter(category__in= categories)
    if statuses: 
        tickets = tickets.filter(status__in=statuses)

    tickets = tickets.order_by(sort_by)
    
    context = {
        'tickets': tickets,
        'show_action': (table_type == 'available'),
        'show_status': (request.user.is_superuser if table_type == 'available' else True)
    }
    
    return render(request, "partials/ticket_list_partials.html", context)

@login_required
@transaction.atomic
def post_reply_ajax(request, ticket_id):
    if request.method == "POST":
        ticket = get_object_or_404(SupportTicket, id=ticket_id)
        content = request.POST.get('content', '').strip()

        if content:
            soup = BeautifulSoup(content, 'html.parser')
            for p in soup.find_all('p'):
                if not p.get_text(strip=True) and not p.find_all(recursive=False):
                    p.decompose()
                elif p.get_text(strip=True) == "" and p.find('br'):
                    p.decompose()
            
            content = str(soup)
        
        files = request.FILES.getlist('attachments')

        if (not content or content == "<p><br></p>") and not files:
            return JsonResponse({"status": "error", "message": "Empty content"}, status=400)

        is_admin = request.user.groups.filter(name='admin').exists()

        message = TicketMessage.objects.create(
            ticket=ticket,
            sender=request.user,
            content=content,
            is_admin_reply=is_admin
        )

        recipient = None
        
        if ticket.assigned_to:
            if ticket.assigned_to == request.user:
                recipient = ticket.created_by
            else:
                recipient = ticket.assigned_to

        try:
            if is_admin:
                template = 'ticket_reply_admin.html'
                full_name = f"{recipient.first_name} {recipient.last_name}".strip()
                context = {
                    "sender_name": full_name or recipient.username,
                    "ticket_title": ticket.title,
                    "ticketId": ticket.id,
                }
            else: 
                template = 'ticket_reply.html'
                context = {
                    "first_name": recipient.first_name or recipient.username,
                    "ticket_title": ticket.title,
                    "ticketId": ticket.id,
                }
            
            subject = f"Update on your Ticket: {ticket.title}"

            if recipient and recipient.email:
                send_ticket_update_email(recipient, subject, ticket, context, template)

        except Exception as e:
                print(f"SMTP Error: {e}")

        for f in files:
            save_manual_attachment(message, f)

        extract_and_save_images(message)

        cluster_data = {
            'is_self': True,
            'messages': [message],
        }

        cluster_html = render_to_string('partials/messages.html', {
            'cluster': cluster_data,
            'just_now': True
        })

        bubble_html = render_to_string('partials/single_bubble.html', {
            'msg': message,
            'just_now': True
        })

        return JsonResponse({
            'status': 'success',
            'cluster_html': cluster_html,  
            'bubble_html': bubble_html
        })
    
    return JsonResponse({"status": "error"}, status=400)

def sync_messages(request, ticket_id):
    ticket = get_object_or_404(SupportTicket, id=ticket_id)

    last_msg_id = request.GET.get('last_msg_id', 0)
    last_act_id = request.GET.get('last_act_id', 0)
    client_status = request.GET.get('current_status')

    should_reload = False
    if client_status and ticket.status != client_status:
        should_reload = True

    new_messages = TicketMessage.objects.filter(
        ticket=ticket, id__gt=last_msg_id
    ).exclude(sender=request.user).order_by('id')

    new_activities = TicketActivity.objects.filter(
        ticket=ticket, id__gt=last_act_id
    ).exclude(user=request.user).order_by('id')

    sync_data = []

    activities_html = None
    for msg in new_messages:
        cluster_html = render_to_string('partials/messages.html', {
            'cluster': {
                'is_self': False, 
                'is_admin': msg.is_admin_reply,
                'messages': [msg],
            },
            'just_now': True
        })
        bubble_html = render_to_string('partials/single_bubble.html', {
            'msg': msg,
            'just_now': True
        })
        
        sync_data.append({
            'id': msg.id,
            'sender_id': msg.sender.id,
            'is_admin_reply': msg.is_admin_reply,
            'timestamp': msg.sent_at.isoformat(),
            'cluster_html': cluster_html,
            'bubble_html': bubble_html
        })

    activities_html = None
    if new_activities.exists():
        activities_html = render_to_string('partials/system_activity_partials.html', {
            'activities': new_activities
        })

    return JsonResponse({
        'should_reload': False,
        'new_messages': sync_data,
        'activities_html': activities_html,
        'new_msg_id': new_messages.last().id if new_messages.exists() else last_msg_id,
        'new_act_id': new_activities.last().id if new_activities.exists() else last_act_id,
    })


@login_required
@transaction.atomic
def ticket_action_ajax(request, ticket_id):
    if request.method == "POST":
        ticket = get_object_or_404(SupportTicket, id=ticket_id)
        action_type = request.POST.get('action')
        
        old_status = ticket.get_status_display()
        
        if action_type == 'escalate':
            TicketActivity.objects.create(
                ticket=ticket,
                user=request.user,
                action='escalation',
            )

            if ticket.assigned_to:
                recipient = ticket.assigned_to
                    
                try:
                    template = 'ticket_escalated.html'
                    context = {
                        "ticket_title": ticket.title,
                        "ticketId": ticket.id,
                    }
                    
                    subject = f"Ticket Escalated by User - #T{ticket.id}"

                    if recipient and recipient.email:
                        send_ticket_update_email(recipient, subject, ticket, context, template)

                except Exception as e:
                        print(f"SMTP Error: {e}")
                        

            messages.success(request, "Escalation request sent successfully!")
            return JsonResponse({"status": "success", "message": "Escalation request sent successfully."})

        elif action_type == 'close':
            if request.user.groups.filter(name='admin').exists():
                ticket.status = 'closed'
                ticket.save()

                activity_id = request.POST.get('activity_id')
                if activity_id:
                    activity = get_object_or_404(TicketActivity, id=activity_id)
                    activity.new_value = 'accepted'
                    activity.save()

                TicketActivity.objects.create(
                    ticket=ticket,
                    user=request.user,
                    action='status_change',
                    old_value=old_status,
                    new_value='Closed',
                )
            else:
                TicketActivity.objects.create(
                    ticket=ticket,
                    user=request.user,
                    action='closure_request',
                )
            recipient = None  

            try:
                if ticket.assigned_to:
                    recipient = ticket.assigned_to
                    template = 'ticket_request_close.html'
                    context = {
                        "ticket_title": ticket.title,
                        "ticketId": ticket.id,
                    }
                    
                    subject = f"User Requested Ticket Closure - #T{ticket.id}"

                    if recipient and recipient.email:
                        send_ticket_update_email(recipient, subject, ticket, context, template)

                if ticket.status == 'closed':
                    recipient = ticket.created_by
                    template = 'ticket_update.html'
                    context = {
                        "first_name": recipient.first_name or recipient.username,
                        "ticket_title": ticket.title,
                        "ticketId": ticket.id,
                        "ticket_status": ticket.status,
                    }
                    
                    subject = f"Update on your support ticket - #T{ticket.id}"

                    if recipient and recipient.email:
                        send_ticket_update_email(recipient, subject, ticket, context, template)
                    
            except Exception as e:
                    print(f"SMTP Error: {e}")

            if request.user.groups.filter(name="admin").exists():
                messages.success(request, "Ticket has been closed!")
                return JsonResponse({"status": "success", "message": "Ticket has been closed."})
            else:
                messages.success(request, "Close ticket request has been sent!")
                return JsonResponse({"status": "success", "message": "Close ticket request has been sent."})
            
        elif action_type == 'rejected_closure':
            activity_id = request.POST.get('activity_id')
            if not activity_id:
                return JsonResponse({"status": "error", "message": "Activity ID is missing."}, status=400)
            activity = get_object_or_404(TicketActivity, id=activity_id)

            activity.new_value = 'rejected'
            activity.save()
        
            TicketActivity.objects.create(
                ticket=ticket,
                user=request.user,
                action='rejected_closure',
            )
            
            try:
                recipient = ticket.created_by
                template = 'ticket_request_close_rejected.html'
                admin_name = request.user.get_full_name() or request.user.username

                context = {
                    "first_name": recipient.first_name or recipient.username,
                    "ticket_title": ticket.title,
                    "ticketId": ticket.id,
                    "admin_name": admin_name,
                }
                
                subject = f"Ticket Closure Request on - #T{ticket.id} has been Rejected"

                if recipient and recipient.email:
                    send_ticket_update_email(recipient, subject, ticket, context, template)

            except Exception as e:
                    print(f"SMTP Error: {e}")
            

            messages.success(request, "Ticket closure request has been rejected.")
            return JsonResponse({"status": "success", "message": "Ticket closure request has been rejected."})

        elif action_type == 'resolved':
            ticket.status = 'resolved'
            ticket.save()
            
            TicketActivity.objects.create(
                ticket=ticket,
                user=request.user,
                action='status_change',
                old_value=old_status,
                new_value='Resolved',
            )
  
            try:
                recipient = ticket.created_by
                template = 'ticket_resolved.html'
                context = {
                    "first_name": recipient.first_name or recipient.username,
                    "ticket_title": ticket.title,
                    "ticketId": ticket.id,
                }
                
                subject = f"Your Ticket Has Been Marked as Resolved - #T{ticket.id}"

                if recipient and recipient.email:
                    send_ticket_update_email(recipient, subject, ticket, context, template)


                if ticket.assigned_to:
                    recipient = ticket.assigned_to
                    template = 'ticket_resolved_admin.html'
                    context = {
                        "ticket_title": ticket.title,
                        "ticketId": ticket.id,
                    }
                    
                    subject = f"Ticket Marked as Resolved by User - #T{ticket.id}"

                    if recipient and recipient.email:
                        send_ticket_update_email(recipient, subject, ticket, context, template)

            except Exception as e:
                        print(f"SMTP Error: {e}")

            messages.success(request, "Ticket has been marked as resolved.")
            return JsonResponse({"status": "success", "message": "Ticket has been resolved."})

    return JsonResponse({"status": "error", "message": "Invalid request"}, status=400)

@role_required(allowed_roles=['admin'])
@transaction.atomic
def edit_faq(request, slug=None): 
    instance = None
    if slug:
        instance = get_object_or_404(faq, slug=slug)


    if request.method == "POST":
        print(request.POST)
        form = newFAQForm(request.POST, instance=instance)
        
        if form.is_valid():
            faq_obj = form.save(commit=False)

            if not instance:
                faq_obj.author = request.user.admin_profile
            faq_obj.save()
            
            soup = BeautifulSoup(faq_obj.content, 'html.parser')
            images = soup.find_all('img')
            images_processed = False

            for img in images: 
                src = img.get('src', '')

                if src.startswith('data:image'):
                    try: 
                        format, imgstr = src.split(';base64,')
                        ext = format.split('/')[-1]
                        
                        # Create a unique filename for the media folder
                        filename = f"faq_{faq_obj.id}_{uuid.uuid4().hex[:8]}.{ext}"
                        data = ContentFile(base64.b64decode(imgstr), name=filename)

                        # 3. Create record in your attachments model
                        new_attachment = attachments.objects.create(
                            content_type=ContentType.objects.get_for_model(faq_obj),
                            object_id=faq_obj.id,
                            file=data
                        )

                        # 4. Replace the Base64 source with the new media URL
                        img['src'] = new_attachment.file.url
                        images_processed = True
                    except Exception as e:
                        print(f"Error processing image: {e}")
                        continue
            
            if images_processed:
                faq_obj.content = str(soup)
                faq_obj.save()

            messages.success(request, "FAQ saved successfully!")
            return redirect('viewFAQ')
        else:
            messages.error(request, "There was an error saving the FAQ. Please check all the fields")
            print(form.errors)
    else:
        form = newFAQForm(instance=instance)
        
    context = {
        'form': form,
        'faqInfo': instance
    }

    return render(request, "help/edit_faq.html", context)

def faq_suggestions(request):
    query = request.GET.get('q', '').strip()
    category = request.GET.get('cat', '').strip()
    queryset = faq.objects.all()

    if request.user.is_superuser:
        pass
    elif not request.user.is_authenticated:
        queryset = queryset.filter(is_visitor_visible=True)
    else:
        user_groups = request.user.groups.values_list('name', flat=True)
        
        role_query = Q(is_visitor_visible=True) 
        
        if "admin" in user_groups:
            role_query |= Q(is_ad_visible=True)
        if "lecturer" in user_groups:
            role_query |= Q(is_lc_visible=True)
        if "student" in user_groups:
            role_query |= Q(is_tp_visible=True)
            
        queryset = queryset.filter(role_query).distinct()
    
    if category:
        queryset = queryset.filter(category=category)

    if query:
        words = query.split()
        q_objects = Q()
        
        for word in words:
            q_objects |= Q(title__icontains=word)
            
        results = faq.objects.filter(q_objects)[:5]
        suggestions = [
            {
                'title': item.title,
                'category': item.get_category_display(), 
                'slug': item.slug
            } for item in results
        ]
    else: suggestions =[]

    return JsonResponse({
        'suggestions': suggestions
    })

@login_required
@require_POST
def faq_vote(request, slug):
    post = get_object_or_404(faq, slug=slug)

    try:
        payload = json.loads(request.body.decode('utf-8')) if request.body else {}
    except json.JSONDecodeError:
        return JsonResponse({'error': 'Invalid payload.'}, status=400)

    reaction_type = payload.get('reaction')
    if reaction_type not in {'like', 'dislike'}:
        return JsonResponse({'error': 'Invalid reaction type.'}, status=400)

    new_value = FAQReaction.LIKE if reaction_type == 'like' else FAQReaction.DISLIKE

    with transaction.atomic():
        reaction = FAQReaction.objects.select_for_update().filter(faq=post, user=request.user).first()

        if reaction is None:
            FAQReaction.objects.create(faq=post, user=request.user, value=new_value)
            if new_value == FAQReaction.LIKE:
                faq.objects.filter(pk=post.pk).update(n_likes=F('n_likes') + 1)
                user_reaction = 'like'
            else:
                faq.objects.filter(pk=post.pk).update(n_dislikes=F('n_dislikes') + 1)
                user_reaction = 'dislike'
        elif reaction.value == new_value:
            reaction.delete()
            if new_value == FAQReaction.LIKE:
                faq.objects.filter(pk=post.pk).update(n_likes=F('n_likes') - 1)
            else:
                faq.objects.filter(pk=post.pk).update(n_dislikes=F('n_dislikes') - 1)
            user_reaction = None
        else:
            old_value = reaction.value
            reaction.value = new_value
            reaction.save(update_fields=['value', 'updated_at'])

            if old_value == FAQReaction.LIKE:
                faq.objects.filter(pk=post.pk).update(
                    n_likes=F('n_likes') - 1,
                    n_dislikes=F('n_dislikes') + 1,
                )
            else:
                faq.objects.filter(pk=post.pk).update(
                    n_likes=F('n_likes') + 1,
                    n_dislikes=F('n_dislikes') - 1,
                )
            user_reaction = 'like' if new_value == FAQReaction.LIKE else 'dislike'

    post.refresh_from_db(fields=['n_likes', 'n_dislikes'])

    return JsonResponse({
        'ok': True,
        'n_likes': post.n_likes,
        'n_dislikes': post.n_dislikes,
        'user_reaction': user_reaction,
    })

@role_required(allowed_roles=['admin'])
@require_POST
def delete_faq(request, slug):
    try:
        post = get_object_or_404(faq, slug=slug)
        post.delete()
        messages.success(request, "FAQ deleted successfully!")
        return redirect('viewFAQ')
    except faq.DoesNotExist:
        messages.error(request, "This FAQ was already deleted or does not exist.")
        return redirect('viewFAQ')
    except DatabaseError:
        messages.error(request, "A database error occurred. Please try again later.")
    except Exception as e:
        messages.error(request, f"An unexpected error occurred: {str(e)}")
    
    return redirect('edit_existing_faq', slug=slug)

def faq_detail(request, slug):
    post = get_object_or_404(faq, slug=slug)

    # Count only explicit click-through visits from FAQ listing/search links.
    if request.GET.get('from_click') == '1':
        faq.objects.filter(pk=post.pk).update(view_count=F('view_count') + 1)
        return redirect('faq_detail', slug=slug)

    faq_content_type = ContentType.objects.get_for_model(faq)
    attachment_count = attachments.objects.filter(
        content_type=faq_content_type,
        object_id=post.id,
    ).count()

    inferred_count = _infer_attachment_count_from_content(post.content)
    attachment_count = max(attachment_count, inferred_count)

    author_name = str(post.author) if post.author else 'Anonymous'
    author_initial = author_name[0].upper() if author_name else 'A'
    user_reaction = None
    if request.user.is_authenticated:
        reaction = FAQReaction.objects.filter(faq=post, user=request.user).values_list('value', flat=True).first()
        if reaction == FAQReaction.LIKE:
            user_reaction = 'like'
        elif reaction == FAQReaction.DISLIKE:
            user_reaction = 'dislike'
    
    return render(request, 'help/faq_detail.html', {
        'post': post,
        'attachment_count': attachment_count,
        'author_name': author_name,
        'author_initial': author_initial,
        'user_reaction': user_reaction,
    })

def _infer_attachment_count_from_content(html_content):
    if not html_content:
        return 0

    soup = BeautifulSoup(html_content, 'html.parser')
    image_count = len(soup.find_all('img'))

    linked_attachment_count = 0
    for link in soup.find_all('a', href=True):
        href = (link.get('href') or '').lower()
        if '/media/attachments/' in href:
            linked_attachment_count += 1

    return image_count + linked_attachment_count

def _attach_faq_attachment_counts(faq_items):
    items = list(faq_items)
    if not items:
        return items

    faq_content_type = ContentType.objects.get_for_model(faq)
    faq_ids = [item.id for item in items]

    counts = (
        attachments.objects
        .filter(content_type=faq_content_type, object_id__in=faq_ids)
        .values('object_id')
        .annotate(total=Count('id'))
    )
    count_map = {row['object_id']: row['total'] for row in counts}

    for item in items:
        db_count = count_map.get(item.id, 0)
        inferred_count = _infer_attachment_count_from_content(item.content)
        item.attachment_count = max(db_count, inferred_count)

    return items

def viewFAQ(request):
    categories = faq.CATEGORY_CHOICES

    queryset = faq.objects.all()

    if request.user.is_superuser:
        pass
    elif not request.user.is_authenticated:
        queryset = queryset.filter(is_visitor_visible=True)
    else:
        user_groups = request.user.groups.values_list('name', flat=True)

        role_query = Q(is_visitor_visible=True) 
        if "admin" in user_groups:
            role_query |= Q(is_ad_visible=True)
        if "lecturer" in user_groups:
            role_query |= Q(is_lc_visible=True)
        if "student" in user_groups:
            role_query |= Q(is_tp_visible=True)
        queryset = queryset.filter(role_query).distinct()
    
    most_viewed_faqs = _attach_faq_attachment_counts(queryset.order_by('-view_count')[:9])
    
    try:
        page = int(request.GET.get('page', 1))
    except (ValueError, TypeError):
        page = 1

    selected_cats = request.GET.getlist('category')
    main_list_qs = queryset.order_by('-published_time')


    if selected_cats:
        main_list_qs = main_list_qs.filter(category__in=selected_cats)

    limit = 9

    total_count = main_list_qs.count()
    max_pages = max(1, math.ceil(total_count / limit))
    start = (page - 1) * limit
    end = start + limit
    faqs = _attach_faq_attachment_counts(main_list_qs[start:end])

    if page > max_pages:
        page = max_pages
        start = (page - 1) * limit
        end = start + limit


    context = {
        'categories': categories,
        'faqs': faqs,
        'most_viewed': most_viewed_faqs,
        'current_page': page,
        'max_pages': max_pages,
        'show_pagination': total_count > limit
    }

    if request.headers.get('x-requested-with') == 'XMLHttpRequest':
        response = render(request, 'partials/faq_list.html', context)
        response['X-Max-Pages'] = max_pages
        return response

    return render(request, 'help/view_faq.html', context)

#extract and store image
def extract_and_save_images(instance):
    if hasattr(instance, 'content'):
        html_data = instance.content
        field_name = 'content'
    elif hasattr(instance, 'description'):
        html_data = instance.description
        field_name = 'description'
    else:
        return 

    if not html_data:
        return

    soup = BeautifulSoup(html_data, 'html.parser')
    images = soup.find_all('img')
    has_changed = False
    
    for img in images:
        src = img.get('src', '')
        if src.startswith('data:image'):
            try:
                format, imgstr = src.split(';base64,') 
                ext = format.split('/')[-1] 
                model_name = instance._meta.model_name 
                filename = f"{model_name}_{instance.id}_{timezone.now().strftime('%Y%m%d%H%M%S')}.{ext}"
                data = ContentFile(base64.b64decode(imgstr), name=filename)

                attachment = attachments.objects.create(
                    content_type=ContentType.objects.get_for_model(instance),
                    object_id=instance.id,
                    file=data
                )

                img['src'] = attachment.file.url
                has_changed = True
            except Exception as e:
                print(f"Error processing base64 image: {e}")

    if has_changed:
        setattr(instance, field_name, str(soup))
        instance.save(update_fields=[field_name])

def save_manual_attachment(instance, file_obj):
    pk_value=instance.pk

    original_name = file_obj.name
    _, ext = os.path.splitext(original_name)
    
    model_name = instance._meta.model_name
    timestamp = timezone.now().strftime('%Y%m%d%H%M%S')
    new_filename = f"{model_name}_{pk_value}_{timestamp}{ext}"

    file_obj.name = new_filename

    return attachments.objects.create(
        content_type=ContentType.objects.get_for_model(instance),
        object_id=pk_value,
        file=file_obj
    )

#Facility Email Ticket
@role_required(allowed_roles=['admin'])
def config_bot(request): 
    return render(request, "help/config_bot.html")

@role_required(allowed_roles=['admin'])
def system_log(request): 
    return render(request, "help/system_log.html")

#Facility Booking
def facility_list(request):
    query = request.GET.get("q", "")
    facility_list = facilities.objects.all()

    if query:
        facility_list = facility_list.filter(
            Q(facility_name__icontains=query) |
            Q(type__icontains=query) |
            Q(building__icontains=query)
        )

    return render(request, "facility/facility_list.html", {
        "facilities": facility_list,
        "query": query
    })

def send_booking_update_email(recipient, sub, booking_obj, context, template):
    subject = sub
    from_email = settings.DEFAULT_FROM_EMAIL

    booking_url = "http://localhost:8000/facility/my/"
    context["booking_URL"] = booking_url

    html_content = render_to_string(f"emails/{template}", context)
    text_content = strip_tags(html_content)

    msg = EmailMultiAlternatives(subject, text_content, from_email, [recipient.email])
    msg.attach_alternative(html_content, "text/html")
    msg.send()

def booking_form(request, facility_id):
    facility = get_object_or_404(facilities, pk=facility_id)

    if request.method == "POST":
        booking_date = request.POST.get("date")
        start_time = request.POST.get("start_time")
        end_time = request.POST.get("end_time")
        purpose = request.POST.get("purpose")

        if start_time >= end_time:
            return render(request, "facility/booking_form.html", {"facility": facility, "error": "End time must be later than start time."})

        conflict = booking.objects.filter(
            facility=facility,
            booking_date=booking_date,
            start_time__lt=end_time,
            end_time__gt=start_time
        ).exclude(status="Cancelled").exists()

        if conflict:
            return render(request, "facility/booking_form.html", {
                "facility": facility,
                "error": "This facility is already booked for the selected time."
            })

        booking.objects.create(
            user=request.user,
            facility=facility,
            booking_date=booking_date,
            start_time=start_time,
            end_time=end_time,
            purpose=purpose,
            status="Pending"
        )

        messages.success(request, "Booking request submitted successfully! Waiting for admin approval.")
        return redirect("my_bookings")

    return render(request, "facility/booking_form.html", {"facility": facility})


def my_bookings(request):
    bookings = booking.objects.filter(user=request.user)
    return render(request, "facility/my_bookings.html", {"bookings": bookings})

@login_required
def cancel_booking(request, booking_id):
    selected_booking = get_object_or_404(booking, booking_id=booking_id, user=request.user)
    selected_booking.status = "Cancelled"
    selected_booking.save()

    messages.success(request, "Booking cancelled successfully!")
    return redirect("my_bookings")

def review_booking_request(request):
    bookings = booking.objects.all().order_by("-booking_date", "-start_time")

    booking_data = []

    for b in bookings:
        name = b.user.get_full_name() or b.user.username
        role = "User"
        code = "-"

        if hasattr(b.user, "student_profile"):
            role = "Student"
            code = b.user.student_profile.tp_id
        elif hasattr(b.user, "lecturer_profile"):
            role = "Lecturer"
            code = b.user.lecturer_profile.lc_id

        booking_data.append({
            "booking": b,
            "name": name,
            "role": role,
            "code": code,
        })

    return render(request, "facility/review_booking_request.html", {
        "booking_data": booking_data
    })

def approve_booking(request, booking_id):
    selected_booking = get_object_or_404(booking, booking_id=booking_id)
    selected_booking.status = "Approved"
    selected_booking.save()

    recipient = selected_booking.user

    try:
        template = "booking_update.html"
        context = {
            "first_name": recipient.first_name or recipient.username,
            "facility_name": selected_booking.facility.facility_name,
            "booking_date": selected_booking.booking_date,
            "start_time": selected_booking.start_time,
            "end_time": selected_booking.end_time,
            "booking_status": selected_booking.status,
        }
        subject = f"Your facility booking for {selected_booking.facility.facility_name} has been approved"

        if recipient and recipient.email:
            send_booking_update_email(recipient, subject, selected_booking, context, template)

    except Exception as e:
        print(f"SMTP Error: {e}")

    messages.success(request, "Booking approved successfully.")
    return redirect("review_booking_request")

def reject_booking(request, booking_id):
    selected_booking = get_object_or_404(booking, booking_id=booking_id)
    selected_booking.status = "Rejected"
    selected_booking.save()

    recipient = selected_booking.user

    try:
        template = "booking_update.html"
        context = {
            "first_name": recipient.first_name or recipient.username,
            "facility_name": selected_booking.facility.facility_name,
            "booking_date": selected_booking.booking_date,
            "start_time": selected_booking.start_time,
            "end_time": selected_booking.end_time,
            "booking_status": selected_booking.status,
        }
        subject = f"Your facility booking for {selected_booking.facility.facility_name} has been rejected"

        if recipient and recipient.email:
            send_booking_update_email(recipient, subject, selected_booking, context, template)

    except Exception as e:
        print(f"SMTP Error: {e}")

    messages.success(request, "Booking rejected successfully.")
    return redirect("review_booking_request")

#Facility Status
def facility_status(request):
    selected_date = request.GET.get("date")

    if not selected_date:
        selected_date = date.today().isoformat()

    all_facilities = facilities.objects.all()
    data = []

    for f in all_facilities:
        day_bookings = booking.objects.filter(
            facility=f,
            booking_date=selected_date,
            status="Approved"
        ).order_by("start_time")

        if day_bookings.exists():
            current_status = "Booked"
        else:
            current_status = "Available"

        data.append({
            "facility": f,
            "status": current_status,
            "bookings": day_bookings
        })

    return render(request, "facility/facility_status.html", {
        "data": data,
        "selected_date": selected_date
    })


# ============================================================
# COURSES MANAGEMENT MODULE
# ============================================================

@role_required(allowed_roles=['admin'])
def manage_courses(request):
    """Main courses management page — assign subjects to course semesters."""
    courses = course.objects.all().order_by('course_code')
    context = {
        'courses': courses,
    }
    return render(request, 'partials/manage_courses.html', context)


@role_required(allowed_roles=['admin'])
def get_course_subjects(request):
    """Get subjects assigned to a course for a given semester."""
    course_id = request.GET.get('course_id')
    semester = request.GET.get('semester')
    if not course_id or not semester:
        return JsonResponse({'error': 'course_id and semester required'}, status=400)

    course_obj = get_object_or_404(course, course_id=course_id)
    cs_entries = course_subject.objects.filter(
        course=course_obj,
        recommended_semester=int(semester)
    ).select_related('subject')

    assigned = []
    for cs in cs_entries:
        components = SubjectComponent.objects.filter(subject=cs.subject)
        comp_list = [{'type': c.class_type, 'hours_per_class': c.hours_per_class, 'total_hours': c.total_required_hours} for c in components]
        assigned.append({
            'cs_id': cs.id,
            'subject_id': cs.subject.subject_id,
            'subject_code': cs.subject.subject_code,
            'subject_name': cs.subject.subject_name,
            'semester': cs.recommended_semester,
            'components': comp_list,
        })

    return JsonResponse({
        'course_name': course_obj.course_name,
        'course_code': course_obj.course_code,
        'semester': int(semester),
        'total_semesters': course_obj.total_semester,
        'assigned': assigned,
    })


@role_required(allowed_roles=['admin'])
def get_available_subjects(request):
    """Get subjects NOT yet assigned to this course/semester."""
    course_id = request.GET.get('course_id')
    semester = request.GET.get('semester')
    if not course_id or not semester:
        return JsonResponse({'error': 'course_id and semester required'}, status=400)

    course_obj = get_object_or_404(course, course_id=course_id)
    already_assigned = course_subject.objects.filter(
        course=course_obj,
        recommended_semester=int(semester)
    ).values_list('subject_id', flat=True)

    available = subject.objects.exclude(subject_id__in=already_assigned).order_by('subject_code')
    result = []
    for s in available:
        components = SubjectComponent.objects.filter(subject=s)
        comp_list = [{'type': c.class_type, 'hours_per_class': c.hours_per_class, 'total_hours': c.total_required_hours} for c in components]
        result.append({
            'subject_id': s.subject_id,
            'subject_code': s.subject_code,
            'subject_name': s.subject_name,
            'components': comp_list,
        })

    return JsonResponse({'available': result})


@role_required(allowed_roles=['admin'])
@require_POST
def assign_subject_to_course(request):
    """Assign a subject to a course semester."""
    try:
        data = json.loads(request.body)
    except json.JSONDecodeError:
        return JsonResponse({'error': 'Invalid JSON'}, status=400)

    course_id = data.get('course_id')
    semester = data.get('semester')
    subject_id = data.get('subject_id')

    if not course_id or not semester or not subject_id:
        return JsonResponse({'error': 'course_id, semester and subject_id required'}, status=400)

    course_obj = get_object_or_404(course, course_id=course_id)
    subj = get_object_or_404(subject, subject_id=subject_id)

    # Check if already assigned
    if course_subject.objects.filter(course=course_obj, subject=subj, recommended_semester=int(semester)).exists():
        return JsonResponse({'error': f'{subj.subject_code} is already assigned to this course/semester.'}, status=400)

    course_subject.objects.create(
        course=course_obj,
        subject=subj,
        recommended_semester=int(semester)
    )

    record_admin_action(
        user_id=request.user.id,
        content_type_id=ContentType.objects.get_for_model(course_subject).pk,
        object_id=course_obj.course_id,
        object_repr=f"{course_obj.course_code} - Sem {semester}",
        action_flag=ADDITION,
        message=f"Assigned {subj.subject_code} to {course_obj.course_code} semester {semester}"
    )

    return JsonResponse({'success': True, 'message': f'{subj.subject_code} assigned successfully.'})


@role_required(allowed_roles=['admin'])
@require_POST
def remove_subject_from_course(request):
    """Remove a subject from a course semester."""
    try:
        data = json.loads(request.body)
    except json.JSONDecodeError:
        return JsonResponse({'error': 'Invalid JSON'}, status=400)

    cs_id = data.get('cs_id')
    if not cs_id:
        return JsonResponse({'error': 'cs_id required'}, status=400)

    cs_entry = get_object_or_404(course_subject, id=cs_id)
    code = cs_entry.subject.subject_code
    course_repr = f"{cs_entry.course.course_code} - Sem {cs_entry.recommended_semester}"

    record_admin_action(
        user_id=request.user.id,
        content_type_id=ContentType.objects.get_for_model(course_subject).pk,
        object_id=cs_entry.course_id,
        object_repr=course_repr,
        action_flag=DELETION,
        message=f"Removed {code} from {course_repr}"
    )

    cs_entry.delete()

    return JsonResponse({'success': True, 'message': f'{code} removed successfully.'})


# ============================================================
# SUBJECTS MANAGEMENT MODULE
# ============================================================

@role_required(allowed_roles=['admin'])
def manage_subjects(request):
    """Main subjects management page — create, edit, remove subjects."""
    subjects_list = subject.objects.prefetch_related('components').all().order_by('subject_code')
    context = {'subjects': subjects_list}
    return render(request, 'partials/manage_subjects.html', context)


@role_required(allowed_roles=['admin'])
def get_subject_detail(request):
    """Get a single subject with its components."""
    subject_id = request.GET.get('subject_id')
    if not subject_id:
        return JsonResponse({'error': 'subject_id required'}, status=400)

    subj = get_object_or_404(subject, subject_id=subject_id)
    components = SubjectComponent.objects.filter(subject=subj)
    comp_list = [{
        'component_id': c.component_id,
        'class_type': c.class_type,
        'hours_per_class': c.hours_per_class,
        'total_required_hours': c.total_required_hours,
    } for c in components]

    return JsonResponse({
        'subject_id': subj.subject_id,
        'subject_code': subj.subject_code,
        'subject_name': subj.subject_name,
        'components': comp_list,
    })


@role_required(allowed_roles=['admin'])
@require_POST
def create_subject(request):
    """Create a new subject with optional components."""
    try:
        data = json.loads(request.body)
    except json.JSONDecodeError:
        return JsonResponse({'error': 'Invalid JSON'}, status=400)

    code = data.get('subject_code', '').strip()
    name = data.get('subject_name', '').strip()
    components_data = data.get('components', [])

    if not code or not name:
        return JsonResponse({'error': 'Subject code and name are required.'}, status=400)

    if subject.objects.filter(subject_code=code).exists():
        return JsonResponse({'error': f'Subject code "{code}" already exists.'}, status=400)

    with transaction.atomic():
        subj = subject.objects.create(subject_code=code, subject_name=name)
        for comp in components_data:
            SubjectComponent.objects.create(
                subject=subj,
                class_type=comp.get('class_type', 'Lecture'),
                hours_per_class=comp.get('hours_per_class', 2),
                total_required_hours=comp.get('total_required_hours', 0),
            )

    record_admin_action(
        user_id=request.user.id,
        content_type_id=ContentType.objects.get_for_model(subject).pk,
        object_id=subj.subject_id,
        object_repr=f"{code} - {name}",
        action_flag=ADDITION,
        message=f"Created subject {code} with {len(components_data)} component(s)"
    )

    return JsonResponse({'success': True, 'message': f'Subject "{code}" created successfully.'})


@role_required(allowed_roles=['admin'])
@require_POST
def update_subject(request):
    """Update an existing subject and its components (preserving timetable links)."""
    try:
        data = json.loads(request.body)
    except json.JSONDecodeError:
        return JsonResponse({'error': 'Invalid JSON'}, status=400)

    subject_id = data.get('subject_id')
    code = data.get('subject_code', '').strip()
    name = data.get('subject_name', '').strip()
    components_data = data.get('components', [])

    if not subject_id or not code or not name:
        return JsonResponse({'error': 'subject_id, code, and name are required.'}, status=400)

    subj = get_object_or_404(subject, subject_id=subject_id)

    # Check for duplicate code (exclude current)
    if subject.objects.filter(subject_code=code).exclude(subject_id=subject_id).exists():
        return JsonResponse({'error': f'Subject code "{code}" already exists.'}, status=400)

    with transaction.atomic():
        subj.subject_code = code
        subj.subject_name = name
        subj.save()

        # Track which existing component IDs are kept
        incoming_ids = set()
        for comp in components_data:
            comp_id = comp.get('component_id')
            if comp_id:
                # Update existing component in-place
                try:
                    existing = SubjectComponent.objects.get(component_id=comp_id, subject=subj)
                    existing.class_type = comp.get('class_type', 'Lecture')
                    existing.hours_per_class = comp.get('hours_per_class', 2)
                    existing.total_required_hours = comp.get('total_required_hours', 0)
                    existing.save()
                    incoming_ids.add(comp_id)
                except SubjectComponent.DoesNotExist:
                    pass
            else:
                # Create new component
                new_comp = SubjectComponent.objects.create(
                    subject=subj,
                    class_type=comp.get('class_type', 'Lecture'),
                    hours_per_class=comp.get('hours_per_class', 2),
                    total_required_hours=comp.get('total_required_hours', 0),
                )
                incoming_ids.add(new_comp.component_id)

        # Only delete components that were removed AND have no timetable sessions
        removed = SubjectComponent.objects.filter(subject=subj).exclude(component_id__in=incoming_ids)
        has_sessions = removed.filter(class_session__isnull=False).distinct()
        if has_sessions.exists():
            # Keep components that have timetable sessions (don't cascade-delete them)
            safe_to_delete = removed.exclude(component_id__in=has_sessions.values_list('component_id', flat=True))
            safe_to_delete.delete()
        else:
            removed.delete()

    record_admin_action(
        user_id=request.user.id,
        content_type_id=ContentType.objects.get_for_model(subject).pk,
        object_id=subj.subject_id,
        object_repr=f"{code} - {name}",
        action_flag=CHANGE,
        message=f"Updated subject {code}"
    )

    return JsonResponse({'success': True, 'message': f'Subject "{code}" updated successfully.'})


@role_required(allowed_roles=['admin'])
def check_subject_usage(request):
    """Check if a subject has timetable sessions before deletion."""
    subject_id = request.GET.get('subject_id')
    if not subject_id:
        return JsonResponse({'error': 'subject_id required'}, status=400)

    subj = get_object_or_404(subject, subject_id=subject_id)
    session_count = class_session.objects.filter(subject_component__subject=subj).count()

    return JsonResponse({
        'subject_code': subj.subject_code,
        'subject_name': subj.subject_name,
        'timetable_sessions': session_count,
    })


@role_required(allowed_roles=['admin'])
@require_POST
def delete_subject(request):
    """Delete a subject and all related data."""
    try:
        data = json.loads(request.body)
    except json.JSONDecodeError:
        return JsonResponse({'error': 'Invalid JSON'}, status=400)

    subject_id = data.get('subject_id')
    if not subject_id:
        return JsonResponse({'error': 'subject_id required'}, status=400)

    subj = get_object_or_404(subject, subject_id=subject_id)
    code = subj.subject_code

    record_admin_action(
        user_id=request.user.id,
        content_type_id=ContentType.objects.get_for_model(subject).pk,
        object_id=subj.subject_id,
        object_repr=f"{code} - {subj.subject_name}",
        action_flag=DELETION,
        message=f"Deleted subject {code}"
    )

    subj.delete()

    return JsonResponse({'success': True, 'message': f'Subject "{code}" deleted successfully.'})


@role_required(allowed_roles=['admin'])
def manage_departments(request):
    """Main departments management page — manage lecturer subject qualifications."""
    depts = departments.objects.all().order_by('dept_code')
    context = {'departments': depts}
    return render(request, 'partials/manage_departments.html', context)


@role_required(allowed_roles=['admin'])
def get_department_lecturers(request):
    """Get lecturers in a department with their assigned subjects."""
    dept_id = request.GET.get('dept_id')
    if not dept_id:
        return JsonResponse({'error': 'dept_id required'}, status=400)

    dept_obj = get_object_or_404(departments, dept_id=dept_id)
    profiles = lecturer_profiles.objects.filter(dept=dept_obj).select_related('user')

    lecturers = []
    for lp in profiles:
        ls_entries = lecturer_subjects.objects.filter(user=lp.user).select_related('subject')
        subjects_list = [{
            'ls_id': ls.id,
            'subject_id': ls.subject.subject_id,
            'subject_code': ls.subject.subject_code,
            'subject_name': ls.subject.subject_name,
            'is_lead': ls.is_lead,
        } for ls in ls_entries]

        lecturers.append({
            'user_id': lp.user.id,
            'lc_id': lp.lc_id,
            'name': lp.user.get_full_name() or lp.user.username,
            'max_hours': lp.max_hours_per_week,
            'subjects': subjects_list,
        })

    return JsonResponse({
        'dept_name': dept_obj.dept_name,
        'dept_code': dept_obj.dept_code,
        'lecturers': lecturers,
    })


@role_required(allowed_roles=['admin'])
def get_available_subjects_for_lecturer(request):
    """Get subjects NOT yet assigned to a lecturer."""
    user_id = request.GET.get('user_id')
    if not user_id:
        return JsonResponse({'error': 'user_id required'}, status=400)

    already_assigned = lecturer_subjects.objects.filter(
        user_id=user_id
    ).values_list('subject_id', flat=True)

    available = subject.objects.exclude(subject_id__in=already_assigned).order_by('subject_code')
    result = [{
        'subject_id': s.subject_id,
        'subject_code': s.subject_code,
        'subject_name': s.subject_name,
    } for s in available]

    return JsonResponse({'available': result})


@role_required(allowed_roles=['admin'])
@require_POST
def assign_subject_to_lecturer(request):
    """Assign a subject qualification to a lecturer."""
    try:
        data = json.loads(request.body)
    except json.JSONDecodeError:
        return JsonResponse({'error': 'Invalid JSON'}, status=400)

    user_id = data.get('user_id')
    subject_id = data.get('subject_id')
    is_lead = data.get('is_lead', False)

    if not user_id or not subject_id:
        return JsonResponse({'error': 'user_id and subject_id required'}, status=400)

    user_obj = get_object_or_404(User, id=user_id)
    subj = get_object_or_404(subject, subject_id=subject_id)

    if lecturer_subjects.objects.filter(user=user_obj, subject=subj).exists():
        return JsonResponse({'error': f'{subj.subject_code} is already assigned to this lecturer.'}, status=400)

    lecturer_subjects.objects.create(user=user_obj, subject=subj, is_lead=is_lead)

    record_admin_action(
        user_id=request.user.id,
        content_type_id=ContentType.objects.get_for_model(lecturer_subjects).pk,
        object_id=user_obj.id,
        object_repr=user_obj.get_full_name(),
        action_flag=ADDITION,
        message=f"Assigned {subj.subject_code} to lecturer {user_obj.get_full_name()}"
    )

    return JsonResponse({'success': True, 'message': f'{subj.subject_code} assigned to {user_obj.get_full_name()}.'})


@role_required(allowed_roles=['admin'])
@require_POST
def remove_subject_from_lecturer(request):
    """Remove a subject qualification from a lecturer."""
    try:
        data = json.loads(request.body)
    except json.JSONDecodeError:
        return JsonResponse({'error': 'Invalid JSON'}, status=400)

    ls_id = data.get('ls_id')
    if not ls_id:
        return JsonResponse({'error': 'ls_id required'}, status=400)

    ls_entry = get_object_or_404(lecturer_subjects, id=ls_id)
    code = ls_entry.subject.subject_code
    lecturer_name = ls_entry.user.get_full_name()

    record_admin_action(
        user_id=request.user.id,
        content_type_id=ContentType.objects.get_for_model(lecturer_subjects).pk,
        object_id=ls_entry.user_id,
        object_repr=lecturer_name,
        action_flag=DELETION,
        message=f"Removed {code} from lecturer {lecturer_name}"
    )

    ls_entry.delete()

    return JsonResponse({'success': True, 'message': f'{code} removed successfully.'})


# ============================================================
# TIMETABLE MODULE
# ============================================================

DAY_ORDER = {'Mon': 0, 'Tue': 1, 'Wed': 2, 'Thu': 3, 'Fri': 4}
DAY_NAMES = {'Mon': 'Monday', 'Tue': 'Tuesday', 'Wed': 'Wednesday', 'Thu': 'Thursday', 'Fri': 'Friday'}

def _get_teaching_cutoff(term_obj):
    """Calculate the last teaching date before study/exam weeks."""
    study_rule = academic_rules.objects.filter(rule_name='Study Weeks').first()
    exam_rule = academic_rules.objects.filter(rule_name='Examination Period').first()
    study_days = study_rule.value_days if study_rule else 0
    exam_days = exam_rule.value_days if exam_rule else 0
    return term_obj.end_date - timedelta(days=study_days + exam_days)

def _is_teaching_date(term_obj, target_date):
    """Check if a date is within the valid teaching period."""
    cutoff = _get_teaching_cutoff(term_obj)
    return term_obj.start_date <= target_date < cutoff

def _get_monday_of_week(target_date):
    """Return the Monday of the week containing target_date."""
    return target_date - timedelta(days=target_date.weekday())

def _day_code_to_weekday_offset(day_code):
    """Convert DAY_CHOICES code to weekday offset (MON=0, FRI=4)."""
    return DAY_ORDER.get(day_code, 0)

def _get_lecturer_week_hours(lecturer_user, week_monday):
    """Get total scheduled hours for a lecturer in a given week."""
    week_end = week_monday + timedelta(days=5)
    sessions = class_session.objects.filter(
        lecturer=lecturer_user,
        date__gte=week_monday,
        date__lt=week_end,
        status='scheduled'
    ).select_related('session')
    total_hours = 0
    for cs in sessions:
        delta = datetime.datetime.combine(datetime.date.today(), cs.session.end_time) - \
                datetime.datetime.combine(datetime.date.today(), cs.session.start_time)
        total_hours += delta.total_seconds() / 3600
    return total_hours

def _get_session_duration_hours(sess):
    """Calculate duration of a session in hours."""
    delta = datetime.datetime.combine(datetime.date.today(), sess.end_time) - \
            datetime.datetime.combine(datetime.date.today(), sess.start_time)
    return delta.total_seconds() / 3600

def _find_or_create_assignment(term_obj, subj, available_lecturers):
    """Find existing lecturer assignment or pick one from available lecturers."""
    existing = lecturer_assignment.objects.filter(term=term_obj, subject=subj).first()
    if existing:
        return existing.lecturer

    for lec_sub in available_lecturers:
        lecturer_assignment.objects.create(
            term=term_obj, subject=subj, lecturer=lec_sub.user
        )
        return lec_sub.user
    return None


@role_required(allowed_roles=['admin'])
def manage_timetable(request):
    """Main timetable management page."""
    terms = academic_term.objects.filter(is_active=True).select_related('course').order_by('-start_date')
    context = {'terms': terms}
    return render(request, "partials/manage_timetable.html", context)


@login_required
@role_required(allowed_roles=['student', 'lecturer'])
def view_timetable(request):
    """Read-only timetable view for students and lecturers."""
    user = request.user
    user_groups = set(user.groups.values_list('name', flat=True))

    if 'student' in user_groups:
        enrollment = course_enrollment.objects.filter(student=user).select_related('term__course').first()
        if not enrollment or not enrollment.term:
            messages.info(request, "You are not enrolled in any active term.")
            return redirect('student_dashboard')
        terms = [enrollment.term]
    elif 'lecturer' in user_groups:
        term_ids = class_session.objects.filter(
            lecturer=user
        ).values_list('term_id', flat=True).distinct()
        terms = academic_term.objects.filter(
            term_id__in=term_ids, is_active=True
        ).select_related('course').order_by('-start_date')
    else:
        return redirect('home')

    return render(request, "view_timetable.html", {'terms': terms})


@login_required
@role_required(allowed_roles=['student', 'lecturer'])
def get_my_timetable_data(request):
    """Return timetable JSON filtered for the current student or lecturer."""
    term_id = request.GET.get('term_id')
    week_start = request.GET.get('week_start')

    if not term_id:
        return JsonResponse({'error': 'term_id required'}, status=400)

    term_obj = get_object_or_404(academic_term, term_id=term_id)

    if week_start:
        monday = parse_date(week_start)
        if monday is None:
            return JsonResponse({'error': 'Invalid date format'}, status=400)
    else:
        monday = _get_monday_of_week(date.today())

    friday = monday + timedelta(days=4)
    user = request.user
    user_groups = set(user.groups.values_list('name', flat=True))

    sessions_qs = class_session.objects.filter(
        term=term_obj,
        date__gte=monday,
        date__lte=friday
    ).select_related(
        'session', 'session__facility',
        'subject_component', 'subject_component__subject', 'lecturer'
    ).order_by('date', 'session__start_time')

    if 'student' in user_groups:
        enrollment = course_enrollment.objects.filter(student=user).select_related('term').first()
        if not enrollment or enrollment.term_id != term_obj.term_id:
            return JsonResponse({'error': 'Not enrolled in this term'}, status=403)
        target_semester = term_obj.current_semester
        semester_subject_ids = set(
            course_subject.objects.filter(
                course=term_obj.course,
                recommended_semester=target_semester
            ).values_list('subject_id', flat=True)
        )
        sessions_qs = [s for s in sessions_qs if s.subject_component.subject_id in semester_subject_ids]
    elif 'lecturer' in user_groups:
        sessions_qs = [s for s in sessions_qs if s.lecturer_id == user.id]
    else:
        return JsonResponse({'error': 'Permission denied'}, status=403)

    subject_ids = set(s.subject_component.subject_id for s in sessions_qs)
    comp_map = {}
    for comp in SubjectComponent.objects.filter(subject_id__in=subject_ids):
        comp_map.setdefault(comp.subject_id, []).append(comp.class_type)

    subj_dates = {}
    for cs in sessions_qs:
        subj_dates.setdefault(cs.subject_component.subject_id, []).append((cs.date, cs.id))
    for sid in subj_dates:
        subj_dates[sid].sort()

    timetable = []
    for cs in sessions_qs:
        fac_type = cs.session.facility.type
        components = comp_map.get(cs.subject_component.subject_id, [])
        if fac_type == 'Lab':
            ct = 'Lab'
        elif fac_type == 'Auditorium':
            ct = 'Lecture'
        elif fac_type == 'Classroom':
            if 'Tutorial' in components and 'Lecture' in components:
                dates_for_subj = subj_dates.get(cs.subject_component.subject_id, [])
                first_id = dates_for_subj[0][1] if dates_for_subj else None
                ct = 'Lecture' if cs.id == first_id else 'Tutorial'
            elif 'Tutorial' in components:
                ct = 'Tutorial'
            else:
                ct = 'Lecture'
        else:
            ct = 'Lecture'

        timetable.append({
            'date': cs.date.isoformat(),
            'day': cs.session.day_of_week,
            'start_time': cs.session.start_time.strftime('%H:%M'),
            'end_time': cs.session.end_time.strftime('%H:%M'),
            'subject_code': cs.subject_component.subject.subject_code,
            'subject_name': cs.subject_component.subject.subject_name,
            'class_type': ct,
            'lecturer': cs.lecturer.get_full_name(),
            'facility': cs.session.facility.facility_name,
            'status': cs.status,
        })

    return JsonResponse({
        'timetable': timetable,
        'term_start': term_obj.start_date.isoformat(),
        'term_end': term_obj.end_date.isoformat(),
        'week_start': monday.isoformat(),
    })


@role_required(allowed_roles=['admin'])
def get_timetable_data(request):
    """Return timetable data as JSON for a given term and week."""
    term_id = request.GET.get('term_id')
    week_start = request.GET.get('week_start')  # YYYY-MM-DD
    semester_param = request.GET.get('semester')  # optional semester filter

    if not term_id:
        return JsonResponse({'error': 'term_id required'}, status=400)

    term_obj = get_object_or_404(academic_term, term_id=term_id)
    target_semester = int(semester_param) if semester_param else term_obj.current_semester

    if week_start:
        monday = parse_date(week_start)
        if monday is None:
            return JsonResponse({'error': 'Invalid date format'}, status=400)
    else:
        monday = _get_monday_of_week(date.today())

    friday = monday + timedelta(days=4)

    sessions_qs = class_session.objects.filter(
        term=term_obj,
        date__gte=monday,
        date__lte=friday
    ).select_related('session', 'session__facility', 'subject_component', 'subject_component__subject', 'lecturer').order_by('date', 'session__start_time')

    # Filter to only subjects in the selected semester
    semester_subject_ids = set(
        course_subject.objects.filter(
            course=term_obj.course,
            recommended_semester=target_semester
        ).values_list('subject_id', flat=True)
    )
    sessions_qs = [s for s in sessions_qs if s.subject_component.subject_id in semester_subject_ids]

    # Pre-fetch SubjectComponent types for all subjects in this week
    subject_ids = set(s.subject_component.subject_id for s in sessions_qs)
    comp_map = {}
    for comp in SubjectComponent.objects.filter(subject_id__in=subject_ids):
        comp_map.setdefault(comp.subject_id, []).append(comp.class_type)

    # Pre-compute per-subject session dates (sorted) for Lecture/Tutorial disambiguation
    subj_dates = {}
    for cs in sessions_qs:
        subj_dates.setdefault(cs.subject_component.subject_id, []).append((cs.date, cs.id))
    for sid in subj_dates:
        subj_dates[sid].sort()

    timetable = []
    for cs in sessions_qs:
        fac_type = cs.session.facility.type
        components = comp_map.get(cs.subject_component.subject_id, [])
        # Facility rules: Lab→Lab, Auditorium→Lecture, Classroom→Tutorial/Lecture
        if fac_type == 'Lab':
            ct = 'Lab'
        elif fac_type == 'Auditorium':
            ct = 'Lecture'
        elif fac_type == 'Classroom':
            if 'Tutorial' in components and 'Lecture' in components:
                # Both exist — first session of the week is Lecture, rest Tutorial
                dates_for_subj = subj_dates.get(cs.subject_component.subject_id, [])
                first_id = dates_for_subj[0][1] if dates_for_subj else None
                ct = 'Lecture' if cs.id == first_id else 'Tutorial'
            elif 'Tutorial' in components:
                ct = 'Tutorial'
            else:
                ct = 'Lecture'
        else:
            ct = 'Lecture'

        timetable.append({
            'id': cs.id,
            'date': cs.date.isoformat(),
            'day': cs.session.day_of_week,
            'day_name': DAY_NAMES.get(cs.session.day_of_week, ''),
            'start_time': cs.session.start_time.strftime('%H:%M'),
            'end_time': cs.session.end_time.strftime('%H:%M'),
            'subject_code': cs.subject_component.subject.subject_code,
            'subject_name': cs.subject_component.subject.subject_name,
            'class_type': ct,
            'lecturer': cs.lecturer.get_full_name(),
            'facility': cs.session.facility.facility_name,
            'status': cs.status,
        })

    has_preference = timetable_preference.objects.filter(term=term_obj, is_active=True).exists()

    skipped = list(skipped_date.objects.filter(term=term_obj).values('date', 'reason'))

    cutoff = _get_teaching_cutoff(term_obj)

    return JsonResponse({
        'timetable': timetable,
        'has_preference': has_preference,
        'skipped_dates': skipped,
        'teaching_cutoff': cutoff.isoformat(),
        'term_start': term_obj.start_date.isoformat(),
        'term_end': term_obj.end_date.isoformat(),
        'week_start': monday.isoformat(),
    })


# ── Slot-index helpers (4 timeslots per day: 0-early … 3-late) ──
_SLOT_INDEX_CACHE = {}

def _slot_index(start_time):
    """Map a start_time to 0-based slot index within a day."""
    if start_time not in _SLOT_INDEX_CACHE:
        distinct = sorted(
            session.objects.values_list('start_time', flat=True).distinct()
        )
        for idx, t in enumerate(distinct):
            _SLOT_INDEX_CACHE[t] = idx
    return _SLOT_INDEX_CACHE.get(start_time, 0)


def _score_candidate(day_ord, slot_idx, facility, class_type, subj_id,
                     assignments, day_load, facility_usage, num_items):
    """Return a numeric score for placing a class into a candidate slot.

    Higher is better.  All weights are relative and tuned for a 5-day,
    4-slot-per-day university layout with ~10 classes to place.
    """
    score = 0.0

    # ── 1. Day-spread: prefer the day with the fewest classes so far ──
    load = day_load.get(day_ord, 0)
    ideal_per_day = max(1, num_items / 5)
    if load < ideal_per_day:
        score += 20          # under-loaded day is very attractive
    elif load == 0:
        score += 25          # empty day gets bonus
    else:
        score -= 10 * (load - ideal_per_day)   # overloaded day penalised

    # ── 2. Consecutive-day avoidance for the same subject ──
    subj_days = {a['day_ord'] for a in assignments if a['subj_id'] == subj_id}
    if (day_ord - 1) in subj_days or (day_ord + 1) in subj_days:
        score -= 30          # strong penalty for back-to-back days
    if day_ord in subj_days:
        score -= 15          # same day as another component (tutorial after lecture ok but not ideal)

    # ── 3. Same-day same-subject slot adjacency ──
    subj_slots_today = [
        a['slot_idx'] for a in assignments
        if a['subj_id'] == subj_id and a['day_ord'] == day_ord
    ]
    for s in subj_slots_today:
        if abs(slot_idx - s) == 1:
            score -= 10      # immediately adjacent slots

    # ── 4. Slot-position preferences ──
    if class_type in ('Lab', 'Practical'):
        # Labs preferred in afternoon (slots 2-3)
        if slot_idx >= 2:
            score += 10
        else:
            score -= 5
    elif class_type == 'Lecture':
        # Lectures preferred in morning (slots 0-1)
        if slot_idx <= 1:
            score += 8
        else:
            score -= 3
    # Tutorials: no strong preference (score += 0)

    # Penalise the last slot of the day slightly (avoid late-only schedules)
    if slot_idx == 3:
        score -= 3

    # ── 5. Facility rotation: penalise overuse of one room ──
    fid = facility.facility_id
    fu = facility_usage.get(fid, 0)
    score -= 4 * fu

    # ── 6. Day-order balance: mild penalty for extreme front/back loading ──
    # Prefer middle days slightly so Mon and Fri aren't always first picks
    mid_dist = abs(day_ord - 2)            # 0=Wed (centre), 2=Mon/Fri
    score -= 2 * mid_dist

    # ── 7. Gap avoidance for the intake on this day ──
    slots_today = sorted(
        [a['slot_idx'] for a in assignments if a['day_ord'] == day_ord] + [slot_idx]
    )
    if len(slots_today) >= 2:
        for i in range(len(slots_today) - 1):
            gap = slots_today[i + 1] - slots_today[i]
            if gap > 1:
                score -= 6 * (gap - 1)    # penalise each empty-slot gap

    return score


@role_required(allowed_roles=['admin'])
@require_POST
def generate_timetable(request):
    """Generate a one-week timetable using score-based constraint scheduling.

    Hard constraints (must satisfy):
      - One class per intake per timeslot
      - One class per lecturer per timeslot
      - One booking per facility per timeslot
      - Correct facility type for class type
      - Lecturer weekly-hours cap
      - Tutorials/Labs on a later day than their Lecture

    Soft constraints (scoring preferences):
      - Spread classes across all five days
      - Avoid same-subject on consecutive days
      - Prefer morning for lectures, afternoon for labs
      - Rotate facility usage
      - Minimise gaps within a day
      - Balanced daily load
    """
    try:
        data = json.loads(request.body)
    except json.JSONDecodeError:
        return JsonResponse({'error': 'Invalid JSON'}, status=400)

    term_id = data.get('term_id')
    week_start_str = data.get('week_start')
    semester_override = data.get('semester')  # optional semester selection

    term_obj = get_object_or_404(academic_term, term_id=term_id)

    # Use the semester from the request if provided, otherwise fall back to term's current_semester
    target_semester = int(semester_override) if semester_override else term_obj.current_semester

    if week_start_str:
        week_monday = parse_date(week_start_str)
        if week_monday is None:
            return JsonResponse({'error': 'Invalid date format'}, status=400)
    else:
        week_monday = _get_monday_of_week(term_obj.start_date)

    if not _is_teaching_date(term_obj, week_monday):
        return JsonResponse({'error': 'Target week falls outside the teaching period (study/exam week).'}, status=400)

    # ── 1. Build items to schedule ──────────────────────────────────
    cs_entries = course_subject.objects.filter(
        course=term_obj.course,
        recommended_semester=target_semester
    ).select_related('subject')

    items_to_schedule = []
    for cs_entry in cs_entries:
        components = SubjectComponent.objects.filter(subject=cs_entry.subject)
        if components.exists():
            for comp in components:
                items_to_schedule.append({
                    'subject': cs_entry.subject,
                    'component': comp,
                    'class_type': comp.class_type,
                    'hours_per_class': comp.hours_per_class,
                })
        else:
            default_comp, _ = SubjectComponent.objects.get_or_create(
                subject=cs_entry.subject,
                class_type='Lecture',
                defaults={'hours_per_class': 2, 'total_required_hours': 0}
            )
            items_to_schedule.append({
                'subject': cs_entry.subject,
                'component': default_comp,
                'class_type': 'Lecture',
                'hours_per_class': 2,
            })

    # Lectures first so tutorials/labs can reference their day
    type_order = {'Lecture': 0, 'Tutorial': 1, 'Lab': 2, 'Practical': 2, 'Fieldwork': 2}
    items_to_schedule.sort(key=lambda item: (
        type_order.get(item['class_type'], 9),
        item['subject'].subject_id,
    ))
    num_items = len(items_to_schedule)

    # ── 2. Prepare session pool ─────────────────────────────────────
    all_sessions = list(session.objects.select_related('facility'))
    all_sessions.sort(key=lambda s: (DAY_ORDER.get(s.day_of_week, 9), s.start_time, s.facility_id))

    # ── 3. Pre-compute valid teaching dates ─────────────────────────
    week_dates = {}
    valid_dates = set()
    skipped_set = set(
        skipped_date.objects.filter(term=term_obj).values_list('date', flat=True)
    )
    for day_ord in range(5):
        d = week_monday + timedelta(days=day_ord)
        week_dates[day_ord] = d
        if d not in skipped_set and _is_teaching_date(term_obj, d):
            valid_dates.add(d)

    # ── 4. Build occupancy maps from existing sessions ──────────────
    existing_qs = class_session.objects.filter(
        date__gte=week_monday,
        date__lt=week_monday + timedelta(days=5),
        status='scheduled'
    ).select_related('session', 'subject_component')

    occupied_intake = set()
    occupied_lecturer = set()
    occupied_facility = set()
    lecturer_week_hours = {}

    # Track current state for scoring
    assignments = []        # list of {'subj_id','day_ord','slot_idx','facility_id','sess'}
    day_load = {}           # day_ord -> count of classes
    facility_usage = {}     # facility_id -> count of bookings

    for ex in existing_qs:
        st = ex.session.start_time
        d_ord = DAY_ORDER.get(ex.session.day_of_week, 9)
        occupied_intake.add((ex.term_id, ex.date, st))
        occupied_lecturer.add((ex.lecturer_id, ex.date, st))
        occupied_facility.add((ex.session.facility_id, ex.date, st))
        hrs = _get_session_duration_hours(ex.session)
        lecturer_week_hours[ex.lecturer_id] = lecturer_week_hours.get(ex.lecturer_id, 0) + hrs
        # Seed scoring state
        assignments.append({
            'subj_id': ex.subject_component.subject_id,
            'day_ord': d_ord,
            'slot_idx': _slot_index(st),
            'facility_id': ex.session.facility_id,
        })
        day_load[d_ord] = day_load.get(d_ord, 0) + 1
        facility_usage[ex.session.facility_id] = facility_usage.get(ex.session.facility_id, 0) + 1

    # ── 5. Score-based scheduling ───────────────────────────────────
    created_sessions = []
    errors = []
    scheduled_days = {}     # subject_id -> day_ord of its Lecture

    with transaction.atomic():
        for item in items_to_schedule:
            subj = item['subject']
            class_type = item['class_type']

            # Resolve lecturer
            qualified = lecturer_subjects.objects.filter(subject=subj).select_related('user__lecturer_profile')
            assigned_lecturer = _find_or_create_assignment(term_obj, subj, qualified)
            if not assigned_lecturer:
                errors.append(f"No qualified lecturer found for {subj.subject_code} ({class_type})")
                continue

            lec_profile = getattr(assigned_lecturer, 'lecturer_profile', None)
            max_hours = lec_profile.max_hours_per_week if lec_profile else 20
            current_hours = lecturer_week_hours.get(assigned_lecturer.id, 0)

            min_day_order = 0
            if class_type in ('Lab', 'Tutorial', 'Practical', 'Fieldwork'):
                parent_day = scheduled_days.get(subj.subject_id)
                if parent_day is not None:
                    min_day_order = parent_day + 1

            # Evaluate ALL valid candidates, pick the best score
            candidates = []
            for sess in all_sessions:
                day_ord = DAY_ORDER.get(sess.day_of_week, 9)
                if day_ord < min_day_order:
                    continue

                sess_date = week_dates.get(day_ord)
                if sess_date is None or sess_date not in valid_dates:
                    continue

                # Facility-type hard constraint
                # Classroom: Lecture / Tutorial
                # Auditorium: Lecture only
                # Lab: Lab only
                ft = sess.facility.type
                if class_type in ('Lab', 'Practical') and ft != 'Lab':
                    continue
                if class_type == 'Lecture' and ft not in ('Classroom', 'Auditorium'):
                    continue
                if class_type == 'Tutorial' and ft != 'Classroom':
                    continue
                if class_type == 'Fieldwork' and ft not in ('Classroom', 'Auditorium'):
                    continue

                st = sess.start_time

                # Hard constraint checks
                if (term_obj.term_id, sess_date, st) in occupied_intake:
                    continue
                if (assigned_lecturer.id, sess_date, st) in occupied_lecturer:
                    continue
                if (sess.facility_id, sess_date, st) in occupied_facility:
                    continue

                sess_hours = _get_session_duration_hours(sess)
                if current_hours + sess_hours > max_hours:
                    continue

                # Candidate passes all hard constraints — score it
                slot_idx = _slot_index(st)
                sc = _score_candidate(
                    day_ord, slot_idx, sess.facility, class_type,
                    subj.subject_id, assignments, day_load,
                    facility_usage, num_items
                )
                candidates.append((sc, sess, day_ord, slot_idx, sess_date, sess_hours))

            if not candidates:
                errors.append(f"Could not find an available slot for {subj.subject_code} ({class_type})")
                continue

            # Pick the candidate with the highest score
            # (tie-break by day_ord then slot_idx for determinism)
            candidates.sort(key=lambda c: (-c[0], c[2], c[3]))
            best_score, best_sess, best_day, best_slot, best_date, best_hours = candidates[0]

            new_cs = class_session.objects.create(
                session=best_sess,
                subject_component=item['component'],
                lecturer=assigned_lecturer,
                term=term_obj,
                date=best_date,
                status='scheduled'
            )
            created_sessions.append(new_cs)

            # Update occupancy & scoring state
            occupied_intake.add((term_obj.term_id, best_date, best_sess.start_time))
            occupied_lecturer.add((assigned_lecturer.id, best_date, best_sess.start_time))
            occupied_facility.add((best_sess.facility_id, best_date, best_sess.start_time))
            current_hours += best_hours
            lecturer_week_hours[assigned_lecturer.id] = current_hours

            assignments.append({
                'subj_id': subj.subject_id,
                'day_ord': best_day,
                'slot_idx': best_slot,
                'facility_id': best_sess.facility_id,
            })
            day_load[best_day] = day_load.get(best_day, 0) + 1
            facility_usage[best_sess.facility_id] = facility_usage.get(best_sess.facility_id, 0) + 1

            if class_type == 'Lecture':
                scheduled_days[subj.subject_id] = best_day

        # ── 6. Improvement pass: try swapping pairs for better scores ──
        improved = True
        max_passes = 3
        pass_count = 0
        while improved and pass_count < max_passes:
            improved = False
            pass_count += 1
            for i in range(len(created_sessions)):
                cs_i = created_sessions[i]
                sess_i = cs_i.session
                day_i = DAY_ORDER.get(sess_i.day_of_week, 9)
                slot_i = _slot_index(sess_i.start_time)

                # Look at other created sessions to try swapping rooms/slots
                for j in range(i + 1, len(created_sessions)):
                    cs_j = created_sessions[j]
                    sess_j = cs_j.session

                    # Only consider swapping if same timeslot (same day+time)
                    # to swap facilities, or same day different time to swap slots
                    if sess_i.day_of_week != sess_j.day_of_week:
                        continue
                    if sess_i.start_time != sess_j.start_time:
                        continue
                    # Same timeslot, different rooms — try swapping rooms
                    if sess_i.facility_id == sess_j.facility_id:
                        continue

                    # Check facility-type compatibility after swap
                    i_type = 'Lab' if sess_i.facility.type == 'Lab' else 'Classroom'
                    j_type = 'Lab' if sess_j.facility.type == 'Lab' else 'Classroom'
                    i_needs = 'Lab' if cs_i.session.facility.type == 'Lab' else 'Classroom'
                    j_needs = 'Lab' if cs_j.session.facility.type == 'Lab' else 'Classroom'

                    if j_type != i_needs or i_type != j_needs:
                        continue

                    # Score before swap
                    old_i = _score_candidate(
                        day_i, slot_i, sess_i.facility, 'Lab' if i_needs == 'Lab' else 'Lecture',
                        cs_i.subject_component.subject_id, assignments, day_load, facility_usage, num_items
                    )
                    old_j = _score_candidate(
                        day_i, slot_i, sess_j.facility, 'Lab' if j_needs == 'Lab' else 'Lecture',
                        cs_j.subject_component.subject_id, assignments, day_load, facility_usage, num_items
                    )

                    # Score after swap
                    new_i = _score_candidate(
                        day_i, slot_i, sess_j.facility, 'Lab' if i_needs == 'Lab' else 'Lecture',
                        cs_i.subject_component.subject_id, assignments, day_load, facility_usage, num_items
                    )
                    new_j = _score_candidate(
                        day_i, slot_i, sess_i.facility, 'Lab' if j_needs == 'Lab' else 'Lecture',
                        cs_j.subject_component.subject_id, assignments, day_load, facility_usage, num_items
                    )

                    if (new_i + new_j) > (old_i + old_j):
                        # Swap sessions in DB
                        cs_i.session, cs_j.session = cs_j.session, cs_i.session
                        cs_i.save()
                        cs_j.save()
                        # Update facility_usage
                        facility_usage[sess_i.facility_id] = facility_usage.get(sess_i.facility_id, 1) - 1
                        facility_usage[sess_j.facility_id] = facility_usage.get(sess_j.facility_id, 1) - 1
                        facility_usage[sess_j.facility_id] = facility_usage.get(sess_j.facility_id, 0) + 1
                        facility_usage[sess_i.facility_id] = facility_usage.get(sess_i.facility_id, 0) + 1
                        improved = True

    record_admin_action(
        user_id=request.user.id,
        content_type_id=ContentType.objects.get_for_model(class_session).pk,
        object_id=term_obj.term_id,
        object_repr=f"{term_obj.intake_code} - Week {week_monday}",
        action_flag=ADDITION,
        message=f"Generated timetable: {len(created_sessions)} session(s) created, {len(errors)} error(s)"
    )

    return JsonResponse({
        'success': True,
        'created': len(created_sessions),
        'errors': errors,
    })


@role_required(allowed_roles=['admin'])
@require_POST
def delete_week_timetable(request):
    """Delete all scheduled sessions for a given term and week."""
    try:
        data = json.loads(request.body)
    except json.JSONDecodeError:
        return JsonResponse({'error': 'Invalid JSON'}, status=400)

    term_id = data.get('term_id')
    week_start_str = data.get('week_start')
    semester_param = data.get('semester')

    term_obj = get_object_or_404(academic_term, term_id=term_id)
    target_semester = int(semester_param) if semester_param else term_obj.current_semester

    monday = parse_date(week_start_str)
    if monday is None:
        return JsonResponse({'error': 'Invalid date format'}, status=400)

    friday = monday + timedelta(days=4)

    # Only delete sessions for subjects in the selected semester
    semester_subject_ids = set(
        course_subject.objects.filter(
            course=term_obj.course,
            recommended_semester=target_semester
        ).values_list('subject_id', flat=True)
    )

    deleted_count, _ = class_session.objects.filter(
        term=term_obj,
        date__gte=monday,
        date__lte=friday,
        status='scheduled',
        subject_component__subject_id__in=semester_subject_ids
    ).delete()

    record_admin_action(
        user_id=request.user.id,
        content_type_id=ContentType.objects.get_for_model(class_session).pk,
        object_id=term_obj.term_id,
        object_repr=f"{term_obj.intake_code} - Week {monday}",
        action_flag=DELETION,
        message=f"Deleted {deleted_count} scheduled session(s) for week {monday}"
    )

    return JsonResponse({
        'success': True,
        'deleted': deleted_count,
    })


@role_required(allowed_roles=['admin'])
@require_POST
def save_preference(request):
    """Save the current week's timetable as the active preference."""
    try:
        data = json.loads(request.body)
    except json.JSONDecodeError:
        return JsonResponse({'error': 'Invalid JSON'}, status=400)

    term_id = data.get('term_id')
    week_start_str = data.get('week_start')
    semester_param = data.get('semester')

    term_obj = get_object_or_404(academic_term, term_id=term_id)
    target_semester = int(semester_param) if semester_param else term_obj.current_semester
    monday = parse_date(week_start_str)
    if monday is None:
        return JsonResponse({'error': 'Invalid date'}, status=400)

    friday = monday + timedelta(days=4)

    # Only save preferences for subjects in the selected semester
    semester_subject_ids = set(
        course_subject.objects.filter(
            course=term_obj.course,
            recommended_semester=target_semester
        ).values_list('subject_id', flat=True)
    )

    current_classes = class_session.objects.filter(
        term=term_obj,
        date__gte=monday,
        date__lte=friday,
        status='scheduled',
        subject_component__subject_id__in=semester_subject_ids
    ).select_related('session', 'subject_component', 'subject_component__subject')

    if not current_classes.exists():
        return JsonResponse({'error': 'No scheduled classes found for this week.'}, status=400)

    with transaction.atomic():
        # Deactivate old preferences
        timetable_preference.objects.filter(term=term_obj).update(is_active=False)
        # Delete old inactive ones
        timetable_preference.objects.filter(term=term_obj, is_active=False).delete()

        # Create new preferences
        for cs in current_classes:
            timetable_preference.objects.create(
                term=term_obj,
                subject_component=cs.subject_component,
                lecturer=cs.lecturer,
                session=cs.session,
                is_active=True
            )

    record_admin_action(
        user_id=request.user.id,
        content_type_id=ContentType.objects.get_for_model(timetable_preference).pk,
        object_id=term_obj.term_id,
        object_repr=f"{term_obj.intake_code} - Week {monday}",
        action_flag=CHANGE,
        message=f"Saved timetable preference for week {monday}"
    )

    return JsonResponse({'success': True, 'message': 'Preference saved successfully.'})


@role_required(allowed_roles=['admin'])
@require_POST
def replicate_preference(request):
    """Replicate preference to one or more target weeks."""
    try:
        data = json.loads(request.body)
    except json.JSONDecodeError:
        return JsonResponse({'error': 'Invalid JSON'}, status=400)

    term_id = data.get('term_id')
    target_weeks = data.get('target_weeks', [])  # list of YYYY-MM-DD (Monday)
    # Backward compat: accept single target_week too
    if not target_weeks:
        single = data.get('target_week')
        if single:
            target_weeks = [single]
    semester_param = data.get('semester')

    if not target_weeks:
        return JsonResponse({'error': 'No target weeks provided.'}, status=400)

    term_obj = get_object_or_404(academic_term, term_id=term_id)
    target_semester = int(semester_param) if semester_param else term_obj.current_semester

    # Only replicate preferences for subjects in the selected semester
    semester_subject_ids = set(
        course_subject.objects.filter(
            course=term_obj.course,
            recommended_semester=target_semester
        ).values_list('subject_id', flat=True)
    )

    prefs = timetable_preference.objects.filter(
        term=term_obj, is_active=True, subject_component__subject_id__in=semester_subject_ids
    ).select_related('session', 'subject')
    if not prefs.exists():
        return JsonResponse({'error': 'No active preference found for this semester. Please save a preference first.'}, status=400)

    total_created = 0
    all_skipped_classes = []
    weeks_with_errors = []
    weeks_processed = 0

    with transaction.atomic():
        for target_week_str in target_weeks:
            target_monday = parse_date(target_week_str)
            if target_monday is None:
                weeks_with_errors.append({'week': target_week_str, 'reason': 'Invalid date'})
                continue

            if not _is_teaching_date(term_obj, target_monday):
                weeks_with_errors.append({'week': target_week_str, 'reason': 'Outside teaching period'})
                continue

            # Check for existing classes in target week for this semester
            target_friday = target_monday + timedelta(days=4)
            existing_count = class_session.objects.filter(
                term=term_obj,
                date__gte=target_monday,
                date__lte=target_friday,
                status='scheduled',
                subject_component__subject_id__in=semester_subject_ids
            ).count()
            if existing_count > 0:
                weeks_with_errors.append({'week': target_week_str, 'reason': 'Already has scheduled classes'})
                continue

            # Get skipped dates for target week
            skipped_dates = set(
                skipped_date.objects.filter(
                    term=term_obj,
                    date__gte=target_monday,
                    date__lte=target_friday
                ).values_list('date', flat=True)
            )

            for pref in prefs:
                day_offset = _day_code_to_weekday_offset(pref.session.day_of_week)
                target_date = target_monday + timedelta(days=day_offset)

                if target_date in skipped_dates:
                    all_skipped_classes.append({
                        'subject': pref.subject_component.subject.subject_code,
                        'day': DAY_NAMES.get(pref.session.day_of_week, ''),
                        'date': target_date.isoformat(),
                        'reason': 'Skipped date / Public holiday',
                    })
                    continue

                if not _is_teaching_date(term_obj, target_date):
                    all_skipped_classes.append({
                        'subject': pref.subject_component.subject.subject_code,
                        'day': DAY_NAMES.get(pref.session.day_of_week, ''),
                        'date': target_date.isoformat(),
                        'reason': 'Outside teaching period',
                    })
                    continue

                class_session.objects.create(
                    session=pref.session,
                    subject_component=pref.subject_component,
                    lecturer=pref.lecturer,
                    term=term_obj,
                    date=target_date,
                    status='scheduled'
                )
                total_created += 1

            weeks_processed += 1

    record_admin_action(
        user_id=request.user.id,
        content_type_id=ContentType.objects.get_for_model(class_session).pk,
        object_id=term_obj.term_id,
        object_repr=f"{term_obj.intake_code}",
        action_flag=ADDITION,
        message=f"Replicated preference to {weeks_processed} week(s), {total_created} session(s) created"
    )

    return JsonResponse({
        'success': True,
        'created': total_created,
        'weeks_processed': weeks_processed,
        'skipped_classes': all_skipped_classes,
        'weeks_with_errors': weeks_with_errors,
    })


@role_required(allowed_roles=['admin'])
@require_POST
def add_skipped_date(request):
    """Add a skipped date (public holiday) for an intake."""
    try:
        data = json.loads(request.body)
    except json.JSONDecodeError:
        return JsonResponse({'error': 'Invalid JSON'}, status=400)

    term_id = data.get('term_id')
    skip_date_str = data.get('date')
    reason = data.get('reason', 'Public Holiday')

    term_obj = get_object_or_404(academic_term, term_id=term_id)
    skip_dt = parse_date(skip_date_str)
    if skip_dt is None:
        return JsonResponse({'error': 'Invalid date'}, status=400)

    if skipped_date.objects.filter(term=term_obj, date=skip_dt).exists():
        return JsonResponse({'error': 'This date is already marked as skipped.'}, status=400)

    skipped_date.objects.create(term=term_obj, date=skip_dt, reason=reason)

    # Cancel any existing classes on that date
    cancelled = class_session.objects.filter(
        term=term_obj, date=skip_dt, status='scheduled'
    ).update(status='cancelled')

    record_admin_action(
        user_id=request.user.id,
        content_type_id=ContentType.objects.get_for_model(skipped_date).pk,
        object_id=term_obj.term_id,
        object_repr=f"{term_obj.intake_code} - {skip_dt}",
        action_flag=ADDITION,
        message=f"Added skipped date {skip_dt} ({reason}), {cancelled} class(es) cancelled"
    )

    return JsonResponse({
        'success': True,
        'message': f'Date {skip_dt} marked as skipped. {cancelled} class(es) cancelled.',
    })


@role_required(allowed_roles=['admin'])
@require_POST
def remove_skipped_date(request):
    """Remove a skipped date."""
    try:
        data = json.loads(request.body)
    except json.JSONDecodeError:
        return JsonResponse({'error': 'Invalid JSON'}, status=400)

    term_id = data.get('term_id')
    skip_date_str = data.get('date')

    term_obj = get_object_or_404(academic_term, term_id=term_id)
    skip_dt = parse_date(skip_date_str)
    if skip_dt is None:
        return JsonResponse({'error': 'Invalid date'}, status=400)

    deleted, _ = skipped_date.objects.filter(term=term_obj, date=skip_dt).delete()
    if deleted == 0:
        return JsonResponse({'error': 'Skipped date not found.'}, status=400)

    record_admin_action(
        user_id=request.user.id,
        content_type_id=ContentType.objects.get_for_model(skipped_date).pk,
        object_id=term_obj.term_id,
        object_repr=f"{term_obj.intake_code} - {skip_dt}",
        action_flag=DELETION,
        message=f"Removed skipped date {skip_dt}"
    )

    return JsonResponse({'success': True, 'message': 'Skipped date removed.'})


@role_required(allowed_roles=['admin'])
def get_missing_classes(request):
    """Get cancelled/missing classes for a term that can be rearranged."""
    term_id = request.GET.get('term_id')
    term_obj = get_object_or_404(academic_term, term_id=term_id)

    missing = class_session.objects.filter(
        term=term_obj,
        status='cancelled'
    ).select_related('session', 'session__facility', 'subject_component', 'subject_component__subject', 'lecturer')

    result = []
    for cs in missing:
        result.append({
            'id': cs.id,
            'date': cs.date.isoformat(),
            'day': cs.session.day_of_week,
            'subject_code': cs.subject_component.subject.subject_code,
            'subject_name': cs.subject_component.subject.subject_name,
            'lecturer': cs.lecturer.get_full_name(),
            'start_time': cs.session.start_time.strftime('%H:%M'),
            'end_time': cs.session.end_time.strftime('%H:%M'),
        })

    return JsonResponse({'missing_classes': result})


@role_required(allowed_roles=['admin'])
@require_POST
def rearrange_missing_class(request):
    """Rearrange a single cancelled class to a new available slot."""
    try:
        data = json.loads(request.body)
    except json.JSONDecodeError:
        return JsonResponse({'error': 'Invalid JSON'}, status=400)

    class_session_id = data.get('class_session_id')
    cs_obj = get_object_or_404(class_session, id=class_session_id, status='cancelled')

    term_obj = cs_obj.term
    subj = cs_obj.subject_component.subject
    lecturer_user = cs_obj.lecturer

    # Search within the same week first, then nearby weeks
    original_monday = _get_monday_of_week(cs_obj.date)
    search_weeks = [original_monday]
    # Also check next week
    search_weeks.append(original_monday + timedelta(days=7))

    # Determine valid facility types based on original facility
    # Rules: Lab→Lab only, Auditorium→Lecture (Auditorium only),
    #        Classroom→Tutorial/Lecture (Classroom only)
    original_facility_type = cs_obj.session.facility.type
    if original_facility_type == 'Lab':
        valid_facility_types = ['Lab']
    elif original_facility_type == 'Auditorium':
        valid_facility_types = ['Auditorium']
    else:
        valid_facility_types = ['Classroom']

    all_sessions = session.objects.filter(
        facility__type__in=valid_facility_types
    ).select_related('facility').order_by('day_of_week', 'start_time')

    for week_monday in search_weeks:
        for sess in all_sessions:
            day_offset = _day_code_to_weekday_offset(sess.day_of_week)
            target_date = week_monday + timedelta(days=day_offset)

            if not _is_teaching_date(term_obj, target_date):
                continue

            if skipped_date.objects.filter(term=term_obj, date=target_date).exists():
                continue

            # Check clashes
            intake_clash = class_session.objects.filter(
                term=term_obj, session=sess, date=target_date, status='scheduled'
            ).exists()
            lecturer_clash = class_session.objects.filter(
                lecturer=lecturer_user, session=sess, date=target_date, status='scheduled'
            ).exists()

            if intake_clash or lecturer_clash:
                continue

            # Check lecturer hours
            lec_profile = getattr(lecturer_user, 'lecturer_profile', None)
            max_hours = lec_profile.max_hours_per_week if lec_profile else 20
            current_hours = _get_lecturer_week_hours(lecturer_user, week_monday)
            sess_hours = _get_session_duration_hours(sess)

            if current_hours + sess_hours > max_hours:
                continue

            # Rearrange
            cs_obj.session = sess
            cs_obj.date = target_date
            cs_obj.status = 'rearranged'
            cs_obj.save()

            record_admin_action(
                user_id=request.user.id,
                content_type_id=ContentType.objects.get_for_model(class_session).pk,
                object_id=cs_obj.id,
                object_repr=f"{subj.subject_code} - {target_date}",
                action_flag=CHANGE,
                message=f"Rearranged {subj.subject_code} to {DAY_NAMES.get(sess.day_of_week)} {target_date} at {sess.facility.facility_name}"
            )

            return JsonResponse({
                'success': True,
                'message': f'Class rearranged to {DAY_NAMES.get(sess.day_of_week)} {target_date}',
                'new_date': target_date.isoformat(),
                'new_day': DAY_NAMES.get(sess.day_of_week, ''),
                'new_time': f"{sess.start_time.strftime('%H:%M')} - {sess.end_time.strftime('%H:%M')}",
                'new_facility': sess.facility.facility_name,
            })

    return JsonResponse({
        'success': False,
        'error': 'No available slot found for rearrangement.',
    })



#announcement function
@role_required(allowed_roles=['admin'])
@transaction.atomic
def announcements_form(request, ann_id=None):
    instance = get_object_or_404(announcement, pk=ann_id) if ann_id else None
    target_instance = None

    if instance:
        target_instance = announcementTarget.objects.filter(announcement=instance).first()

    if request.method == 'POST':
        form = newAnnouncemeentForm(request.POST, request.FILES, instance=instance)

        if form.is_valid():
            ann_obj = form.save(commit=False)
            if not instance:
                ann_obj.author = request.user.admin_profile
            ann_obj.save()

            deleted_ids_raw = request.POST.get('deleted_attachments', '')
            if deleted_ids_raw:
                deleted_ids = [rid for rid in deleted_ids_raw.split(',') if rid]
                attachments.objects.filter(id__in=deleted_ids).delete()

            files = request.FILES.getlist('extra_attachments')
            for f in files:
                save_manual_attachment(ann_obj, f)

            is_for_students = request.POST.get('is_tp_visible') == 'True'
            intake_ids_raw = request.POST.get('academic_term', '')
            academic_term_val = None
            if not is_for_students and intake_ids_raw:
                academic_term_val = intake_ids_raw

            announcementTarget.objects.update_or_create(
                announcement=ann_obj,
                defaults={
                    'is_for_students': is_for_students,
                    'is_for_lecturer': request.POST.get('is_lc_visible') == 'True',
                    'is_for_admins': request.POST.get('is_ad_visible') == 'True', 
                    'is_visitor_visible': request.POST.get('is_visitor_visible') == 'True', 
                    'academic_term': academic_term_val,
                }
            )

            messages.success(request, f"Announcement {'updated' if instance else 'published'} successfully!")
            return redirect('announcement_list')
        else:
            messages.error(request, "There was an error in the form. Please check your inputs.")
            print(form.errors)
    else:
        initial_data = {}
        if target_instance:
            initial_data = {
                'is_ad_visible': target_instance.is_for_admins,
                'is_lc_visible': target_instance.is_for_lecturer,
                'is_tp_visible': target_instance.is_for_students,
                'is_visitor_visible': target_instance.is_visitor_visible,
                'academic_term': target_instance.academic_term,
            }
        form = newAnnouncemeentForm(instance=instance, initial=initial_data)

    available_term = list(academic_term.objects.values('term_id', 'intake_code').order_by('-start_date'))
    context = {
        "form": form,
        "instance": instance,
        'targetInfo': target_instance,
        "available_term": available_term,
    }
    return render(request, "announcement/announcement_form.html", context)

def announcement_list(request): 
    user = request.user

    announcements = announcement.objects.filter(
        announcement_type="NORMAL",
        is_active=True,
    ).prefetch_related('all_attachments').order_by('-date_published')

    if not user.is_authenticated:
       announcements = announcements.filter(targets__is_visitor_visible=True)
    elif not user.is_superuser:
        if hasattr(user, 'admin_profile'):
            announcements = announcements.filter(targets__is_for_admins=True)
        elif hasattr(user, 'lecturer_profile'):
            announcements = announcements.filter(targets__is_for_lecturer=True)
        elif hasattr(user, 'student_profile'):
            student_intake = str(user.course_enrollment.term.term_id)

            announcements = announcements.filter(
                Q(targets__is_for_lecturer=True) |
                Q(targets__academic_term__icontains=student_intake)
            ).distinct()

    context = {
        "announcements": announcements,
    }
    return render(request, "announcement/announcement_list.html", context)

def get_visibility_count(ann_type, field_key):
    base_filter = announcementTarget.objects.filter(announcement__announcement_type=ann_type)
    
    if field_key == 'is_for_students':
        return base_filter.filter(
            Q(is_for_students=True) | Q(academic_term__isnull=False)
        ).exclude(academic_term='').distinct().count()
    
    return base_filter.filter(**{field_key: True}).count()

@role_required(allowed_roles=['admin'])
@transaction.atomic
def announcement_manage(request):
    news_qs = announcement.objects.filter(announcement_type='NORMAL').order_by('-date_published')
    banner_qs = announcement.objects.filter(announcement_type='BANNER').order_by('-date_published')

    target_groups = [
        ('is_for_admins', 'Admins'),
        ('is_for_lecturer', 'Lecturers'),
        ('is_for_students', 'Students'),
        ('is_visitor_visible', 'Visitors'),
    ]

    news_visibility_counts = {
        key: get_visibility_count('NORMAL', key) for key, label in target_groups
    }

    banner_visibility_counts = {
        key: get_visibility_count('BANNER', key) for key, label in target_groups
    }

    visible_news = request.GET.getlist('visible-news')
    if visible_news:
        news_query = Q()
        for field in visible_news:
            if field == 'is_for_students':
                news_query |= Q(targets__is_for_students=True) | Q(targets__academic_term__isnull=False)
            else:
                news_query |= Q(**{f"targets__{field}": True})
        news_qs = news_qs.filter(news_query).distinct()

    visible_banner = request.GET.getlist('visible-banner')
    if visible_banner:
        banner_query = Q()
        for field in visible_banner:
            if field == 'is_for_students':
                banner_query |= Q(targets__is_for_students=True) | Q(targets__academic_term__isnull=False)
            else:
                banner_query |= Q(**{f"targets__{field}": True})
        banner_qs = banner_qs.filter(banner_query).distinct()

    try:
        news_page = int(request.GET.get('news_page', 1))
        banner_page = int(request.GET.get('banner_page', 1))
    except (ValueError, TypeError):
        news_page = 1
        banner_page = 1

    limit = 10

    news_total = news_qs.count()
    max_news_pages = max(1, math.ceil(news_total / limit))
    if news_page > max_news_pages: news_page = max_news_pages
    
    news_start = (news_page - 1) * limit
    news_list = news_qs[news_start : news_start + limit]

    banner_total = banner_qs.count()
    max_banner_pages = max(1, math.ceil(banner_total / limit))
    if banner_page > max_banner_pages: banner_page = max_banner_pages
    
    banner_start = (banner_page - 1) * limit
    banner_list = banner_qs[banner_start : banner_start + limit]

    context = {
        'target_groups': target_groups,
        'news_visibility_counts': news_visibility_counts,
        'banner_visibility_counts': banner_visibility_counts,
        'news_list': news_list,
        'banner_list': banner_list,
        'current_news_page': news_page,
        'max_news_pages': max_news_pages,
        'current_banner_page': banner_page,
        'max_banner_pages': max_banner_pages,
        'show_news_pagination': news_total > limit,
        'show_banner_pagination': banner_total > limit,
    }

    if request.headers.get('x-requested-with') == 'XMLHttpRequest':
        print('ajax request')
        target = request.GET.get('target')
        print(target)
        if target == 'news':
            return render(request, 'partials/announcement_list_partial.html', context)
        elif target == 'banner':
            return render(request, 'partials/banner_list_partial.html', context)
        
    return render(request, "announcement/announcement_manage.html", context)

@role_required(allowed_roles=['admin'])
@require_POST
def announcement_delete(request, pk, page=1):
    instance = get_object_or_404(announcement, pk=pk)
    type = instance.announcement_type.capitalize()
    instance.delete()

    try:
        news_page = int(request.GET.get('news_page', '1'))
        banner_page = int(request.GET.get('banner_page', '1'))
    except ValueError:
        news_page = 1
        banner_page = 1

    if type == 'NORMAL':
        remaining = announcement.objects.filter(announcement_type='NORMAL').count()
        items_per_page = 10
        max_page = math.ceil(remaining / items_per_page) if remaining > 0 else 1
        
        if news_page > max_page:
            news_page = max_page
    else:
        remaining = announcement.objects.filter(announcement_type='BANNER').count()
        items_per_banner_page = 10
        max_banner_page = math.ceil(remaining / items_per_banner_page) if remaining > 0 else 1
        
        if banner_page > max_banner_page:
            banner_page = max_banner_page


    messages.success(request, f'Successfully deleted {type} post.')
    return redirect(f"{reverse('announcement_manage')}?news_page={news_page}&banner_page={banner_page}")