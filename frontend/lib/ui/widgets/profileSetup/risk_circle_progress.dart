import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';
import 'dart:math' as math;

class RiskCircleProgress extends StatelessWidget {
  final int riskPercentage;

  const RiskCircleProgress({
    Key? key,
    required this.riskPercentage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer grey circle
          Container(
            width: 210,
            height: 210,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  spreadRadius: 5,
                ),
              ],
            ),
          ),
          
          // Progress indicator
          SizedBox(
            width: 180,
            height: 180,
            child: CustomPaint(
              painter: _CircleProgressPainter(
                progress: riskPercentage / 100,
                progressColor: orangeColor,
                backgroundColor: const Color(0xFFE8E8E8),
                strokeWidth: 15,
              ),
            ),
          ),
          
          // Center content
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'You Got',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Stroke Risk',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '$riskPercentage%',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: riskPercentage < 30
                      ? Colors.green
                      : riskPercentage < 70
                          ? orangeColor
                          : Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CircleProgressPainter extends CustomPainter {
  final double progress;
  final Color progressColor;
  final Color backgroundColor;
  final double strokeWidth;

  _CircleProgressPainter({
    required this.progress,
    required this.progressColor,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    
    // Background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
      
    canvas.drawCircle(center, radius, backgroundPaint);
    
    // Progress arc
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
      
    final progressRect = Rect.fromCircle(center: center, radius: radius);
    
    // Draw the progress arc (-90 degrees to start from the top)
    canvas.drawArc(
      progressRect,
      -math.pi / 2,  // Start at the top
      2 * math.pi * progress,  // Progress angle
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircleProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}