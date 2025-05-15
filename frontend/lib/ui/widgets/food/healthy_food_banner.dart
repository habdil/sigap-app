// lib/ui/widgets/food/healthy_food_banner.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/shared/loading.dart';
import 'package:frontend/shared/theme.dart';
import 'package:frontend/ui/pages/dashboard/food/scan_food_page.dart';
import 'package:frontend/shared/notification.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/blocs/food_bloc.dart';

class HealthyFoodBanner extends StatelessWidget {
  const HealthyFoodBanner({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Calculate responsive dimensions
    final bannerHeight = screenHeight * 0.25; // 25% of screen height with min/max constraints
    final horizontalPadding = screenWidth * 0.04; // 4% of screen width
    final iconSize = screenWidth * 0.15; // 15% of screen width for circular icon
    final borderRadius = screenWidth * 0.08; // Responsive border radius
    
    // Calculate responsive text sizes
    final headingFontSize = screenWidth * 0.038; // ~14px on 375px width
    final titleFontSize = screenWidth < 360 ? 16.0 : 18.0; // Adjust title size for small screens
    final subtitleFontSize = screenWidth < 360 ? 10.0 : 12.0; // Adjust subtitle size for small screens
    
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            // Header with title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Healthy food for you',
                    style: blackTextStyle.copyWith(
                      fontWeight: semiBold, 
                      fontSize: headingFontSize
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.015), // Responsive vertical spacing
            
            // Banner container
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Container(
                height: bannerHeight.clamp(150.0, 250.0), // Min 150, max 250
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(borderRadius.clamp(20.0, 30.0)), // Min 20, max 30
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(borderRadius.clamp(20.0, 30.0)),
                  child: Stack(
                    children: [
                      // Background Image with proper fit
                      Positioned.fill(
                        child: Image.asset(
                          'assets/img_salad.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      
                      // Orange icon on the right - positioned proportionally
                      Positioned(
                        top: bannerHeight * 0.38, // 38% from top
                        right: horizontalPadding * 0.5,
                        child: GestureDetector(
                          onTap: () {
                            // Handle tap - now we need to create a food log first
                            _handleScanFoodTap(context);
                          },
                          child: Container(
                            width: iconSize.clamp(50.0, 90.0), // Min 50, max 90
                            height: iconSize.clamp(50.0, 90.0),
                            decoration: BoxDecoration(
                              color: orangeColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 7,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            ),
                            child: Center(
                              child: Image.asset(
                                'assets/ic_scan_food.png',
                                color: Colors.white,
                                width: iconSize * 0.65, // Proportional icon size
                                height: iconSize * 0.65, // Proportional icon size
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      // Semi-transparent Text Background with responsive widths
                      Positioned.fill(
                        child: Row(
                          children: [
                            // Text section takes proportional width based on screen size
                            Expanded(
                              flex: screenWidth < 360 ? 3 : 2, // More space on small screens
                              child: Container(
                                color: Colors.white.withOpacity(0.1),
                                padding: EdgeInsets.all(horizontalPadding * 0.8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Your\nHealth\nStarts on\nYour Plate',
                                      style: blackTextStyle.copyWith(
                                        fontSize: titleFontSize,
                                        fontWeight: FontWeight.bold,
                                        height: 1.3,
                                      ),
                                    ),
                                    SizedBox(height: bannerHeight * 0.04),
                                    Text(
                                      'healthy food\nrecommendations here',
                                      style: orangeTextStyle.copyWith(
                                        fontSize: subtitleFontSize,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Empty space takes remaining proportional width
                            Expanded(
                              flex: screenWidth < 360 ? 2 : 3, // Less space on small screens
                              child: const SizedBox(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
  
  // Helper method to handle scan food button tap
  void _handleScanFoodTap(BuildContext context) {
    // Show dialog to create food entry first
    final foodNameController = TextEditingController(text: "Quick Meal");
    
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            'Add Quick Food Entry',
            style: blackTextStyle.copyWith(
              fontSize: 18,
              fontWeight: semiBold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Before scanning, let\'s create a food entry',
                style: greyTextStyle.copyWith(fontSize: 14),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: foodNameController,
                decoration: InputDecoration(
                  labelText: 'Food Name',
                  labelStyle: greyTextStyle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'Cancel',
                style: greyTextStyle.copyWith(
                  fontWeight: medium,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Close dialog
                Navigator.of(dialogContext).pop();
                
                if (foodNameController.text.isNotEmpty) {
                  // Create a food log first
                  context.read<FoodBloc>().add(
                    AddFoodLog(
                      foodName: foodNameController.text,
                      notes: "Quick scan entry",
                    ),
                  );
                  
                  // Listen for the food log creation result and navigate to scan page
                  _navigateToScanAfterCreation(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: orangeColor,
                foregroundColor: whiteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Create & Scan'),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }
  
  // Helper method to navigate to scan page after food log creation
  void _navigateToScanAfterCreation(BuildContext context) {
    // Show loading indicator
    ElegantLoading.show(context, message: 'Creating food entry...');
    
    // Set up a listener for the FoodBloc
    late final StreamSubscription subscription;
    
    // Perbaikan: Variabel untuk melacak timeout timer
    Timer? timeoutTimer;

    // Perbaikan: Tambahkan variabel untuk mendeteksi jika sudah diproses
    bool isProcessed = false;
    
    subscription = BlocProvider.of<FoodBloc>(context).stream.listen(
      (state) {
        // Perbaikan: Hindari pemrosesan ganda
        if (isProcessed) return;
        
        if (state is FoodAdded) {
          isProcessed = true;
          
          // Batalkan timer timeout karena proses berhasil
          timeoutTimer?.cancel();
          
          // Dismiss loading indicator - gunakan try-catch untuk lebih aman
          try {
            if (context.mounted) {
              ElegantLoading.dismiss(context);
            }
          } catch (e) {
            print('Error dismissing loading: $e');
          }
          
          // Cancel subscription to avoid memory leaks
          subscription.cancel();
          
          // Perbaikan: Tambahkan delay kecil untuk memastikan UI diperbarui dengan benar
          Future.delayed(const Duration(milliseconds: 100), () {
            if (context.mounted) {
              // Navigate to scan page with the new food log id
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ScanFoodPage(
                    foodLogId: state.foodLog.id!,
                  ),
                ),
              );
            }
          });
        } else if (state is FoodError) {
          isProcessed = true;
          
          // Batalkan timer timeout pada error
          timeoutTimer?.cancel();
          
          // Dismiss loading indicator - gunakan try-catch untuk lebih aman
          try {
            if (context.mounted) {
              ElegantLoading.dismiss(context);
            }
          } catch (e) {
            print('Error dismissing loading: $e');
          }
          
          // Cancel subscription to avoid memory leaks
          subscription.cancel();
          
          // Perbaikan: Tambahkan delay kecil untuk memastikan UI diperbarui dengan benar
          Future.delayed(const Duration(milliseconds: 100), () {
            if (context.mounted) {
              // Show error notification
              context.showErrorNotification(
                title: 'Error',
                message: state.message,
              );
            }
          });
        }
      },
    );
    
    // Perbaikan: Tingkatkan timeout menjadi 15 detik
    timeoutTimer = Timer(const Duration(seconds: 15), () {
      // Perbaikan: Verifikasi bahwa tidak ada respon yang diterima
      if (!isProcessed) {
        subscription.cancel();
        isProcessed = true;
        
        // Tunda sedikit untuk memastikan loading benar-benar hilang
        Future.delayed(const Duration(milliseconds: 300), () {
          if (context.mounted) {
            try {
              ElegantLoading.dismiss(context);
            } catch (e) {
              print('Error dismissing loading: $e');
            }
            
            context.showErrorNotification(
              title: 'Timeout',
              message: 'Creating food entry timed out. Please try again.',
            );
          }
        });
      }
    });
  }
}