import 'package:flutter/material.dart';

class OrderTabs extends StatelessWidget {
  final TabController tabController;

  const OrderTabs({
    required this.tabController,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: tabController,
        indicatorColor: const Color(0xFFFF5722),
        labelColor: Colors.black,
        unselectedLabelColor: Colors.black54,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        tabs: const [
          Tab(text: "Processing"),
          Tab(text: "Shipped"),
        ],
      ),
    );
  }
}
