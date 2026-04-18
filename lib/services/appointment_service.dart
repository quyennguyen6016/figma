import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/appointment.dart';
import 'auth_service.dart';

class AppointmentService {
  static final AppointmentService _instance = AppointmentService._internal();

  // Cấu hình URL cơ sở từ môi trường hoặc mặc định
  static const String _baseUrl = String.fromEnvironment(
    'BACKEND_BASE_URL',
    defaultValue:
        'http://127.0.0.1:8000', // Đổi thành http://10.0.2.2:8000 nếu dùng Android Emulator
  );

  factory AppointmentService() {
    return _instance;
  }

  AppointmentService._internal();

  // ---------------------------------------------------------------------------
  // 1. NGHIỆP VỤ CHUYÊN KHOA & LỊCH TRÌNH (DATABASE DRIVEN)
  // ---------------------------------------------------------------------------

  /// Lấy danh sách chuyên khoa từ bảng public.appointments_specialty
  Future<List<Map<String, dynamic>>> getSpecialties() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/appointments/specialties/'),
        headers: AuthService().authorizedJsonHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      print("Lỗi kết nối lấy chuyên khoa: $e");
      return [];
    }
  }

  /// Lấy lịch làm việc của bác sĩ từ bảng public.appointments_doctorschedule
  Future<List<Map<String, dynamic>>> getDoctorSchedule(int doctorId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/appointments/schedules/?doctor_id=$doctorId'),
        headers: AuthService().authorizedJsonHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      print("Lỗi lấy lịch bác sĩ: $e");
      return [];
    }
  }

  // ---------------------------------------------------------------------------
  // 2. QUẢN LÝ LỊCH HẸN (APPOINTMENTS)
  // ---------------------------------------------------------------------------

  /// Lưu lịch hẹn mới vào database
  Future<bool> saveAppointment(Appointment appointment) async {
    final payload = Map<String, dynamic>.from(appointment.toJson());
    payload['status'] = _normalizeStatus(payload['status']?.toString());

    final response = await http.post(
      Uri.parse('$_baseUrl/api/appointments/'),
      headers: AuthService().authorizedJsonHeaders(),
      body: jsonEncode(payload),
    );

    return response.statusCode >= 200 && response.statusCode < 300;
  }

  /// Lấy tất cả lịch hẹn và xử lý ánh xạ snake_case -> camelCase
  Future<List<Appointment>> getAllAppointments() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/appointments/'),
        headers: AuthService().authorizedJsonHeaders(),
      );

      if (response.statusCode < 200 || response.statusCode >= 300) return [];

      final decoded = jsonDecode(response.body);
      final List<dynamic> list = decoded is List<dynamic>
          ? decoded
          : (decoded['results'] as List<dynamic>? ?? <dynamic>[]);

      return list
          .map((jsonItem) {
            try {
              return Appointment.fromJson(
                _normalizeAppointmentJson(jsonItem as Map<String, dynamic>),
              );
            } catch (_) {
              return null;
            }
          })
          .whereType<Appointment>()
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Cập nhật trạng thái và ghi chú y khoa (Dành cho bác sĩ)
  Future<bool> updateAppointmentById(
    String id, {
    required String status,
    String? medicalNote,
  }) async {
    final payload = <String, dynamic>{'status': _normalizeStatus(status)};
    if (medicalNote != null) {
      payload['medical_note'] = medicalNote;
    }

    final response = await http.patch(
      Uri.parse('$_baseUrl/api/appointments/$id/'),
      headers: AuthService().authorizedJsonHeaders(),
      body: jsonEncode(payload),
    );

    return response.statusCode >= 200 && response.statusCode < 300;
  }

  /// Xóa lịch hẹn theo ID
  Future<void> deleteAppointmentById(String id) async {
    await http.delete(
      Uri.parse('$_baseUrl/api/appointments/$id/'),
      headers: AuthService().authorizedJsonHeaders(),
    );
  }

  // ---------------------------------------------------------------------------
  // 3. CÁC HÀM TRỢ GIÚP (HELPER METHODS)
  // ---------------------------------------------------------------------------

  /// Ánh xạ các trường từ Database (PostgreSQL) sang Model Flutter
  Map<String, dynamic> _normalizeAppointmentJson(Map<String, dynamic> json) {
    return {
      'id': json['id']?.toString() ?? '',
      'patientName': (json['patientName'] ?? json['patient_name'] ?? '')
          .toString(),
      'patientAge': _toInt(json['patientAge'] ?? json['patient_age']),
      'patientGender': (json['patientGender'] ?? json['patient_gender'] ?? '')
          .toString(),
      'doctorName': (json['doctorName'] ?? json['doctor_name'] ?? '')
          .toString(),
      'specialty': json['specialty']?.toString() ?? '',
      'appointmentDate':
          (json['appointmentDate'] ?? json['appointment_date'] ?? '')
              .toString(),
      'appointmentTime':
          (json['appointmentTime'] ?? json['appointment_time'] ?? '')
              .toString(),
      'appointmentType':
          (json['appointmentType'] ?? json['appointment_type'] ?? '')
              .toString(),
      'medicalNote': (json['medicalNote'] ?? json['medical_note'] ?? '')
          .toString(),
      'status': _normalizeStatus(json['status']?.toString()),
      'createdAt':
          (json['createdAt'] ??
                  json['created_at'] ??
                  DateTime.now().toIso8601String())
              .toString(),
    };
  }

  /// Chuẩn hóa trạng thái để khớp với logic Backend
  String _normalizeStatus(String? raw) {
    final value = (raw ?? '').trim().toLowerCase();
    if (value.isEmpty) return 'pending';
    if (['pending', 'cho kham', 'chờ khám'].contains(value)) return 'pending';
    if (['in_progress', 'dang kham', 'đang khám'].contains(value))
      return 'in_progress';
    if (['completed', 'xong', 'đã khám'].contains(value)) return 'completed';
    if (['cancelled', 'huy', 'hủy'].contains(value)) return 'cancelled';
    return value;
  }

  int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
