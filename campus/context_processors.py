import barcode
from barcode import get_barcode
from barcode.writer import ImageWriter
import io
import base64

#returning card ID
def card_context(request):
    u = getattr(request, 'user', None)
    if not u or not u.is_authenticated:
        return {}
    
    role = None
    card_id = None
    barcode_base64 = None
    extra_info = None

    group_names = set(u.groups.values_list('name', flat=True))
    print('hello1')
    try: 
        if any('admin' in g.lower() for g in group_names) and hasattr(u, 'admin_profile'):
            role = 'admin'
            card_id = u.admin_profile.ad_id
        elif any('lecturer' in g.lower() for g in group_names) and hasattr(u, 'lecturer_profile'):
            role = 'lecturer'
            card_id = u.lecturer_profile.lc_id
            department = u.lecturer_profile.dept_id.dept_name if u.lecturer_profile.dept_id else 'N/A'
            extra_info = f"Head of department of {department}" if u.lecturer_profile.is_head else department
        elif any('student' in g.lower() for g in group_names) and hasattr(u, 'student_profile'):
            role = 'student'
            card_id = u.student_profile.tp_id
            term = u.course_enrollment.term_id.intake_code
            course = u.course_enrollment.term_id.course_id.course_name
            extra_info = {
                'term' : term if term else 'N/A',
                'course' : course if course else 'N/A',
            }

        if card_id:
            code128 = barcode.get_barcode_class('code128')
            buffer = io.BytesIO()

            options = {
                'module_height': 5.0,    # Default is 15.0 (Shorter height)
                'module_width': 0.25,    # Increase this to make it wider 
                'quiet_zone': 1.0,       # Margin on the sides
                'font_size': 10,         # Size of the text under the bars
                'text_distance': 4.0,    # Space between bars and text
                'write_text': False       # Set to False if you want bars ONLY
            }

            barcode_instance = code128(str(card_id), writer= ImageWriter())
            barcode_instance.write(buffer, options=options)

            base64_str = base64.b64encode(buffer.getvalue()).decode('utf-8')
            barcode_base64 = f"data:image/png;base64,{base64_str}"
            print('hello')
            print('barcode = ', barcode_base64)
    except Exception as e:
        print(f"Barcode error: {e}")
    
    return {
        'user_role': role,
        'card_id' : card_id,
        'user_barcode' : barcode_base64 if barcode_base64 else None,
        'extra_info' : extra_info
    }