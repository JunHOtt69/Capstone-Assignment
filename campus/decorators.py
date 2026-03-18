# from django.core.exceptions import PermissionDenied
from django.shortcuts import redirect
from django.http import JsonResponse
from functools import wraps

def _is_ajax(request):
    return request.headers.get('X-Requested-With') == 'XMLHttpRequest' or \
           request.content_type == 'application/json'

def role_required(allowed_roles = []):
    def decorator(view_func):
        @wraps(view_func)
        def _wrapped_view(request, *args, **kwargs):
            if not request.user.is_authenticated:
                if _is_ajax(request):
                    return JsonResponse({'error': 'Authentication required'}, status=401)
                return redirect('login')
            
            if request.user.groups.filter(name__in = allowed_roles).exists():
                return view_func(request, *args, **kwargs)
            # else:
            #     raise PermissionDenied

            if _is_ajax(request):
                return JsonResponse({'error': 'Permission denied'}, status=403)

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