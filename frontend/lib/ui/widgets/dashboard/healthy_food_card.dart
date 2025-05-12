import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';
import 'package:frontend/ui/pages/dashboard/food/food_page.dart'; // Sesuaikan path import

class HealthyFoodSection extends StatelessWidget {
  const HealthyFoodSection({Key? key, required void Function() onTapSeeMore}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Calculate adaptive dimensions
    final horizontalPadding = _getAdaptiveHorizontalPadding(screenWidth);
    final cardHeight = _getAdaptiveCardHeight(screenHeight);
    final textScaleFactor = _getAdaptiveTextScaleFactor(screenWidth);
    final borderRadius = _getAdaptiveBorderRadius(screenWidth);
    
    return Column(
      children: [
        // Header with title and "see all" button
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Healthy food for you',
                style: blackTextStyle.copyWith(
                  fontWeight: semiBold, 
                  fontSize: 14 * textScaleFactor
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Navigasi ke halaman Food
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FoodPage(),
                    ),
                  );
                },
                child: Text(
                  'see all',
                  style: orangeTextStyle.copyWith(
                    fontSize: 12 * textScaleFactor, 
                    fontWeight: medium
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Space between header and card
        SizedBox(height: 12 * textScaleFactor),
        
        // Main food card
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: GestureDetector(
            onTap: () {
              // Navigasi ke halaman Food ketika card di-tap
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FoodPage(),
                ),
              );
            },
            child: Container(
              height: cardHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(borderRadius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius),
                child: Stack(
                  children: [
                    // Background Image
                    Positioned.fill(
                      child: Image.asset(
                        'assets/img_salad.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    
                    // Semi-transparent Text Background
                    Positioned.fill(
                      child: Row(
                        children: [
                          // Text container on the left
                          Expanded(
                            // Adjust flex based on screen width
                            flex: _getAdaptiveTextFlex(screenWidth),
                            child: Container(
                              color: Colors.white.withOpacity(0.1),
                              padding: EdgeInsets.all(20 * textScaleFactor),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Your\nHealth\nStarts on\nYour Plate',
                                    style: blackTextStyle.copyWith(
                                      fontSize: 18 * textScaleFactor,
                                      fontWeight: FontWeight.bold,
                                      height: 1.3,
                                    ),
                                  ),
                                  SizedBox(height: 8 * textScaleFactor),
                                  Text(
                                    'healthy food\nrecommendations here',
                                    style: orangeTextStyle.copyWith(
                                      fontSize: 12 * textScaleFactor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          // Empty space on the right side of card
                          Expanded(
                            // Adjust flex based on screen width
                            flex: _getAdaptiveImageFlex(screenWidth),
                            child: const SizedBox()
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  // Helper methods tetap sama seperti sebelumnya
  // (salin semua metode pembantu dari versi sebelumnya)
  
  // Get adaptive horizontal padding based on screen width
  double _getAdaptiveHorizontalPadding(double screenWidth) {
    if (screenWidth < 320) return 12; // Very small devices
    if (screenWidth > 600) return 24; // Large devices
    return 16; // Default for medium devices
  }
  
  // Get adaptive card height based on screen height
  double _getAdaptiveCardHeight(double screenHeight) {
    // Smaller height for very small screens
    if (screenHeight < 600) return 180;
    
    // Taller for larger screens
    if (screenHeight > 800) return 220;
    
    // Default value
    return 200;
  }
  
  // Get adaptive text scale factor based on screen width
  double _getAdaptiveTextScaleFactor(double screenWidth) {
    if (screenWidth < 320) return 0.85; // Very small devices
    if (screenWidth < 360) return 0.9; // Small devices
    if (screenWidth > 600) return 1.15; // Large devices
    return 1.0; // Default for medium devices
  }
  
  // Get adaptive border radius based on screen width
  double _getAdaptiveBorderRadius(double screenWidth) {
    if (screenWidth < 320) return 24; // Smaller radius for very small screens
    if (screenWidth > 600) return 36; // Larger radius for big screens
    return 30; // Default radius
  }
  
  // Get adaptive flex for text container based on screen width
  int _getAdaptiveTextFlex(double screenWidth) {
    if (screenWidth < 320) return 3; // More space for text on very small screens
    if (screenWidth > 600) return 2; // Standard ratio on larger screens
    return 2; // Default flex
  }
  
  // Get adaptive flex for image space based on screen width
  int _getAdaptiveImageFlex(double screenWidth) {
    if (screenWidth < 320) return 2; // Less space for image on very small screens
    if (screenWidth > 600) return 4; // More image space on larger screens
    return 3; // Default flex
  }
}