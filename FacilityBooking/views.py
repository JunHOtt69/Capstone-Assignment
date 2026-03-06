from django.shortcuts import render

def booking_home(request):
    return render(request, 'FacilityBooking/Booking.html')