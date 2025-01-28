import 'package:flutter/material.dart';

class QuizImage extends StatelessWidget {
  final String imageUrl;

  const QuizImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        imageUrl,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => const Icon(
          Icons.error_outline,
          size: 48,
          color: Colors.red,
        ),
      ),
    );
  }
}
