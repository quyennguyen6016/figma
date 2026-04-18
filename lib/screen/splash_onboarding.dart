import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'login_screen.dart';

// ============================================================
//  MedCall – Splash + Onboarding
//  Gồm: SplashScreen → OnboardingScreen (3 trang) → LoginScreen
// ============================================================

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  runApp(const MedCallApp());
}

// ── App ──────────────────────────────────────────────────────
class MedCallApp extends StatelessWidget {
  const MedCallApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MedCall',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter',
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2145BF)),
      ),
      home: const SplashScreen(),
    );
  }
}

// ============================================================
//  SPLASH SCREEN – Màn hình chờ
// ============================================================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _scaleAnim = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack),
    );

    _ctrl.forward();

    // Sau 2.5s → sang Onboarding
    Future.delayed(const Duration(milliseconds: 2500), _goToOnboarding);
  }

  void _goToOnboarding() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const OnboardingScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2145BF),
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: ScaleTransition(
            scale: _scaleAnim,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // TODO(IMAGE): Replace splash logo icon with brand logo asset (PNG/SVG).
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.18),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Image.asset(
                      'assets/images/logo.png', // TODO(IMAGE): change to your app logo asset path.
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const _MedCallLogoIcon(size: 80),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // App name
                const Text(
                  'MedCall',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Đặt lịch khám nhanh chóng',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.white70,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
//  ONBOARDING SCREEN – 3 trang giới thiệu
// ============================================================
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageCtrl = PageController();
  int _currentPage = 0;

  static const List<_OnboardData> _pages = [
    _OnboardData(
      illustrationIcon: Icons.medical_services_outlined,
      illustrationColor: Color(0xFFB3C8F0),
      illustrationImagePath: 'assets/images/splash1.png',
      title: 'XIN CHÀO !',
      description:
          'Chúng tôi sẽ hỗ trợ bạn đặt lịch hẹn với bác sĩ một cách hiệu quả và dễ dàng. Hãy bắt đầu nào!',
    ),
    _OnboardData(
      illustrationIcon: Icons.local_hospital_outlined,
      illustrationColor: Color(0xFFC8E6C9),
      illustrationImagePath: 'assets/images/splash2.png',
      title: 'CHỌN CHUYÊN KHOA',
      description:
          'Chọn chuyên khoa y tế bạn cần để chúng tôi có thể tùy chỉnh trải nghiệm của bạn.',
    ),
    _OnboardData(
      illustrationIcon: Icons.calendar_month_outlined,
      illustrationColor: Color(0xFFFFCDD2),
      illustrationImagePath: 'assets/images/splash3.png',
      title: 'LÊN LỊCH KHÁM',
      description:
          'Chọn thời gian và ngày phù hợp để gặp bác sĩ. Hướng tới sức khỏe tốt hơn của bạn!',
    ),
  ];

  void _goToLogin() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const LoginScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _goToLogin();
    }
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLast = _currentPage == _pages.length - 1;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Page view ────────────────────────────────────
            Expanded(
              child: PageView.builder(
                controller: _pageCtrl,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (_, i) => _OnboardPage(data: _pages[i]),
              ),
            ),

            // ── Dot indicator ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == i ? 24 : 8,
                    height: 4,
                    decoration: BoxDecoration(
                      color: _currentPage == i
                          ? const Color(0xFF2145BF)
                          : const Color(0xFFBDBDBD),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),

            // ── Buttons ───────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
              child: isLast
                  ? SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _goToLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2145BF),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Bắt đầu',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  : Row(
                      children: [
                        // Bỏ qua
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: OutlinedButton(
                              onPressed: _goToLogin,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.black87,
                                side: const BorderSide(
                                    color: Color(0xFFBDBDBD), width: 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text(
                                'Bỏ qua',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Tiếp tục
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _nextPage,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2145BF),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text(
                                'Tiếp tục',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
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

// ── Data model ───────────────────────────────────────────────
class _OnboardData {
  const _OnboardData({
    required this.illustrationIcon,
    required this.illustrationColor,
    required this.illustrationImagePath,
    required this.title,
    required this.description,
  });
  final IconData illustrationIcon;
  final Color illustrationColor;
  final String illustrationImagePath;
  final String title;
  final String description;
}

// ── Single onboarding page ───────────────────────────────────
class _OnboardPage extends StatelessWidget {
  const _OnboardPage({required this.data});
  final _OnboardData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TODO(IMAGE): Replace onboarding icon illustration with artwork/image per page.
        Expanded(
          flex: 5,
          child: Container(
            width: double.infinity,
            color: data.illustrationColor.withOpacity(0.35),
            child: ClipRect(
              child: Image.asset(
                data.illustrationImagePath,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                alignment: Alignment.center,
                errorBuilder: (context, error, stackTrace) => Center(
                  child: Icon(
                    data.illustrationIcon,
                    size: 120,
                    color: data.illustrationColor,
                  ),
                ),
              ),
            ),
          ),
        ),

        // Text content
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 28, 32, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Accent line
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2145BF),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  data.title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                    height: 1.2,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  data.description,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF666666),
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── MedCall logo icon (vẽ bằng Icon + Text, thay ảnh thật sau) ──
class _MedCallLogoIcon extends StatelessWidget {
  const _MedCallLogoIcon({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.local_hospital_rounded,
            size: size * 0.6, color: const Color(0xFF2145BF)),
        const SizedBox(height: 4),
        Text(
          'MedCall',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: size * 0.17,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF2145BF),
          ),
        ),
      ],
    );
  }
}
