import 'package:flutter/material.dart';
import 'package:bt_cuoi_ky/services/auth_service.dart';
import 'login_screen.dart';

// ============================================================
//  Doctor Settings Screen – Cài đặt
// ============================================================

class DoctorSettingsTab extends StatelessWidget {
  const DoctorSettingsTab({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () async {
              // Logout using AuthService
              await AuthService().logout();

              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            child: const Text('Đăng xuất', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color brand = Color(0xFF2145BF);
    const Color headerBlue = Color(0xFF2145BF);

    return SafeArea(
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            color: headerBlue,
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: const Text(
              'Cài đặt',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),

          // Settings menu
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              children: [
                // Language
                _SettingItem(
                  icon: Icons.language_outlined,
                  label: 'Ngôn ngữ',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Chọn ngôn ngữ')),
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Notifications
                _SettingItem(
                  icon: Icons.notifications_outlined,
                  label: 'Thông báo',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Cài đặt thông báo')),
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Change password
                _SettingItem(
                  icon: Icons.settings_outlined,
                  label: 'Đổi mật khẩu',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Đổi mật khẩu')),
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Logout
                _SettingItem(
                  icon: Icons.exit_to_app_outlined,
                  label: 'Đăng xuất',
                  onTap: () {
                    _showLogoutDialog(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingItem extends StatelessWidget {
  const _SettingItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE8E8E8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: const Color(0xFF8A8A8A),
                ),
                const SizedBox(width: 16),
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const Icon(
              Icons.chevron_right,
              color: Color(0xFFBDBDBD),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
