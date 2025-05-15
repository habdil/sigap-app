import 'package:flutter/material.dart';
import 'package:frontend/ui/pages/order/checkout_page.dart';
import 'package:frontend/ui/pages/order/setaddress_page.dart'; // Change import

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
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SetAddressPage()),
                      );
                    },
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Confirm Your Order",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            // Stepper
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Color(0xFFEEEEEE)),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Step 1 (Set address - active)
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: const Color(0xFF1ABC9C),
                    child: const Text(
                      "1",
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Set address",
                    style: TextStyle(fontSize: 14, color: Color(0xFF1ABC9C), fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right, size: 18),
                  const SizedBox(width: 8),
                  // Step 2 (Confirm Order - inactive)
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: Color(0xFFE0E0E0),
                    child: const Text(
                      "2",
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Confirm Order",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Address Section
                    _AddressSection(
                      icon: Icons.location_on_outlined,
                      label: "User",
                      value:
                          "Jl. Sunan Giri, RT.05/RW.13, Candi Winangun, Sardonoharjo, Kec.\nNgaglik, Kabupaten Sleman, Daerah Istimewa Yogyakarta 55581",
                    ),
                    // Divider
                    _SectionDivider(),
                    // City Section
                    _AddressSection(
                      icon: Icons.location_on_outlined,
                      label: "CITY",
                      value: "YOGYAKARTA",
                    ),
                    _SectionDivider(),
                    // Region Section
                    _AddressSection(
                      icon: Icons.location_on_outlined,
                      label: "REGION",
                      value: "INDONESIA",
                    ),
                    _SectionDivider(),
                    // Contact Section
                    _AddressSection(
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
        padding: EdgeInsets.fromLTRB(24, 16, 24, MediaQuery.of(context).padding.bottom + 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 13,
                  height: 1.5,
                ),
                children: [
                  TextSpan(text: "By continuing you, you agree to the "),
                  TextSpan(
                    text: "Privacy Policy",
                    style: TextStyle(
                      color: Color(0xFFFF5722),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: " and "),
                  TextSpan(
                    text: "Terms of Use",
                    style: TextStyle(
                      color: Color(0xFFFF5722),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => CheckoutPage()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFFFF5722)),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  elevation: MaterialStateProperty.all(0),
                ),
                child: const Text(
                  "Save Information",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddressSection extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _AddressSection({
    required this.icon,
    required this.label,
    required this.value,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3F0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: const Color(0xFFFF5722),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 0,
      thickness: 8,
      color: Color(0xFFF8F8F8),
    );
  }
}