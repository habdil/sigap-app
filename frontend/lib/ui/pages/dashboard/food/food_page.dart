// lib\ui\pages\dashboard\food\food_page.dart
import 'package:flutter/material.dart';
import 'package:frontend/shared/navbar.dart';
import 'package:frontend/ui/widgets/food/food_header.dart';
import 'package:frontend/ui/widgets/food/avoid_food_section.dart';
import 'package:frontend/ui/widgets/food/healthy_food_banner.dart';
import 'package:frontend/ui/widgets/food/food_nutrients_section.dart';
import 'package:frontend/ui/widgets/food/food_history_section.dart';

class FoodPage extends StatelessWidget {
  const FoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
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
      bottomNavigationBar: CustomNavBar(initialIndex: 2), // Using CustomNavBar with Food tab selected
    );
  }
}