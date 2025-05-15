import 'package:flutter/material.dart';

class EmptyOrdersMessage extends StatelessWidget {
  final String message;

  const EmptyOrdersMessage({
    this.message = "No orders yet.",
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: TextStyle(color: Colors.black54, fontSize: 16),
      ),
    );
  }
}
