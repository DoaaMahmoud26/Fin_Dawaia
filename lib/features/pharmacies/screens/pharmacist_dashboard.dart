import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:medicinfine/features/pharmacies/providers/navigation_providers.dart';

import '../../../core/services/invontery_service.dart';
import '../../../core/services/notiications_service.dart';
import '../../../core/services/pharmacy_service.dart';
import '../../../core/services/requests_sevice.dart';
import '../../../core/theme/pharmacy_color.dart';
import '../widgets/dashoard_card.dart';


class PharmacistDashboard extends StatelessWidget {
  const PharmacistDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer4<InventoryService, RequestsService, PharmacyService, NotificationsService>(
      builder: (context, inventory, requests, pharmacy, notifications, _) {
        return SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(width: double.infinity, padding: const EdgeInsets.fromLTRB(20, 24, 20, 25), decoration: const BoxDecoration(color: PharmacistColors.primary, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(26), bottomRight: Radius.circular(26))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [Expanded(child: Text('Hello, ${pharmacy.pharmacistName}', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))), IconButton(onPressed: () => context.read<NavigationProvider>().goTo(5), icon: Badge(isLabelVisible: notifications.unreadCount > 0, label: Text('${notifications.unreadCount}'), child: const Icon(Icons.notifications_none, color: Colors.white, size: 30)))]),
            const SizedBox(height: 15),
            Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: PharmacistColors.lightGreen, borderRadius: BorderRadius.circular(18)), child: Row(children: [const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Welcome back!', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: PharmacistColors.primary)), SizedBox(height: 7), Text('Manage your pharmacy and medicines easily.', style: TextStyle(fontSize: 13, color: PharmacistColors.textDark))])), const Icon(Icons.local_pharmacy, size: 55, color: PharmacistColors.primary)])),
          ])),
          const Padding(padding: EdgeInsets.fromLTRB(18, 24, 18, 14), child: Text('Overview', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: PharmacistColors.textDark))),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.25, children: [
            DashboardCard(title: 'Available Medicines', value: '${inventory.availableMedicines}', icon: Icons.medication_outlined, onTap: () => context.read<NavigationProvider>().goTo(1)),
            DashboardCard(title: 'New Requests', value: '${requests.pendingRequests}', icon: Icons.notifications_active_outlined, iconColor: PharmacistColors.warning, onTap: () => context.read<NavigationProvider>().goTo(3)),
            DashboardCard(title: 'Accepted Orders', value: '${requests.acceptedRequests}', icon: Icons.check_circle_outline, iconColor: PharmacistColors.success, onTap: () => context.read<NavigationProvider>().goTo(3)),
            DashboardCard(title: 'Low Stock', value: '${inventory.lowStockMedicines}', icon: Icons.warning_amber_outlined, iconColor: PharmacistColors.error, onTap: () => context.read<NavigationProvider>().goTo(1)),
          ])),
          const Padding(padding: EdgeInsets.fromLTRB(18, 25, 18, 14), child: Text('Quick Actions', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: PharmacistColors.textDark))),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Row(children: [Expanded(child: _action(context, Icons.add_circle_outline, 'Add Medicine', 2)), const SizedBox(width: 12), Expanded(child: _action(context, Icons.inventory_2_outlined, 'Inventory', 1))])),
          const SizedBox(height: 12),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Row(children: [Expanded(child: _action(context, Icons.inbox_outlined, 'Requests', 3)), const SizedBox(width: 12), Expanded(child: _action(context, Icons.person_outline, 'My Profile', 4))])),
          const SizedBox(height: 25),
        ]));
      },
    );
  }

  Widget _action(BuildContext context, IconData icon, String title, int index) => InkWell(onTap: () => context.read<NavigationProvider>().goTo(index), borderRadius: BorderRadius.circular(16), child: Container(padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .04), blurRadius: 8, offset: const Offset(0, 3))]), child: Column(children: [Icon(icon, color: PharmacistColors.primary, size: 34), const SizedBox(height: 10), Text(title, textAlign: TextAlign.center, style: const TextStyle(color: PharmacistColors.textDark, fontWeight: FontWeight.w600, fontSize: 13))])));
}
