import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  final String message;

  const EmptyWidget({super.key, this.message = "No data available"});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message, style: const TextStyle(fontSize: 16)));
  }
}
