#returning card ID
def card_context(request):
    u = getattr(request, 'user', None)
    if not u or not u.is_authenticated:
        return {}
    
    role = None
    card_id = None

    group_names = set(u.groups.values_list('name', flat=True))

    try: 
        if any('admin' in g.lower() for g in group_names) and hasattr(u, 'admin_profile'):
            role = 'admin'
            card_id = u.admin_profile.ad_id
        elif any('lecturer' in g.lower() for g in group_names) and hasattr(u, 'lecturer_profile'):
            role = 'lecturer'
            card_id = u.lecturer_profile.lc_id
        elif any('student' in g.lower() for g in group_names) and hasattr(u, 'student_profile'):
            role = 'student'
            card_id = u.student_profile.tp_id
    except Exception:
        pass
    
    return {
        'user_role': role,
        'card_id' : card_id
    }