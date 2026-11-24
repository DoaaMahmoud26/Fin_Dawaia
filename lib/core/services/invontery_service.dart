
import 'package:flutter/material.dart';
import 'package:medicinfine/models/medicine_model.dart';

import '../../features/pharmacies/models/medicin_models.dart';

class InventoryService extends ChangeNotifier {
  InventoryService._();

  static final InventoryService instance =
  InventoryService._();

  // قائمة الأدوية
  final List<Medicine> _medicines = [
    Medicine(
      id: '1',
      name: 'Panadol',
      price: 50,
      quantity: 20,
      expiryDate: DateTime(2027, 12, 30),
    ),
    Medicine(
      id: '2',
      name: 'Augmentin',
      price: 120,
      quantity: 5,
      expiryDate: DateTime(2027, 8, 15),
    ),
    Medicine(
      id: '3',
      name: 'Vitamin C',
      price: 35,
      quantity: 0,
      expiryDate: DateTime(2028, 5, 20),
    ),
  ];

  // الحصول على كل الأدوية
  List<Medicine> get medicines =>
      List.unmodifiable(_medicines);

  // عدد الأدوية
  int get totalMedicines => _medicines.length;

  // الأدوية المتوفرة
  int get availableMedicines =>
      _medicines.where((medicine) =>
      medicine.isAvailable).length;

  // الأدوية قليلة الكمية
  int get lowStockMedicines =>
      _medicines.where((medicine) =>
      medicine.isLowStock &&
          !medicine.isExpired).length;

  // الأدوية منتهية الصلاحية
  int get expiredMedicines =>
      _medicines.where((medicine) =>
      medicine.isExpired).length;

  // البحث عن دواء
  List<Medicine> searchMedicine(String query) {
    if (query.trim().isEmpty) {
      return medicines;
    }

    return _medicines.where((medicine) {
      return medicine.name
          .toLowerCase()
          .contains(query.trim().toLowerCase());
    }).toList();
  }

  // إضافة دواء
  void addMedicine(Medicine medicine) {
    final exists = _medicines.any(
          (item) => item.id == medicine.id,
    );

    if (exists) {
      throw Exception('Medicine already exists');
    }

    if (medicine.price < 0 || medicine.quantity < 0) {
      throw Exception('Invalid price or quantity');
    }

    _medicines.add(medicine);
    notifyListeners();
  }

  // تعديل دواء
  void updateMedicine(Medicine updatedMedicine) {
    final index = _medicines.indexWhere(
          (medicine) => medicine.id == updatedMedicine.id,
    );

    if (index == -1) {
      throw Exception('Medicine not found');
    }

    if (updatedMedicine.price < 0 ||
        updatedMedicine.quantity < 0) {
      throw Exception('Invalid price or quantity');
    }

    _medicines[index] = updatedMedicine;
    notifyListeners();
  }

  // حذف دواء
  void deleteMedicine(String id) {
    _medicines.removeWhere(
          (medicine) => medicine.id == id,
    );

    notifyListeners();
  }

  // الحصول على دواء باستخدام ID
  Medicine? getMedicineById(String id) {
    try {
      return _medicines.firstWhere(
            (medicine) => medicine.id == id,
      );
    } catch (_) {
      return null;
    }
  }

  // تحديث كمية الدواء
  void updateQuantity(String id, int newQuantity) {
    if (newQuantity < 0) {
      throw Exception('Quantity cannot be negative');
    }

    final medicine = getMedicineById(id);

    if (medicine == null) {
      throw Exception('Medicine not found');
    }

    updateMedicine(
      Medicine(
        id: medicine.id,
        name: medicine.name,
        price: medicine.price,
        quantity: newQuantity,
        expiryDate: medicine.expiryDate,
      ),
    );
  }
}
