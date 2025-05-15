import 'package:flutter/material.dart';
import 'package:frontend/ui/widgets/activites/order/status_step.dart';

class StatusOrderSection extends StatelessWidget {
  const StatusOrderSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Status Order",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 18),
          // Timeline
          StatusStep(
            title: "Your order has arrived",
            description:
                "The courier has delivered the package right at your doorstep.",
            isFirst: true,
            isLast: false,
            isActive: true,
          ),
          StatusStep(
            title: "Your order is heading to your country",
            description:
                "the package is in transit to the destination country (your country)",
            isFirst: false,
            isLast: false,
            isActive: false,
          ),
          StatusStep(
            title: "Your order is ready to be delivered",
            description:
                "package has been packed and ready to be sent, waiting for shipping services",
            isFirst: false,
            isLast: false,
            isActive: false,
          ),
          StatusStep(
            title: "Your package is being prepared",
            description:
                "your order has been confirmed and is being packed, waiting for package queue",
            isFirst: false,
            isLast: true,
            isActive: false,
          ),
        ],
      ),
    );
  }
}
