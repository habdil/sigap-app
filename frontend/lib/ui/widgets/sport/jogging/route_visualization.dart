import 'package:flutter/material.dart';

class RouteVisualization extends StatelessWidget {
  const RouteVisualization({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Center(
        child: SizedBox(
          height: 150,
          width: 150,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Base circle
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
              ),
              
              // Try loading asset with error handling
              Image.asset(
                'assets/sport_jogging/ic_petunjukArah.png',
                width: 500,
                height: 500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}