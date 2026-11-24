
import 'package:flutter/material.dart';

// نموذج طلب المريض
class PharmacyRequest {
  final String id;
  final String medicineName;
  final String customerName;
  final int quantity;
  final String status;
  final DateTime requestDate;

  const PharmacyRequest({
    required this.id,
    required this.medicineName,
    required this.customerName,
    required this.quantity,
    required this.status,
    required this.requestDate,
  });

  // إنشاء نسخة جديدة عند تعديل حالة الطلب
  PharmacyRequest copyWith({
    String? status,
  }) {
    return PharmacyRequest(
      id: id,
      medicineName: medicineName,
      customerName: customerName,
      quantity: quantity,
      status: status ?? this.status,
      requestDate: requestDate,
    );
  }
}

class RequestsService extends ChangeNotifier {
  RequestsService._();

  static final RequestsService instance =
  RequestsService._();

  // طلبات تجريبية
  final List<PharmacyRequest> _requests = [
    PharmacyRequest(
      id: 'REQ001',
      medicineName: 'Panadol',
      customerName: 'Mohamed Ali',
      quantity: 2,
      status: 'Pending',
      requestDate: DateTime.now(),
    ),
    PharmacyRequest(
      id: 'REQ002',
      medicineName: 'Augmentin',
      customerName: 'Sara Ahmed',
      quantity: 1,
      status: 'Pending',
      requestDate: DateTime.now(),
    ),
    PharmacyRequest(
      id: 'REQ003',
      medicineName: 'Vitamin C',
      customerName: 'Omar Hassan',
      quantity: 3,
      status: 'Accepted',
      requestDate: DateTime.now(),
    ),
  ];

  // عرض كل الطلبات
  List<PharmacyRequest> get requests =>
      List.unmodifiable(_requests);

  // عدد الطلبات الجديدة
  int get pendingRequests =>
      _requests.where(
            (request) => request.status == 'Pending',
      ).length;

  // عدد الطلبات المقبولة
  int get acceptedRequests =>
      _requests.where(
            (request) => request.status == 'Accepted',
      ).length;

  // عدد الطلبات المرفوضة
  int get rejectedRequests =>
      _requests.where(
            (request) => request.status == 'Rejected',
      ).length;

  // البحث عن طلب
  List<PharmacyRequest> searchRequests(String query) {
    if (query.trim().isEmpty) {
      return requests;
    }

    return _requests.where((request) {
      return request.medicineName
          .toLowerCase()
          .contains(query.toLowerCase()) ||
          request.customerName
              .toLowerCase()
              .contains(query.toLowerCase()) ||
          request.id
              .toLowerCase()
              .contains(query.toLowerCase());
    }).toList();
  }

  // تحديث حالة الطلب
  void updateRequest(String id, String newStatus) {
    const allowedStatuses = [
      'Pending',
      'Accepted',
      'Rejected',
    ];

    if (!allowedStatuses.contains(newStatus)) {
      throw Exception('Invalid request status');
    }

    final index = _requests.indexWhere(
          (request) => request.id == id,
    );

    if (index == -1) {
      throw Exception('Request not found');
    }

    _requests[index] =
        _requests[index].copyWith(status: newStatus);

    notifyListeners();
  }

  // إضافة طلب جديد
  void addRequest(PharmacyRequest request) {
    final exists = _requests.any(
          (item) => item.id == request.id,
    );

    if (exists) {
      throw Exception('Request already exists');
    }

    _requests.add(request);
    notifyListeners();
  }

  // الحصول على طلب باستخدام ID
  PharmacyRequest? getRequestById(String id) {
    try {
      return _requests.firstWhere(
            (request) => request.id == id,
      );
    } catch (_) {
      return null;
    }
  }
}
