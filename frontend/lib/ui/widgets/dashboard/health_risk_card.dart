import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';
import 'package:frontend/ui/pages/profile/health_assessment_page.dart';
import 'package:frontend/ui/pages/profile/result_page.dart';

class HealthRiskCard extends StatelessWidget {
  final bool isLoading;
  final Map<String, dynamic>? assessmentResult;

  const HealthRiskCard({
    super.key,
    required this.isLoading,
    this.assessmentResult,
  });

  @override
  Widget build(BuildContext context) {
    // Responsif sesuai ukuran layar
    final screenWidth = MediaQuery.of(context).size.width;
    final cardMargin = EdgeInsets.symmetric(
      horizontal: screenWidth < 360 ? 12 : 16, 
      vertical: 5
    );

    // Loading state dengan pendekatan ringan
    if (isLoading) {
      return Container(
        margin: cardMargin,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5, // Lebih rendah untuk performa lebih baik
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Gunakan ukuran minimum yang diperlukan
          children: [
            // Header
            Container(
              width: 130,
              height: 18,
              color: Colors.grey.shade200,
            ),
            const SizedBox(height: 16),
            
            // Simple loading indicator yang ringan
            Row(
              children: [
                // Indikator kecil
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade200,
                  ),
                ),
                const SizedBox(width: 12),
                
                // Text placeholder - minimal dan efisien
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 80,
                        height: 16,
                        color: Colors.grey.shade200,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        height: 12,
                        color: Colors.grey.shade200,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Button placeholder
            Container(
              width: double.infinity,
              height: 36,
              color: Colors.grey.shade200,
            ),
          ],
        ),
      );
    }

    if (assessmentResult == null) {
      return Container(
        margin: cardMargin,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
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
              'Health Assessment',
              style: blackTextStyle.copyWith(
                fontSize: screenWidth < 360 ? 14 : 16,
                fontWeight: semiBold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Take a health assessment to know your risk factors and get personalized recommendations.',
              style: greyTextStyle.copyWith(
                fontSize: screenWidth < 360 ? 12 : 14,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const HealthAssessmentPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFE8A3B),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Take Assessment',
                  style: whiteTextStyle.copyWith(
                    fontWeight: semiBold,
                    fontSize: screenWidth < 360 ? 12 : 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    final riskPercentage = assessmentResult!['result']['risk_percentage'];
    final riskFactors = List<String>.from(assessmentResult!['result']['risk_factors']);

    Color riskColor;
    String riskLevel;

    if (riskPercentage < 30) {
      riskColor = Colors.green;
      riskLevel = 'Low Risk';
    } else if (riskPercentage < 70) {
      riskColor = const Color.fromARGB(255, 151, 91, 0);
      riskLevel = 'Medium Risk';
    } else {
      riskColor = Colors.red;
      riskLevel = 'High Risk';
    }

    return Container(
      margin: cardMargin,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
            'Health Assessment',
            style: blackTextStyle.copyWith(
              fontSize: screenWidth < 360 ? 14 : 16,
              fontWeight: semiBold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: screenWidth < 360 ? 50 : 60,
                height: screenWidth < 360 ? 50 : 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: riskColor.withOpacity(0.1),
                ),
                child: Center(
                  child: Text(
                    '$riskPercentage%',
                    style: TextStyle(
                      color: riskColor,
                      fontWeight: bold,
                      fontSize: screenWidth < 360 ? 16 : 18,
                    ),
                  ),
                ),
              ),
              SizedBox(width: screenWidth < 360 ? 12 : 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      riskLevel,
                      style: TextStyle(
                        color: riskColor,
                        fontWeight: bold,
                        fontSize: screenWidth < 360 ? 18 : 20,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Your health assessment shows ${riskFactors.length} risk factor${riskFactors.length > 1 ? 's' : ''}',
                      style: greyTextStyle.copyWith(
                        fontSize: screenWidth < 360 ? 12 : 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ResultPage(assessmentResult: assessmentResult!),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFE8A3B),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'View Details',
                style: whiteTextStyle.copyWith(
                  fontWeight: semiBold,
                  fontSize: screenWidth < 360 ? 12 : 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}