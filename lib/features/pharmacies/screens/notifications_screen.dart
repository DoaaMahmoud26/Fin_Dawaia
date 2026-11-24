import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/services/notiications_service.dart';
import '../../../core/theme/pharmacy_color.dart';
import '../providers/navigation_providers.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PharmacistColors.background,
      appBar: AppBar(title: const Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.white, actions: [TextButton(onPressed: () => context.read<NotificationsService>().markAllRead(), child: const Text('Read all'))]),
      body: Consumer<NotificationsService>(builder: (context, service, _) {
        final items = service.notifications;
        if (items.isEmpty) return const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.notifications_none, size: 64, color: PharmacistColors.textGrey), SizedBox(height: 10), Text('No notifications yet', style: TextStyle(fontSize: 16, color: PharmacistColors.textGrey))]));
        return ListView.builder(padding: const EdgeInsets.all(16), itemCount: items.length, itemBuilder: (context, index) {
          final item = items[index];
          return Card(color: item.isRead ? Colors.white : const Color(0xFFE8F5F1), elevation: 0, margin: const EdgeInsets.only(bottom: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), child: InkWell(borderRadius: BorderRadius.circular(16), onTap: () {
            service.markRead(item.id);
            context.read<NavigationProvider>().goTo(item.destinationIndex);
          }, child: Padding(padding: const EdgeInsets.all(16), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const CircleAvatar(radius: 24, backgroundColor: Colors.white, child: Icon(Icons.notifications_active_outlined, size: 27, color: PharmacistColors.primary)),
            const SizedBox(width: 13), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)), const SizedBox(height: 5), Text(item.message, style: const TextStyle(color: PharmacistColors.textGrey)), const SizedBox(height: 7), Text(_format(item.createdAt), style: const TextStyle(fontSize: 12, color: PharmacistColors.textGrey))])),
            if (!item.isRead) const Icon(Icons.circle, size: 11, color: PharmacistColors.primary),
          ]))));
        });
      }),
    );
  }

  String _format(DateTime date) => '${date.day}/${date.month}/${date.year}  ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
}
