import 'package:flutter/material.dart';
import '../../../core/theme/pharmacy_color.dart';


class RequestCard extends StatelessWidget {
  final String medicineName;
  final String customerName;
  final int quantity;
  final String status;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  const RequestCard({
    super.key,
    required this.medicineName,
    required this.customerName,
    required this.quantity,
    required this.status,
    this.onAccept,
    this.onReject,
  });

  Color get statusColor {
    switch (status.toLowerCase()) {
      case 'accepted':
        return PharmacistColors.success;
      case 'rejected':
        return PharmacistColors.error;
      default:
        return PharmacistColors.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(medicineName, style:
              const TextStyle(fontWeight: FontWeight.bold))),
              Text(status, style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.bold,
              )),
            ],
          ),
          const SizedBox(height: 10),
          Text('Customer: $customerName'),
          Text('Quantity: $quantity'),
          if (status.toLowerCase() == 'pending') ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onAccept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PharmacistColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Accept'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: onReject,
                    child: const Text('Reject'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}