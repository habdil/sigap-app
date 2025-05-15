// frontend/lib/ui/widgets/dashboard/profile/recipes_posts_section.dart
import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';
import 'package:frontend/ui/widgets/dashboard/profile/recipe_post_card.dart';

class RecipesPostsSection extends StatelessWidget {
  const RecipesPostsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recipes Posts',
          style: blackTextStyle.copyWith(
            fontSize: 18,
            fontWeight: semiBold,
          ),
        ),
        const SizedBox(height: 16),
        
        // Recipe Card
        RecipePostCard(),
      ],
    );
  }
}