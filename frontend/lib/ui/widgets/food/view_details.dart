// lib/ui/widgets/food/view_details.dart
import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';
import 'package:frontend/models/food_model.dart';
import 'package:frontend/shared/notification.dart';
import 'package:frontend/shared/loading.dart';

class FoodDetailsView extends StatelessWidget {
  final FoodLog foodLog;
  final Function()? onClose;

  const FoodDetailsView({
    Key? key,
    required this.foodLog,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive design
    final screenSize = MediaQuery.of(context).size;
    final isPad = screenSize.width > 600;
    final isLargeScreen = screenSize.width > 900;

    // Check if analysis data is available
    final hasAnalysis = foodLog.analysis != null;
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      // Responsive dialog width
      insetPadding: EdgeInsets.symmetric(
        horizontal: isLargeScreen 
            ? screenSize.width * 0.3 
            : isPad 
                ? screenSize.width * 0.15 
                : 16,
      ),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight: screenSize.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with image
            _buildHeader(context, isPad),
            
            // Content with scrolling for smaller screens
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(isPad ? 24 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Food name and date
                    Text(
                      foodLog.foodName,
                      style: blackTextStyle.copyWith(
                        fontSize: isPad ? 24 : 20,
                        fontWeight: semiBold,
                      ),
                    ),
                    SizedBox(height: isPad ? 8 : 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: isPad ? 16 : 14,
                          color: greyColor,
                        ),
                        SizedBox(width: isPad ? 8 : 4),
                        Text(
                          foodLog.logDate != null
                              ? '${foodLog.logDate!.day}/${foodLog.logDate!.month}/${foodLog.logDate!.year}'
                              : 'Today',
                          style: greyTextStyle.copyWith(
                            fontSize: isPad ? 14 : 12,
                          ),
                        ),
                      ],
                    ),
                    
                    // Notes section if available
                    if (foodLog.notes != null && foodLog.notes!.isNotEmpty) ...[
                      SizedBox(height: isPad ? 20 : 16),
                      Text(
                        'Notes',
                        style: blackTextStyle.copyWith(
                          fontSize: isPad ? 18 : 16,
                          fontWeight: semiBold,
                        ),
                      ),
                      SizedBox(height: isPad ? 8 : 4),
                      Container(
                        padding: EdgeInsets.all(isPad ? 16 : 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Text(
                          foodLog.notes!,
                          style: greyTextStyle.copyWith(
                            fontSize: isPad ? 14 : 12,
                          ),
                        ),
                      ),
                    ],
                    
                    // Nutritional information section
                    SizedBox(height: isPad ? 24 : 16),
                    Text(
                      'Nutritional Information',
                      style: blackTextStyle.copyWith(
                        fontSize: isPad ? 18 : 16,
                        fontWeight: semiBold,
                      ),
                    ),
                    SizedBox(height: isPad ? 16 : 12),
                    
                    // Display analysis or placeholder
                    hasAnalysis
                        ? _buildNutritionInfo(context, isPad)
                        : _buildNoAnalysisView(context, isPad),
                    
                    // Food composition if analysis available
                    if (hasAnalysis) ...[
                      SizedBox(height: isPad ? 24 : 16),
                      Text(
                        'Food Composition',
                        style: blackTextStyle.copyWith(
                          fontSize: isPad ? 18 : 16,
                          fontWeight: semiBold,
                        ),
                      ),
                      SizedBox(height: isPad ? 16 : 12),
                      _buildCompositionChart(context, isPad),
                    ],
                  ],
                ),
              ),
            ),
            
            // Bottom buttons
            Padding(
              padding: EdgeInsets.all(isPad ? 24 : 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Close button
                  TextButton(
                    onPressed: () {
                      if (onClose != null) {
                        onClose!();
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text(
                      'Close',
                      style: greyTextStyle.copyWith(
                        fontWeight: medium,
                        fontSize: isPad ? 16 : 14,
                      ),
                    ),
                  ),
                  SizedBox(width: isPad ? 16 : 8),
                  
                  // Download button for analysis data
                  if (hasAnalysis)
                    ElevatedButton(
                      onPressed: () {
                        context.showSuccessNotification(
                          title: 'Coming Soon',
                          message: 'Download functionality will be available in future updates.',
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: blueColor,
                        foregroundColor: whiteColor,
                        padding: EdgeInsets.symmetric(
                          horizontal: isPad ? 24 : 16,
                          vertical: isPad ? 12 : 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.download,
                            size: isPad ? 20 : 16,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Download PDF',
                            style: whiteTextStyle.copyWith(
                              fontSize: isPad ? 16 : 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Header with image
  Widget _buildHeader(BuildContext context, bool isPad) {
    return Container(
      height: isPad ? 200 : 150,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        image: DecorationImage(
          image: AssetImage('assets/img_salad.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.1),
                  Colors.black.withOpacity(0.5),
                ],
              ),
            ),
          ),
          
          // Close button positioned at top-right
          Positioned(
            top: 16,
            right: 16,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  color: whiteColor,
                  size: isPad ? 24 : 20,
                ),
              ),
            ),
          ),
          
          // Date added at bottom-left
          Positioned(
            bottom: 16,
            left: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Food Details',
                  style: whiteTextStyle.copyWith(
                    fontSize: isPad ? 22 : 18,
                    fontWeight: semiBold,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Added on ${foodLog.logDate != null ? '${foodLog.logDate!.day}/${foodLog.logDate!.month}/${foodLog.logDate!.year}' : 'Today'}',
                  style: whiteTextStyle.copyWith(
                    fontSize: isPad ? 14 : 12,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // Nutrition information cards
  Widget _buildNutritionInfo(BuildContext context, bool isPad) {
    if (foodLog.analysis == null) {
      return const SizedBox.shrink();
    }
    
    final analysis = foodLog.analysis!;
    
    // Calculate wider card size on larger screens
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 800;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isPad ? 16 : 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: isWide
          ? Row(
              children: [
                _buildNutrientCard(
                  'Calories', 
                  '${analysis.calories}', 
                  'kcal', 
                  orangeColor, 
                  isPad,
                  flex: 1,
                ),
                SizedBox(width: 12),
                _buildNutrientCard(
                  'Protein', 
                  '${analysis.proteinGrams}', 
                  'g', 
                  Colors.blue, 
                  isPad,
                  flex: 1,
                ),
                SizedBox(width: 12),
                _buildNutrientCard(
                  'Carbs', 
                  '${analysis.carbsGrams}', 
                  'g', 
                  Colors.green, 
                  isPad,
                  flex: 1,
                ),
                SizedBox(width: 12),
                _buildNutrientCard(
                  'Fat', 
                  '${analysis.fatGrams}', 
                  'g', 
                  Colors.red, 
                  isPad,
                  flex: 1,
                ),
              ],
            )
          : Column(
              children: [
                Row(
                  children: [
                    _buildNutrientCard(
                      'Calories', 
                      '${analysis.calories}', 
                      'kcal', 
                      orangeColor, 
                      isPad,
                    ),
                    SizedBox(width: 12),
                    _buildNutrientCard(
                      'Protein', 
                      '${analysis.proteinGrams}', 
                      'g', 
                      Colors.blue, 
                      isPad,
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    _buildNutrientCard(
                      'Carbs', 
                      '${analysis.carbsGrams}', 
                      'g', 
                      Colors.green, 
                      isPad,
                    ),
                    SizedBox(width: 12),
                    _buildNutrientCard(
                      'Fat', 
                      '${analysis.fatGrams}', 
                      'g', 
                      Colors.red, 
                      isPad,
                    ),
                  ],
                ),
              ],
            ),
    );
  }
  
  // Individual nutrient card
  Widget _buildNutrientCard(
    String title, 
    String value, 
    String unit, 
    Color color, 
    bool isPad, 
    {int flex = 1}
  ) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: EdgeInsets.all(isPad ? 16 : 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              title,
              style: greyTextStyle.copyWith(
                fontSize: isPad ? 14 : 12,
              ),
            ),
            SizedBox(height: isPad ? 8 : 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: isPad ? 24 : 20,
                    fontWeight: bold,
                  ),
                ),
                SizedBox(width: 2),
                Padding(
                  padding: EdgeInsets.only(bottom: isPad ? 4 : 2),
                  child: Text(
                    unit,
                    style: TextStyle(
                      color: color,
                      fontSize: isPad ? 14 : 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  // No analysis placeholder
  Widget _buildNoAnalysisView(BuildContext context, bool isPad) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isPad ? 24 : 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(
            Icons.no_food,
            size: isPad ? 48 : 40,
            color: greyColor,
          ),
          SizedBox(height: isPad ? 16 : 12),
          Text(
            'No nutrition analysis available',
            style: blackTextStyle.copyWith(
              fontSize: isPad ? 16 : 14,
              fontWeight: medium,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'Take a photo of your food to get detailed nutritional information',
            style: greyTextStyle.copyWith(
              fontSize: isPad ? 14 : 12,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isPad ? 24 : 16),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Here we would navigate to scan food page
              // This would be implemented in a real app
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: orangeColor,
              foregroundColor: whiteColor,
              padding: EdgeInsets.symmetric(
                horizontal: isPad ? 24 : 16,
                vertical: isPad ? 12 : 8,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.camera_alt,
                  size: isPad ? 20 : 16,
                ),
                SizedBox(width: 8),
                Text(
                  'Analyze Food',
                  style: whiteTextStyle.copyWith(
                    fontSize: isPad ? 16 : 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // Food composition chart
  Widget _buildCompositionChart(BuildContext context, bool isPad) {
    if (foodLog.analysis == null) {
      return const SizedBox.shrink();
    }
    
    final analysis = foodLog.analysis!;
    
    // Calculate percentages
    final totalGrams = analysis.proteinGrams + analysis.carbsGrams + analysis.fatGrams;
    final proteinPercentage = totalGrams > 0 ? (analysis.proteinGrams / totalGrams * 100).round() : 0;
    final carbsPercentage = totalGrams > 0 ? (analysis.carbsGrams / totalGrams * 100).round() : 0;
    final fatPercentage = totalGrams > 0 ? (analysis.fatGrams / totalGrams * 100).round() : 0;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isPad ? 16 : 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // Progress bars for composition
          _buildNutrientProgressBar(
            'Protein',
            proteinPercentage,
            Colors.blue,
            isPad,
          ),
          SizedBox(height: isPad ? 16 : 12),
          _buildNutrientProgressBar(
            'Carbs',
            carbsPercentage,
            Colors.green,
            isPad,
          ),
          SizedBox(height: isPad ? 16 : 12),
          _buildNutrientProgressBar(
            'Fat',
            fatPercentage,
            Colors.red,
            isPad,
          ),
          
          // Additional information
          SizedBox(height: isPad ? 24 : 16),
          Text(
            'Recommended Daily Intake',
            style: blackTextStyle.copyWith(
              fontSize: isPad ? 16 : 14,
              fontWeight: medium,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'This meal provides approximately: ${analysis.calories} out of 2000 recommended daily calories (${(analysis.calories / 2000 * 100).round()}%)',
            style: greyTextStyle.copyWith(
              fontSize: isPad ? 14 : 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  // Nutrient progress bar
  Widget _buildNutrientProgressBar(
    String label,
    int percentage,
    Color color,
    bool isPad,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: blackTextStyle.copyWith(
                fontSize: isPad ? 14 : 12,
              ),
            ),
            Text(
              '$percentage%',
              style: blackTextStyle.copyWith(
                fontSize: isPad ? 14 : 12,
                fontWeight: semiBold,
              ),
            ),
          ],
        ),
        SizedBox(height: isPad ? 8 : 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: Colors.grey.shade200,
            color: color,
            minHeight: isPad ? 10 : 8,
          ),
        ),
      ],
    );
  }
  
  // Show the details view as a dialog
  static void show(BuildContext context, FoodLog foodLog) {
    showDialog(
      context: context,
      builder: (context) => FoodDetailsView(foodLog: foodLog),
    );
  }
}