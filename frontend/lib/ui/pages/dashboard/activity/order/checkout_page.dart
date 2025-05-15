import 'package:flutter/material.dart';
import 'package:frontend/ui/pages/dashboard/sport/activity_page.dart';
import 'package:frontend/ui/pages/dashboard/activity/order/myorder_page.dart';
import 'package:frontend/ui/widgets/activites/order/address_section_checkout.dart';
import 'package:frontend/ui/widgets/activites/order/address_section_fill.dart';
import 'package:frontend/ui/widgets/activites/order/custom_header.dart';
import 'package:frontend/ui/widgets/activites/order/item_detail_section.dart';
import 'package:frontend/ui/widgets/activites/order/order_stepper.dart';
import 'package:frontend/ui/widgets/activites/order/privacy_policy_text.dart';
import 'package:frontend/ui/widgets/activites/order/shipping_section.dart';
import 'package:frontend/ui/widgets/activites/order/submit_button.dart'; // Add this import

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int selectedShipping = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header
            CustomHeader(
              title: "Confirm Your Order",
              onBackPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ActivityPage()),
                );
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Stepper
                    const OrderStepper(
                      isFirstStepActive: false,
                      isSecondStepActive: true,
                    ),
                    // const OrderStepper(
                    //   isFirstStepActive: false,
                    //   isSecondStepActive: true,
                    // ),
                    // Address Section
                    const AddressSectionCheckout(
                      userName: "User",
                      address:
                          "Jl. Sunan Giri, RT.05/RW.13, Candi Winangun, Sardonoharjo, Kec. Ngaglik, Kabupaten Sleman, Daerah Istimewa Yogyakarta 55581",
                      onTap: null,
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
                    const SizedBox(height: 8),
                    // Shipping Section
                    ShippingSection(
                      selectedShipping: selectedShipping,
                      onShippingSelected: (index) {
                        setState(() {
                          selectedShipping = index;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    // Policy
                    const PrivacyPolicyText(),
                  ],
                ),
              ),
            ),
            // Submit Button
            SubmitButton(
              text: "Submit Order",
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MyOrderPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
