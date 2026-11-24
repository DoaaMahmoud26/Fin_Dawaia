import 'package:cloud_firestore/cloud_firestore.dart';

class UserRole {
  static const patient = 'patient';
  static const pharmacist = 'pharmacist';
  static const admin = 'admin';

  static String label(String r) {
    switch (r) {
      case admin:
        return 'مدير';
      case pharmacist:
        return 'صيدلي';
      default:
        return 'مريض';
    }
  }
}

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String role;
  final bool isActive;
  final String? fcmToken;
  final DateTime? createdAt;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.role = UserRole.patient,
    this.isActive = true,
    this.fcmToken,
    this.createdAt,
  });

  factory UserModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return UserModel(
      uid: doc.id,
      name: d['name'] ?? '',
      email: d['email'] ?? '',
      role: d['role'] ?? UserRole.patient,
      isActive: d['isActive'] ?? true,
      fcmToken: d['fcmToken'],
      createdAt: (d['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'email': email,
    'role': role,
    'isActive': isActive,
    'createdAt': FieldValue.serverTimestamp(),
  };
}



