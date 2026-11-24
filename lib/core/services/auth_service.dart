import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../constants/firestore_paths.dart';
import '../../models/user_model.dart';

class AuthService {
  AuthService._();
  static final instance = AuthService._();

  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authState => _auth.authStateChanges();

  /// تسجيل الدخول
  Future<void> signIn(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(), password: password);
    // لو الحساب موقوف من الأدمن نطلّع المستخدم
    final doc =
    await _db.collection(FirestorePaths.users).doc(cred.user!.uid).get();
    if (doc.exists && (doc.data()?['isActive'] == false)) {
      await _auth.signOut();
      throw FirebaseAuthException(
          code: 'user-disabled', message: 'تم إيقاف هذا الحساب');
    }
    await saveFcmToken();
  }

  /// إنشاء حساب جديد (مريض أو صيدلي فقط - الأدمن بيتعمل يدوي من الكونسول)
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    String role = UserRole.patient,
  }) async {
    assert(role != UserRole.admin);
    final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(), password: password);
    final user = UserModel(
        uid: cred.user!.uid, name: name, email: email.trim(), role: role);
    await _db.collection(FirestorePaths.users).doc(user.uid).set(user.toMap());
    await saveFcmToken();
  }

  /// جلب دور المستخدم (patient / pharmacist / admin)
  Future<String?> getRole(String uid) async {
    final doc = await _db.collection(FirestorePaths.users).doc(uid).get();
    return doc.data()?['role'] as String?;
  }

  /// حفظ توكن الإشعارات عشان الـ Cloud Function تبعتله
  Future<void> saveFcmToken() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return;
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await _db
            .collection(FirestorePaths.users)
            .doc(uid)
            .set({'fcmToken': token}, SetOptions(merge: true));
      }
    } catch (_) {}
  }

  Future<void> signOut() => _auth.signOut();

  /// ترجمة أخطاء Firebase لرسائل عربي
  static String errorMessage(Object e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'invalid-email':
          return 'البريد الإلكتروني غير صالح';
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          return 'البريد أو كلمة المرور غير صحيحة';
        case 'user-disabled':
          return 'تم إيقاف هذا الحساب';
        case 'email-already-in-use':
          return 'البريد مستخدم بالفعل';
        case 'weak-password':
          return 'كلمة المرور ضعيفة';
        case 'network-request-failed':
          return 'تأكد من اتصالك بالإنترنت';
      }
      return e.message ?? 'حدث خطأ غير متوقع';
    }
    return 'حدث خطأ غير متوقع';
  }
}