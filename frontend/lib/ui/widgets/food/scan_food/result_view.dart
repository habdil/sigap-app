// lib/ui/widgets/food/scan_food/result_scan/result_view.dart
import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';
import 'package:frontend/ui/widgets/food/scan_food/nutrient_card.dart';

class ResultView extends StatelessWidget {
  final Map<String, Map<String, dynamic>> analysisData;
  final VoidCallback onScanAgain;
  final VoidCallback onGoToFoodPage;
  
  const ResultView({
    Key? key,
    required this.analysisData,
    required this.onScanAgain,
    required this.onGoToFoodPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header section
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: orangeColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  color: orangeColor,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Analysis Complete',
                      style: blackTextStyle.copyWith(
                        fontSize: 22,
                        fontWeight: bold,
                      ),
                    ),
                    Text(
                      'Here\'s what we found in your food',
                      style: greyTextStyle.copyWith(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Results grid
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: analysisData.entries.map((entry) {
                return NutrientCard(
                  title: entry.key,
                  amount: entry.value['amount'] as String,
                  perKg: entry.value['perKg'] as String,
                  backgroundColor: _getCardColor(entry.key),
                );
              }).toList(),
            ),
          ),
          
          // Action buttons
          Row(
            children: [
              // Button to view food diary
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: blueColor,
                    foregroundColor: whiteColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    elevation: 2,
                    shadowColor: blueColor.withOpacity(0.3),
                  ),
                  onPressed: onGoToFoodPage,
                  icon: const Icon(Icons.book),
                  label: Text(
                    'FOOD DIARY',
                    style: whiteTextStyle.copyWith(
                      fontWeight: bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Button to scan again
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orangeColor,
                    foregroundColor: whiteColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    elevation: 2,
                    shadowColor: orangeColor.withOpacity(0.3),
                  ),
                  onPressed: onScanAgain,
                  icon: const Icon(Icons.camera_alt),
                  label: Text(
                    'SCAN AGAIN',
                    style: whiteTextStyle.copyWith(
                      fontWeight: bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Additional info text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'Values are an estimate based on visual analysis',
              textAlign: TextAlign.center,
              style: greyTextStyle.copyWith(
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper method to get custom background color for each nutrient type
  Color _getCardColor(String nutrientName) {
    switch (nutrientName.toLowerCase()) {
      case 'protein':
        return Colors.orange.shade50;
      case 'carbs':
        return Colors.amber.shade50;
      case 'fat':
        return Colors.blue.shade50;
      case 'fibers':
        return Colors.green.shade50;
      case 'calories':
        return Colors.red.shade50;
      default:
        return Colors.white;
    }
  }
}