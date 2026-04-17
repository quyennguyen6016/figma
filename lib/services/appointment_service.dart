import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/appointment.dart';
import 'auth_service.dart';

class AppointmentService {
  static final AppointmentService _instance = AppointmentService._internal();
  static const String _baseUrl = String.fromEnvironment(
    'BACKEND_BASE_URL',
    defaultValue: 'http://127.0.0.1:8000',
  );

  factory AppointmentService() {
    return _instance;
  }

  AppointmentService._internal();

  Future<bool> saveAppointment(Appointment appointment) async {
    try {
      final payload = Map<String, dynamic>.from(appointment.toJson());
      payload['status'] = _normalizeStatus(payload['status']?.toString());

      final response = await http.post(
        Uri.parse('$_baseUrl/api/appointments/'),
        headers: AuthService().authorizedJsonHeaders(),
        body: jsonEncode(payload),
      );

      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (_) {
      return false;
    }
  }

  Future<List<Appointment>> getAllAppointments() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/appointments/'),
        headers: AuthService().authorizedJsonHeaders(),
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return [];
      }

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

  Future<List<Appointment>> getAppointmentsByStatus(String status) async {
    final all = await getAllAppointments();
    final normalized = _normalizeStatus(status);
    return all.where((a) => a.status == normalized).toList();
  }

  Future<List<Appointment>> getAppointmentsByDoctor(String doctorName) async {
    final all = await getAllAppointments();
    return all.where((a) => a.doctorName == doctorName).toList();
  }

  Future<void> updateAppointmentStatus(int index, String newStatus) async {
    final all = await getAllAppointments();

    if (index >= 0 && index < all.length) {
      final appointment = all[index];
      await updateAppointmentStatusById(appointment.id, newStatus);
    }
  }

  Future<void> updateAppointmentStatusById(String id, String newStatus) async {
    try {
      await http.patch(
        Uri.parse('$_baseUrl/api/appointments/$id/'),
        headers: AuthService().authorizedJsonHeaders(),
        body: jsonEncode({'status': _normalizeStatus(newStatus)}),
      );
    } catch (_) {}
  }

  Future<bool> updateAppointmentById(
    String id, {
    required String status,
    String? medicalNote,
  }) async {
    try {
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
    } catch (_) {
      return false;
    }
  }

  Future<void> deleteAppointment(int index) async {
    final all = await getAllAppointments();

    if (index >= 0 && index < all.length) {
      await deleteAppointmentById(all[index].id);
    }
  }

  Future<void> deleteAppointmentById(String id) async {
    try {
      await http.delete(
        Uri.parse('$_baseUrl/api/appointments/$id/'),
        headers: AuthService().authorizedJsonHeaders(),
      );
    } catch (_) {}
  }

  Future<int> countByStatus(String status) async {
    final all = await getAllAppointments();
    final normalized = _normalizeStatus(status);
    return all.where((a) => a.status == normalized).length;
  }

  Future<void> clearAll() async {
    final all = await getAllAppointments();
    for (final item in all) {
      await deleteAppointmentById(item.id);
    }
  }

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

  String _normalizeStatus(String? raw) {
    final value = (raw ?? '').trim().toLowerCase();

    if (value.isEmpty) return 'pending';

    if (value == 'pending' ||
        value == 'cho kham' ||
        value == 'chờ khám' ||
        value == 'chá» khã¡m') {
      return 'pending';
    }

    if (value == 'in_progress' ||
        value == 'dang kham' ||
        value == 'đang khám' ||
        value == 'ä‘ang khã¡m') {
      return 'in_progress';
    }

    if (value == 'completed' ||
        value == 'xong' ||
        value == 'da kham' ||
        value == 'đã khám' ||
        value == 'ä‘ã£ khã¡m') {
      return 'completed';
    }

    if (value == 'cancelled' ||
        value == 'huy' ||
        value == 'hủy' ||
        value == 'há»§y') {
      return 'cancelled';
    }

    return value;
  }

  int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }
}
