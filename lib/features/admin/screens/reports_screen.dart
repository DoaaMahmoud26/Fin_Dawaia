import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/admin_provider.dart';

/// عرض التقارير: الأرقام جاية من AdminProvider
class ReportsScreen extends StatefulWidget {
  final bool embedded; // true لو جوه التاب (من غير سهم رجوع)
  const ReportsScreen({super.key, this.embedded = false});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  @override
  void initState() {
    super.initState();
    // read: بننفذ أمر مرة واحدة من غير ما نشترك في التغييرات
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<AdminProvider>().loadStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<AdminProvider>();
    final s = p.stats;

    Widget body;
    if (p.statsState == LoadState.error && s == null) {
      body = ListView(children: const [
        SizedBox(height: 200),
        Center(child: Text('حدث خطأ في تحميل التقارير')),
      ]);
    } else if (s == null) {
      body = const Center(
          child: CircularProgressIndicator(color: AppColors.primary));
    } else {
      final items = [
        ('إجمالي المستخدمين', s.users, Icons.groups_rounded, AppColors.primary),
        ('الصيادلة', s.pharmacists, Icons.local_pharmacy_rounded, AppColors.info),
        ('صيدليات معتمدة', s.approvedPharmacies, Icons.verified_rounded, AppColors.success),
        ('طلبات معلّقة', s.pendingPharmacies, Icons.hourglass_top_rounded, AppColors.warning),
        ('الأدوية', s.medicines, Icons.medication_rounded, AppColors.secondary),
      ];
      body = GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1.15,
        physics: const AlwaysScrollableScrollPhysics(),
        children: items
            .map((e) => Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(e.$3, color: e.$4, size: 32),
              const SizedBox(height: 6),
              Text('${e.$2}',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: e.$4)),
              Text(e.$1,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textGrey)),
            ],
          ),
        ))
            .toList(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('التقارير'),
        automaticallyImplyLeading: !widget.embedded,
      ),
      body: RefreshIndicator(onRefresh: p.loadStats, child: body),
    );
  }
}