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
from django.conf import settings
import os
import uuid
import datetime
import random
import json
from .forms import UserRowForm, AcademicTermForm, newFAQForm
from .models import course, academic_term, academic_rules, departments, lecturer_profiles, course_enrollment, admin_profiles, student_profiles, MapNode, MapEdge, faq
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
            return JsonResponse({"nodes": [], "edges": []})
        
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
        
        data = {"nodes": nodes_list, "edges": edges_list}
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
        
        return messages.success(request, "Map saved successfully!")
    except Exception as e:
        return JsonResponse({"error": str(e)}, status=400)
    
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
def manage_faq(request): 
    context = {
        'form': newFAQForm()
    }
    return render(request, "help/manage_faq.html", context)

@role_required(allowed_roles=['admin'])
def config_bot(request): 
    return render(request, "help/config_bot.html")

@role_required(allowed_roles=['admin'])
def system_log(request): 
    return render(request, "help/system_log.html")
