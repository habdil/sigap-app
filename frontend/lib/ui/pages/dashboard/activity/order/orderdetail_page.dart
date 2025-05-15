import 'package:flutter/material.dart';
import 'package:frontend/ui/pages/dashboard/activity/order/myorder_page.dart';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({Key? key}) : super(key: key);

  Widget _buildStatusStep({
    required String title,
    required String description,
    required bool isFirst,
    required bool isLast,
    required bool isActive,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFFF5722),
                  width: 3,
                ),
                color: Colors.white,
              ),
              child: isActive
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFF5722),
                        ),
                      ),
                    )
                  : null,
            ),
            if (!isLast)
              Container(
                width: 3,
                height: 48,
                color: const Color(0xFFFF5722),
              ),
          ],
        ),
        const SizedBox(width: 16),
        // Step content
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
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
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // AppBar
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
                          MaterialPageRoute(builder: (context) => const MyOrderPage()),
                        );
                      },
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          "Order detail",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48), // Balance the layout
                  ],
                ),
              ),
              // Address Section
              Container(
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
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "User",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Jl. Sunan Giri, RT.05/RW.13, Candi Winangun, Sardonoharjo, Kec. Ngaglik, Kabupaten Sleman, Daerah Istimewa Yogyakarta 55581",
                            style: TextStyle(
                              color: Colors.black87,
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
              const SizedBox(height: 8),
              // Item Detail Section
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "item Detail",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Image
                        Container(
                          width: 110,
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
                              Row(
                                children: const [
                                  Expanded(
                                    child: Text(
                                      "Tumblr",
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  Icon(Icons.monetization_on, color: Color(0xFFFF5722), size: 18),
                                  SizedBox(width: 2),
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
                              Row(
                                children: const [
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
                              Row(
                                children: [
                                  const Text(
                                    "SIGAP ",
                                    style: TextStyle(
                                      color: Color(0xFFFF5722),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const Text(
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
                              Row(
                                children: const [
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
                              Row(
                                children: const [
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
                              Row(
                                children: const [
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Subtotal",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.monetization_on, color: Color(0xFFFF5722), size: 18),
                            SizedBox(width: 2),
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
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Status Order Section
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Status Order",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 18),
                    // Timeline
                    _buildStatusStep(
                      title: "Your order has arrived",
                      description: "The courier has delivered the package right at your doorstep.",
                      isFirst: true,
                      isLast: false,
                      isActive: true,
                    ),
                    _buildStatusStep(
                      title: "Your order is heading to your country",
                      description: "the package is in transit to the destination country (your country)",
                      isFirst: false,
                      isLast: false,
                      isActive: false,
                    ),
                    _buildStatusStep(
                      title: "Your order is ready to be delivered",
                      description: "package has been packed and ready to be sent, waiting for shipping services",
                      isFirst: false,
                      isLast: false,
                      isActive: false,
                    ),
                    _buildStatusStep(
                      title: "Your package is being prepared",
                      description: "your order has been confirmed and is being packed, waiting for package queue",
                      isFirst: false,
                      isLast: true,
                      isActive: false,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}