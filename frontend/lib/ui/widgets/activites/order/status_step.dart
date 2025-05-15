import 'package:flutter/material.dart';

class StatusStep extends StatelessWidget {
  final String title;
  final String description;
  final bool isFirst;
  final bool isLast;
  final bool isActive;

  const StatusStep({
    required this.title,
    required this.description,
    required this.isFirst,
    required this.isLast,
    required this.isActive,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}
