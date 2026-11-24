import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/medicine_model.dart';
import '../constants/firestore_paths.dart';
import '../../models/user_model.dart';
import '../../models/pharmacy_model.dart';


/// إحصائيات صفحة التقارير
class AdminStats {
  final int users, pharmacists, approvedPharmacies, pendingPharmacies, medicines;
  const AdminStats(this.users, this.pharmacists, this.approvedPharmacies,
      this.pendingPharmacies, this.medicines);
}

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  final _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _users =>
      _db.collection(FirestorePaths.users);
  CollectionReference<Map<String, dynamic>> get _pharmacies =>
      _db.collection(FirestorePaths.pharmacies);
  CollectionReference<Map<String, dynamic>> get _medicines =>
      _db.collection(FirestorePaths.medicines);

  // ================= Users =================
  Stream<List<UserModel>> usersStream() => _users.snapshots().map((s) {
    final list = s.docs.map(UserModel.fromDoc).toList();
    list.sort((a, b) => a.name.compareTo(b.name));
    return list;
  });

  Future<void> setUserActive(String uid, bool active) =>
      _users.doc(uid).update({'isActive': active});

  Future<void> setUserRole(String uid, String role) =>
      _users.doc(uid).update({'role': role});

  Future<void> deleteUser(String uid) => _users.doc(uid).delete();

  // ================= Pharmacies =================
  /// بنفلتر بالـ status بس وبنرتب في الكلاينت (عشان منحتاجش Composite Index)
  Stream<List<PharmacyModel>> pharmaciesByStatus(String status) => _pharmacies
      .where('status', isEqualTo: status)
      .snapshots()
      .map((s) {
    final list = s.docs.map(PharmacyModel.fromDoc).toList();
    list.sort((a, b) => (b.createdAt ?? DateTime(2000))
        .compareTo(a.createdAt ?? DateTime(2000)));
    return list;
  });

  Stream<int> pendingCount() => _pharmacies
      .where('status', isEqualTo: PharmacyStatus.pending)
      .snapshots()
      .map((s) => s.size);

  /// اعتماد / رفض صيدلية.. الـ Cloud Function هتبعت إشعار لصاحبها تلقائي
  Future<void> setPharmacyStatus(String id, String status) =>
      _pharmacies.doc(id).update({
        'status': status,
        'reviewedAt': FieldValue.serverTimestamp(),
      });

  Future<void> deletePharmacy(String id) => _pharmacies.doc(id).delete();

  // ================= Medicines =================
  Stream<List<MedicineModel>> medicinesStream() =>
      _medicines.snapshots().map((s) {
        final list = s.docs.map(MedicineModel.fromDoc).toList();
        list.sort((a, b) => a.name.compareTo(b.name));
        return list;
      });

  Future<void> addMedicine(MedicineModel m) => _medicines.add(m.toMap());
  Future<void> deleteMedicine(String id) => _medicines.doc(id).delete();

  // ================= Reports =================
  Future<AdminStats> getStats() async {
    final r = await Future.wait([
      _users.count().get(),
      _users.where('role', isEqualTo: UserRole.pharmacist).count().get(),
      _pharmacies
          .where('status', isEqualTo: PharmacyStatus.approved)
          .count()
          .get(),
      _pharmacies
          .where('status', isEqualTo: PharmacyStatus.pending)
          .count()
          .get(),
      _medicines.count().get(),
    ]);
    return AdminStats(r[0].count ?? 0, r[1].count ?? 0, r[2].count ?? 0,
        r[3].count ?? 0, r[4].count ?? 0);
  }
}