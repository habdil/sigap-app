import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';

class ActivityStats extends StatelessWidget {
  final String date;
  final String time;
  final int steps;
  final String reward;
  final int coins;

  const ActivityStats({
    Key? key,
    required this.date,
    required this.time,
    required this.steps,
    required this.coins,
    required this.reward,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade200, Colors.orange.shade200],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date and time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style: blackTextStyle.copyWith(
                  fontWeight: medium,
                  fontSize: 14,
                ),
              ),
              Text(
                time,
                style: blackTextStyle.copyWith(
                  fontWeight: medium,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Activity graph visualization - Responsive height
          SizedBox(
            height: 50,
            width: double.infinity,
            child: CustomPaint(
              painter: WaveGraphPainter(),
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Steps and reward
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$steps Steps',
                style: blackTextStyle.copyWith(
                  fontWeight: bold,
                  fontSize: 16,
                ),
              ),
              Text(
                reward,
                style: blackTextStyle.copyWith(
                  fontWeight: bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Coin balance
          Row(
            children: [
              const Icon(
                Icons.watch_later_outlined,
                size: 18,
              ),
              const SizedBox(width: 4),
              Text(
                '$coins Coin',
                style: blackTextStyle.copyWith(
                  fontWeight: medium,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Custom painter for wave graph visualization
class WaveGraphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = orangeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
      
    final Path path = Path();
    
    // Start from left
    path.moveTo(0, size.height * 0.5);
    
    // First wave
    path.quadraticBezierTo(
      size.width * 0.1, 
      size.height * 0.2,
      size.width * 0.2, 
      size.height * 0.5
    );
    
    // Second wave
    path.quadraticBezierTo(
      size.width * 0.3, 
      size.height * 0.8,
      size.width * 0.4, 
      size.height * 0.5
    );
    
    // Third wave
    path.quadraticBezierTo(
      size.width * 0.5, 
      size.height * 0.2,
      size.width * 0.6, 
      size.height * 0.5
    );
    
    // Fourth wave
    path.quadraticBezierTo(
      size.width * 0.7, 
      size.height * 0.8,
      size.width * 0.8, 
      size.height * 0.5
    );
    
    // Fifth wave
    path.quadraticBezierTo(
      size.width * 0.9, 
      size.height * 0.2,
      size.width, 
      size.height * 0.5
    );
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}