import 'package:flutter/material.dart';
import 'package:frontend/ui/pages/dashboard/activity/order/checkout_page.dart';
import 'package:frontend/ui/pages/dashboard/activity/order/setaddress_page.dart';
import 'package:frontend/ui/widgets/activites/order/address_section_fill.dart';
import 'package:frontend/ui/widgets/activites/order/custom_header.dart';
import 'package:frontend/ui/widgets/activites/order/order_stepper.dart';
import 'package:frontend/ui/widgets/activites/order/privacy_policy_text.dart';
import 'package:frontend/ui/widgets/activites/order/save_button.dart';
import 'package:frontend/ui/widgets/activites/order/section_divider.dart'; // Change import

class FillAddressPage extends StatelessWidget {
  const FillAddressPage({Key? key}) : super(key: key);

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
                  MaterialPageRoute(builder: (context) => SetAddressPage()),
                );
              },
            ),
            const OrderStepper(
              isFirstStepActive: true,
              isSecondStepActive: false,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const AddressSectionFill(
                      icon: Icons.location_on_outlined,
                      label: "User",
                      value:
                          "Jl. Sunan Giri, RT.05/RW.13, Candi Winangun, Sardonoharjo, Kec.\nNgaglik, Kabupaten Sleman, Daerah Istimewa Yogyakarta 55581",
                    ),
                    // Divider
                    const SectionDivider(),
                    // City Section
                    const AddressSectionFill(
                      icon: Icons.location_on_outlined,
                      label: "CITY",
                      value: "YOGYAKARTA",
                    ),
                    const SectionDivider(),
                    // Region Section
                    const AddressSectionFill(
                      icon: Icons.location_on_outlined,
                      label: "REGION",
                      value: "INDONESIA",
                    ),
                    const SectionDivider(),
                    // Contact Section
                    const AddressSectionFill(
                      icon: Icons.person_outline,
                      label: "SIGAP Official",
                      value: "+62 8722-1092-8752",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: const Color(0xFFF6F6F6),
        padding: EdgeInsets.fromLTRB(
            24, 16, 24, MediaQuery.of(context).padding.bottom + 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const PrivacyPolicyText(),
            const SizedBox(height: 16),
            SaveButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => CheckoutPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
