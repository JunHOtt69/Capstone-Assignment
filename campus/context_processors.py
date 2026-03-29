import barcode
from barcode import get_barcode
from barcode.writer import ImageWriter
import io
import base64
from datetime import datetime
from django.conf import settings
from django.utils import timezone
from django.contrib.auth.models import User
from .models import announcement, announcementTarget, class_session, SubjectComponent, AttendanceSession, AttendanceMark
import pytz

def card_context(request):
    u = getattr(request, 'user', None)
    if not u or not u.is_authenticated:
        return {}
    
    role = None
    card_id = None
    barcode_base64 = None
    extra_info = None

    group_names = set(u.groups.values_list('name', flat=True))
    try: 
        if any('admin' in g.lower() for g in group_names) and hasattr(u, 'admin_profile'):
            role = 'admin'
            card_id = u.admin_profile.ad_id

        elif any('lecturer' in g.lower() for g in group_names) and hasattr(u, 'lecturer_profile'):
            role = 'lecturer'
            prof = u.lecturer_profile
            card_id = prof.lc_id

            if prof.dept:
                department_name = prof.dept.dept_name
                is_head = getattr(prof, 'is_head', False)
                extra_info = f"Head of department of {department_name}" if is_head else department_name
            else:
                extra_info = "N/A"
            
        elif any('student' in g.lower() for g in group_names) and hasattr(u, 'student_profile'):
            role = 'student'
            card_id = u.student_profile.tp_id
            term = u.course_enrollment.term.intake_code
            course = u.course_enrollment.term.course.course_name
            extra_info = {
                'term' : term if term else 'N/A',
                'course' : course if course else 'N/A',
            }

        if card_id:
            code128 = barcode.get_barcode_class('code128')
            buffer = io.BytesIO()

            options = {
                'module_height': 5.0,
                'module_width': 0.25,
                'quiet_zone': 1.0,
                'font_size': 10,
                'text_distance': 4.0,
                'write_text': False
            }

            barcode_instance = code128(str(card_id), writer= ImageWriter())
            barcode_instance.write(buffer, options=options)

            base64_str = base64.b64encode(buffer.getvalue()).decode('utf-8')
            barcode_base64 = f"data:image/png;base64,{base64_str}"
    except Exception as e:
        print(f"Barcode error: {e}")
    
    return {
        'user_role': role,
        'card_id' : card_id,
        'user_barcode' : barcode_base64 if barcode_base64 else None,
        'extra_info' : extra_info
    }

def announcement_banner(request):
    user = request.user
    
    recent_banners = announcement.objects.filter(
        announcement_type='BANNER',
        is_active=True,
        date_published__lte=timezone.now()
    ).order_by('-date_published')

    recent_news = announcement.objects.filter(
        announcement_type='NORMAL',
        is_active=True,
        date_published__lte=timezone.now()
    ).only(
        'subject', 
        'content', 
        'date_published'
    ).order_by('-date_published')[:2]

    for banner in recent_banners:
        target = announcementTarget.objects.filter(announcement=banner).first()
        if not target: continue
        show_this_one = False

        if not user.is_authenticated and target.is_visitor_visible:
            show_this_one = True

        if hasattr(user, 'admin_profile') and target.is_for_admins:
            show_this_one = True
            
        elif hasattr(user, 'lecturer_profile') and target.is_for_lecturer:
            show_this_one = True
            
        elif hasattr(user, 'student_profile'):
            if target.is_for_students:
                show_this_one = True

            elif target.academic_term:
                student_intake = str(user.course_enrollment.term.term_id)
                allowed_intakes = target.academic_term.split(',')
                if student_intake in allowed_intakes:
                    show_this_one = True

        if show_this_one:
            return {
                "recent_news": recent_news,
                "rolling_banner": banner, }
        
    return {"recent_news": recent_news, "rolling_banner": None}


def closest_attendance_session(request):
    if request.user.is_authenticated and request.user.groups.filter(name="lecturer").exists():
        now = timezone.now()
        
        malaysia_tz = pytz.timezone('Asia/Kuala_Lumpur')
        now_local = now.astimezone(malaysia_tz)
        
        current_time = now_local.time() 
        today = now_local.date()

        active_event = class_session.objects.filter(
            lecturer=request.user,
            date=today,
            status='scheduled',
            session__start_time__lte=current_time, 
            session__end_time__gte=current_time 
        ).select_related('session').first()

        return {
            'closest_class_event': active_event
        }
    
    return {'closest_class_event': None}

def today_schedule(request):
    u = getattr(request, 'user', None)
    if not u or not u.is_authenticated:
        return {'classList': []}

    if getattr(settings, 'DEBUG_DATE', None):
        today = datetime.strptime(settings.DEBUG_DATE, '%Y-%m-%d').date()
    else:
        today = timezone.localdate()

    if hasattr(u, 'student_profile') and hasattr(u, 'course_enrollment'):
        sessions = class_session.objects.filter(
            term=u.course_enrollment.term,
            date=today,
            status='scheduled',
        ).select_related(
            'session__facility', 'subject_component__subject'
        ).order_by('session__start_time')
        is_student=True
    elif hasattr(u, 'lecturer_profile'):
        sessions = class_session.objects.filter(
            lecturer=u,
            date=today,
            status='scheduled',
        ).select_related(
            'session__facility', 'subject_component__subject'
        ).order_by('session__start_time')
        is_student=False
    else:
        return {'classList': []}

    attendance_rate = 0
    att_color = None 
    class_list = []
    for cs in sessions:
        start = cs.session.start_time.strftime('%I:%M %p')
        end = cs.session.end_time.strftime('%I:%M %p')

        if is_student:
            target_subject = cs.subject_component.subject
            student_term = u.course_enrollment.term
            
            all_subject_components = SubjectComponent.objects.filter(subject=target_subject)
            
            total_held_sessions = AttendanceSession.objects.filter(
                class_event__term=student_term,
                class_event__subject_component__in=all_subject_components
            ).count()
            
            if total_held_sessions > 0:
                present_count = AttendanceMark.objects.filter(
                    student=u,
                    session__class_event__term=student_term,
                    session__class_event__subject_component__in=all_subject_components,
                    status__in=['PRESENT', 'LATE']
                ).count()
                
                rate = (present_count / total_held_sessions) * 100
                attendance_rate = f"{round(rate, 1)}%"
                att_color = 'danger' if rate < 80 else 'success'
            else:
                attendance_rate = "New Subject"
                att_color = 'new'

        else:
            target_subject = cs.subject_component.subject
            all_subject_components = SubjectComponent.objects.filter(subject=target_subject)

            held_sessions = AttendanceSession.objects.filter(
                lecturer=u,
                class_event__subject_component__in=all_subject_components
            )

            total_sessions_count = held_sessions.count()

            if total_sessions_count > 0:
                enrolled_count = User.objects.filter(
                    groups__name="student",
                    course_enrollment__term=cs.term
                ).count()

                total_possible_marks = total_sessions_count * enrolled_count

                if total_possible_marks > 0:
                    actual_present_count = AttendanceMark.objects.filter(
                        session__in=held_sessions,
                        status__in=['PRESENT', 'LATE']
                    ).count()

                    rate_val = (actual_present_count / total_possible_marks) * 100
                    attendance_rate = f"{round(rate_val, 1)}%"
                    att_color = "danger" if rate_val < 80 else "success"
            else:
                attendance_rate = "No Sessions Yet"
                att_color = "neutral"

        class_list.append({
            'class_time': f"{start} - {end}",
            'class_code': cs.subject_component.subject.subject_code,
            'classroom': cs.session.facility.facility_name,
            'attendance_rate': attendance_rate,
            'att_color': att_color,
        })

    return {'classList': class_list}