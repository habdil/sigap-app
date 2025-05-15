import 'package:flutter/material.dart';

class SectionDivider extends StatelessWidget {
  const SectionDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 0,
      thickness: 8,
      color: Color(0xFFF8F8F8),
    );
  }
}
