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