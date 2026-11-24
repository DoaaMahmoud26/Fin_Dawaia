import 'package:flutter/material.dart';

import '../../../core/theme/pharmacy_color.dart';

import '../../../models/medicine_model.dart';
import '../models/medicin_models.dart';


class MedicineCard extends StatelessWidget {
  final Medicine medicine;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const MedicineCard({
    super.key,
    required this.medicine,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLowStock = medicine.quantity <= 10;
    final bool isExpired =
    medicine.expiryDate.isBefore(DateTime.now());

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PharmacistColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade100,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Medicine Icon
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: PharmacistColors.lightGreen,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.medication_outlined,
              color: PharmacistColors.primary,
              size: 29,
            ),
          ),

          const SizedBox(width: 12),

          // Medicine Information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medicine.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: PharmacistColors.textDark,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  'Price: ${medicine.price.toStringAsFixed(2)} EGP',
                  style: const TextStyle(
                    fontSize: 12,
                    color: PharmacistColors.textGrey,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Quantity: ${medicine.quantity}',
                  style: TextStyle(
                    fontSize: 12,
                    color: isLowStock
                        ? PharmacistColors.warning
                        : PharmacistColors.textGrey,
                    fontWeight: isLowStock
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Expiry: ${medicine.expiryDate.day}/'
                      '${medicine.expiryDate.month}/'
                      '${medicine.expiryDate.year}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: PharmacistColors.textGrey,
                  ),
                ),

                if (isLowStock || isExpired) ...[
                  const SizedBox(height: 6),

                  if (isLowStock)
                    const Text(
                      'Low Stock',
                      style: TextStyle(
                        color: PharmacistColors.warning,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  if (isExpired)
                    const Text(
                      'Expired',
                      style: TextStyle(
                        color: PharmacistColors.error,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ],
            ),
          ),

          // Edit and Delete Buttons
          Column(
            children: [
              IconButton(
                onPressed: onEdit,
                icon: const Icon(
                  Icons.edit_outlined,
                ),
                color: PharmacistColors.primary,
                tooltip: 'Edit Medicine',
              ),

              IconButton(
                onPressed: onDelete,
                icon: const Icon(
                  Icons.delete_outline,
                ),
                color: PharmacistColors.error,
                tooltip: 'Delete Medicine',
              ),
            ],
          ),
        ],
      ),
    );
  }
}