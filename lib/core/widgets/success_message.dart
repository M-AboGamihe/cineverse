import 'package:flutter/material.dart';

class SuccessMessage extends StatelessWidget {
  final String message;

  const SuccessMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message, style: const TextStyle(color: Colors.green)),
    );
  }
}
