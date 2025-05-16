// lib\ui\pages\dashboard\food\food_page.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/blocs/food_bloc.dart';
import 'package:frontend/shared/loading.dart';
import 'package:frontend/shared/navbar.dart';
import 'package:frontend/shared/notification.dart';
import 'package:frontend/shared/theme.dart';
import 'package:frontend/ui/pages/dashboard/food/scan_food_page.dart';
import 'package:frontend/ui/widgets/food/avoid_food_section.dart';
import 'package:frontend/ui/widgets/food/food_header.dart';
import 'package:frontend/ui/widgets/food/food_history_section.dart';
import 'package:frontend/ui/widgets/food/food_nutrients_section.dart';
import 'package:frontend/ui/widgets/food/healthy_food_banner.dart';

class FoodPage extends StatelessWidget {
  const FoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Main content
      body: const SingleChildScrollView(
        child: Column(
          children: [
            // Header section with gradient background
            FoodHeader(),
            
            SizedBox(height: 24),
            // Want To Avoid section
            AvoidFoodSection(),

            SizedBox(height: 24),
            // Food Recommendation section
            HealthyFoodBanner(),

            SizedBox(height: 24),
            // Calculation of food components section
            FoodNutrientsSection(),

            SizedBox(height: 24),
            // Food History section
            FoodHistorySection(),
            
            SizedBox(height: 24),
          ],
        ),
      ),
      
      // Add floating action button for scan food
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFoodEntryDialog(context),
        backgroundColor: orangeColor,
        elevation: 5.0,
        child: Image.asset(
          'assets/ic_scan_food.png',
          color: Colors.white,
          width: 50,
          height: 50,
        ),
      ),
      
      bottomNavigationBar: const CustomNavBar(initialIndex: 2), // Using CustomNavBar with Food tab selected
    );
  }
  
  // Show dialog to create food entry
  void _showFoodEntryDialog(BuildContext context) {
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
  
  // Navigate to scan page after food log creation
  void _navigateToScanAfterCreation(BuildContext context) {
    // Show loading indicator
    ElegantLoading.show(context, message: 'Creating food entry...');
    
    // Set up a listener for the FoodBloc
    late final StreamSubscription subscription;
    
    // Variable to track timeout timer
    Timer? timeoutTimer;

    // Variable to detect if already processed
    bool isProcessed = false;
    
    subscription = BlocProvider.of<FoodBloc>(context).stream.listen(
      (state) {
        // Avoid double processing
        if (isProcessed) return;
        
        if (state is FoodAdded) {
          isProcessed = true;
          
          // Cancel timeout timer as process succeeded
          timeoutTimer?.cancel();
          
          // Dismiss loading indicator - use try-catch for safety
          try {
            if (context.mounted) {
              ElegantLoading.dismiss(context);
            }
          } catch (e) {
            print('Error dismissing loading: $e');
          }
          
          // Cancel subscription to avoid memory leaks
          subscription.cancel();
          
          // Add small delay to ensure UI is properly updated
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
          
          // Cancel timeout timer on error
          timeoutTimer?.cancel();
          
          // Dismiss loading indicator - use try-catch for safety
          try {
            if (context.mounted) {
              ElegantLoading.dismiss(context);
            }
          } catch (e) {
            print('Error dismissing loading: $e');
          }
          
          // Cancel subscription to avoid memory leaks
          subscription.cancel();
          
          // Add small delay to ensure UI is properly updated
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
    
    // Increase timeout to 15 seconds
    timeoutTimer = Timer(const Duration(seconds: 15), () {
      // Verify that no response was received
      if (!isProcessed) {
        subscription.cancel();
        isProcessed = true;
        
        // Delay slightly to ensure loading is properly dismissed
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