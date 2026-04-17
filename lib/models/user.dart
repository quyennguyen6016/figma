class User {
  final String username;
  final String password;
  final String role; // 'patient' or 'doctor'
  final String fullName;
  final String dateOfBirth;
  final String gender;
  final String phoneNumber;
  final String insuranceNumber;
  final String address;

  User({
    required this.username,
    required this.password,
    required this.role,
    required this.fullName,
    this.dateOfBirth = '',
    this.gender = '',
    this.phoneNumber = '',
    this.insuranceNumber = '',
    this.address = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'role': role,
      'full_name': fullName,
      'date_of_birth': dateOfBirth,
      'gender': gender,
      'phone_number': phoneNumber,
      'insurance_number': insuranceNumber,
      'address': address,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] as String,
      password: json['password'] as String,
      role: json['role'] as String,
      fullName: (json['fullName'] ?? json['full_name'] ?? '').toString(),
      dateOfBirth: (json['dateOfBirth'] ?? json['date_of_birth'] ?? '')
          .toString(),
      gender: (json['gender'] ?? '').toString(),
      phoneNumber: (json['phoneNumber'] ?? json['phone_number'] ?? '')
          .toString(),
      insuranceNumber:
          (json['insuranceNumber'] ?? json['insurance_number'] ?? '').toString(),
      address: (json['address'] ?? '').toString(),
    );
  }

  bool get hasCompleteBookingProfile {
    return fullName.trim().isNotEmpty &&
        dateOfBirth.trim().isNotEmpty &&
        gender.trim().isNotEmpty &&
        phoneNumber.trim().isNotEmpty &&
        insuranceNumber.trim().isNotEmpty &&
        address.trim().isNotEmpty;
  }

  int? get age {
    final birthDate = DateTime.tryParse(dateOfBirth) ?? _parseSlashDate(dateOfBirth);
    if (birthDate == null) return null;

    final now = DateTime.now();
    var years = now.year - birthDate.year;
    final hadBirthday =
        now.month > birthDate.month ||
        (now.month == birthDate.month && now.day >= birthDate.day);
    if (!hadBirthday) {
      years -= 1;
    }

    return years < 0 ? null : years;
  }

  String get genderLabel {
    switch (gender) {
      case 'male':
        return 'Nam';
      case 'female':
        return 'Nữ';
      case 'other':
        return 'Khác';
      default:
        return gender;
    }
  }

  DateTime? _parseSlashDate(String value) {
    final parts = value.split('/');
    if (parts.length != 3) return null;

    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) return null;

    return DateTime(year, month, day);
  }
}
