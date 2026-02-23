from django.shortcuts import render, HttpResponse, redirect
from django.template.loader import render_to_string
from django.http import JsonResponse
from django.contrib.auth import authenticate, login as auth_login
from django.contrib import messages
from django.db import transaction
from django.contrib.admin.models import LogEntry, ADDITION
from django.contrib.contenttypes.models import ContentType

from .forms import LoginForm, PasswordResetRequestForm, PasscordVerificationForm, SetNewPasswordForm, UserRowForm, AcademicTermForm
from .models import course, academic_term, academic_rules, departments


# Create your views here.

def home(request): 
    return render(request, "home.html")

def about(request): 
    return render(request, "about.html")

def help(request): 
    return render(request, "help.html")

def login(request): 
    if request.method == "POST":
        form = LoginForm(request.POST)
        if form.is_valid():
            email = form.cleaned_data.get('email')
            password = form.cleaned_data.get('password')

            user = authenticate(request, username=email, password=password)

            if user is not None:
                auth_login(request, user)

                if not request.POST.get('remember_me'):
                    request.session.set_expiry(0)
                
                if user.groups.filter(name = 'admin').exists():
                    return redirect('admin_dashboard')
                elif user.groups.filter(name = 'admin').exists():
                    return redirect('lecturer_dashboard')
                else:
                    return redirect('student_dashboard')
            else:
                messages.error(request, "Invalid email or password.")
    else: 
        form = LoginForm()
    return render(request, "partials/login.html", {"form": form})

def password_reset_view(request, step=1):
    if step == 1:
        form = PasswordResetRequestForm()
        template = "partials/step1_form.html"
    elif step == 2:
        form = PasscordVerificationForm()
        template = "partials/step2_form.html"
    elif step == 3:
        form = SetNewPasswordForm()
        template = "partials/step3_form.html"
    
    if request.headers.get('x-requested-with') == 'XMLHttpRequest':
        html = render_to_string(template, {'form': form}, request=request)
        return JsonResponse({'html': html})
    
    # Fallback for direct page load
    return render(request, template, {"form": form})

def navigation(request): 
    return render(request, "navigation.html")

def attendance(request): 
    return render(request, "attendance.html")

def user_management(request):
    return render(request, "user_management.html")

def create_user_manually(request):
    dept = list(departments.objects.values('dept_id', 'dept_name'))
    available_term = list(academic_term.objects.values('term_id', 'intake_code').order_by('-start_date'))
    form = UserRowForm()

    context = {
        "dept" : dept,
        "available_term" : available_term,
        "form": form,
    }
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
        else: print(form.errors)
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