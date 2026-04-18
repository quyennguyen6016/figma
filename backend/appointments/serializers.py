from rest_framework import serializers

from .models import Appointment


class AppointmentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Appointment
        fields = (
            'id',
            'patient',
            'doctor',
            'patient_name',
            'patient_age',
            'patient_gender',
            'doctor_name',
            'specialty',
            'appointment_date',
            'appointment_time',
            'appointment_type',
            'medical_note',
            'status',
            'created_at',
        )
        read_only_fields = ('created_at',)
        extra_kwargs = {
            'patient': {'required': False, 'allow_null': True},
            'doctor': {'required': False, 'allow_null': True},
        }
