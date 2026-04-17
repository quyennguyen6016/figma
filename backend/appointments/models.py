from django.conf import settings
from django.db import models


class Appointment(models.Model):
    id = models.CharField(primary_key=True, max_length=64)
    patient = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.SET_NULL,
        related_name='patient_appointments',
        null=True,
        blank=True,
    )
    doctor = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.SET_NULL,
        related_name='doctor_appointments',
        null=True,
        blank=True,
    )
    patient_name = models.CharField(max_length=255)
    patient_age = models.IntegerField()
    patient_gender = models.CharField(max_length=20)
    doctor_name = models.CharField(max_length=255)
    specialty = models.CharField(max_length=255)
    appointment_date = models.CharField(max_length=50)
    appointment_time = models.CharField(max_length=50)
    appointment_type = models.CharField(max_length=100)
    medical_note = models.TextField(blank=True, default='')
    status = models.CharField(max_length=40, default='cho kham')
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f'{self.id} - {self.patient_name} - {self.doctor_name}'
