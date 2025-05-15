import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';

class RecipePostCard extends StatelessWidget {
  const RecipePostCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 360;
    
    return Container(
      // Use adaptive height based on screen size
      height: screenSize.height * 0.25, // 25% of screen height
      constraints: BoxConstraints(
        minHeight: 150, // Minimum height
        maxHeight: 230, // Maximum height
      ),
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
          
          // Content - Right aligned with adaptive width
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              // Adaptive width based on screen size
              width: screenSize.width * (isSmallScreen ? 0.7 : 0.6),
              padding: EdgeInsets.all(isSmallScreen ? 12 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'salad recipe recommendations',
                    style: blackTextStyle.copyWith(
                      // Adjust font size for smaller screens
                      fontSize: isSmallScreen ? 16 : 20,
                      fontWeight: semiBold,
                    ),
                    // Enable text wrapping
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  SizedBox(height: isSmallScreen ? 8 : 16),
                  Row(
                    children: [
                      Text(
                        'click for recipe',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 12 : 14,
                          fontWeight: medium,
                          color: Color(0xFFFF7A45),
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.chevron_right,
                        color: Color(0xFFFF7A45),
                        size: isSmallScreen ? 16 : 18,
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Color(0xFFFF7A45),
                        size: isSmallScreen ? 16 : 18,
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