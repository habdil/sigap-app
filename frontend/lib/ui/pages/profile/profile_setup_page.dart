import 'package:flutter/material.dart';
import 'package:frontend/models/user_profile_model.dart';
import 'package:frontend/services/profile_service.dart';
import 'package:frontend/ui/pages/profile/health_assessment_page.dart';
import 'package:frontend/ui/widgets/profileSetup/gradient_background.dart';
import 'package:frontend/shared/notification.dart';
import 'package:frontend/shared/theme.dart';

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({Key? key}) : super(key: key);

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> with SingleTickerProviderStateMixin {
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  UserProfile profile = UserProfile();
  int currentStep = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleAgeSubmit() {
    if (_ageController.text.isNotEmpty) {
      setState(() {
        profile = profile.copyWith(age: int.tryParse(_ageController.text));
        currentStep = 1;
      });
      _animationController.reset();
      _animationController.forward();
    }
  }

  void _handleHeightSubmit() {
    if (_heightController.text.isNotEmpty) {
      setState(() {
        profile = profile.copyWith(height: double.tryParse(_heightController.text));
        currentStep = 2;
      });
      _animationController.reset();
      _animationController.forward();
    }
  }

  void _handleWeightSubmit() {
    if (_weightController.text.isNotEmpty) {
      setState(() {
        profile = profile.copyWith(weight: double.tryParse(_weightController.text));
        currentStep = 3;
      });
      _animationController.reset();
      _animationController.forward();
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

  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(4, (index) {
          return Container(
            width: 35,
            height: 5,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: index <= currentStep 
                  ? orangeColor 
                  : greyColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                
                // Logo and Header
                Center(
                  child: Image.asset(
                    'assets/ic_logo_orange.png',
                    height: 45,
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Step Indicator
                _buildStepIndicator(),
               
                // Heading
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: RichText(
                      text: TextSpan(
                        style: blackTextStyle.copyWith(
                          fontSize: 38,
                          fontWeight: black,
                          height: 1.1,
                        ),
                        children: [
                          const TextSpan(text: 'Tell '),
                          TextSpan(
                            text: 'SIGAP ',
                            style: orangeTextStyle.copyWith(
                              fontSize: 38,
                              fontWeight: black,
                              height: 1.1,
                            ),
                          ),
                          const TextSpan(text: '\nAbout\nYourself'),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 10),
                
                // Subheading
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Text(
                      'Help us personalize your experience',
                      style: greyTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: medium,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Input Cards
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: _buildInputCard(
                      index: 0,
                      title: 'How Old are You?',
                      subtitle: 'Your age helps us tailor health recommendations specific to your life stage.',
                      controller: _ageController,
                      onSubmit: _handleAgeSubmit,
                      suffix: 'years',
                      icon: Icons.calendar_today_rounded,
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: _buildInputCard(
                      index: 1,
                      title: 'What about Your Height?',
                      subtitle: 'Your height is important for calculating your body mass index (BMI).',
                      controller: _heightController,
                      onSubmit: _handleHeightSubmit,
                      suffix: 'cm',
                      icon: Icons.height,
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: _buildInputCard(
                      index: 2,
                      title: 'What about Your Weight?',
                      subtitle: 'Your weight helps us understand your current health status.',
                      controller: _weightController,
                      onSubmit: _handleWeightSubmit,
                      suffix: 'kg',
                      icon: Icons.fitness_center,
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Final Step - What's Next
                if (currentStep == 3)
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 15,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Image
                            Image.asset(
                              'assets/img_card_people.png',
                              height: 120,
                            ),
                            const SizedBox(height: 20),
                            
                            Text(
                              "What's Next?",
                              style: blackTextStyle.copyWith(
                                fontSize: 22,
                                fontWeight: bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Look at your daily habits, are you at risk of stroke with the daily activities you do?',
                              style: greyTextStyle.copyWith(
                                fontSize: 15,
                                fontWeight: medium,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            isLoading
                                ? CircularProgressIndicator(
                                    color: orangeColor,
                                  )
                                : SizedBox(
                                    width: double.infinity,
                                    height: 55,
                                    child: ElevatedButton(
                                      onPressed: _saveProfile,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: orangeColor,
                                        foregroundColor: whiteColor,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Let's Go!",
                                            style: whiteTextStyle.copyWith(
                                              fontSize: 18,
                                              fontWeight: bold,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          const Icon(
                                            Icons.arrow_forward_rounded,
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildInputCard({
    required int index,
    required String title,
    required String subtitle,
    required TextEditingController controller,
    required Function() onSubmit,
    required String suffix,
    required IconData icon,
  }) {
    final bool isActive = currentStep == index;
    final bool isCompleted = currentStep > index;
    
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
        border: isActive 
            ? Border.all(color: orangeColor, width: 2) 
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isCompleted ? orangeColor : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    isCompleted ? Icons.check : icon,
                    color: isCompleted ? whiteColor : orangeColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: blackTextStyle.copyWith(
                          fontSize: 18,
                          fontWeight: semiBold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: greyTextStyle.copyWith(
                          fontSize: 12,
                          fontWeight: regular,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            // Only show the input field if this card is active
            if (isActive) ...[
              const SizedBox(height: 20),
              Container(
                height: 58,
                decoration: BoxDecoration(
                  color: orangeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          controller: controller,
                          keyboardType: TextInputType.number,
                          style: blackTextStyle.copyWith(
                            fontSize: 18,
                            fontWeight: semiBold,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter your ${title.split(' ').last.toLowerCase()}',
                            hintStyle: greyTextStyle.copyWith(
                              fontSize: 16,
                              fontWeight: medium,
                            ),
                            border: InputBorder.none,
                            suffixText: suffix,
                            suffixStyle: orangeTextStyle.copyWith(
                              fontSize: 16,
                              fontWeight: semiBold,
                            ),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: controller.text.isNotEmpty ? onSubmit : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orangeColor,
                    foregroundColor: whiteColor,
                    disabledBackgroundColor: greyColor.withOpacity(0.3),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: whiteTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: semiBold,
                    ),
                  ),
                ),
              ),
            ],
            
            // If the card is completed, show the entered value
            if (isCompleted) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    'Your answer: ',
                    style: greyTextStyle.copyWith(
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '${controller.text} $suffix',
                    style: blackTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: bold,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}