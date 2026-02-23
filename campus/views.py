from django.shortcuts import render, HttpResponse, redirect
from django.template.loader import render_to_string
from django.http import JsonResponse
from django.contrib.auth import authenticate, login as auth_login
from django.contrib import messages
from django.db import transaction
from django.contrib.admin.models import LogEntry, ADDITION
from django.contrib.contenttypes.models import ContentType
from django.db.models import Q
from django.core.mail import send_mail
from django.contrib.auth.tokens import default_token_generator
from django.utils.encoding import force_bytes
from django.utils.http import urlsafe_base64_encode
from django.urls import reverse
import secrets
import string

from django.contrib.auth.models import User, Group
from .forms import UserRowForm, AcademicTermForm
from .models import course, academic_term, academic_rules, departments, lecturer_profiles, course_enrollment


# Create your views here.

def home(request): 
    return render(request, "home.html")

def about(request): 
    return render(request, "about.html")

def help(request): 
    return render(request, "help.html")

def navigation(request): 
    return render(request, "navigation.html")

def attendance(request): 
    return render(request, "attendance.html")

def user_management(request):
    return render(request, "user_management.html")

def build_set_password_link(request, user):
    uidb64 = urlsafe_base64_encode(force_bytes(user.pk))
    token = default_token_generator.make_token(user)
    path = reverse("password_reset_confirm", kwargs = {"uidb64": uidb64, "token": token})
    return request.build_absolute_uri(path)

# def generate_random_password(length=15):
    #generate a random password in a length of 15 characters
    alphabet = string.ascii_letters + string.digits + string.punctuation
    return ''.join(secrets.choice(alphabet) for i in range(length))

def check_email_exists(request):
    emails = request.GET.getlist('emails[]')
    existing = User.objects.filter(
        Q(username__in = emails) | Q (email__in = emails)
    )
    
    taken = list(
        existing.values_list('username', flat=True)
    )

    taken = [e for e in emails if e in taken] or list(existing.values_list('email', flat=True))
    
    return JsonResponse({
        'is_taken' : existing.exists(),
        'taken_emails' : list(set(taken)),
    })

def create_user_manually(request):
    groups = {g.name: g.id for g in Group.objects.filter(name__in=['admin', 'lecturer', 'student'])}
    dept = list(departments.objects.values('dept_id', 'dept_name'))
    available_term = list(academic_term.objects.values('term_id', 'intake_code').order_by('-start_date'))
    
    context = {
        "groups" : groups,
        "dept" : dept,
        "available_term" : available_term,
        "form":  None,
    }

    if request.method == 'POST':
        context["form"] = UserRowForm(request.POST)
        first_names = request.POST.getlist('first_name')
        last_names = request.POST.getlist('last_name')
        emails = request.POST.getlist('email')
        role_id = request.POST.get('user_role')
        
        try:
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
                    
                    new_user.set_unusable_password()
                    new_user.save()

                    #schedule email after transaction succeeds
                    def send_invite(to_email = email, first_name = first_names[i], user_id = new_user.id):
                        user = User.objects.get(id=user_id)
                        link = build_set_password_link(request, user)
                        send_mail(
                            subject = 'Set your Smart Campus password',
                            message = (
                                f"Hi {first_name},\n\n"
                                f"Your Smart Campus account has been created.\n"
                                f"Login email: {to_email}\n"
                                f"Set your password here: {link}\n\n"
                                f"If you didn\'t request this, you can ignore this email."
                            ),
                            from_email=None,
                            recipient_list = [to_email],
                            fail_silently = False,
                        )
                        print('SET PASSWORD LINK:', link)
                    transaction.on_commit(send_invite)

                    if str(role_id) == str(groups.get('admin')):
                        new_user.is_staff = True

                        new_user.save()
                    
                    group = Group.objects.get(id=role_id)
                    new_user.groups.add(group)

                    if str(role_id) == str(groups.get('lecturer')):
                        dept_val = request.POST.get(f'department_{i+1}')
                        new_user.is_staff = True
                        lecturer_profiles.objects.create(
                            # passing the user object, instead of the id, because the id is automatically incremented, django will handle the id extraction
                            user = new_user,
                            dept_id = dept_val if dept_val else None
                        )

                    elif str(role_id) == str(groups.get('student')):
                        term_val = request.POST.get(f'term_{i+1}')
                        course_enrollment.objects.create(
                            student = new_user,
                            term_id = term_val,
                            enrollment_status = 'Active'
                        )

            messages.success(request, f'Successfully created {len(first_names)} user(s)!')

            return redirect('create_user_manually')
        
        except Exception as e:
            # If anything fails, print to console and show error to user
            print(f"Error during user creation: {e}")
            messages.error(request, f"An error occurred: {str(e)}")

    else: context["form"] = UserRowForm()

    return render(request, "partials/create_user_manually.html", context)

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

    # nodes need to figure out how to import from database, so i am not hard coding
    nodes = [
        {"id": "A", "name": "Classroom 1", "type": "classroom", "x": 170, "y": 151},
        {"id": "B", "name": "Administration Building", "type": "office", "x": 300, "y": 120},
        {"id": "C", "name": "Library", "type": "academic", "x": 480, "y": 100},
        {"id": "D", "name": "Auditorium 1", "type": "academic", "x": 150, "y": 300},
        {"id": "E", "name": "Cafeteria / Student Hub", "type": "facility", "x": 350, "y": 320},
        {"id": "F", "name": "Science & Computer Labs", "type": "academic", "x": 540, "y": 310},
        {"id": "G", "name": "Sports Complex", "type": "recreation", "x": 260, "y": 480},
        {"id": "H", "name": "Student Hostel", "type": "residence", "x": 460, "y": 480}
    ]

    edges = [
        {"from": "A", "to": "B"},
        {"from": "B", "to": "C"},
        {"from": "A", "to": "D"},
        {"from": "B", "to": "E"},
        {"from": "C", "to": "F"},
        {"from": "D", "to": "E"},
        {"from": "E", "to": "F"},
        {"from": "D", "to": "G"},
        {"from": "E", "to": "G"},
        {"from": "E", "to": "H"},
        {"from": "F", "to": "H"},
        {"from": "G", "to": "H"}
    ]

    pois = [
        {"id": "lib", "name": "Library", "node": "A", "description": "Main library"},
        {"id": "admin", "name": "Administration", "node": "C", "description": "Admin offices"},
        {"id": "caf", "name": "Cafeteria", "node": "E", "description": "Food and coffee"},
        {"id": "gym", "name": "Gym", "node": "G", "description": "Sports center"}
    ]

    data = {"nodes": nodes, "edges": edges, "pois": pois}
    return JsonResponse(data)