import 'package:flutter/material.dart';
import 'package:frontend/models/user_profile_model.dart';
import 'package:frontend/services/profile_service.dart';
import 'package:frontend/ui/pages/profile/health_assessment_page.dart';
import 'package:frontend/ui/widgets/profileSetup/action_button.dart';
import 'package:frontend/ui/widgets/profileSetup/gradient_background.dart';
import 'package:frontend/ui/widgets/profileSetup/personalize_input_card.dart';
import 'package:frontend/shared/notification.dart';

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({Key? key}) : super(key: key);

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  
  UserProfile profile = UserProfile();
  int currentStep = 0;
  bool isLoading = false;

  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _handleAgeSubmit() {
    if (_ageController.text.isNotEmpty) {
      setState(() {
        profile = profile.copyWith(age: int.tryParse(_ageController.text));
        currentStep = 1;
      });
    }
  }

  void _handleHeightSubmit() {
    if (_heightController.text.isNotEmpty) {
      setState(() {
        profile = profile.copyWith(height: double.tryParse(_heightController.text));
        currentStep = 2;
      });
    }
  }

  void _handleWeightSubmit() {
    if (_weightController.text.isNotEmpty) {
      setState(() {
        profile = profile.copyWith(weight: double.tryParse(_weightController.text));
        currentStep = 3;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (profile.isComplete) {
      setState(() {
        isLoading = true;
      });

      final result = await ProfileService.updateProfile(profile);
      
      setState(() {
        isLoading = false;
      });

      if (result['success']) {
        context.showSuccessNotification(
          title: 'Profile Updated',
          message: 'Your profile information was saved successfully',
        );
        
        // Navigate to the health assessment page
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HealthAssessmentPage()),
        );
      } else {
        context.showErrorNotification(
          title: 'Error',
          message: result['message'] ?? 'Failed to update profile',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const Text(
                  'Tell\nSIGAP\nAbout\nYourself',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 40),
                
                // Age Input
                PersonalizeInputCard(
                  title: 'How Old are You?',
                  subtitle: 'Tell us about yourself so we can give you the right advice for your current condition.',
                  placeholder: 'Insert Here',
                  controller: _ageController,
                  onEnter: _handleAgeSubmit,
                  isActive: currentStep == 0,
                  keyboardType: TextInputType.number,
                  suffix: 'years',
                ),
                
                // Height Input
                PersonalizeInputCard(
                  title: 'What about Your Height?',
                  subtitle: 'Tell us about yourself so we can give you the right advice for your current condition.',
                  placeholder: 'Insert Here',
                  controller: _heightController,
                  onEnter: _handleHeightSubmit,
                  isActive: currentStep == 1,
                  keyboardType: TextInputType.number,
                  suffix: 'cm',
                ),
                
                // Weight Input
                PersonalizeInputCard(
                  title: 'What about Your Weight?',
                  subtitle: 'Tell us about yourself so we can give you the right advice for your current condition.',
                  placeholder: 'Insert Here',
                  controller: _weightController,
                  onEnter: _handleWeightSubmit,
                  isActive: currentStep == 2,
                  keyboardType: TextInputType.number,
                  suffix: 'kg',
                ),
                
                // Final Step - What's Next
                if (currentStep == 3)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "What's Next?",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Look at your daily habits, are you at risk of stroke with the daily activities you do?',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        isLoading
                            ? const CircularProgressIndicator(
                                color: Color(0xFFFE8A3B),
                              )
                            : ActionButton(
                                text: "Let's Go!",
                                onPressed: _saveProfile,
                              ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}