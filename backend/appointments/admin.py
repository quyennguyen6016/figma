from django.contrib import admin

from .models import Appointment


@admin.register(Appointment)
class AppointmentAdmin(admin.ModelAdmin):
    list_display = ('id', 'patient_name', 'doctor_name', 'status', 'appointment_date', 'appointment_time')
    search_fields = ('id', 'patient_name', 'doctor_name', 'specialty')
    list_filter = ('status', 'specialty')
