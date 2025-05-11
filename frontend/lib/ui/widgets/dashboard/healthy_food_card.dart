import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';

class HealthyFoodSection extends StatelessWidget {
  final VoidCallback onTapSeeMore;

  const HealthyFoodSection({
    Key? key,
    required this.onTapSeeMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Healthy food for you',
                style: blackTextStyle.copyWith(fontWeight: semiBold, fontSize: 14),
              ),
              GestureDetector(
                onTap: onTapSeeMore,
                child: Text(
                  'see all',
                  style: orangeTextStyle.copyWith(fontSize: 12, fontWeight: medium),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
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
                        Expanded(
                          flex: 2,
                          child: Container(
                            color: Colors.white.withOpacity(0.1),
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Your\nHealth\nStarts on\nYour Plate',
                                  style: blackTextStyle.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    height: 1.3,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'healthy food\nrecommendations here',
                                  style: orangeTextStyle.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(flex: 3, child: SizedBox()),
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
  }
}