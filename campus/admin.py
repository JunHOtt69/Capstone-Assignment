from django.contrib import admin
from .models import facilities, booking, timetable_preference, lecturer_assignment, skipped_date
# Register your models here.

admin.site.register(facilities)
admin.site.register(booking)
admin.site.register(timetable_preference)
admin.site.register(lecturer_assignment)
admin.site.register(skipped_date)