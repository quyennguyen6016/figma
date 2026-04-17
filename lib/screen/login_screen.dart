import 'package:flutter/material.dart';
import 'package:bt_cuoi_ky/services/auth_service.dart';

import 'home_screen.dart';
import 'doctor_home_screen.dart';
import 'register_screen.dart';

// ============================================================
//  MedCall – Trang Đăng Nhập
//  Dựa trên thiết kế Figma: App-MedCall / node 1:8
// ============================================================

void main() => runApp(const MedCallApp());

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
      home: const LoginScreen(),
    );
  }
}

// ============================================================
//  LOGIN SCREEN
// ============================================================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Back button ──────────────────────────────
                const SizedBox(height: 16),
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 20),
                  onPressed: () => Navigator.maybePop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),

                // ── Title ────────────────────────────────────
                const SizedBox(height: 44),
                const Text(
                  'Đăng nhập',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    height: 48 / 30,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Nhập thông tin để đăng nhập',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 24 / 14,
                    color: Colors.black,
                  ),
                ),

                // ── Email field ──────────────────────────────
                const SizedBox(height: 64),
                _FieldLabel(label: 'Email - Tên đăng nhập'),
                const SizedBox(height: 8),
                _InputField(
                  controller: _emailController,
                  hint: 'Email',
                  keyboardType: TextInputType.emailAddress,
                ),

                // ── Password field ───────────────────────────
                const SizedBox(height: 16),
                _FieldLabel(label: 'Mật khẩu'),
                const SizedBox(height: 8),
                _InputField(
                  controller: _passwordController,
                  hint: 'Mật khẩu',
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                      color: Colors.black38,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),

                // ── Forgot password ──────────────────────────
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'Quên mật khẩu ?',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 24 / 12,
                        color: Color(0xFF2145BF),
                      ),
                    ),
                  ),
                ),

                // ── Login button ─────────────────────────────
                const SizedBox(height: 32),
                Center(
                  child: SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _onLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2145BF),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'ĐĂNG NHẬP',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),

                // ── Divider – social ─────────────────────────
                const SizedBox(height: 40),
                const Center(
                  child: Text(
                    'Hoặc đăng nhập với',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0x80000000),
                    ),
                  ),
                ),

                // ── Social buttons ───────────────────────────
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _SocialButton(
                      onTap: () {},
                      child: const Icon(Icons.apple, size: 22, color: Colors.black),
                    ),
                    const SizedBox(width: 20),
                    _SocialButton(
                      onTap: () {},
                      child: _GoogleIcon(),
                    ),
                    const SizedBox(width: 20),
                    _SocialButton(
                      onTap: () {},
                      child: const Icon(Icons.facebook, size: 22, color: Color(0xFF1877F2)),
                    ),
                  ],
                ),

                // ── Register link ────────────────────────────
                const SizedBox(height: 48),
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0x80000000),
                      ),
                      children: [
                        const TextSpan(text: 'Nếu bạn chưa có tài khoản? '),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const RegisterScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Đăng ký',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF2145BF),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Home indicator space ─────────────────────
                const SizedBox(height: 32),
                Center(
                  child: Container(
                    width: 134,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFF020E22),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onLogin() async {
    final String username = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập tên đăng nhập và mật khẩu'),
        ),
      );
      return;
    }

    // Attempt login
    final authService = AuthService();
    final success = await authService.login(username, password);

    if (success) {
      // Get current user to determine role
      final user = await authService.getCurrentUser();

      if (context.mounted) {
        if (user?.role == 'patient') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        } else if (user?.role == 'doctor') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const DoctorHomeScreen()),
          );
        }
      }
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tài khoản hoặc mật khẩu không đúng'),
      ),
    );
  }
}

// ============================================================
//  SHARED WIDGETS
// ============================================================

/// Label phía trên input
class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 24 / 14,
        color: Colors.black,
      ),
    );
  }
}

/// Input field theo đúng style Figma
class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0x80000000),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          suffixIcon: suffixIcon,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0x80000000), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF2145BF), width: 1.5),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}

/// Nút social media (Apple, Google, Facebook)
class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.onTap, required this.child});
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0x24332218),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(child: child),
      ),
    );
  }
}

/// Google "G" icon tự vẽ bằng Flutter (không cần asset)
class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(20, 20),
      painter: _GooglePainter(),
    );
  }
}

class _GooglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double cx = size.width / 2;
    final double cy = size.height / 2;
    final double r = size.width / 2;

    // Blue arc
    final paintBlue = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r - 1.6),
        -0.2,
        1.8,
        false,
        paintBlue);

    // Green arc
    final paintGreen = Paint()
      ..color = const Color(0xFF34A853)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r - 1.6),
        1.6,
        1.5,
        false,
        paintGreen);

    // Yellow arc
    final paintYellow = Paint()
      ..color = const Color(0xFFFBBC05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r - 1.6),
        3.1,
        1.2,
        false,
        paintYellow);

    // Red arc
    final paintRed = Paint()
      ..color = const Color(0xFFEA4335)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r - 1.6),
        4.3,
        2.2,
        false,
        paintRed);

    // Horizontal bar of "G"
    final paintBar = Paint()
      ..color = const Color(0xFF4285F4)
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(cx, cy),
      Offset(cx + r - 1.6, cy),
      paintBar,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
