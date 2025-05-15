import 'package:flutter/material.dart';
import 'package:frontend/shared/navbar.dart';
import 'package:frontend/ui/widgets/activites/overview_activites/activity_header.dart';
import 'package:frontend/ui/widgets/activites/overview_activites/history_activity_section.dart';
import 'package:frontend/ui/widgets/activites/overview_activites/redeem_point_section.dart';
import 'package:frontend/ui/widgets/activites/overview_activites/today_activity_section.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({Key? key}) : super(key: key);

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF7F7F7),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                // Header component
                ActivityHeader(),
                SizedBox(height: 24),
                // Today's activity component
                TodayActivitySection(),
                SizedBox(height: 24),
                // Redeem points component
                RedeemPointsSection(),
                SizedBox(height: 24),
                // History activities component
                HistoryActivitiesSection(),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomNavBar(initialIndex: 1),
    );
  }
}