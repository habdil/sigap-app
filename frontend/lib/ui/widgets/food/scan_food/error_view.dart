// lib/ui/widgets/food/scan_food/result_scan/error_view.dart
import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';

class ErrorView extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onTryAgain;
  
  const ErrorView({
    Key? key,
    required this.errorMessage,
    required this.onTryAgain,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Error icon in circle
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline_rounded,
                  color: Colors.red.shade400,
                  size: 60,
                ),
              ),
              const SizedBox(height: 32),
              
              // Error title
              Text(
                'Analysis Failed',
                style: blackTextStyle.copyWith(
                  fontSize: 24,
                  fontWeight: bold,
                ),
              ),
              const SizedBox(height: 16),
              
              // Error message
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Text(
                  errorMessage,
                  textAlign: TextAlign.center,
                  style: blackTextStyle.copyWith(
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              
              // Try again button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: orangeColor,
                  foregroundColor: whiteColor,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 2,
                  shadowColor: orangeColor.withOpacity(0.3),
                ),
                onPressed: onTryAgain,
                icon: const Icon(Icons.refresh),
                label: Text(
                  'Try Again',
                  style: whiteTextStyle.copyWith(
                    fontWeight: semiBold,
                    fontSize: 16,
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Troubleshooting tips
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Troubleshooting Tips:',
                      style: blackTextStyle.copyWith(
                        fontWeight: semiBold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildTip('Make sure food is clearly visible in the frame'),
                    _buildTip('Check your internet connection'),
                    _buildTip('Try with better lighting conditions'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildTip(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            color: blueColor,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              tip,
              style: blackTextStyle.copyWith(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}