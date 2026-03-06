from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion
from django.utils import timezone


class Migration(migrations.Migration):

    dependencies = [
        ("campus", "0004_departments_head_alter_admin_profiles_user_and_more"),
    ]

    operations = [
        migrations.CreateModel(
            name="AttendanceSession",
            fields=[
                ("id", models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name="ID")),
                ("otp", models.CharField(max_length=4)),
                ("created_at", models.DateTimeField(default=timezone.now)),
                ("expires_at", models.DateTimeField()),
                ("is_active", models.BooleanField(default=True)),
                ("created_by", models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name="created_attendance_sessions", to=settings.AUTH_USER_MODEL)),
            ],
        ),
        migrations.CreateModel(
            name="AttendanceMark",
            fields=[
                ("id", models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name="ID")),
                ("status", models.CharField(choices=[("PRESENT", "Present"), ("LATE", "Late")], max_length=10)),
                ("marked_at", models.DateTimeField(default=timezone.now)),
                ("session", models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name="marks", to="campus.attendancesession")),
                ("student", models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name="attendance_marks", to=settings.AUTH_USER_MODEL)),
            ],
            options={
                "unique_together": {("session", "student")},
            },
        ),
    ]