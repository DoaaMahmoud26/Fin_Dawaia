import 'package:flutter/material.dart';

class AppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime createdAt;
  final int destinationIndex;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.destinationIndex,
    this.isRead = false,
  });
}

class NotificationsService extends ChangeNotifier {
  final List<AppNotification> _items = [];
  List<AppNotification> get notifications => List.unmodifiable(_items);
  int get unreadCount => _items.where((item) => !item.isRead).length;

  void add({required String title, required String message, required int destinationIndex}) {
    _items.insert(0, AppNotification(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      message: message,
      createdAt: DateTime.now(),
      destinationIndex: destinationIndex,
    ));
    notifyListeners();
  }

  void markRead(String id) {
    for (final item in _items) {
      if (item.id == id && !item.isRead) {
        item.isRead = true;
        notifyListeners();
        return;
      }
    }
    notifyListeners();
  }

  void markAllRead() {
    for (final item in _items) { item.isRead = true; }
    notifyListeners();
  }
}
