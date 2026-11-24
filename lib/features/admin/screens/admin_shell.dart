import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/admin_provider.dart';
import '../../../core/theme/app_colors.dart';
import 'admin_panel_screen.dart';
import 'reports_screen.dart';
import 'admin_profile_screen.dart';

/// الهيكل الرئيسي للأدمن: 3 تابات (الرئيسية - التقارير - الملف)
class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _index = 0;
  late final AdminProvider _admin;

  @override
  void initState() {
    super.initState();
    _admin = context.read<AdminProvider>();
    _admin.start(); // نبدأ الاستماع لعدد الطلبات المعلقة
  }

  @override
  void dispose() {
    _admin.stop(); // نوقف الاستماع لما الأدمن يخرج
    super.dispose();
  }

  final _pages = const [
    AdminPanelScreen(),
    ReportsScreen(embedded: true),
    AdminProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textGrey,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded), label: 'الرئيسية'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_rounded), label: 'التقارير'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded), label: 'الملف'),
        ],
      ),
    );
  }
}