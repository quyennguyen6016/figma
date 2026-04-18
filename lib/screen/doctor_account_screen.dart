import 'package:flutter/material.dart';

// ============================================================
//  Doctor Account Screen – Thông tin bác sĩ
// ============================================================

class DoctorAccountTab extends StatelessWidget {
  const DoctorAccountTab({super.key});

  @override
  Widget build(BuildContext context) {
    const Color brand = Color(0xFF2145BF);
    const Color headerBlue = Color(0xFF2145BF);

    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              color: headerBlue,
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
              child: Column(
                children: [
                  const Text(
                    'Thông tin bác sĩ',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // TODO(IMAGE): Replace this icon avatar with the doctor's real profile photo.
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF4DB8E8),
                        width: 3,
                      ),
                      color: const Color(0xFF4DB8E8),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/doctor_avatar.png', // TODO(IMAGE): change to your doctor avatar asset path.
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Center(
                          child: Icon(
                            Icons.medical_services,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Doctor name
                  const Text(
                    'Bác sĩ: Nguyễn Văn A',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Specialty
                  const Text(
                    'Chuyên khoa: Da liễu',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Qualification badge
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: brand,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'trình độ: tiến sĩ, bác sĩ chuyên khoa II',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Basic information section
                  const Text(
                    'Thông tin cơ bản',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Date of birth
                  _InfoField(
                    icon: Icons.person_outline,
                    label: 'Ngày sinh: 15/05/1975',
                  ),
                  const SizedBox(height: 10),

                  // Phone
                  _InfoField(
                    icon: Icons.phone_outlined,
                    label: 'Số điện thoại: 0912345678',
                  ),
                  const SizedBox(height: 10),

                  // Email
                  _InfoField(
                    icon: Icons.email_outlined,
                    label: 'Email: nguyenvana@gmail.com',
                  ),
                  const SizedBox(height: 24),

                  // Working facilities section
                  const Text(
                    'Cơ sở công tác',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Hospital
                  _InfoField(
                    icon: Icons.local_hospital_outlined,
                    label: 'Bệnh viện Da khoa quốc tế',
                  ),
                  const SizedBox(height: 10),

                  // Clinic
                  _InfoField(
                    icon: Icons.location_on_outlined,
                    label: 'Phòng khám tư',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoField extends StatelessWidget {
  const _InfoField({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF2145BF), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
