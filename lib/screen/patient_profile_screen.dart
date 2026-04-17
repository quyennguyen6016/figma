import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/auth_service.dart';
import 'patient_profile_edit_screen.dart';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({super.key});

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  Future<User?> _userFuture = AuthService().getCurrentUser();

  void _reloadUser() {
    setState(() {
      _userFuture = AuthService().getCurrentUser();
    });
  }

  String _formatDate(String value) {
    if (value.trim().isEmpty) return '';
    final parsed = DateTime.tryParse(value);
    if (parsed != null) {
      final day = parsed.day.toString().padLeft(2, '0');
      final month = parsed.month.toString().padLeft(2, '0');
      return '$day/$month/${parsed.year}';
    }

    final parts = value.split('/');
    if (parts.length == 3) return value;
    return value;
  }

  String _genderDisplay(String value) {
    switch (value) {
      case 'male':
        return 'Nam';
      case 'female':
        return 'Nữ';
      case 'other':
        return 'Khác';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: _userFuture,
      builder: (context, snapshot) {
        final user = snapshot.data;
        final displayName = (user?.fullName.trim().isNotEmpty ?? false)
            ? user!.fullName
            : 'Người dùng';
        final displayUsername = (user?.username.trim().isNotEmpty ?? false)
            ? user!.username
            : 'username';
        final dateOfBirth = _formatDate(user?.dateOfBirth ?? '');
        final gender = _genderDisplay(user?.gender ?? '');
        final phoneNumber = user?.phoneNumber ?? '';
        final insuranceNumber = user?.insuranceNumber ?? '';
        final address = user?.address ?? '';

        return Scaffold(
          backgroundColor: const Color(0xFFF2F2F2),
          body: Column(
            children: [
              Container(
                color: const Color(0xFFEDEDED),
                child: SafeArea(
                  bottom: false,
                  child: SizedBox(
                    height: 70,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: IconButton(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: const Icon(
                                Icons.arrow_back_ios_new,
                                size: 26,
                                color: Color(0xFF191C22),
                              ),
                            ),
                          ),
                        ),
                        const Text(
                          'Tài khoản',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 23,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1B1D22),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 110,
                                height: 110,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF191C22),
                                    width: 2,
                                  ),
                                  color: const Color(0xFFDEE3EA),
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/images/patient_avatar.png',
                                    fit: BoxFit.cover,
                                    errorBuilder: (
                                      context,
                                      error,
                                      stackTrace,
                                    ) =>
                                        const Icon(
                                      Icons.person,
                                      size: 60,
                                      color: Color(0xFF7D8795),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: -2,
                                bottom: -2,
                                child: Container(
                                  width: 46,
                                  height: 46,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(
                                      0xFF4B5C88,
                                    ).withValues(alpha: 0.72),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt_outlined,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  displayName,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 23,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF0D1017),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  displayUsername,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    height: 1.1,
                                    color: Color(0xFF65779F),
                                    decoration: TextDecoration.underline,
                                    decorationColor: Color(0xFF65779F),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle_outline,
                                      color: Color(0xFF30C74F),
                                      size: 24,
                                    ),
                                    SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        'Tài khoản đã được xác thực',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF65779F),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () async {
                              final updated =
                                  await Navigator.of(context).push<bool>(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const PatientProfileEditScreen(),
                                ),
                              );
                              if (updated == true && mounted) {
                                _reloadUser();
                              }
                            },
                            icon: const Icon(
                              Icons.edit_outlined,
                              size: 18,
                              color: Color(0xFF5FB9E3),
                            ),
                            label: const Text(
                              'Chỉnh sửa',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF3769C8),
                              ),
                            ),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.only(top: 2),
                              minimumSize: const Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 42),
                      const Text(
                        'Thông tin cá nhân',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF111318),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _InfoItem(
                        icon: Icons.person_outline,
                        label: 'Họ và tên:',
                        value: displayName,
                      ),
                      const SizedBox(height: 22),
                      _InfoItem(
                        icon: Icons.calendar_today_outlined,
                        label: 'Ngày sinh:',
                        value: dateOfBirth,
                      ),
                      const SizedBox(height: 22),
                      _InfoItem(
                        icon: Icons.person_outline,
                        label: 'Giới tính:',
                        value: gender,
                      ),
                      const SizedBox(height: 22),
                      _InfoItem(
                        icon: Icons.phone_outlined,
                        label: 'Số điện thoại:',
                        value: phoneNumber,
                      ),
                      const SizedBox(height: 22),
                      _InfoItem(
                        icon: Icons.shield_outlined,
                        label: 'Số BHYT:',
                        value: insuranceNumber,
                      ),
                      const SizedBox(height: 22),
                      _InfoItem(
                        icon: Icons.location_on_outlined,
                        label: 'Địa chỉ:',
                        value: address,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 34,
          child: Icon(icon, size: 22, color: const Color(0xFF0F1117)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF65779F),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF111318),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
