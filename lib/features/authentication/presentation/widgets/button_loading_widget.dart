import 'package:flutter/material.dart';
import 'package:movie_app/core/widgets/loading_widget.dart';

class ButtonLoadingWidget extends StatelessWidget {
  final bool isLoading;
  final String text;
  final VoidCallback onPressed;

  const ButtonLoadingWidget({
    super.key,
    required this.isLoading,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading ? const LoadingWidget() : Text(text),
    );
  }
}
