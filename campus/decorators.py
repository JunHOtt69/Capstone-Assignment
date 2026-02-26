# from django.core.exceptions import PermissionDenied
from django.shortcuts import redirect

def role_required(allowed_roles = []):
    def decorator(view_func):
        def _wrapped_view(request, *args, **kwargs):
            if not request.user.is_authenticated:
                return redirect('login')
            
            if request.user.groups.filter(name__in = allowed_roles).exists():
                return view_func(request, *args, **kwargs)
            # else:
            #     raise PermissionDenied

            user_groups = request.user.groups.values_list('name', flat=True)

            if 'admin' in user_groups:
                return redirect('admin_dashboard')
            elif 'lecturer' in user_groups:
                return redirect('lecturer_dashboard')
            elif 'student' in user_groups:
                return redirect('student_dashboard')
            
            return redirect('login')
        return _wrapped_view
    return decorator