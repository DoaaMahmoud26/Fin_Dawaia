import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:medicinfine/core/services/invontery_service.dart';

import '../../../core/theme/pharmacy_color.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});
  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PharmacistColors.background,
      appBar: AppBar(title: const Text('Medicine Inventory', style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.white),
      body: Consumer<InventoryService>(builder: (context, inventory, _) {
        final medicines = inventory.searchMedicine(searchText);
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            TextField(onChanged: (v) => setState(() => searchText = v), decoration: InputDecoration(hintText: 'Search medicine...', prefixIcon: const Icon(Icons.search, size: 26), filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none))),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('All Medicines', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)), Text('${medicines.length} items')]),
            const SizedBox(height: 12),
            Expanded(child: medicines.isEmpty ? const Center(child: Text('No medicines found')) : ListView.builder(itemCount: medicines.length, itemBuilder: (context, index) {
              final medicine = medicines[index];
              final low = medicine.isLowStock;
              return Card(margin: const EdgeInsets.only(bottom: 12), color: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), child: Padding(padding: const EdgeInsets.all(15), child: Row(children: [
                const CircleAvatar(radius: 25, backgroundColor: Color(0xFFE8F5F1), child: Icon(Icons.medication_outlined, size: 28, color: PharmacistColors.primary)),
                const SizedBox(width: 13), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(medicine.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), const SizedBox(height: 5), Text('Price: ${medicine.price} EGP'), Text('Quantity: ${medicine.quantity}', style: TextStyle(color: low ? Colors.red : PharmacistColors.textGrey)), Text('Expiry: ${medicine.expiryDate.day}/${medicine.expiryDate.month}/${medicine.expiryDate.year}', style: const TextStyle(fontSize: 12))])),
                Icon(low ? Icons.warning_amber_rounded : Icons.check_circle_outline, size: 27, color: low ? Colors.orange : PharmacistColors.success),
              ])));
            })),
          ]),
        );
      }),
    );
  }
}
