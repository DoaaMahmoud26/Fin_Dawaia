import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/requests_sevice.dart';
import '../../../core/services/notiications_service.dart';
import '../../../core/services/invontery_service.dart';

import '../../../core/theme/pharmacy_color.dart';

class RequestsScreen extends StatelessWidget {
  const RequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PharmacistColors.background,
      appBar: AppBar(title: const Text('Medicine Requests', style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.white),
      body: Consumer<RequestsService>(builder: (context, service, _) {
        final requests = service.requests;
        if (requests.isEmpty) return const Center(child: Text('No requests yet'));
        return ListView.builder(padding: const EdgeInsets.all(16), itemCount: requests.length, itemBuilder: (context, index) {
          final request = requests[index];
          final pending = request.status == 'Pending';
          final accepted = request.status == 'Accepted';
          final statusColor = pending ? Colors.orange : accepted ? PharmacistColors.success : Colors.red;
          return Card(color: Colors.white, elevation: 0, margin: const EdgeInsets.only(bottom: 13), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)), child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [const CircleAvatar(radius: 23, backgroundColor: Color(0xFFE8F5F1), child: Icon(Icons.person_outline, size: 27, color: PharmacistColors.primary)), const SizedBox(width: 12), Expanded(child: Text(request.customerName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))), Container(padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6), decoration: BoxDecoration(color: statusColor.withValues(alpha: .12), borderRadius: BorderRadius.circular(20)), child: Text(request.status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold)))]),
            const Divider(height: 24),
            Text('Medicine: ${request.medicineName}', style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6), Text('Quantity: ${request.quantity}'),
            const SizedBox(height: 5), Text('Request ID: ${request.id}', style: const TextStyle(color: PharmacistColors.textGrey, fontSize: 12)),
            if (pending) ...[
              const SizedBox(height: 15),
              Row(children: [Expanded(child: ElevatedButton.icon(onPressed: () => _update(context, request.id, 'Accepted'), icon: const Icon(Icons.check, size: 20), label: const Text('Accept'), style: ElevatedButton.styleFrom(backgroundColor: PharmacistColors.primary, foregroundColor: Colors.white, minimumSize: const Size(0, 46)))), const SizedBox(width: 10), Expanded(child: OutlinedButton.icon(onPressed: () => _update(context, request.id, 'Rejected'), icon: const Icon(Icons.close, size: 20), label: const Text('Reject'), style: OutlinedButton.styleFrom(foregroundColor: Colors.red, minimumSize: const Size(0, 46))))]),
            ],
          ])));
        });
      }),
    );
  }

  void _update(BuildContext context, String id, String status) {
    final service = context.read<RequestsService>();
    final request = service.getRequestById(id);
    if (request == null) return;
    if (status == 'Accepted') {
      final inventory = context.read<InventoryService>();
      final matches = inventory.medicines.where(
            (item) => item.name.toLowerCase() == request.medicineName.toLowerCase(),
      );
      final medicine = matches.isEmpty ? null : matches.first;
      if (medicine == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${request.medicineName} is not in your inventory')),
        );
        return;
      }
      if (medicine.quantity < request.quantity) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Not enough stock to accept this request')),
        );
        return;
      }
      inventory.updateQuantity(medicine.id, medicine.quantity - request.quantity);
    }
    service.updateRequest(id, status);
    context.read<NotificationsService>().add(
      title: status == 'Accepted' ? 'Request accepted' : 'Request rejected',
      message: '${request.medicineName} request from ${request.customerName} was ${status.toLowerCase()}.',
      destinationIndex: 3,
    );
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Request $status')));
  }
}
