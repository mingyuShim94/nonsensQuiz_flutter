import 'package:flutter/material.dart';
import 'package:nonsense_quiz/widgets/quiz/image/image_error_placeholder.dart';

class QuizImageContainer extends StatelessWidget {
  final String imageUrl;

  const QuizImageContainer({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        // 더블 탭 시 이미지 확대/축소 로직
      },
      child: InteractiveViewer(
        minScale: 1.0,
        maxScale: 3.0,
        child: AspectRatio(
          aspectRatio: 1.0,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            child: Image.asset(
              imageUrl,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const ImageErrorPlaceholder(),
            ),
          ),
        ),
      ),
    );
  }
}
