import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:frontend/shared/theme.dart';

/// Today's activity section with chart and step count
class TodayActivitySection extends StatelessWidget {
  const TodayActivitySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsiveness
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "TODAY'S ACTIVITY",
          style: blackTextStyle.copyWith(fontWeight: semiBold, fontSize: 14),
        ),
        const SizedBox(height: 12),
        Container(
          height: isSmallScreen ? 220 : 240,
          padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: AssetImage('assets/bg_chart.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('5 Dec 2025', style: blackTextStyle.copyWith(fontWeight: medium)),
                  Text('10:48', style: blackTextStyle.copyWith(fontWeight: medium)),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          const FlSpot(0, 2),
                          const FlSpot(1, 5),
                          const FlSpot(2, 1),
                          const FlSpot(3, 3),
                          const FlSpot(4, 1),
                          const FlSpot(5, 4),
                          const FlSpot(6, 5),
                        ],
                        isCurved: true,
                        color: orangeColor,
                        barWidth: 3,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 6,
                              color: Colors.white,
                              strokeWidth: 2,
                              strokeColor: orangeColor,
                            );
                          },
                          checkToShowDot: (spot, barData) {
                            // Only show dot on the last point
                            return spot.x == 6;
                          },
                        ),
                        belowBarData: BarAreaData(show: true, color: Colors.transparent),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '6028',
                            style: blackTextStyle.copyWith(
                              fontSize: isSmallScreen ? 28 : 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Steps',
                            style: blackTextStyle.copyWith(
                              fontSize: isSmallScreen ? 16 : 18,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            '5,402 m',
                            style: blackTextStyle.copyWith(fontSize: 12, fontWeight: medium),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text('|', style: blackTextStyle.copyWith(fontSize: 12)),
                          ),
                          Text(
                            '508 Kcal',
                            style: blackTextStyle.copyWith(fontSize: 12, fontWeight: medium),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '+1 Coin/step',
                        style: blackTextStyle.copyWith(fontSize: 12, fontWeight: medium),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.monetization_on, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '+6028 Coin',
                            style: orangeTextStyle.copyWith(
                              fontWeight: semiBold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}