from rest_framework import serializers
from .models import Appointment, Specialty, DoctorSchedule, DoctorDayOff
from accounts.models import User

# 1. Serializer cho Chuyên khoa (Dữ liệu động thay vì hard-code)
class SpecialtySerializer(serializers.ModelSerializer):
    class Meta:
        model = Specialty
        fields = '__all__'

# 2. Serializer cho Lịch làm việc của bác sĩ
class DoctorScheduleSerializer(serializers.ModelSerializer):
    day_name = serializers.CharField(source='get_day_of_week_display', read_only=True)

    class Meta:
        model = DoctorSchedule
        fields = ['id', 'doctor', 'day_of_week', 'day_name', 'start_time', 'end_time', 'is_active']

# 3. Cập nhật AppointmentSerializer
class AppointmentSerializer(serializers.ModelSerializer):
    # Sử dụng SlugRelatedField để nhận tên chuyên khoa từ Frontend hoặc PrimaryKeyRelatedField cho ID
    specialty = serializers.SlugRelatedField(
        queryset=Specialty.objects.all(),
        slug_field='name'
    )
    
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

    def validate(self, data):
        """
        Kiểm tra logic nghiệp vụ trước khi lưu lịch hẹn
        """
        # 1. Kiểm tra hồ sơ bệnh nhân (Yêu cầu từ lib/models/user.dart)
        patient = data.get('patient')
        if patient:
            if not patient.insurance_number or not patient.phone_number:
                raise serializers.ValidationError(
                    "Hồ sơ bệnh nhân chưa hoàn thiện. Vui lòng cập nhật Số BHYT và Số điện thoại."
                )

        # 2. Kiểm tra ngày nghỉ của bác sĩ (DoctorDayOff)
        doctor = data.get('doctor')
        app_date = data.get('appointment_date')
        if doctor and app_date:
            is_off = DoctorDayOff.objects.filter(doctor=doctor, off_date=app_date).exists()
            if is_off:
                raise serializers.ValidationError("Bác sĩ có lịch nghỉ vào ngày này. Vui lòng chọn ngày khác.")

        return data