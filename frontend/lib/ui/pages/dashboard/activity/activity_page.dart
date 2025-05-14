import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:frontend/ui/pages/dashboard/activity/reedem_items.dart';
import 'package:frontend/ui/pages/order/orderdetail_page.dart';
import 'package:intl/intl.dart';
import 'package:frontend/shared/theme.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({Key? key}) : super(key: key);

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                // Header tanpa AppBar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: blueColor.withOpacity(0.2),
                          child: Image.asset('assets/icn_user.png', height: 24),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'User',
                              style: blackTextStyle.copyWith(fontWeight: semiBold, fontSize: 16),
                            ),
                            Row(
                              children: [
                                Text(
                                  '10,206',
                                  style: orangeTextStyle.copyWith(fontWeight: semiBold, fontSize: 16),
                                ),
                                Text(
                                  ' SIGAP Points',
                                  style: blackTextStyle.copyWith(fontWeight: medium, fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.menu, color: blackColor),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildTodayActivitySection(),
                const SizedBox(height: 24),
                _buildRedeemPointsSection(),
                const SizedBox(height: 24),
                _buildHistoryActivitiesSection(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTodayActivitySection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "TODAY'S ACTIVITY",
        style: blackTextStyle.copyWith(fontWeight: semiBold, fontSize: 14),
      ),
      const SizedBox(height: 12),
      Container(
        height: 240,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage('assets/bg_chart.png'), // Ganti dengan path gambar Anda
            fit: BoxFit.cover, // Menyesuaikan gambar agar pas dengan kontainer
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
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Steps',
                          style: blackTextStyle.copyWith(
                            fontSize: 18,
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

  Widget _buildRedeemPointsSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Redeem ',
                    style: blackTextStyle.copyWith(
                      fontWeight: medium, 
                      fontSize: 16
                    ),
                  ),
                  TextSpan(
                    text: 'Points',
                    style: blackTextStyle.copyWith(
                      fontWeight: bold,
                      fontSize: 16
                    ),
                  ),
                ],
              ),
            ),
            Text(
              'see more',
              style: orangeTextStyle.copyWith(
                fontWeight: medium,
                fontSize: 16
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      SizedBox(
        height: 280,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            _buildRedeemItem(
              'Tumblr',
              'always hydrate with a',
              'tumbler',
              3206,
              'assets/tumblr.png',
              orangeColor
            ),
            const SizedBox(width: 12),
            _buildRedeemItem(
              'Running Shoes',
              'get a comfortable run with',
              'shoe',
              3206,
              'assets/shoe.png',
              orangeColor
            ),
            const SizedBox(width: 12),
            _buildRedeemItem(
              'Sports',
              'always comfortable with a',
              's',
              3206,
              'assets/shoe.png',
              orangeColor
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _buildRedeemItem(
  String title,
  String description,
  String itemType,
  int coins,
  String imagePath,
  Color brandColor,
) {
  return Container(
    width: 220,
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(24),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image section
        Container(
          height: 139,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xFFDADADA),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Center(
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
              height: 190,
              errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported, size: 40, color: Colors.grey.shade400),
            ),
          ),
        ),
        // Content section
        Container(
          padding: const EdgeInsets.only(left: 12, right: 12, bottom: 6, top: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row: Title & Coin
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'SIGAP ',
                            style: orangeTextStyle.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          TextSpan(
                            text: 'Tumblr',
                            style: blackTextStyle.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Coin
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '3,206',
                        style: orangeTextStyle.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Coins',
                        style: blackTextStyle.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 6),
              // Description
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'always hydrate with a\n',
                      style: blackTextStyle.copyWith(
                        fontSize: 12,
                        color: Colors.black, 
                      )
                    ),
                    TextSpan(
                      text: 'SIGAP ',
                      style: orangeTextStyle.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    TextSpan(
                      text: 'tumbler',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              // const SizedBox(height: 2),
              // Redeem button
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () {
                         Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RedeemItemDetailPage(
                          imagePath: imagePath,
                          itemName: title, // Use dynamic item name
                          coinAmount: coins.toString(), // Use dynamic coin amount
                          redeemedInfo: description, // Pass description as info
                          description: description, // Pass description
                        ),
                      ),
                    );
                      },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 1,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Redeem',
                    style: blackTextStyle.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}

  Widget _buildHistoryActivitiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('HISTORY ACTIVITIES', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildHistoryItem('YESTERDAY','Running',4.5,45,'Morning Routine',6028,orangeColor),
            _buildHistoryItem('FRIDAY','Running',4.5,45,'Morning Routine',6028,Colors.white),
            _buildHistoryItem('YESTERDAY','YOGA',0,45,'YOGA TIME...',6028,Colors.white),
            _buildHistoryItem('YESTERDAY','Running',4.5,45,'Morning Routine',6028,orangeColor),
          ],
        ),
      ],
    );
  }

  Widget _buildHistoryItem(String day, String activity, double distance, int duration, String title, int steps, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: bgColor == Colors.white ? Border.all(color: Colors.grey.shade300) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(day, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: bgColor == Colors.white ? Colors.black : Colors.white)),
              if (activity != 'YOGA') Text('$distance km', style: TextStyle(fontSize: 10, color: bgColor == Colors.white ? Colors.black : Colors.white)),
            ],
          ),
          const SizedBox(height: 4),
          Container(height: 4, decoration: BoxDecoration(color: bgColor == Colors.white ? Colors.orange : Colors.white, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 4),
          Text(activity, style: TextStyle(fontSize: 10, color: bgColor == Colors.white ? Colors.black : Colors.white)),
          const Spacer(),
          Text('$duration min', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: bgColor == Colors.white ? Colors.black : Colors.white)),
          Text(title, style: TextStyle(fontSize: 14, color: bgColor == Colors.white ? Colors.black : Colors.white)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$steps', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: bgColor == Colors.white ? Colors.black : Colors.white)),
              Row(children: [Icon(Icons.monetization_on, size: 12, color: bgColor == Colors.white ? Colors.amber : Colors.white), const SizedBox(width: 2), Text('+$steps', style: TextStyle(fontSize: 10, color: bgColor == Colors.white ? Colors.orange : Colors.white))]),
            ],
          ),
          Text('steps', style: TextStyle(fontSize: 10, color: bgColor == Colors.white ? Colors.black : Colors.white)),
        ],
      ),
    );
  }
}
