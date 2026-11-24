import 'package:flutter/material.dart';
import '../../../core/theme/pharmacy_color.dart';

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? iconColor;
  final VoidCallback? onTap;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 9,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30,
                color: iconColor ?? PharmacistColors.primary),
            const SizedBox(height: 12),
            Text(value, style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: PharmacistColors.textDark,
            )),
            const SizedBox(height: 5),
            Text(title, style: const TextStyle(
              fontSize: 12,
              color: PharmacistColors.textGrey,
            )),
          ],
        ),
      ),
    );
  }
}