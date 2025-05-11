import 'package:flutter/material.dart';
import 'package:frontend/models/health_assessment_model.dart';
import 'package:frontend/services/health_service.dart';
import 'package:frontend/ui/pages/profile/result_page.dart';
import 'package:frontend/ui/widgets/profileSetup/action_button.dart';
import 'package:frontend/ui/widgets/profileSetup/gradient_background.dart';
import 'package:frontend/shared/notification.dart';

class HealthAssessmentPage extends StatefulWidget {
  const HealthAssessmentPage({Key? key}) : super(key: key);

  @override
  State<HealthAssessmentPage> createState() => _HealthAssessmentPageState();
}

class _HealthAssessmentPageState extends State<HealthAssessmentPage> {
  int screenTimeHours = 4; // Default values
  int exerciseHours = 4;
  int lateNightFrequency = 4;
  int dietQuality = 4;
  bool isLoading = false;

  Future<void> _submitAssessment() async {
    setState(() {
      isLoading = true;
    });

    final assessment = HealthAssessment(
      screenTimeHours: screenTimeHours,
      exerciseHours: exerciseHours,
      lateNightFrequency: lateNightFrequency,
      dietQuality: dietQuality,
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

  Widget _buildSlider({
    required String title,
    required String description,
    required int value,
    required Function(int) onChanged,
    required List<String> labels,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          Slider(
            value: value.toDouble(),
            min: 1,
            max: labels.length.toDouble(),
            divisions: labels.length - 1,
            activeColor: const Color(0xFFFE8A3B),
            inactiveColor: Colors.grey[300],
            onChanged: (newValue) {
              onChanged(newValue.round());
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: labels.map((label) {
                return Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
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
                  'Health\nAssessment',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Please answer the following questions about your health habits to help us assess your health status.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 32),
                
                // Screen Time Slider
                _buildSlider(
                  title: 'Daily Screen Time',
                  description: 'How many hours do you spend looking at screens daily?',
                  value: screenTimeHours,
                  onChanged: (value) {
                    setState(() {
                      screenTimeHours = value;
                    });
                  },
                  labels: ['1', '2', '3', '4', '5+'],
                ),
                
                // Exercise Hours Slider
                _buildSlider(
                  title: 'Weekly Exercise',
                  description: 'How many hours do you exercise each week?',
                  value: exerciseHours,
                  onChanged: (value) {
                    setState(() {
                      exerciseHours = value;
                    });
                  },
                  labels: ['1', '2', '3', '4', '5+'],
                ),
                
                // Late Night Frequency Slider
                _buildSlider(
                  title: 'Late Night Frequency',
                  description: 'How many nights per week do you stay up past midnight?',
                  value: lateNightFrequency,
                  onChanged: (value) {
                    setState(() {
                      lateNightFrequency = value;
                    });
                  },
                  labels: ['1', '2', '3', '4', '5+'],
                ),
                
                // Diet Quality Slider
                _buildSlider(
                  title: 'Diet Quality',
                  description: 'How would you rate your overall diet quality?',
                  value: dietQuality,
                  onChanged: (value) {
                    setState(() {
                      dietQuality = value;
                    });
                  },
                  labels: ['Poor', 'Fair', 'Good', 'Very Good', 'Excellent'],
                ),
                
                const SizedBox(height: 32),
                
                isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFFE8A3B),
                        ),
                      )
                    : ActionButton(
                        text: 'Submit Assessment',
                        onPressed: _submitAssessment,
                      ),
                
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}