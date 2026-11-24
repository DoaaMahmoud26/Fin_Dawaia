import 'package:flutter/material.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_colors.dart';

/// تاب "الملف" للأدمن: بياناته + تسجيل الخروج
class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('الملف الشخصي')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 12),
            const CircleAvatar(
              radius: 44,
              backgroundColor: AppColors.lightGreen,
              child: Icon(Icons.admin_panel_settings_rounded,
                  size: 44, color: AppColors.primary),
            ),
            const SizedBox(height: 12),
            const Text('مدير النظام',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(user?.email ?? '',
                style: const TextStyle(color: AppColors.textGrey)),
            const Spacer(),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              icon: const Icon(Icons.logout),
              label: const Text('تسجيل الخروج'),
              onPressed: () => AuthService.instance.signOut(),
            ),
          ],
        ),
      ),
    );
  }
}