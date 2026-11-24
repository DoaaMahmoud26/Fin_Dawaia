import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medicinfine/core/services/invontery_service.dart';
import 'package:medicinfine/core/services/notiications_service.dart';

import '../../../core/theme/pharmacy_color.dart';
import '../models/medicin_models.dart';

class AddMedicineScreen extends StatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();

  DateTime? expiryDate;

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  Future<void> selectExpiryDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
    );

    if (selected != null) {
      setState(() {
        expiryDate = selected;
      });
    }
  }

  void saveMedicine() {
    if (!_formKey.currentState!.validate()) return;

    if (expiryDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select expiry date')),
      );
      return;
    }

    final medicine = Medicine(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: nameController.text.trim(),
      price: double.parse(priceController.text.trim()),
      quantity: int.parse(quantityController.text.trim()),
      expiryDate: expiryDate!,
    );

    try {
      context.read<InventoryService>().addMedicine(medicine);
      context.read<NotificationsService>().add(
        title: 'New medicine added',
        message: '${medicine.name} was added to inventory.',
        destinationIndex: 1,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Medicine added to inventory successfully')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString().replaceFirst('Exception: ', ''))),
      );
      return;
    }

    nameController.clear();
    priceController.clear();
    quantityController.clear();

    setState(() {
      expiryDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PharmacistColors.background,
      appBar: AppBar(
        title: const Text(
          'Add Medicine',
          style: TextStyle(
            color: PharmacistColors.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Medicine Information',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: PharmacistColors.textDark,
                ),
              ),
              const SizedBox(height: 20),

              _buildLabel('Medicine Name'),
              _buildField(
                controller: nameController,
                hint: 'Enter medicine name',
                icon: Icons.medication_outlined,
              ),

              const SizedBox(height: 18),
              _buildLabel('Price (EGP)'),
              _buildField(
                controller: priceController,
                hint: 'Enter medicine price',
                icon: Icons.attach_money,
                isNumber: true,
              ),

              const SizedBox(height: 18),
              _buildLabel('Quantity'),
              _buildField(
                controller: quantityController,
                hint: 'Enter available quantity',
                icon: Icons.inventory_2_outlined,
                isNumber: true,
                isInteger: true,
              ),

              const SizedBox(height: 18),
              _buildLabel('Expiry Date'),
              InkWell(
                onTap: selectExpiryDate,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_month,
                        color: PharmacistColors.primary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        expiryDate == null
                            ? 'Select expiry date'
                            : '${expiryDate!.day}/${expiryDate!.month}/${expiryDate!.year}',
                        style: const TextStyle(
                          color: PharmacistColors.textDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: saveMedicine,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PharmacistColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  child: const Text(
                    'Save Medicine',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: PharmacistColors.textDark,
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isNumber = false,
    bool isInteger = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required';
        }

        if (isInteger && int.tryParse(value) == null) {
          return 'Enter a whole number';
        }
        if (isNumber && double.tryParse(value) == null) {
          return 'Enter a valid number';
        }

        if (isNumber && double.parse(value) <= 0) {
          return 'Value must be greater than zero';
        }

        return null;
      },
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: PharmacistColors.primary),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}