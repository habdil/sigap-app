// frontend\lib\ui\widgets\food\icon_scan_food.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/blocs/food_bloc.dart';
import 'package:frontend/shared/loading.dart';
import 'package:frontend/shared/notification.dart';
import 'package:frontend/shared/theme.dart';
import 'package:frontend/ui/pages/dashboard/food/scan_food_page.dart';

class IconScanFood extends StatelessWidget {
  final double? size;
  final double? right;
  final double? top;

  const IconScanFood({
    super.key,
    this.size,
    this.right,
    this.top,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive sizing
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Calculate responsive dimensions with optional override
    final iconSize = size ?? (screenWidth * 0.15); // Default: 15% of screen width for circular icon
    final horizontalPadding = screenWidth * 0.04; // 4% of screen width
    
    return Positioned(
      top: top, // Use provided value or null (will be ignored if null)
      right: right ?? (horizontalPadding * 0.5), // Use provided value or default
      child: GestureDetector(
        onTap: () {
          // Handle tap - create a food log first
          _handleScanFoodTap(context);
        },
        child: Container(
          width: iconSize.clamp(50.0, 120.0), // Min 50, max 120
          height: iconSize.clamp(50.0, 120.0),
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
              width: iconSize * 0.80, // Proportional icon size
              height: iconSize * 0.80, // Proportional icon size
            ),
          ),
        ),
      ),
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