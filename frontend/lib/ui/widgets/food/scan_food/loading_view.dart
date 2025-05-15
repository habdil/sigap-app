// lib/ui/widgets/food/scan_food/result_scan/loading_view.dart
import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';

class LoadingView extends StatelessWidget {
  final VoidCallback onCancel;
  
  const LoadingView({
    Key? key,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Custom animated loading indicator
            SizedBox(
              width: 100,
              height: 100,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer rotating circle
                  CircularProgressIndicator(
                    strokeWidth: 5,
                    valueColor: AlwaysStoppedAnimation<Color>(orangeColor),
                  ),
                  // Inner rotating circle
                  SizedBox(
                    width: 75,
                    height: 75,
                    child: CircularProgressIndicator(
                      strokeWidth: 5,
                      valueColor: AlwaysStoppedAnimation<Color>(blueColor),
                    ),
                  ),
                  // Center icon
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.restaurant,
                      color: orangeColor,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Text(
              'Analyzing your food...',
              style: blackTextStyle.copyWith(
                fontSize: 22,
                fontWeight: semiBold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This may take a moment',
              style: greyTextStyle.copyWith(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 50),
            // Progress indicators
            SizedBox(
              width: 200,
              child: LinearProgressIndicator(
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(orangeColor),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Identifying nutrients...',
              style: greyTextStyle.copyWith(
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade200,
                foregroundColor: blackColor,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: onCancel,
              icon: const Icon(Icons.close),
              label: Text(
                'Cancel',
                style: blackTextStyle.copyWith(
                  fontWeight: medium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}