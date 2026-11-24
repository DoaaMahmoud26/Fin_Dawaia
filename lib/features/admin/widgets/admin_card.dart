import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// كارت الأيقونة + العنوان في لوحة الإدارة (مربع رمادي فاتح زي التصميم)
class AdminCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final int badge; // عدد الطلبات المعلّقة (اختياري)

  const AdminCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.badge = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardGrey,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 38, color: AppColors.primary),
                  const SizedBox(height: 10),
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppColors.textDark)),
                ],
              ),
            ),
            if (badge > 0)
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(12)),
                  child: Text('$badge',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}