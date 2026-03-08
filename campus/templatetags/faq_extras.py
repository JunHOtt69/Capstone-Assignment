from django import template

register = template.Library()

@register.filter(name='cool_number')
def cool_number(value):
    try:
        value = float(value)
    except (ValueError, TypeError):
        return value

    if value >= 1000000:
        return f"{value / 1000000:.1f}m".replace('.0m', 'm')
    if value >= 1000:
        return f"{value / 1000:.1f}k".replace('.0k', 'k')
    return int(value)