from django import template
from django.utils import timezone
from datetime import timedelta

register = template.Library()

@register.filter
def smart_date(value):
    now = timezone.now().date()
    if value.date() == now:
        return "Today"
    elif value.date() == now - timedelta(days=1):
        return "Yesterday"
    else:
        return value.strftime("%d %b %Y")

@register.filter
def smart_time(value):
    now = timezone.now()
    diff = now - value

    if diff < timedelta(minutes=1):
        return "Just now"
    if diff < timedelta(hours=1):
        return f"{diff.seconds // 60} minutes ago"
    if diff < timedelta(days=1):
        return f"{diff.seconds // 3600} hours ago"
    if diff < timedelta(days=7):
        return f"{diff.days} days ago"
    
    return value.strftime("%d %b %Y")