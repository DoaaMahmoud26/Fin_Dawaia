import 'package:cloud_firestore/cloud_firestore.dart';

class PharmacyStatus {
  static const pending = 'pending';
  static const approved = 'approved';
  static const rejected = 'rejected';
}

class PharmacyModel {
  final String id;
  final String name;
  final String address;
  final String phone;
  final String ownerId;
  final String status;
  final double rating;
  final double? lat;
  final double? lng;
  final DateTime? createdAt;

  const PharmacyModel({
    required this.id,
    required this.name,
    required this.address,
    required this.ownerId,
    this.phone = '',
    this.status = PharmacyStatus.pending,
    this.rating = 0,
    this.lat,
    this.lng,
    this.createdAt,
  });

  factory PharmacyModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return PharmacyModel(
      id: doc.id,
      name: d['name'] ?? '',
      address: d['address'] ?? '',
      phone: d['phone'] ?? '',
      ownerId: d['ownerId'] ?? '',
      status: d['status'] ?? PharmacyStatus.pending,
      rating: (d['rating'] ?? 0).toDouble(),
      lat: (d['lat'] as num?)?.toDouble(),
      lng: (d['lng'] as num?)?.toDouble(),
      createdAt: (d['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'address': address,
    'phone': phone,
    'ownerId': ownerId,
    'status': status,
    'rating': rating,
    'lat': lat,
    'lng': lng,
    'createdAt': FieldValue.serverTimestamp(),
  };
}