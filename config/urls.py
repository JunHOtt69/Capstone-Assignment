"""
URL configuration for demo project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/6.0/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import include, path
from django.contrib.auth import views as auth_views
from campus.forms import CustomSetPasswordForm, CustomLoginForm, CustomPasswordResetForm  # adjust import
from campus.views import RoleBasedLoginView

urlpatterns = [
    path('admin/', admin.site.urls),
    path("", include("campus.urls")),
    path('accounts/login/', 
        RoleBasedLoginView.as_view(authentication_form=CustomLoginForm),
        name='login',
        ),

    path('accounts/password_reset/', auth_views.PasswordResetView.as_view(
        template_name='registration/password_reset_form.html',
        form_class=CustomPasswordResetForm
    ), name='password_reset'),

    path(
        "accounts/reset/<uidb64>/<token>/",
        auth_views.PasswordResetConfirmView.as_view(
            template_name="registration/password_reset_confirm.html",
            form_class=CustomSetPasswordForm,
        ),
        name="password_reset_confirm",
    ),
    path("accounts/", include("django.contrib.auth.urls")),
]