import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/pharmacy_service.dart';
import '../../../core/services/notiications_service.dart';

import '../../../core/theme/pharmacy_color.dart';

class PharmacyProfileScreen extends StatefulWidget {
  const PharmacyProfileScreen({super.key});

  @override
  State<PharmacyProfileScreen> createState() =>
      _PharmacyProfileScreenState();
}

class _PharmacyProfileScreenState extends State<PharmacyProfileScreen> {
  late final TextEditingController nameController;
  late final TextEditingController phoneController;
  late final TextEditingController addressController;

  @override
  void initState() {
    super.initState();
    final profile = PharmacyService.instance;
    nameController = TextEditingController(text: profile.pharmacyName);
    phoneController = TextEditingController(text: profile.phone);
    addressController = TextEditingController(text: profile.address);
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void saveProfile() {
    try {
      final profile = context.read<PharmacyService>();
      profile.updateProfile(
        pharmacyName: nameController.text,
        pharmacistName: profile.pharmacistName,
        phone: phoneController.text,
        address: addressController.text,
        workingHours: profile.workingHours,
      );
      context.read<NotificationsService>().add(
        title: 'Pharmacy profile updated',
        message: 'Your pharmacy information was saved successfully.',
        destinationIndex: 4,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PharmacistColors.background,
      appBar: AppBar(
        title: const Text(
          'Pharmacy Profile',
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
        child: Column(
          children: [
            const CircleAvatar(
              radius: 48,
              backgroundColor: Color(0xFFE8F5F1),
              child: Icon(
                Icons.local_pharmacy,
                size: 48,
                color: PharmacistColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Pharmacy Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: PharmacistColors.textDark,
              ),
            ),
            const SizedBox(height: 25),
            _buildField(
              label: 'Pharmacy Name',
              controller: nameController,
              icon: Icons.local_pharmacy_outlined,
            ),
            const SizedBox(height: 18),
            _buildField(
              label: 'Phone Number',
              controller: phoneController,
              icon: Icons.phone_outlined,
              isPhone: true,
            ),
            const SizedBox(height: 18),
            _buildField(
              label: 'Address',
              controller: addressController,
              icon: Icons.location_on_outlined,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: PharmacistColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool isPhone = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: PharmacistColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType:
          isPhone ? TextInputType.phone : TextInputType.text,
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: PharmacistColors.primary,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}