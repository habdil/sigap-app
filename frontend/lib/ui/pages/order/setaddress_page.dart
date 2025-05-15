import 'package:flutter/material.dart';
import 'package:frontend/ui/pages/dashboard/sport/activity_page.dart';
import 'package:frontend/ui/pages/order/filladdress_page.dart';

class SetAddressPage extends StatefulWidget {
  const SetAddressPage({super.key});

  @override
  State<SetAddressPage> createState() => _SetAddressPageState();
}

class _SetAddressPageState extends State<SetAddressPage> {
  int selectedShipping = 0;

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
                        MaterialPageRoute(builder: (context) => const ActivityPage()),
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
                  const SizedBox(width: 48), // Balance the layout
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Stepper
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Step 1 (Set address - active)
                          const CircleAvatar(
                            radius: 12,
                            backgroundColor: Color(0xFF1ABC9C),
                            child: Text(
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
                            backgroundColor: Colors.grey[300],
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
                    // Address Section (empty)
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const FillAddressPage()),
                        );
                      },
                      child: Container(
                        color: Colors.white,
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
                              child: const Icon(
                                Icons.location_on_outlined,
                                color: Color(0xFFFF5722),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "User",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Fill your address here...",
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 13,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right, color: Colors.black54),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Item Detail Section
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Item Detail",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Product Image
                              Container(
                                width: 100,
                                height: 130,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDADADA),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Image.asset(
                                    "assets/tumblr.png",
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Product Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Tumblr",
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "3,206",
                                          style: TextStyle(
                                            color: Color(0xFFFF5722),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Row(
                                      children: [
                                        Spacer(),
                                        Text(
                                          "Coins",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    const Row(
                                      children: [
                                        Text(
                                          "SIGAP ",
                                          style: TextStyle(
                                            color: Color(0xFFFF5722),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          "Tumblr",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      height: 1,
                                      color: Colors.black26,
                                    ),
                                    const SizedBox(height: 8),
                                    const Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Color",
                                            style: TextStyle(fontSize: 14, color: Colors.black54),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "Green",
                                            style: TextStyle(fontSize: 14, color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Size",
                                            style: TextStyle(fontSize: 14, color: Colors.black54),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "500mL",
                                            style: TextStyle(fontSize: 14, color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Quantity",
                                            style: TextStyle(fontSize: 14, color: Colors.black54),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "1",
                                            style: TextStyle(fontSize: 14, color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Subtotal",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "3,206",
                                style: TextStyle(
                                  color: Color(0xFFFF5722),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          const Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "Coins",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Shipping Section
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Shipping",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildShippingOption(
                                  isSelected: selectedShipping == 0,
                                  title: "Standard Shipping",
                                  delivery: "Delivery: Apr 21-25",
                                  cost: "FREE",
                                  costColor: const Color(0xFF1ABC9C),
                                  onTap: () => setState(() => selectedShipping = 0),
                                ),
                                const SizedBox(width: 16),
                                _buildShippingOption(
                                  isSelected: selectedShipping == 1,
                                  title: "Instant Shipping",
                                  delivery: "Delivery: Apr 20-21",
                                  cost: "30.0 Points",
                                  costColor: Colors.grey,
                                  onTap: () => setState(() => selectedShipping = 1),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Policy
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(24),
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(color: Colors.black54, fontSize: 13, height: 1.5),
                          children: [
                            TextSpan(text: "By continuing, you agree to the "),
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
                    ),
                  ],
                ),
              ),
            ),
            // Submit Button
            Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(24, 16, 24, MediaQuery.of(context).padding.bottom + 16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implement your submit logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF5722), // Orange
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Submit Order",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShippingOption({
    required bool isSelected,
    required String title,
    required String delivery,
    required String cost,
    required Color costColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220, // Fixed width for horizontal card
        margin: const EdgeInsets.only(right: 8), // Optional: spacing between cards
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF1ABC9C) : Colors.grey[300]!,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Custom radio indicator
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? const Color(0xFF1ABC9C) : Colors.grey[300],
                border: Border.all(
                  color: isSelected ? const Color(0xFF1ABC9C) : Colors.grey[400]!,
                  width: 2,
                ),
              ),
              child: isSelected
                ? Center(
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  )
                : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    delivery,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    cost,
                    style: TextStyle(
                      color: costColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}