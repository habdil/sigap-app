import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';

class YogaVisualization extends StatelessWidget {
  const YogaVisualization({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Circular background gradient
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.0)],
                stops: const [0.5, 1.0],
              ),
            ),
          ),
          
          // Yoga pose image
          Image.asset(
            'assets/sport_jogging/ic_yoga_visual.png',
            width: 100,
            height: 100,
            color: orangeColor,
            // Fallback if image is not found
            errorBuilder: (context, error, stackTrace) {
              print('Error loading yoga visualization image: $error');
              return _buildFallbackYogaVisualization();
            },
          ),
        ],
      ),
    );
  }
  
  // Fallback visualization if image doesn't load
  Widget _buildFallbackYogaVisualization() {
    return Container(
      width: 100,
      height: 100,
      child: Icon(
        Icons.self_improvement,
        size: 80,
        color: orangeColor,
      ),
    );
  }
}