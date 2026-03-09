from django.shortcuts import render, redirect
from django.template.loader import render_to_string
from django.http import JsonResponse
from django.db import transaction
from django.db.models import Q
from django.core.mail import EmailMultiAlternatives
from django.core.files.base import ContentFile
from django.utils.encoding import force_bytes
from django.utils import timezone
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
from django.conf import settings
from datetime import timedelta
from bs4 import BeautifulSoup
import os
import uuid
import datetime
import random
import json
import base64
from .forms import UserRowForm, AcademicTermForm, newFAQForm
from .models import course, academic_term, academic_rules, departments, lecturer_profiles, course_enrollment, admin_profiles, student_profiles, MapNode, MapEdge, faq, AttendanceSession, AttendanceMark, attachments
from .decorators import role_required

#playground
def testing(request):
    return render(request, 'testing.html')

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
    return render(request, "attendance.html")

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

@role_required(allowed_roles=['admin'])  
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

@role_required(allowed_roles=['admin'])
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
        return JsonResponse({"url": url})
    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)

#announcement function
def announcements(request): 
    return render(request, "dashboards/announcements.html")


#FAQ function
def help(request): 
    return render(request, "help/help.html")

def viewFAQ(request):
    return render(request, 'help/faq.html')

@role_required(allowed_roles=['admin', 'lecturer', 'student'])
def support_center(request):
    return render(request, 'help/support_center.html')

@role_required(allowed_roles=['lecturer', 'student'])
def smart_assistant(request):
    return render(request, 'help/smart_assistant.html')

@role_required(allowed_roles=['admin'])
def review_feedback(request): 
    return render(request, "help/review_feedback.html")

@role_required(allowed_roles=['lecturer', 'student'])
def submit_feedback(request): 
    return render(request, "help/submit_feedback.html")

@role_required(allowed_roles=['admin'])
@transaction.atomic
def edit_faq(request): 
    if request.method == "POST":
        form = newFAQForm(request.POST)
        if form.is_valid():
            new_faq = form.save(commit=False)
            new_faq.author = request.user.admin_profile 
            new_faq.save()

            soup = BeautifulSoup(new_faq.content, 'html.parser')
            images = soup.find_all('img')
            images_processed = False

            for img in images: 
                src = img.get('src', '')

                if src.startswith('data:image'):
                    try: 
                        format, imgstr = src.split(';base64,')
                        ext = format.split('/')[-1]
                        
                        # Create a unique filename for the media folder
                        filename = f"faq_{new_faq.id}_{uuid.uuid4().hex[:8]}.{ext}"
                        data = ContentFile(base64.b64decode(imgstr), name=filename)

                        # 3. Create record in your attachments model
                        new_attachment = attachments.objects.create(
                            content_type=ContentType.objects.get_for_model(new_faq),
                            object_id=new_faq.id,
                            file=data
                        )

                        # 4. Replace the Base64 source with the new media URL
                        img['src'] = new_attachment.file.url
                        images_processed = True
                    except Exception as e:
                        print(f"Error processing image: {e}")
                        continue
            
            if images_processed:
                new_faq.content = str(soup)
                new_faq.save()

            messages.success(request, "FAQ saved successfully!")
            return redirect('viewFAQ')
        else:
            messages.error(request, "There was an error saving the FAQ. Please check all the fields")
    else:
        form = newFAQForm()
        
    context = {
        'form': form,
    }

    return render(request, "help/edit_faq.html", context)

@role_required(allowed_roles=['admin'])
def config_bot(request): 
    return render(request, "help/config_bot.html")

@role_required(allowed_roles=['admin'])
def system_log(request): 
    return render(request, "help/system_log.html")


#extract and store image
def extract_and_save_images(faq_instance):
    soup = BeautifulSoup(faq_instance.content, 'html.parser')
    images = soup.find_all('img')
    
    for img in images:
        src = img.get('src', '')
        if src.startswith('data:image'):
            # 1. Parse the Base64 string
            format, imgstr = src.split(';base64,') 
            ext = format.split('/')[-1] 
            data = ContentFile(base64.b64decode(imgstr), name=f"faq_img.{ext}")

            # 2. Save to your attachments model
            attachment = attachments.objects.create(
                content_type=ContentType.objects.get_for_model(faq_instance),
                object_id=faq_instance.id,
                file=data
            )

            # 3. Replace Base64 with the actual file URL
            img['src'] = attachment.file.url

    # Update the FAQ content with new cleaned HTML
    faq_instance.content = str(soup)
    faq_instance.save()