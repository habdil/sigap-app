// frontend/lib/ui/widgets/dashboard/profile/recipe_post_card.dart
import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';

class RecipePostCard extends StatelessWidget {
  const RecipePostCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background image that fills the entire card
          Positioned.fill(
            child: Image.asset(
              'assets/bg_salad.png',
              fit: BoxFit.cover,
            ),
          ),
          
          // Gradient overlay to ensure text readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.transparent,
                    Colors.white.withOpacity(0.4),
                    Colors.white,
                  ],
                  stops: const [0.0, 0.5, 0.8],
                ),
              ),
            ),
          ),
          
          // Content - Right aligned
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'salad recipe recommendations',
                    style: blackTextStyle.copyWith(
                      fontSize: 20,
                      fontWeight: semiBold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        'click for recipe',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: medium,
                          color: Color(0xFFFF7A45),
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.chevron_right,
                        color: Color(0xFFFF7A45),
                        size: 18,
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Color(0xFFFF7A45),
                        size: 18,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Make the entire card clickable
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // Handle recipe card tap
                  print('Recipe card tapped');
                },
                splashColor: Colors.white.withOpacity(0.1),
                highlightColor: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}