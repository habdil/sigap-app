import 'package:flutter/material.dart';
import 'package:frontend/ui/pages/dashboard/activity/order/myorder_page.dart';
import 'package:frontend/ui/widgets/activites/order/address_section_checkout.dart';
import 'package:frontend/ui/widgets/activites/order/address_section_fill.dart';
import 'package:frontend/ui/widgets/activites/order/custom_app_bar.dart';
import 'package:frontend/ui/widgets/activites/order/item_detail_section.dart';
import 'package:frontend/ui/widgets/activites/order/status_order_section.dart';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // AppBar
              CustomAppBar(
                title: "Order detail",
                onBackPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyOrderPage()),
                  );
                },
              ),
              // Address Section
              const AddressSectionCheckout(
                userName: "User",
                address:
                    "Jl. Sunan Giri, RT.05/RW.13, Candi Winangun, Sardonoharjo, Kec. Ngaglik, Kabupaten Sleman, Daerah Istimewa Yogyakarta 55581",
              ),
              const SizedBox(height: 8),
              // Item Detail Section
              const ItemDetailSection(
                imagePath: "assets/tumblr.png",
                productType: "Tumblr",
                price: "3,206",
                brandName: "SIGAP",
                productName: "Tumblr",
                color: "Green",
                size: "500mL",
                quantity: "1",
              ),
              const SizedBox(height: 12),
              // Status Order Section
              const StatusOrderSection(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
