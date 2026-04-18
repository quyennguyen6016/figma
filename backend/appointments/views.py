import datetime

from rest_framework import status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response

from .models import Appointment
from .serializers import AppointmentSerializer


def _normalize_appointment_payload(payload):
    if not isinstance(payload, dict):
        return payload

    mapping = {
        'patientName': 'patient_name',
        'patientAge': 'patient_age',
        'patientGender': 'patient_gender',
        'doctorName': 'doctor_name',
        'appointmentDate': 'appointment_date',
        'appointmentTime': 'appointment_time',
        'appointmentType': 'appointment_type',
        'medicalNote': 'medical_note',
        'createdAt': 'created_at',
    }

    data = dict(payload)
    for camel_key, snake_key in mapping.items():
        if camel_key in data and snake_key not in data:
            data[snake_key] = data.pop(camel_key)
    return data


def _parse_birth_date(value):
    if not value:
        return None

    if hasattr(value, 'year'):
        return value

    try:
        return datetime.date.fromisoformat(str(value))
    except ValueError:
        pass

    parts = str(value).split('/')
    if len(parts) != 3:
        return None

    try:
        day = int(parts[0])
        month = int(parts[1])
        year = int(parts[2])
        return datetime.date(year, month, day)
    except ValueError:
        return None


def _calculate_age(birth_date):
    if birth_date is None:
        return None

    today = datetime.date.today()
    years = today.year - birth_date.year
    if (today.month, today.day) < (birth_date.month, birth_date.day):
        years -= 1
    return years if years >= 0 else None


def _gender_label(raw_gender):
    mapping = {
        'male': 'Nam',
        'female': 'Nữ',
        'other': 'Khác',
    }
    normalized = (raw_gender or '').strip().lower()
    return mapping.get(normalized, (raw_gender or '').strip())


def _missing_profile_fields(user):
    missing = []
    if not getattr(user, 'full_name', '').strip():
        missing.append('full_name')
    if not getattr(user, 'date_of_birth', None):
        missing.append('date_of_birth')
    if not getattr(user, 'gender', '').strip():
        missing.append('gender')
    if not getattr(user, 'phone_number', '').strip():
        missing.append('phone_number')
    if not getattr(user, 'insurance_number', '').strip():
        missing.append('insurance_number')
    if not getattr(user, 'address', '').strip():
        missing.append('address')
    return missing


@api_view(['GET', 'POST'])
@permission_classes([IsAuthenticated])
def appointment_list_create(request):
    if request.method == 'GET':
        queryset = Appointment.objects.all().order_by('-created_at')
        serializer = AppointmentSerializer(queryset, many=True)
        return Response(serializer.data)

    missing_fields = _missing_profile_fields(request.user)
    if missing_fields:
        return Response(
            {
                'detail': 'Hồ sơ bệnh nhân chưa đầy đủ.',
                'missing_fields': missing_fields,
            },
            status=status.HTTP_400_BAD_REQUEST,
        )

    payload = _normalize_appointment_payload(request.data)
    birth_date = _parse_birth_date(getattr(request.user, 'date_of_birth', None))
    patient_age = _calculate_age(birth_date)

    payload['patient'] = request.user.pk
    payload['patient_name'] = getattr(request.user, 'full_name', '').strip()
    payload['patient_age'] = patient_age or 0
    payload['patient_gender'] = _gender_label(getattr(request.user, 'gender', ''))
    serializer = AppointmentSerializer(data=payload)
    serializer.is_valid(raise_exception=True)
    serializer.save()
    return Response(serializer.data, status=status.HTTP_201_CREATED)


@api_view(['PATCH', 'DELETE'])
@permission_classes([IsAuthenticated])
def appointment_update_delete(request, pk):
    try:
        appointment = Appointment.objects.get(pk=pk)
    except Appointment.DoesNotExist:
        return Response({'detail': 'Not found'}, status=status.HTTP_404_NOT_FOUND)

    if request.method == 'PATCH':
        payload = _normalize_appointment_payload(request.data)
        serializer = AppointmentSerializer(appointment, data=payload, partial=True)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(serializer.data)

    appointment.delete()
    return Response(status=status.HTTP_204_NO_CONTENT)
