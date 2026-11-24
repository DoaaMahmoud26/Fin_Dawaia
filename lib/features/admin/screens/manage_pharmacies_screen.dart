import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/admin_provider.dart';
import '../../../core/services/firestore_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/pharmacy_model.dart';

/// إدارة الصيدليات + اعتماد/رفض الطلبات (3 تابات حسب الحالة)
class ManagePharmaciesScreen extends StatelessWidget {
  const ManagePharmaciesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إدارة الصيدليات'),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'قيد الانتظار'),
              Tab(text: 'معتمدة'),
              Tab(text: 'مرفوضة'),
            ],
          ),
        ),
        body: const TabBarView(children: [
          _PharmacyList(status: PharmacyStatus.pending),
          _PharmacyList(status: PharmacyStatus.approved),
          _PharmacyList(status: PharmacyStatus.rejected),
        ]),
      ),
    );
  }
}

class _PharmacyList extends StatelessWidget {
  final String status;
  const _PharmacyList({required this.status});

  Future<void> _change(BuildContext c, PharmacyModel p, String newStatus) async {
    // الأمر بيمر عن طريق الـ Provider (مش بنكلم Firestore مباشرة من الشاشة)
    final error =
    await c.read<AdminProvider>().setPharmacyStatus(p.id, newStatus);
    if (!c.mounted) return;
    final approved = newStatus == PharmacyStatus.approved;
    ScaffoldMessenger.of(c).showSnackBar(SnackBar(
      backgroundColor:
      (error == null && approved) ? AppColors.success : AppColors.error,
      content: Text(error ??
          (approved ? 'تم اعتماد ${p.name}' : 'تم رفض ${p.name}')),
    ));
  }

  Future<void> _delete(BuildContext c, PharmacyModel p) async {
    final ok = await showDialog<bool>(
      context: c,
      builder: (_) => AlertDialog(
        title: const Text('حذف الصيدلية'),
        content: Text('هل تريد حذف ${p.name} نهائياً؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('إلغاء')),
          TextButton(
              onPressed: () => Navigator.pop(c, true),
              child: const Text('حذف', style: TextStyle(color: AppColors.error))),
        ],
      ),
    );
    if (ok == true) await FirestoreService.instance.deletePharmacy(p.id);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<PharmacyModel>>(
      stream: FirestoreService.instance.pharmaciesByStatus(status),
      builder: (context, snap) {
        if (snap.hasError) {
          return const Center(child: Text('حدث خطأ في تحميل البيانات'));
        }
        if (!snap.hasData) {
          return const Center(
              child: CircularProgressIndicator(color: AppColors.primary));
        }
        final list = snap.data!;
        if (list.isEmpty) {
          return const Center(
              child: Text('لا توجد صيدليات', style: TextStyle(color: AppColors.textGrey)));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, i) => _card(context, list[i]),
        );
      },
    );
  }

  Widget _card(BuildContext c, PharmacyModel p) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 8)],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: AppColors.lightGreen,
                    borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.storefront_rounded,
                    color: AppColors.primary, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                    Text(p.address,
                        style: const TextStyle(
                            color: AppColors.textGrey, fontSize: 12)),
                    if (p.phone.isNotEmpty)
                      Text(p.phone,
                          style: const TextStyle(
                              color: AppColors.textGrey, fontSize: 12)),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: AppColors.error),
                onPressed: () => _delete(c, p),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              if (status != PharmacyStatus.approved)
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        minimumSize: const Size.fromHeight(40)),
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('اعتماد'),
                    onPressed: () => _change(c, p, PharmacyStatus.approved),
                  ),
                ),
              if (status == PharmacyStatus.pending) const SizedBox(width: 10),
              if (status != PharmacyStatus.rejected)
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        minimumSize: const Size.fromHeight(40)),
                    icon: const Icon(Icons.close, size: 18),
                    label: Text(status == PharmacyStatus.approved ? 'إيقاف' : 'رفض'),
                    onPressed: () => _change(c, p, PharmacyStatus.rejected),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}