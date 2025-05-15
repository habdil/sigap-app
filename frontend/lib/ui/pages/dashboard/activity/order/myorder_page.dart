import 'package:flutter/material.dart';
import 'package:frontend/ui/pages/dashboard/activity/order/checkout_page.dart';
import 'package:frontend/ui/pages/dashboard/activity/order/orderdetail_page.dart';
import 'package:frontend/ui/widgets/activites/order/custom_app_bar.dart';
import 'package:frontend/ui/widgets/activites/order/empty_order_message.dart';
import 'package:frontend/ui/widgets/activites/order/order_card.dart';
import 'package:frontend/ui/widgets/activites/order/order_tab.dart'; // Add this import

class MyOrderPage extends StatefulWidget {
  const MyOrderPage({Key? key}) : super(key: key);

  @override
  State<MyOrderPage> createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<MyOrderPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Column(
          children: [
            // Custom AppBar
            CustomAppBar(
              title: "My Orders",
              onBackPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const CheckoutPage()),
                );
              },
            ),
            // Tab Bar
            OrderTabs(tabController: _tabController),
            // TabBarView
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Processing Tab
                  ListView(
                    children: [
                      OrderCard(
                        productImagePath: "assets/tumblr.png",
                        brandName: "SIGAP",
                        productName: "Tumblr",
                        quantity: "1",
                        price: "3,206",
                        onDetailPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrderDetailPage()),
                          );
                        },
                      ),
                    ],
                  ),
                  // Shipped Tab
                  const EmptyOrdersMessage(message: "No shipped orders yet."),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
