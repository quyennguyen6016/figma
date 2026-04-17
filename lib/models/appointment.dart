class Appointment {
  final String id;
  final String patientName;
  final int patientAge;
  final String patientGender;
  final String doctorName;
  final String specialty;
  final String appointmentDate;
  final String appointmentTime;
  final String appointmentType;
  final String medicalNote;
  final String status;
  final DateTime createdAt;

  Appointment({
    required this.id,
    required this.patientName,
    required this.patientAge,
    required this.patientGender,
    required this.doctorName,
    required this.specialty,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.appointmentType,
    this.medicalNote = '',
    this.status = 'pending',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientName': patientName,
      'patientAge': patientAge,
      'patientGender': patientGender,
      'doctorName': doctorName,
      'specialty': specialty,
      'appointmentDate': appointmentDate,
      'appointmentTime': appointmentTime,
      'appointmentType': appointmentType,
      'medicalNote': medicalNote,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] as String,
      patientName: json['patientName'] as String,
      patientAge: json['patientAge'] as int,
      patientGender: json['patientGender'] as String,
      doctorName: json['doctorName'] as String,
      specialty: json['specialty'] as String,
      appointmentDate: json['appointmentDate'] as String,
      appointmentTime: json['appointmentTime'] as String,
      appointmentType: json['appointmentType'] as String,
      medicalNote: (json['medicalNote'] as String?) ?? '',
      status: (json['status'] as String?) ?? 'pending',
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Appointment copyWith({
    String? id,
    String? patientName,
    int? patientAge,
    String? patientGender,
    String? doctorName,
    String? specialty,
    String? appointmentDate,
    String? appointmentTime,
    String? appointmentType,
    String? medicalNote,
    String? status,
    DateTime? createdAt,
  }) {
    return Appointment(
      id: id ?? this.id,
      patientName: patientName ?? this.patientName,
      patientAge: patientAge ?? this.patientAge,
      patientGender: patientGender ?? this.patientGender,
      doctorName: doctorName ?? this.doctorName,
      specialty: specialty ?? this.specialty,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      appointmentTime: appointmentTime ?? this.appointmentTime,
      appointmentType: appointmentType ?? this.appointmentType,
      medicalNote: medicalNote ?? this.medicalNote,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
