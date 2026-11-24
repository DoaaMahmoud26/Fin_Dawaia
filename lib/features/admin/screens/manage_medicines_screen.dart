import 'package:flutter/material.dart';
import '../../../core/services/firestore_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/medicine_model.dart';

/// إدارة الأدوية: عرض + إضافة + حذف
class ManageMedicinesScreen extends StatelessWidget {
  const ManageMedicinesScreen({super.key});

  Future<void> _showAddDialog(BuildContext context) async {
    final name = TextEditingController();
    final category = TextEditingController();
    final desc = TextEditingController();
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إضافة دواء جديد'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: name, decoration: const InputDecoration(labelText: 'اسم الدواء')),
            TextField(controller: category, decoration: const InputDecoration(labelText: 'التصنيف')),
            TextField(controller: desc, decoration: const InputDecoration(labelText: 'الوصف')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: const Size(90, 40)),
            onPressed: () async {
              if (name.text.trim().isEmpty) return;
              await FirestoreService.instance.addMedicine(MedicineModel(
                  id: '',
                  name: name.text.trim(),
                  category: category.text.trim(),
                  description: desc.text.trim()));
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إدارة الأدوية')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: StreamBuilder<List<MedicineModel>>(
        stream: FirestoreService.instance.medicinesStream(),
        builder: (context, snap) {
          if (snap.hasError) return const Center(child: Text('حدث خطأ في تحميل البيانات'));
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          final list = snap.data!;
          if (list.isEmpty) return const Center(child: Text('لا توجد أدوية، أضف أول دواء'));
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) {
              final m = list[i];
              return Container(
                decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: AppColors.lightGreen,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.medication_rounded, color: AppColors.primary),
                  ),
                  title: Text(m.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(m.category),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: AppColors.error),
                    onPressed: () => FirestoreService.instance.deleteMedicine(m.id),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}