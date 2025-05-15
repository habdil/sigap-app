import 'package:flutter/material.dart';
import 'package:frontend/ui/widgets/activites/order/shipping_option.dart';

class ShippingSection extends StatelessWidget {
  final int selectedShipping;
  final Function(int) onShippingSelected;

  const ShippingSection({
    required this.selectedShipping,
    required this.onShippingSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                ShippingOption(
                  isSelected: selectedShipping == 0,
                  title: "Standard Shipping",
                  delivery: "Delivery: Apr 21-25",
                  cost: "FREE",
                  costColor: const Color(0xFF1ABC9C),
                  onTap: () => onShippingSelected(0),
                ),
                const SizedBox(width: 16),
                ShippingOption(
                  isSelected: selectedShipping == 1,
                  title: "Instant Shipping",
                  delivery: "Delivery: Apr 20-21",
                  cost: "30.0 Points",
                  costColor: Colors.grey,
                  onTap: () => onShippingSelected(1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
