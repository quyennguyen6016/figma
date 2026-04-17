import 'package:flutter/material.dart';

import 'booking_schedule_screen.dart';
import 'dermatology_schedule_screen.dart';
import 'dental_schedule_screen.dart';
import 'ent_schedule_screen.dart';
import 'login_screen.dart';
import 'ophthalmology_schedule_screen.dart';
import 'orthopedic_schedule_screen.dart';
import 'patient_profile_screen.dart';
import '../models/user.dart';
import '../services/appointment_service.dart';
import '../services/auth_service.dart';
import '../models/appointment.dart';

// ============================================================
//  MedCall – Trang chủ (TabBar dưới cùng)
// ============================================================

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  int _reminderRefreshToken = 0;
  final GlobalKey<NavigatorState> _appointmentsNavKey =
      GlobalKey<NavigatorState>();

  void _goToAppointments() {
    setState(() => _index = 1);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final nav = _appointmentsNavKey.currentState;
      if (nav == null) return;
      nav.popUntil((route) => route.isFirst);
    });
  }

  void _handleLogout() async {
    // Logout using AuthService
    await AuthService().logout();

    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  void _onBottomTap(int i) {
    setState(() {
      _index = i;
      if (i == 2) {
        _reminderRefreshToken++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _HomeTab(onNavigateToAppointments: _goToAppointments),
      _AppointmentsTab(
        navigatorKey: _appointmentsNavKey,
        onBackToHome: () => setState(() => _index = 0),
      ),
      _ReminderTab(refreshToken: _reminderRefreshToken),
      _AccountTab(onLogout: _handleLogout),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _index,
        onTap: _onBottomTap,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF2145BF),
        unselectedItemColor: const Color(0xFF8A8A8A),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            activeIcon: Icon(Icons.calendar_month),
            label: 'Lịch khám',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            activeIcon: Icon(Icons.list_alt),
            label: 'Lịch nhắc',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Tài khoản',
          ),
        ],
      ),
    );
  }
}

class _AppointmentsTab extends StatelessWidget {
  const _AppointmentsTab({
    required this.navigatorKey,
    required this.onBackToHome,
  });

  final GlobalKey<NavigatorState> navigatorKey;
  final VoidCallback onBackToHome;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: '/specialties',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/specialties':
            return MaterialPageRoute(
              builder: (_) => BookingScheduleScreen(onBackToHome: onBackToHome),
            );
          case '/dermatology':
            return MaterialPageRoute(
              builder: (_) => const DermatologyScheduleScreen(),
            );
          case '/dental':
            return MaterialPageRoute(
              builder: (_) => const DentalScheduleScreen(),
            );
          case '/ent':
            return MaterialPageRoute(
              builder: (_) => const EntScheduleScreen(),
            );
          case '/ophthalmology':
            return MaterialPageRoute(
              builder: (_) => const OphthalmologyScheduleScreen(),
            );
          case '/orthopedic':
            return MaterialPageRoute(
              builder: (_) => const OrthopedicScheduleScreen(),
            );
          default:
            return MaterialPageRoute(
              builder: (_) => BookingScheduleScreen(onBackToHome: onBackToHome),
            );
        }
      },
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab({required this.onNavigateToAppointments});

  final VoidCallback onNavigateToAppointments;

  @override
  Widget build(BuildContext context) {
    const Color brand = Color(0xFF2145BF);
    const Color headerBlue = Color(0xFF2145BF);

    final facilities = <_Facility>[
      const _Facility(
        name: 'Bệnh viện Bạch Mai',
        address: '278 Đường Giải Phóng, ...',
        tag: 'Đặt khám ngay',
        accent: Color(0xFF2E7DFF),
        icon: Icons.local_hospital,
        imagePath: 'assets/images/bachmai.png',
      ),
      const _Facility(
        name: 'Bệnh viện Hoàn Mỹ',
        address: 'Số 01 Võ Văn ...',
        tag: 'Đặt khám ngay',
        accent: Color(0xFF34A853),
        icon: Icons.local_hospital_outlined,
        imagePath: 'assets/images/hoanmy.png',
      ),
    ];

    final specialties = <_Specialty>[
      const _Specialty(
        label: 'Da liễu',
        icon: Icons.spa_outlined,
        imagePath: 'assets/images/dalieu.png',
      ),
      const _Specialty(
        label: 'Răng hàm mặt',
        icon: Icons.medical_services,
        imagePath: 'assets/images/ranghammat.png',
      ),
      const _Specialty(
        label: 'Tai - Mũi - Họng',
        icon: Icons.hearing,
        imagePath: 'assets/images/taimuihong.png',
      ),
      const _Specialty(
        label: 'Mắt',
        icon: Icons.remove_red_eye_outlined,
        imagePath: 'assets/images/mat.png',
      ),
      const _Specialty(
        label: 'xương khớp',
        icon: Icons.healing_outlined,
        imagePath: 'assets/images/xuongkhop.png',
      ),
    ];

    final services = <_ServiceCard>[
      const _ServiceCard(
        title: 'Gói khám mắt tổng quát',
        subtitle: 'Giữ đôi mắt khỏe mạnh',
        accent: Color(0xFF2E7DFF),
        icon: Icons.medical_services,
        imagePath: 'assets/images/khammat.png',
      ),
      const _ServiceCard(
        title: 'Gói khám tiểu đường',
        subtitle: 'Giữ đường huyết ổn định',
        accent: Color(0xFF34A853),
        icon: Icons.food_bank,
        imagePath: 'assets/images/tieuduong.png',
      ),
    ];

    final doctors = <_DoctorCard>[
      const _DoctorCard(
        name: 'BS. Lê Tuấn',
        specialty: 'Nội tổng quát',
        duration: '15 phút',
        fee: '200,000đ',
        accent: Color(0xFF2E7DFF),
        icon: Icons.person,
        imagePath: 'assets/images/bs1.png',
      ),
      const _DoctorCard(
        name: 'BS. Trần Thị Mây',
        specialty: 'Tâm Lý',
        duration: '20 phút',
        fee: '350,000đ',
        accent: Color(0xFF34A853),
        icon: Icons.person_outline,
        imagePath: 'assets/images/bs2.png',
      ),
    ];

    final stats = <_Stat>[
      const _Stat(label: 'Lượt khám', value: '4.0M+', icon: Icons.stars),
      const _Stat(
        label: 'Bệnh viện',
        value: '100+',
        icon: Icons.local_hospital,
      ),
      const _Stat(
        label: 'Cơ sở y tế',
        value: '300+',
        icon: Icons.health_and_safety,
      ),
      const _Stat(label: 'Bác sĩ', value: '1000+', icon: Icons.person),
      const _Stat(label: 'Lượt tư vấn', value: '1.0M+', icon: Icons.video_call),
      const _Stat(label: 'Lượt trị liệu', value: '30K+', icon: Icons.spa),
    ];

    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 84),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              color: headerBlue,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi admin!',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Kết nối người dân với dịch vụ y tế',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Search
                  Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Color(0xFFBDBDBD)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              isDense: true,
                              hintText: 'Tìm kiếm bệnh viện, bác sĩ...',
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              color: Colors.black,
                            ),
                            onChanged: (_) {},
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // TODO: Nếu bạn có icon/button theo Figma, thay ở widget riêng bên dưới.
                  _BookingCtaButton(onPressed: onNavigateToAppointments),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Linked facilities
            _SectionHeader(title: 'Các cơ sở liên kết', onMore: () {}),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: facilities.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.0,
                ),
                itemBuilder: (_, i) => _FacilityCard(
                  facility: facilities[i],
                  onTap: onNavigateToAppointments,
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Specialties
            _SectionHeader(title: 'Chuyên khoa', onMore: () {}),
            SizedBox(
              height: 92,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: specialties.length,
                separatorBuilder: (_, __) => const SizedBox(width: 14),
                itemBuilder: (_, i) =>
                    _SpecialtyChip(specialty: specialties[i]),
              ),
            ),

            const SizedBox(height: 18),

            // Comprehensive care
            _SectionHeader(title: 'Chăm sóc sức khỏe toàn diện', onMore: () {}),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(child: _ServiceCardWidget(service: services[0])),
                  const SizedBox(width: 12),
                  Expanded(child: _ServiceCardWidget(service: services[1])),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Video doctors
            _SectionHeader(title: 'Bác sĩ tư vấn qua video', onMore: () {}),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _DoctorVideoCardWidget(
                      doctor: doctors[0],
                      onBook: onNavigateToAppointments,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _DoctorVideoCardWidget(
                      doctor: doctors[1],
                      onBook: onNavigateToAppointments,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Stats
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'THỐNG KÊ',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: brand.withOpacity(0.9),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: stats.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.98,
                ),
                itemBuilder: (_, i) => _StatWidget(stat: stats[i]),
              ),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _BookingCtaButton extends StatelessWidget {
  const _BookingCtaButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    const Color brand = Color(0xFF2145BF);
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: brand,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        icon: const Icon(Icons.calendar_month_outlined),
        label: const Text(
          'Đặt lịch khám',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.onMore});

  final String title;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          InkWell(
            onTap: onMore,
            borderRadius: BorderRadius.circular(10),
            child: const Padding(
              padding: EdgeInsets.all(6.0),
              child: Icon(Icons.chevron_right, color: Color(0xFFBDBDBD)),
            ),
          ),
        ],
      ),
    );
  }
}

class _Facility {
  final String name;
  final String address;
  final String tag;
  final Color accent;
  final IconData icon;
  final String imagePath;

  const _Facility({
    required this.name,
    required this.address,
    required this.tag,
    required this.accent,
    required this.icon,
    required this.imagePath,
  });
}

class _FacilityCard extends StatelessWidget {
  const _FacilityCard({required this.facility, required this.onTap});
  final _Facility facility;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const Color brand = Color(0xFF2145BF);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE8E8E8)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: facility.accent.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      facility.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        facility.icon,
                        color: facility.accent,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    facility.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              facility.address,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: Colors.black.withOpacity(0.55),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: brand,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Đặt khám ngay',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2145BF).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.chevron_right, color: brand),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Specialty {
  final String label;
  final IconData icon;
  final String imagePath;

  const _Specialty({
    required this.label,
    required this.icon,
    required this.imagePath,
  });
}

class _SpecialtyChip extends StatelessWidget {
  const _SpecialtyChip({required this.specialty});
  final _Specialty specialty;

  @override
  Widget build(BuildContext context) {
    const Color brand = Color(0xFF2145BF);
    return Container(
      width: 90,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDEDED)),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 26,
            height: 26,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                specialty.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(specialty.icon, size: 24, color: brand),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            specialty.label,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceCard {
  final String title;
  final String subtitle;
  final Color accent;
  final IconData icon;
  final String imagePath;

  const _ServiceCard({
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.icon,
    required this.imagePath,
  });
}

class _ServiceCardWidget extends StatelessWidget {
  const _ServiceCardWidget({required this.service});
  final _ServiceCard service;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 152,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDEDED)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 76,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                colors: [
                  service.accent.withOpacity(0.18),
                  service.accent.withOpacity(0.06),
                ],
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                service.imagePath,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Center(
                  child: Icon(service.icon, color: service.accent, size: 28),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            service.title,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            service.subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xFF8A8A8A),
            ),
          ),
        ],
      ),
    );
  }
}

class _DoctorCard {
  final String name;
  final String specialty;
  final String duration;
  final String fee;
  final Color accent;
  final IconData icon;
  final String imagePath;

  const _DoctorCard({
    required this.name,
    required this.specialty,
    required this.duration,
    required this.fee,
    required this.accent,
    required this.icon,
    required this.imagePath,
  });
}

class _DoctorVideoCardWidget extends StatelessWidget {
  const _DoctorVideoCardWidget({required this.doctor, required this.onBook});
  final _DoctorCard doctor;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    const Color brand = Color(0xFF2145BF);
    return Container(
      height: 152,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDEDED)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // TODO(IMAGE): Replace this doctor icon with a doctor thumbnail/profile image.
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: doctor.accent.withOpacity(0.12),
                ),
                child: ClipOval(
                  child: Image.asset(
                    doctor.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      doctor.icon,
                      color: doctor.accent,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  doctor.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            doctor.specialty,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black.withOpacity(0.65),
            ),
          ),
          const SizedBox(height: 10),

          Row(children: [_TinyMeta(text: 'Thời lượng: ${doctor.duration}')]),
          const SizedBox(height: 4),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                doctor.fee,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: brand,
                ),
              ),
              InkWell(
                onTap: onBook,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: brand,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Đặt lịch',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
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

class _TinyMeta extends StatelessWidget {
  const _TinyMeta({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: Color(0xFF8A8A8A),
        ),
      ),
    );
  }
}

class _Stat {
  final String value;
  final String label;
  final IconData icon;

  const _Stat({required this.value, required this.label, required this.icon});
}

class _StatWidget extends StatelessWidget {
  const _StatWidget({required this.stat});
  final _Stat stat;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDEDED)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(stat.icon, size: 18, color: const Color(0xFF2145BF)),
          const SizedBox(height: 6),
          Text(
            stat.value,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            stat.label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Color(0xFF8A8A8A),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReminderTab extends StatefulWidget {
  const _ReminderTab({required this.refreshToken});

  final int refreshToken;

  @override
  State<_ReminderTab> createState() => _ReminderTabState();
}

class _ReminderTabState extends State<_ReminderTab> {
  List<Appointment> appointments = [];
  List<Appointment> displayAppointments = [];
  String _selectedFilter = 'all'; // all, pending, in_progress, cancelled

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  @override
  void didUpdateWidget(covariant _ReminderTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.refreshToken != oldWidget.refreshToken) {
      _loadAppointments();
    }
  }

  Future<void> _loadAppointments() async {
    final all = await AppointmentService().getAllAppointments();
    if (!mounted) return;
    setState(() {
      appointments = all;
      _filterAppointments();
    });
  }

  void _filterAppointments() {
    switch (_selectedFilter) {
      case 'pending':
        displayAppointments = appointments
            .where((a) => a.status == 'pending')
            .toList();
        break;
      case 'in_progress':
        displayAppointments = appointments
            .where((a) => a.status == 'in_progress')
            .toList();
        break;
      case 'cancelled':
        displayAppointments = appointments
            .where((a) => a.status == 'cancelled')
            .toList();
        break;
      default:
        displayAppointments = appointments;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return const Color(0xFFFF9500);
      case 'in_progress':
        return const Color(0xFF2145BF);
      case 'cancelled':
        return const Color(0xFFE53935);
      default:
        return const Color(0xFF8A8A8A);
    }
  }

  String _getDisplayStatus(String status) {
    switch (status) {
      case 'pending':
        return 'Dang cho';
      case 'in_progress':
        return 'Dang kham';
      case 'cancelled':
        return 'Huy';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color brand = Color(0xFF2145BF);

    return SafeArea(
      child: Column(
        children: [
          Container(
            color: brand,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Lich nhac',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      onPressed: _loadAppointments,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _FilterChip(
                  label: 'Tat ca',
                  isSelected: _selectedFilter == 'all',
                  onTap: () {
                    setState(() {
                      _selectedFilter = 'all';
                      _filterAppointments();
                    });
                  },
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Dang cho',
                  isSelected: _selectedFilter == 'pending',
                  onTap: () {
                    setState(() {
                      _selectedFilter = 'pending';
                      _filterAppointments();
                    });
                  },
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Dang kham',
                  isSelected: _selectedFilter == 'in_progress',
                  onTap: () {
                    setState(() {
                      _selectedFilter = 'in_progress';
                      _filterAppointments();
                    });
                  },
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Huy',
                  isSelected: _selectedFilter == 'cancelled',
                  onTap: () {
                    setState(() {
                      _selectedFilter = 'cancelled';
                      _filterAppointments();
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: displayAppointments.isEmpty
                ? Center(
                    child: Text(
                      'Khong co lich hen',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: displayAppointments.length,
                    itemBuilder: (context, index) {
                      final appointment = displayAppointments[index];
                      final statusColor = _getStatusColor(appointment.status);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE8E8E8)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        appointment.doctorName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        appointment.specialty,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black.withOpacity(0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    _getDisplayStatus(appointment.status),
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: statusColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 16,
                                  color: Colors.black.withOpacity(0.6),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '${appointment.appointmentDate} - ${appointment.appointmentTime}',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black.withOpacity(0.65),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.local_hospital_outlined,
                                  size: 16,
                                  color: Colors.black.withOpacity(0.6),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    appointment.appointmentType,
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black.withOpacity(0.65),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const Color brand = Color(0xFF2145BF);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? brand : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? brand : const Color(0xFFE8E8E8),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

class _AccountTab extends StatelessWidget {
  const _AccountTab({required this.onLogout});

  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    const Color brand = Color(0xFF2145BF);

    return FutureBuilder<User?>(
      future: AuthService().getCurrentUser(),
      builder: (context, snapshot) {
        final user = snapshot.data;
        final displayName = (user?.fullName.trim().isNotEmpty ?? false)
            ? user!.fullName
            : 'Người dùng';
        final displayUsername = (user?.username.trim().isNotEmpty ?? false)
            ? user!.username
            : 'username';

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User profile section
                Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: brand.withValues(alpha: 0.1),
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 40,
                        color: brand,
                      ),
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
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            displayUsername,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF2145BF),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Personal info section
                _MenuSection(
                  icon: Icons.person_outline,
                  title: 'Thông tin cá nhân',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const PatientProfileScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Home section
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.home_outlined,
                        size: 24,
                        color: Colors.black87,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Trang chủ',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Hospital section
                _MenuSection(
                  icon: Icons.local_hospital_outlined,
                  title: 'Bệnh viện',
                  onTap: () {},
                ),

                const SizedBox(height: 10),

                // Invoice section
                _MenuSection(
                  icon: Icons.receipt_outlined,
                  title: 'Hóa đơn',
                  onTap: () {},
                ),

                const SizedBox(height: 20),

                // Other section header
                Text(
                  'Khác',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),

                const SizedBox(height: 12),

                // Terms section
                _MenuSection(
                  icon: Icons.description_outlined,
                  title: 'Điều khoản',
                  onTap: () {},
                ),

                const SizedBox(height: 10),

                // About section
                _MenuSection(
                  icon: Icons.info_outline,
                  title: 'Về chúng tôi',
                  onTap: () {},
                ),

                const SizedBox(height: 10),

                // Settings section
                _MenuSection(
                  icon: Icons.settings_outlined,
                  title: 'Cài đặt',
                  onTap: () {},
                ),

                const SizedBox(height: 20),

                // Divider
                Container(height: 1, color: Colors.black.withOpacity(0.1)),

                const SizedBox(height: 20),

                // Logout button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: onLogout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF8A8A8A),
                      elevation: 0,
                      side: const BorderSide(color: Color(0xFFE8E8E8)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.logout, color: Color(0xFF8A8A8A)),
                    label: const Text(
                      'Đăng xuất',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF8A8A8A),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Theme toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.light_mode_outlined),
                      color: Colors.black.withOpacity(0.4),
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.dark_mode_outlined),
                      color: Colors.black.withOpacity(0.4),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MenuSection extends StatelessWidget {
  const _MenuSection({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Colors.black87),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.black.withOpacity(0.3)),
          ],
        ),
      ),
    );
  }
}
