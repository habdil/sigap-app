// lib/ui/widgets/food/food_nutrients_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/blocs/food_bloc.dart';
import 'package:frontend/shared/theme.dart';
import 'package:frontend/ui/widgets/food/nutrient_card.dart';


class FoodNutrientsSection extends StatelessWidget {
  const FoodNutrientsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today\'s Nutrients',
            style: blackTextStyle.copyWith(
              fontWeight: semiBold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          
          // Nutrient cards using BlocBuilder to get the latest food data
          BlocBuilder<FoodBloc, FoodState>(
            builder: (context, state) {
              if (state is FoodLoaded) {
                // Get the latest food log with analysis
                final analyzedFoods = state.foodLogs.where((food) => food.analysis != null).toList();
                
                if (analyzedFoods.isEmpty) {
                  return _buildEmptyNutrients();
                }
                
                // Get the latest food log with analysis
                final latestFood = analyzedFoods.first;
                final analysis = latestFood.analysis!;
                
                return GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    NutrientCard(
                      nutrientName: 'Protein',
                      amount: '${analysis.proteinGrams}g',
                      bgColor: Colors.orange.shade100,
                      iconData: Icons.circle_outlined,
                      iconColor: orangeColor,
                      perKg: '0.8g/kg',
                    ),
                    NutrientCard(
                      nutrientName: 'Carbs',
                      amount: '${analysis.carbsGrams}g',
                      bgColor: Colors.red.shade50,
                      iconData: Icons.local_fire_department_outlined,
                      iconColor: orangeColor,
                      perKg: '200g/kg',
                    ),
                    NutrientCard(
                      nutrientName: 'Fat',
                      amount: '${analysis.fatGrams}g',
                      bgColor: Colors.blue.shade50,
                      iconData: Icons.water_drop_outlined,
                      iconColor: orangeColor,
                      perKg: '0.8g/kg',
                    ),
                    NutrientCard(
                      nutrientName: 'Fibers',
                      amount: '${analysis.fiberGrams}g',
                      bgColor: Colors.green.shade50,
                      iconData: Icons.grass_outlined,
                      iconColor: orangeColor,
                      perKg: '0.8g/kg',
                    ),
                  ],
                );
              }
              
              // Default nutrient cards with placeholder data
              return _buildPlaceholderNutrients();
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildEmptyNutrients() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          children: [
            Icon(
              Icons.restaurant,
              size: 48,
              color: greyColor,
            ),
            const SizedBox(height: 16),
            Text(
              'No nutrients data available',
              style: blackTextStyle.copyWith(
                fontWeight: medium,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add a food log and analyze it to see nutritional information',
              style: greyTextStyle.copyWith(
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPlaceholderNutrients() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        NutrientCard(
          nutrientName: 'Protein',
          amount: '0g',
          bgColor: Colors.orange.shade100,
          iconData: Icons.circle_outlined,
          iconColor: orangeColor,
          perKg: '0.8g/kg',
        ),
        NutrientCard(
          nutrientName: 'Carbs',
          amount: '0g',
          bgColor: Colors.red.shade50,
          iconData: Icons.local_fire_department_outlined,
          iconColor: orangeColor,
          perKg: '200g/kg',
        ),
        NutrientCard(
          nutrientName: 'Fat',
          amount: '0g',
          bgColor: Colors.blue.shade50,
          iconData: Icons.water_drop_outlined,
          iconColor: orangeColor,
          perKg: '0.8g/kg',
        ),
        NutrientCard(
          nutrientName: 'Fibers',
          amount: '0g',
          bgColor: Colors.green.shade50,
          iconData: Icons.grass_outlined,
          iconColor: orangeColor,
          perKg: '0.8g/kg',
        ),
      ],
    );
  }
}