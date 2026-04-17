import 'package:flutter/material.dart';

// xương khớp

class OrthopedicScheduleScreen extends StatelessWidget {
  const OrthopedicScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final doctors = <_DoctorItem>[
      const _DoctorItem(
        name: 'Bác sĩ Trần Nam Chung',
        title: 'Tiến sĩ',
        experience: '20 năm kinh nghiệm',
        schedule: '8 : 00 sáng',
        imagePath: 'assets/images/xk_bs_1.png',
      ),
      const _DoctorItem(
        name: 'Bác sĩ Lê Quốc Việt',
        title: 'Tiến sĩ, CKII',
        experience: '40 năm kinh nghiệm',
        schedule: '9 : 00 sáng',
        imagePath: 'assets/images/xk_bs_2.png',
      ),
      const _DoctorItem(
        name: 'Bác sĩ Lê Thị Liễu',
        title: 'Tiến sĩ',
        experience: '20 năm kinh nghiệm',
        schedule: '3 : 30 sáng',
        imagePath: 'assets/images/xk_bs_3.png',
      ),
    ];

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _TopBar(title: 'Xương khớp'),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
              itemCount: doctors.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (_, i) => _DoctorCard(doctor: doctors[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () => Navigator.of(context).pop(),
            padding: EdgeInsets.zero,
          ),
          Expanded(
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _DoctorItem {
  const _DoctorItem({
    required this.name,
    required this.title,
    required this.experience,
    required this.schedule,
    required this.imagePath,
  });

  final String name;
  final String title;
  final String experience;
  final String schedule;
  final String imagePath;
}

class _DoctorCard extends StatelessWidget {
  const _DoctorCard({required this.doctor});

  final _DoctorItem doctor;

  @override
  Widget build(BuildContext context) {
    const Color brand = Color(0xFF2145BF);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  doctor.imagePath,
                  width: 86,
                  height: 86,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 86,
                    height: 86,
                    color: const Color(0xFFEFF2F8),
                    child: const Icon(
                      Icons.person,
                      color: Color(0xFF8A8A8A),
                      size: 34,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 33 / 2,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF3A3A3A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      doctor.title,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 24 / 2,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF3152C8),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      doctor.experience,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 21 / 2,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF99A0B0),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Giờ làm việc',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 29 / 2,
                      fontWeight: FontWeight.w700,
                      color: brand,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    doctor.schedule,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 28 / 2,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF7B8499),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                height: 34,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brand,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: const Text(
                    'Đặt lịch ngay',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
