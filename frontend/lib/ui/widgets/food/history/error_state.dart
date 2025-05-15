import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/blocs/food_bloc.dart';

class ErrorState extends StatelessWidget {
  final String message;
  final bool isPad;

  const ErrorState({
    Key? key,
    required this.message,
    required this.isPad,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isPad ? 32 : 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: isPad ? 72 : 64,
              color: Colors.red.shade300,
            ),
            SizedBox(height: isPad ? 24 : 16),
            Text(
              'Error Loading Food History',
              style: blackTextStyle.copyWith(
                fontSize: isPad ? 20 : 18,
                fontWeight: semiBold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: isPad ? 12 : 8),
            Text(
              message,
              style: greyTextStyle.copyWith(
                fontSize: isPad ? 16 : 14,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: isPad ? 32 : 24),
            ElevatedButton(
              onPressed: () {
                context.read<FoodBloc>().add(LoadFoodLogs());
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
              child: Text(
                'Try Again',
                style: whiteTextStyle.copyWith(
                  fontSize: isPad ? 16 : 14,
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