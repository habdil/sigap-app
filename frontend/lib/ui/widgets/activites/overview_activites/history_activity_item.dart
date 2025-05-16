import 'package:flutter/material.dart';

/// History activity item card with improved responsiveness and larger text
class HistoryActivityItem extends StatelessWidget {
  final String day;
  final String activity;
  final double distance;
  final int duration;
  final String title;
  final int steps;
  final Color bgColor;

  const HistoryActivityItem({
    Key? key,
    required this.day,
    required this.activity,
    required this.distance,
    required this.duration,
    required this.title,
    required this.steps,
    required this.bgColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive sizing
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    final isSmallScreen = screenWidth < 360;
    final isLandscape = screenWidth > screenHeight;
    
    // Calculate responsive values with larger base font sizes
    final baseFontSize = isSmallScreen ? 0.9 : 1.1; // Slightly reduced to prevent overflow
    final paddingScale = isSmallScreen ? 0.7 : 0.9; // Reduced padding to give more space for text
    
    // Calculate card height based on screen size
    final cardHeight = isLandscape 
        ? screenHeight * 0.5 
        : screenHeight * 0.22;
    
    // Text colors based on background
    final textColor = bgColor == Colors.white ? Colors.black : Colors.white;
    final accentColor = bgColor == Colors.white ? Colors.orange : Colors.white;
    final coinColor = bgColor == Colors.white ? Colors.amber : Colors.white;
    
    return Container(
      height: cardHeight,
      padding: EdgeInsets.symmetric(
        horizontal: 10 * paddingScale, // Reduced horizontal padding
        vertical: 14 * paddingScale,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: bgColor == Colors.white ? Border.all(color: Colors.grey.shade300) : null,
        boxShadow: bgColor == Colors.white 
            ? [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))]
            : null,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Use LayoutBuilder to get the exact available space in the container
          final maxHeight = constraints.maxHeight;
          final maxWidth = constraints.maxWidth;
          
          // Calculate spacing based on available height
          final smallSpacing = maxHeight * 0.01;
          
          // Calculate font sizes based on container width
          // Slightly reduced multipliers to prevent overflow
          final smallFontSize = maxWidth * 0.05 * baseFontSize;
          final mediumFontSize = maxWidth * 0.065 * baseFontSize;
          final largeFontSize = maxWidth * 0.1 * baseFontSize;
          final iconSize = maxWidth * 0.055;
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with day and distance
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: Text(
                      day, 
                      style: TextStyle(
                        fontSize: smallFontSize, 
                        fontWeight: FontWeight.bold, 
                        color: textColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (activity != 'YOGA') 
                    Flexible(
                      flex: 1,
                      child: Text(
                        '$distance km', 
                        style: TextStyle(
                          fontSize: smallFontSize, 
                          color: textColor,
                        ),
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
              
              SizedBox(height: smallSpacing),
              
              // Divider line
              Container(
                height: 3, // Slightly reduced height
                decoration: BoxDecoration(
                  color: accentColor, 
                  borderRadius: BorderRadius.circular(1.5),
                ),
              ),
              
              SizedBox(height: smallSpacing),
              
              // Activity type
              Text(
                activity, 
                style: TextStyle(
                  fontSize: smallFontSize, 
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              
              // Flexible spacer that adapts to available space
              Spacer(flex: 1),
              
              // Duration and title
              Text(
                '$duration min', 
                style: TextStyle(
                  fontSize: largeFontSize, 
                  fontWeight: FontWeight.bold, 
                  color: textColor,
                ),
              ),
              
              Text(
                title, 
                style: TextStyle(
                  fontSize: mediumFontSize, 
                  color: textColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              
              // Flexible spacer that adapts to available space
              Spacer(flex: 2),
              
              // Steps and coins info - THIS IS THE ROW THAT WAS OVERFLOWING
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Steps column - wrapped in Flexible to prevent overflow
                  Flexible(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$steps', 
                          style: TextStyle(
                            fontSize: mediumFontSize, 
                            fontWeight: FontWeight.bold, 
                            color: textColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'steps', 
                          style: TextStyle(
                            fontSize: smallFontSize, 
                            color: textColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  
                  // Coins info - wrapped in Flexible to prevent overflow
                  Flexible(
                    flex: 2,
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // Important to prevent overflow
                      children: [
                        Icon(
                          Icons.monetization_on, 
                          size: iconSize, 
                          color: coinColor,
                        ), 
                        const SizedBox(width: 2), // Reduced spacing
                        Flexible(
                          child: Text(
                            '+$steps', 
                            style: TextStyle(
                              fontSize: smallFontSize, 
                              fontWeight: FontWeight.w500,
                              color: bgColor == Colors.white ? Colors.orange : Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
