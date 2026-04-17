import 'package:flutter/material.dart';

class BookingScheduleScreen extends StatelessWidget {
  const BookingScheduleScreen({
    required this.onBackToHome,
    super.key,
  });

  final VoidCallback onBackToHome;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _TopBar(
            onBack: onBackToHome,
          ),
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Chuyên khoa y tế',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Đa dạng các chuyên khoa',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF8A8A8A),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: [
                _SpecialtyRow(
                  label: 'Da liễu',
                  icon: Icons.spa_outlined,
                  imagePath: 'assets/images/dalieu.png',
                  onTap: () => Navigator.of(context).pushNamed('/dermatology'),
                ),
                _SpecialtyRow(
                  label: 'Răng hàm mặt',
                  icon: Icons.medical_services_outlined,
                  imagePath: 'assets/images/ranghammat.png',
                  onTap: () => Navigator.of(context).pushNamed('/dental'),
                ),
                _SpecialtyRow(
                  label: 'Tai mũi họng',
                  icon: Icons.hearing,
                  imagePath: 'assets/images/taimuihong.png',
                  onTap: () => Navigator.of(context).pushNamed('/ent'),
                ),
                _SpecialtyRow(
                  label: 'Mắt',
                  icon: Icons.remove_red_eye_outlined,
                  imagePath: 'assets/images/mat.png',
                  onTap: () => Navigator.of(context).pushNamed('/ophthalmology'),
                ),
                _SpecialtyRow(
                  label: 'Xương khớp',
                  icon: Icons.healing_outlined,
                  imagePath: 'assets/images/xuongkhop.png',
                  onTap: () => Navigator.of(context).pushNamed('/orthopedic'),
                ),
                const SizedBox(height: 22),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.chevron_right, color: Color(0xFF2145BF)),
                    label: const Text(
                      'See More',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2145BF),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.onBack,
  });

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: onBack,
            padding: EdgeInsets.zero,
          ),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}

class _SpecialtyRow extends StatelessWidget {
  const _SpecialtyRow({
    required this.label,
    required this.icon,
    required this.imagePath,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final String imagePath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const Color brand = Color(0xFF2145BF);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        child: Row(
          children: [
            // TODO: Replace with specialty icon/image asset
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: brand.withOpacity(0.05),
                borderRadius: BorderRadius.circular(14),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    icon,
                    color: brand,
                    size: 28,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFFBDBDBD)),
          ],
        ),
      ),
    );
  }
}

