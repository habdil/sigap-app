import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final VoidCallback onBackPressed;

  const CustomAppBar({
    required this.title,
    required this.onBackPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: onBackPressed,
          ),
          Expanded(
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(width: 48), // To balance the layout
        ],
      ),
    );
  }
}
