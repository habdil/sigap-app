import 'package:flutter/material.dart';
import 'package:frontend/models/health_assessment_model.dart';
import 'package:frontend/services/health_service.dart';
import 'package:frontend/ui/pages/profile/result_page.dart';
import 'package:frontend/ui/widgets/profileSetup/gradient_background.dart';
import 'package:frontend/shared/notification.dart';
import 'package:frontend/shared/theme.dart';

// Import komponen yang telah dibuat sebelumnya
// Asumsikan komponen-komponen ini sudah berada di folder ui/widgets/profileSetup
import 'package:frontend/ui/widgets/profileSetup/health_assessment_option_card.dart';
import 'package:frontend/ui/widgets/profileSetup/health_assessment_progress_indicator.dart';
import 'package:frontend/ui/widgets/profileSetup/assessment_continue_button.dart';
import 'package:frontend/ui/widgets/profileSetup/assessment_question_header.dart';

class HealthAssessmentPage extends StatefulWidget {
  const HealthAssessmentPage({Key? key}) : super(key: key);

  @override
  State<HealthAssessmentPage> createState() => _HealthAssessmentPageState();
}

class _HealthAssessmentPageState extends State<HealthAssessmentPage> {
  // Untuk pengelolaan tab
  int currentStep = 1;
  final int totalSteps = 4;
  
  // Untuk menyimpan jawaban dari setiap pertanyaan
  int? screenTimeAnswer;
  int? exerciseTimeAnswer;
  int? lateNightAnswer;
  int? dietQualityAnswer;
  
  // Status loading
  bool isLoading = false;
  
  // Data pilihan untuk setiap pertanyaan
  final List<String> screenTimeOptions = [
    "just an hour",
    "around 2-4 hours",
    "around 5-8 hours",
    "more than 9 hours per day"
  ];
  
  final List<String> exerciseTimeOptions = [
    "just an hour",
    "around 2-4 hours",
    "around 5-8 hours",
    "more than 9 hours per day"
  ];
  
  final List<String> lateNightOptions = [
    "Never",
    "once a week when tomorrow is a vacation day",
    "about 2-4 times a week",
    "every day without pause and continuously"
  ];
  
  final List<String> dietQualityOptions = [
    "a regular diet with plenty of vegetables and fruit",
    "a little messy but still consuming vegetables",
    "messy diet and sometimes eat fast and high-fat foods",
    "no vegetables, no fruits, only eat something like junk food"
  ];
  
  // Konversi jawaban pengguna ke skor untuk backend
  int _convertToScore(int stepIndex, int? optionIndex) {
    if (optionIndex == null) return 4; // Default value
    
    // Aturan konversi untuk backend
    switch (stepIndex) {
      case 0: // Screen Time - nilai lebih tinggi berarti lebih buruk
        return optionIndex + 1;
      case 1: // Exercise Time - nilai lebih tinggi berarti lebih baik
        return 5 - optionIndex; // Membalik skala
      case 2: // Late Night - nilai lebih tinggi berarti lebih buruk
        return optionIndex + 1;
      case 3: // Diet Quality - nilai lebih tinggi berarti lebih baik
        return 5 - optionIndex; // Membalik skala
      default:
        return 4;
    }
  }
  
  // Fungsi untuk menangani tombol continue
  void _handleContinue() {
    // Cek apakah sudah ada jawaban untuk step saat ini
    bool canContinue = false;
    
    switch (currentStep) {
      case 1:
        canContinue = screenTimeAnswer != null;
        break;
      case 2:
        canContinue = exerciseTimeAnswer != null;
        break;
      case 3:
        canContinue = lateNightAnswer != null;
        break;
      case 4:
        canContinue = dietQualityAnswer != null;
        break;
    }
    
    if (!canContinue) return;
    
    if (currentStep < totalSteps) {
      setState(() {
        currentStep++;
      });
    } else {
      _submitAssessment();
    }
  }
  
  // Fungsi untuk mengirim assessment ke backend
  Future<void> _submitAssessment() async {
    setState(() {
      isLoading = true;
    });

    final assessment = HealthAssessment(
      screenTimeHours: _convertToScore(0, screenTimeAnswer),
      exerciseHours: _convertToScore(1, exerciseTimeAnswer),
      lateNightFrequency: _convertToScore(2, lateNightAnswer),
      dietQuality: _convertToScore(3, dietQualityAnswer),
    );

    final result = await HealthService.submitAssessment(assessment);

    setState(() {
      isLoading = false;
    });

    if (result['success']) {
      context.showSuccessNotification(
        title: 'Assessment Submitted',
        message: 'Your health assessment was submitted successfully',
      );

      // Navigate to the result page
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ResultPage(assessmentResult: result['data']),
        ),
      );
    } else {
      context.showErrorNotification(
        title: 'Error',
        message: result['message'] ?? 'Failed to submit assessment',
      );
    }
  }

  // Fungsi untuk menampilkan konten berdasarkan step saat ini
  Widget _buildCurrentStepContent() {
    switch (currentStep) {
      case 1:
        return _buildScreenTimeStep();
      case 2:
        return _buildExerciseTimeStep();
      case 3:
        return _buildLateNightStep();
      case 4:
        return _buildDietQualityStep();
      default:
        return const SizedBox.shrink();
    }
  }
  
  // Step 1: Screen Time
  Widget _buildScreenTimeStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AssessmentQuestionHeader(
          question: 'How many hours a day do you spend on your cell phone?',
          description: 'Look at your daily habits, are you at risk of stroke with the daily activities you do?',
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1,
            ),
            itemCount: screenTimeOptions.length,
            itemBuilder: (context, index) {
              return HealthAssessmentOptionCard(
                text: screenTimeOptions[index],
                isSelected: screenTimeAnswer == index,
                onTap: () {
                  setState(() {
                    screenTimeAnswer = index;
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }
  
  // Step 2: Exercise Time
  Widget _buildExerciseTimeStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AssessmentQuestionHeader(
          question: 'How many hours a day do you spend exercising?',
          description: 'Look at your daily habits, are you at risk of stroke with the daily activities you do?',
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1,
            ),
            itemCount: exerciseTimeOptions.length,
            itemBuilder: (context, index) {
              return HealthAssessmentOptionCard(
                text: exerciseTimeOptions[index],
                isSelected: exerciseTimeAnswer == index,
                onTap: () {
                  setState(() {
                    exerciseTimeAnswer = index;
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }
  
  // Step 3: Late Night
  Widget _buildLateNightStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AssessmentQuestionHeader(
          question: 'Do you often stay up late / sleep too late with cell phone activities?',
          description: 'Look at your daily habits, are you at risk of stroke with the daily activities you do?',
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1,
            ),
            itemCount: lateNightOptions.length,
            itemBuilder: (context, index) {
              return HealthAssessmentOptionCard(
                text: lateNightOptions[index],
                isSelected: lateNightAnswer == index,
                onTap: () {
                  setState(() {
                    lateNightAnswer = index;
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }
  
  // Step 4: Diet Quality
  Widget _buildDietQualityStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AssessmentQuestionHeader(
          question: 'What about your diet, can you give us an idea?',
          description: 'Look at your daily habits, are you at risk of stroke with the daily activities you do?',
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1,
            ),
            itemCount: dietQualityOptions.length,
            itemBuilder: (context, index) {
              return HealthAssessmentOptionCard(
                text: dietQualityOptions[index],
                isSelected: dietQualityAnswer == index,
                onTap: () {
                  setState(() {
                    dietQualityAnswer = index;
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Status Bar Placeholder (Jam, Sinyal, dll)
              SizedBox(
                height: 16,
                width: double.infinity,
              ),
              
              // Progress Indicator
              HealthAssessmentProgressIndicator(
                currentStep: currentStep,
                totalSteps: totalSteps,
              ),
              
              // Main Content Area (Scrollable)
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: _buildCurrentStepContent(),
                ),
              ),
              
              // Continue Button
              if (isLoading)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: CircularProgressIndicator(
                      color: orangeColor,
                    ),
                  ),
                )
              else
                AssessmentContinueButton(
                  onPressed: _handleContinue,
                  isEnabled: currentStep == 1 && screenTimeAnswer != null ||
                            currentStep == 2 && exerciseTimeAnswer != null ||
                            currentStep == 3 && lateNightAnswer != null ||
                            currentStep == 4 && dietQualityAnswer != null,
                  isLastStep: currentStep == totalSteps,
                ),
              
              // Bottom Bar / Home Indicator
              Container(
                height: 24,
                width: 100,
                margin: const EdgeInsets.only(bottom: 8.0),
                child: Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(2),
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
}