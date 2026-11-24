import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../core/services/firestore_service.dart';

/// حالة تحميل الإحصائيات
enum LoadState { idle, loading, loaded, error }

/// AdminProvider = مخزن الحالة (State) الخاص بالأدمن.
/// بيمد الشاشات بـ: عدد الطلبات المعلّقة + الإحصائيات + تنفيذ اعتماد/رفض.
/// أي Widget بيعمل context.watch<AdminProvider>() بيتبنى من جديد تلقائي
/// كل ما نادينا notifyListeners().
class AdminProvider extends ChangeNotifier {
  final _fs = FirestoreService.instance;

  // ---------- الحالة ----------
  int pendingPharmacies = 0;
  AdminStats? stats;
  LoadState statsState = LoadState.idle;
  StreamSubscription<int>? _pendingSub;

  /// بنبدأ الاستماع بعد ما الأدمن يدخل (مش قبل، عشان الصلاحيات)
  void start() {
    _pendingSub?.cancel();
    _pendingSub = _fs.pendingCount().listen((count) {
      pendingPharmacies = count;
      notifyListeners();
    }, onError: (_) {});
  }

  void stop() {
    _pendingSub?.cancel();
    _pendingSub = null;
  }

  Future<void> loadStats() async {
    statsState = LoadState.loading;
    notifyListeners();
    try {
      stats = await _fs.getStats();
      statsState = LoadState.loaded;
    } catch (_) {
      statsState = LoadState.error;
    }
    notifyListeners();
  }

  /// بترجع null لو نجحت، أو رسالة الخطأ لو فشلت
  Future<String?> setPharmacyStatus(String id, String status) async {
    try {
      await _fs.setPharmacyStatus(id, status);
      return null;
    } catch (_) {
      return 'حدث خطأ، حاول مرة أخرى';
    }
  }

  @override
  void dispose() {
    stop();
    super.dispose();
  }
}