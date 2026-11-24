import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/admin_provider.dart';
import '../widgets/admin_card.dart';
import 'manage_medicines_screen.dart';
import 'manage_pharmacies_screen.dart';
import 'manage_users_screen.dart';
import 'reports_screen.dart';

/// شاشة "لوحة الإدارة" - 4 كروت في Grid
class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({super.key});

  void _open(BuildContext c, Widget page) =>
      Navigator.push(c, MaterialPageRoute(builder: (_) => page));

  @override
  Widget build(BuildContext context) {
    // watch: الشاشة تتحدث لما عدد الطلبات المعلقة يتغير
    final pending = context.watch<AdminProvider>().pendingPharmacies;

    return Scaffold(
      appBar: AppBar(title: const Text('لوحة الإدارة')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 1.15,
          shrinkWrap: true,
          children: [
            AdminCard(
              icon: Icons.medication_rounded,
              title: 'إدارة الأدوية',
              onTap: () => _open(context, const ManageMedicinesScreen()),
            ),
            AdminCard(
              icon: Icons.storefront_rounded,
              title: 'إدارة الصيدليات',
              badge: pending,
              onTap: () => _open(context, const ManagePharmaciesScreen()),
            ),
            AdminCard(
              icon: Icons.groups_rounded,
              title: 'إدارة المستخدمين',
              onTap: () => _open(context, const ManageUsersScreen()),
            ),
            AdminCard(
              icon: Icons.bar_chart_rounded,
              title: 'عرض التقارير',
              onTap: () => _open(context, const ReportsScreen()),
            ),
          ],
        ),
      ),
    );
  }
}