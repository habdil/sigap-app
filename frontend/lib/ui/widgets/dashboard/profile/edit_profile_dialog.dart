// frontend/lib/ui/widgets/dashboard/profile/edit_profile_dialog.dart
import 'package:flutter/material.dart';
import 'package:frontend/models/user_profile_model.dart';
import 'package:frontend/shared/theme.dart';

class EditProfileDialog extends StatefulWidget {
  final UserProfile profile;

  const EditProfileDialog({
    Key? key,
    required this.profile,
  }) : super(key: key);

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  late TextEditingController _ageController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;

  @override
  void initState() {
    super.initState();
    _ageController = TextEditingController(text: widget.profile.age?.toString() ?? '');
    _heightController = TextEditingController(text: widget.profile.height?.toString() ?? '');
    _weightController = TextEditingController(text: widget.profile.weight?.toString() ?? '');
  }

  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Edit Profile',
        style: blackTextStyle.copyWith(
          fontSize: 18,
          fontWeight: semiBold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _ageController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Age',
              labelStyle: greyTextStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _heightController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Height (cm)',
              labelStyle: greyTextStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _weightController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Weight (kg)',
              labelStyle: greyTextStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: greyTextStyle,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            // Create updated profile
            final updatedProfile = UserProfile(
              age: _ageController.text.isNotEmpty ? int.parse(_ageController.text) : null,
              height: _heightController.text.isNotEmpty ? double.parse(_heightController.text) : null,
              weight: _weightController.text.isNotEmpty ? double.parse(_weightController.text) : null,
            );
            
            Navigator.pop(context, updatedProfile);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E90FF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Save',
            style: whiteTextStyle.copyWith(
              fontWeight: medium,
            ),
          ),
        ),
      ],
    );
  }
}