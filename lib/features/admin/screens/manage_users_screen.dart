import 'package:flutter/material.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/firestore_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/user_model.dart';

/// إدارة المستخدمين: بحث + تفعيل/إيقاف + تغيير الدور + حذف
class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  String _query = '';

  Color _roleColor(String r) => r == UserRole.admin
      ? AppColors.warning
      : r == UserRole.pharmacist
      ? AppColors.info
      : AppColors.success;

  @override
  Widget build(BuildContext context) {
    final myUid = AuthService.instance.currentUser?.uid;
    return Scaffold(
      appBar: AppBar(title: const Text('إدارة المستخدمين')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (v) => setState(() => _query = v.trim().toLowerCase()),
              decoration: InputDecoration(
                hintText: 'ابحث بالاسم أو البريد...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<UserModel>>(
              stream: FirestoreService.instance.usersStream(),
              builder: (context, snap) {
                if (snap.hasError) {
                  return const Center(child: Text('حدث خطأ في تحميل البيانات'));
                }
                if (!snap.hasData) {
                  return const Center(
                      child: CircularProgressIndicator(color: AppColors.primary));
                }
                final users = snap.data!
                    .where((u) =>
                u.name.toLowerCase().contains(_query) ||
                    u.email.toLowerCase().contains(_query))
                    .toList();
                if (users.isEmpty) {
                  return const Center(child: Text('لا يوجد مستخدمون'));
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: users.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final u = users[i];
                    final isMe = u.uid == myUid;
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16)),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColors.lightGreen,
                            child: Text(
                                u.name.isNotEmpty ? u.name[0] : '?',
                                style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(u.name,
                                    style: const TextStyle(fontWeight: FontWeight.bold)),
                                Text(u.email,
                                    style: const TextStyle(
                                        fontSize: 12, color: AppColors.textGrey)),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                      color: _roleColor(u.role).withOpacity(.15),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Text(UserRole.label(u.role),
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: _roleColor(u.role),
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                          if (!isMe) ...[
                            Switch(
                              value: u.isActive,
                              activeColor: AppColors.primary,
                              onChanged: (v) =>
                                  FirestoreService.instance.setUserActive(u.uid, v),
                            ),
                            PopupMenuButton<String>(
                              onSelected: (v) {
                                if (v == 'delete') {
                                  FirestoreService.instance.deleteUser(u.uid);
                                } else {
                                  FirestoreService.instance.setUserRole(u.uid, v);
                                }
                              },
                              itemBuilder: (_) => const [
                                PopupMenuItem(
                                    value: UserRole.patient, child: Text('تعيين كمريض')),
                                PopupMenuItem(
                                    value: UserRole.pharmacist, child: Text('تعيين كصيدلي')),
                                PopupMenuItem(
                                    value: UserRole.admin, child: Text('تعيين كمدير')),
                                PopupMenuItem(
                                    value: 'delete',
                                    child: Text('حذف',
                                        style: TextStyle(color: AppColors.error))),
                              ],
                            ),
                          ] else
                            const Padding(
                              padding: EdgeInsets.all(8),
                              child: Text('(أنت)',
                                  style: TextStyle(color: AppColors.textGrey)),
                            ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}