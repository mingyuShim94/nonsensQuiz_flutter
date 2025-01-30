import 'package:flutter/material.dart';
import 'package:nonsense_quiz/data/quiz_data.dart';
import 'package:nonsense_quiz/models/style.dart';
import 'package:go_router/go_router.dart';

class StyleListItem extends StatelessWidget {
  final Style style;
  final int stars;

  const StyleListItem({super.key, required this.style, required this.stars});

  bool get isLocked => stars < style.requiredStars;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        // 레벨 이미지
        leading: Image.asset(
          style.thumbnailPath,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                style.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            if (isLocked)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: const Icon(Icons.lock),
              ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8, right: 8),
          child: _buildProgressIndicator(context),
        ),
        onTap: isLocked ? null : () => context.push('/quiz-set/${style.id}'),
      ),
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      height: 24,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          if (!isLocked) ...[
            FractionallySizedBox(
              widthFactor: style.progress / 100,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            //퀴즈 진행도: 퀴즈 수 / 최대 퀴즈 수
            Center(
              child: Text(
                '${(style.progress * QuizData.getQuizCount(style.id) / 100).round()}'
                ' / ${QuizData.getQuizCount(style.id)}',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ] else
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('⭐ '),
                  Text(
                    '${style.requiredStars}개 필요',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
