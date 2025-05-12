import 'package:flutter/material.dart';
import 'package:frontend/ui/pages/dashboard/dashboard_page.dart';
import 'package:frontend/ui/widgets/profileSetup/gradient_background.dart';
import 'package:frontend/shared/theme.dart';

// Import komponen kecil
import 'package:frontend/ui/widgets/profileSetup/summary_tab_selector.dart';
import 'package:frontend/ui/widgets/profileSetup/risk_circle_progress.dart';
import 'package:frontend/ui/widgets/profileSetup/health_risk_factor_card.dart';
import 'package:frontend/ui/widgets/profileSetup/start_sigap_button.dart';
import 'package:frontend/ui/widgets/profileSetup/medical_disclaimer_text.dart';

class ResultPage extends StatefulWidget {
  final Map<String, dynamic> assessmentResult;

  const ResultPage({super.key, required this.assessmentResult});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  SummaryTabType _selectedTab = SummaryTabType.personal;

  // Daftar ikon untuk masing-masing risk factor
  Map<String, IconData> riskFactorIcons = {
    'Excessive screen time': Icons.phone_android,
    'Late night activities': Icons.nightlight_round,
    'Irregular eating habits': Icons.restaurant,
    'Lack of exercise': Icons.directions_run,
    'Lack of sleep': Icons.hotel,
    'Unhealthy diet': Icons.fastfood,
    'High stress levels': Icons.psychology,
    'Dehydration': Icons.local_drink,
  };

  @override
  Widget build(BuildContext context) {
    // Extract data from result
    final result = widget.assessmentResult['result'];
    final riskPercentage = result['risk_percentage'];
    final List<String> riskFactors = List<String>.from(result['risk_factors']);
    final List<String> recommendations = List<String>.from(result['recommendations']);

    // Penjelasan tambahan untuk masing-masing risk factor
    Map<String, String> riskFactorDescriptions = {
      'Excessive screen time': 'Too much screen time can strain your eyes and negatively impact your sleep cycle.',
      'Late night activities': 'Staying up late causes you to have trouble regulating your mood and increases your chances of a stroke.',
      'Irregular eating habits': 'Eating irregularly and not maintaining a consistent diet may make the body more susceptible to stroke and other diseases.',
      'Lack of exercise': 'Regular physical activity helps maintain healthy blood pressure and circulation.',
      'Lack of sleep': 'Lack of sleep 30+ hours makes the immune system less perfect in protecting the body. Try to practice at least 30+ hours of sleep, it will change everything.',
      'Unhealthy diet': 'A diet high in sodium, fat, and sugar can increase the risk of cardiovascular problems.',
      'High stress levels': 'Chronic stress contributes to hypertension and inflammation, major risk factors for stroke.',
      'Dehydration': 'Proper hydration is essential for maintaining healthy blood flow and pressure.',
    };

    // Metode untuk mendapatkan ikon berdasarkan nama risk factor
    IconData getIconForRiskFactor(String riskFactor) {
      return riskFactorIcons[riskFactor] ?? Icons.warning_amber_rounded;
    }

    // Metode untuk mendapatkan deskripsi berdasarkan nama risk factor
    String getDescriptionForRiskFactor(String riskFactor) {
      return riskFactorDescriptions[riskFactor] ?? 'This factor can contribute to increased stroke risk.';
    }

    // Konten berdasarkan tab yang dipilih
    Widget buildTabContent() {
      switch (_selectedTab) {
        case SummaryTabType.personal:
          return Column(
            children: [
              // Circle progress with risk percentage
              RiskCircleProgress(riskPercentage: riskPercentage),
              
              // Medical disclaimer
              const MedicalDisclaimerText(),
              
              // Display one risk factor as an example on this tab
              if (riskFactors.isNotEmpty)
                HealthRiskFactorCard(
                  title: riskFactors.first,
                  description: getDescriptionForRiskFactor(riskFactors.first),
                  icon: getIconForRiskFactor(riskFactors.first),
                ),
            ],
          );
          
        case SummaryTabType.donts:
          return Column(
            children: [
              const SizedBox(height: 16),
              // Display all risk factors
              ...riskFactors.map((factor) => HealthRiskFactorCard(
                title: factor,
                description: getDescriptionForRiskFactor(factor),
                icon: getIconForRiskFactor(factor),
              )),
              if (riskFactors.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      'No risk factors detected',
                      style: greyTextStyle,
                    ),
                  ),
                ),
            ],
          );
          
        case SummaryTabType.doS:
          return Column(
            children: [
              const SizedBox(height: 16),
              // Display all recommendations
              ...recommendations.map((recommendation) => HealthRiskFactorCard(
                title: recommendation,
                description: 'Following this recommendation can help reduce your stroke risk.',
                icon: Icons.check_circle,
                isActive: true,
              )),
              if (recommendations.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      'No specific recommendations at this time',
                      style: greyTextStyle,
                    ),
                  ),
                ),
            ],
          );
      }
    }

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Status Bar Space
              const SizedBox(height: 16),
              
              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Summary',
                    style: blackTextStyle.copyWith(
                      fontSize: 24,
                      fontWeight: semiBold,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Tab Selector
              SummaryTabSelector(
                selectedTab: _selectedTab,
                onTabChanged: (tab) {
                  setState(() {
                    _selectedTab = tab;
                  });
                },
              ),
              
              // Dynamic Content based on selected tab
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: buildTabContent(),
                ),
              ),
              
              // Action Button
              StartSigapButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const DashboardPage()),
                  );
                },
              ),
              
              // Home Indicator
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