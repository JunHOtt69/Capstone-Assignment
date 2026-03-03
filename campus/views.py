from django.shortcuts import render, HttpResponse, redirect
from django.template.loader import render_to_string
from django.http import JsonResponse
from django.db import transaction
from django.db.models import Q
from django.core.mail import EmailMultiAlternatives
from django.utils.encoding import force_bytes
from django.utils.http import urlsafe_base64_encode
from django.urls import reverse_lazy
from django.urls import reverse
#from django.utils.decorators import method_decorator
from django.contrib import messages
from django.contrib.admin.models import LogEntry, ADDITION
from django.contrib.contenttypes.models import ContentType
from django.contrib.auth.tokens import default_token_generator
from django.contrib.auth.decorators import login_required
from django.contrib.auth import logout
from django.contrib.auth.views import LoginView, PasswordResetView
from django.contrib.auth import get_user_model
from django.contrib.auth.models import User, Group
import datetime
import random
from .forms import UserRowForm, AcademicTermForm
from .models import course, academic_term, academic_rules, departments, lecturer_profiles, course_enrollment, admin_profiles, student_profiles
from .decorators import role_required

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

def help(request): 
    return render(request, "help.html")

def navigation(request): 
    return render(request, "navigation.html")

def editmap(request): 
    return render(request, "editmap.html")

#attendance function

def attendance(request): 
    return render(request, "attendance.html")

def attendance_signup(request):
    if request.method == "POST":
        input_otp = (request.POST.get("otp") or "").strip()
        saved_otp = request.session.get("attendance_otp")

        if not saved_otp:
            return JsonResponse({
                "ok": False,
                "message": "OTP not available yet. Please ask lecturer to generate OTP."
            })

        if input_otp != saved_otp:
            return JsonResponse({
                "ok": False,
                "message": "Invalid code. Please try again."
            })

        request.session.pop("attendance_otp", None)
        return JsonResponse({
            "ok": True,
            "message": "Attendance successful!"
        })
    return render(request, "attendance_signup.html")


def attendance_lecturer_otp(request):
    otp = None

    if request.method == "POST":
        otp = f"{random.randint(0, 9999):04d}"
        request.session["attendance_otp"] = otp
    else:
        otp = request.session.get("attendance_otp")

    return render(request, "attendance_lecturer_otp.html", {
        "otp": otp
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
    emails = request.GET.getlist('emails[]')
    existing = User.objects.filter(
        Q(username__in = emails) | Q (email__in = emails)
    )
    
    taken_set = set(existing.values_list('username', flat=True)) | \
                set(existing.values_list('email', flat=True))

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

#manage academic function
def academic_management(request):
    return render(request, "academic_management.html")

@transaction.atomic
def manage_academic_term(request):
    levels = [{'id': c[0], 'name': c[1]} for c in course.LEVEL_CHOICES]
    
    if request.method == 'POST':
        form = AcademicTermForm(request.POST)
        if form.is_valid():
            form.save()

            # LogEntry.objects.log_action(
            #     user_id=request.user.id,
            #     content_type_id=ContentType.objects.get_for_model(academic_term).pk,
            #     object_id=academic_term.pk,
            #     object_repr=str(academic_term),
            #     action_flag=ADDITION,
            #     change_message=f"Created new Academic Term: {academic_term.course}"
            # )

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


def get_terms(request):
    terms = list(academic_term.objects.select_related('course').values(
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

def get_courses_by_level(request):
    level = request.GET.get('level')
    courses = course.objects.filter(level=level).values('course_id', 'course_code',  'course_name', 'semester_week')
    return JsonResponse(list(courses), safe=False)

def map_data(request):
    # Sample graph and POIs for client-side rendering and pathfinding
    # Coordinates are pixel positions for the SVG map (800x600)

    nodes = [
        {"id": "A", "name": "Classroom 1", "type": "terminal", "x": 170, "y": 160},
        {"id": "B", "name": "Classroom 2", "type": "terminal", "x": 263, "y": 160},
        {"id": "C", "name": "Classroom 3", "type": "terminal", "x": 567, "y": 106},
        {"id": "D", "name": "Classroom 4", "type": "terminal", "x": 730, "y": 106},
        {"id": "E", "name": "Classroom 5", "type": "terminal", "x": 567, "y": 220},
        {"id": "F", "name": "Classroom 6", "type": "terminal", "x": 730, "y": 220},
        {"id": "G", "name": "Auditorium 1", "type": "terminal", "x": 471, "y": 288},
        {"id": "H", "name": "Auditorium 2", "type": "terminal", "x": 471, "y": 465},
        {"id": "I", "name": "Lab 1", "type": "terminal", "x": 170, "y": 502},
        {"id": "J", "name": "Lab 2", "type": "terminal", "x": 263, "y": 502},
        {"id": "K", "name": "Cafeteria", "type": "terminal", "x": 395, "y": 288},
        {"id": "Entrance", "name": "Entrance", "type": "terminal", "x": 152, "y": 576},

        {"id": "C1", "name": "C1 Junction", "type": "pathway", "x": 170, "y": 177},
        {"id": "C2", "name": "C2 Junction", "type": "pathway", "x": 263, "y": 177},
        {"id": "U", "name": "Upper Junction", "type": "pathway", "x": 433, "y": 121},
        {"id": "C3", "name": "C3 Junction", "type": "pathway", "x": 567, "y": 121},
        {"id": "C4", "name": "C4 Junction", "type": "pathway", "x": 730, "y": 121},
        {"id": "M", "name": "Mid Junction", "type": "pathway", "x": 433, "y": 235},
        {"id": "LM", "name": "Lower-Mid Junction", "type": "pathway", "x": 433, "y": 288},
        {"id": "A2", "name": "A2 Junction", "type": "pathway", "x": 433, "y": 465},
        {"id": "L", "name": "Lower Junction", "type": "pathway", "x": 433, "y": 526},
        {"id": "LAB2", "name": "Lab 2 Junction", "type": "pathway", "x": 263, "y": 526},
        {"id": "LAB1", "name": "Lab 1 Junction", "type": "pathway", "x": 170, "y": 526},
        {"id": "C5", "name": "C5 Junction", "type": "pathway", "x": 567, "y": 235},
        {"id": "C6", "name": "C6 Junction", "type": "pathway", "x": 730, "y": 235},
        {"id": "C2 Out", "name": "C2 Out Junction", "type": "pathway", "x": 433, "y": 177},
        {"id": "Entrance Junction", "name": "Entrance Junction", "type": "pathway", "x": 152, "y": 526},
    ]

    # Connection edges - create routes through pathway junctions
    edges = [
        # Top row connections
        {"from": "A", "to": "C1"},
        {"from": "C1", "to": "C2"},
        {"from": "C2", "to": "B"},
        {"from": "C2", "to": "C2 Out"},
        {"from": "C2 Out", "to": "U"},
        {"from": "U", "to": "C3"},
        {"from": "C3", "to": "C"},
        {"from": "C3", "to": "C4"},
        {"from": "C4", "to": "D"},
        {"from": "C2 Out", "to": "M"},
        
        # Middle row connections
        {"from": "C5", "to": "E"},
        {"from": "C6", "to": "F"},
        {"from": "M", "to": "U"},
        {"from": "M", "to": "LM"},
        {"from": "C5", "to": "M"},
        {"from": "C6", "to": "M"},
        
        # Cafeteria and Auditorium connections
        {"from": "LM", "to": "K"},
        {"from": "LM", "to": "G"},
        {"from": "A2", "to": "H"},
        
        # Bottom row connections
        {"from": "A2", "to": "LM"},
        {"from": "A2", "to": "L"},
        {"from": "L", "to": "LAB2"},
        {"from": "LAB2", "to": "LAB1"},
        {"from": "LAB1", "to": "L"},
        {"from": "LAB1", "to": "I"},
        {"from": "LAB2", "to": "J"},
        {"from": "Entrance", "to": "Entrance Junction"},
        {"from": "Entrance Junction", "to": "LAB1"},
    ]

    pois = [
        {"id": "lib", "name": "Library", "node": "A", "description": "Main library facility"},
        {"id": "admin", "name": "Administration", "node": "B", "description": "Admin offices"},
        {"id": "caf", "name": "Cafeteria", "node": "K", "description": "Food and beverage"},
        {"id": "gym", "name": "Gym", "node": "I", "description": "Sports center"},
    ]

    data = {"nodes": nodes, "edges": edges, "pois": pois}
    return JsonResponse(data)

def announcements(request): 
    return render(request, "dashboards/announcements.html")