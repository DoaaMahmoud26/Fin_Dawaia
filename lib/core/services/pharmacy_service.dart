
import 'package:flutter/material.dart';

class PharmacyService extends ChangeNotifier {
  PharmacyService._();

  static final PharmacyService instance =
  PharmacyService._();

  // بيانات الصيدلية الافتراضية
  String _pharmacyName = 'Fein Dawai Pharmacy';
  String _pharmacistName = 'Ahmed Mohamed';
  String _phone = '01000000000';
  String _address = 'Cairo, Egypt';
  String _workingHours = '9:00 AM - 11:00 PM';

  // قراءة البيانات
  String get pharmacyName => _pharmacyName;

  String get pharmacistName => _pharmacistName;

  String get phone => _phone;

  String get address => _address;

  String get workingHours => _workingHours;

  // تعديل بيانات الصيدلية
  void updateProfile({
    required String pharmacyName,
    required String pharmacistName,
    required String phone,
    required String address,
    required String workingHours,
  }) {
    if (pharmacyName.trim().isEmpty ||
        pharmacistName.trim().isEmpty ||
        phone.trim().isEmpty ||
        address.trim().isEmpty ||
        workingHours.trim().isEmpty) {
      throw Exception('Please fill in all fields');
    }

    _pharmacyName = pharmacyName.trim();
    _pharmacistName = pharmacistName.trim();
    _phone = phone.trim();
    _address = address.trim();
    _workingHours = workingHours.trim();

    notifyListeners();
  }

  // تعديل رقم الهاتف فقط
  void updatePhone(String newPhone) {
    if (newPhone.trim().isEmpty) {
      throw Exception('Phone number cannot be empty');
    }

    _phone = newPhone.trim();
    notifyListeners();
  }

  // تعديل العنوان فقط
  void updateAddress(String newAddress) {
    if (newAddress.trim().isEmpty) {
      throw Exception('Address cannot be empty');
    }

    _address = newAddress.trim();
    notifyListeners();
  }
}
