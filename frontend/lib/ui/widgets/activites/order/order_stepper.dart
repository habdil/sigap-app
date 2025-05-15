import 'package:flutter/material.dart';

class OrderStepper extends StatelessWidget {
  final bool isFirstStepActive;
  final bool isSecondStepActive;

  const OrderStepper({
    this.isFirstStepActive = false,
    this.isSecondStepActive = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Step 1 (Set address)
          CircleAvatar(
            radius: 12,
            backgroundColor:
                isFirstStepActive ? const Color(0xFF1ABC9C) : Colors.grey[300],
            child: Text(
              "1",
              style: TextStyle(
                color: isFirstStepActive ? Colors.white : Colors.black54,
                fontSize: 12,
                fontWeight:
                    isFirstStepActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            "Set address",
            style: TextStyle(
              fontSize: 14,
              color:
                  isFirstStepActive ? const Color(0xFF1ABC9C) : Colors.black54,
              fontWeight:
                  isFirstStepActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, size: 18),
          const SizedBox(width: 8),
          // Step 2 (Confirm Order)
          CircleAvatar(
            radius: 12,
            backgroundColor:
                isSecondStepActive ? const Color(0xFF1ABC9C) : Colors.grey[300],
            child: Text(
              "2",
              style: TextStyle(
                color: isSecondStepActive ? Colors.white : Colors.black54,
                fontSize: 12,
                fontWeight:
                    isSecondStepActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            "Confirm Order",
            style: TextStyle(
              fontSize: 14,
              color:
                  isSecondStepActive ? const Color(0xFF1ABC9C) : Colors.black54,
              fontWeight:
                  isSecondStepActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
