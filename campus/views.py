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
from django.core.mail import EmailMultiAlternatives
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

                        subject = "Set your Smart Campus password"
                        from_email=None
                        to = [to_email]
                        
                        html_content = render_to_string(
                            'emails/set_password_email.html',
                            {
                                "first_name" : first_name,
                                "reset_link": link,
                            },
                        )
                        text_content = f"""
                    Hi{first_name},
                    Your Smart Campus account has been created

                    Set your password here:
                    {link}

                    If you didn't request this, ignore this email.
                    """
                        msg = EmailMultiAlternatives(subject, text_content, from_email, to)
                        msg.attach_alternative(html_content, "text/html")
                        msg.send()

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