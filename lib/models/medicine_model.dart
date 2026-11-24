import 'package:cloud_firestore/cloud_firestore.dart';

class MedicineModel {
  final String id;
  final String name;
  final String category;
  final String description;

  const MedicineModel({
    required this.id,
    required this.name,
    this.category = '',
    this.description = '',
  });

  factory MedicineModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return MedicineModel(
      id: doc.id,
      name: d['name'] ?? '',
      category: d['category'] ?? '',
      description: d['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'nameLower': name.toLowerCase(), // للبحث لاحقاً
    'category': category,
    'description': description,
    'createdAt': FieldValue.serverTimestamp(),
  };
}


