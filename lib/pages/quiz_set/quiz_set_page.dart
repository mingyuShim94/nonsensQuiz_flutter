import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nonsense_quiz/data/quiz_data.dart';
import 'package:nonsense_quiz/providers/quiz_progress_provider.dart';
import 'package:nonsense_quiz/config/quiz_config.dart';

class QuizSetPage extends ConsumerWidget {
  final String styleId;

  const QuizSetPage({
    super.key,
    required this.styleId,
  });

  String _getFormattedStyleId(String id) {
    return 'style_${id.padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final formattedStyleId = _getFormattedStyleId(styleId);
    final maxQuizCount = QuizData.getQuizCount(styleId);
    final quizProgress = ref.watch(quizProgressProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text('퀴즈 세트 $styleId'),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              itemCount: maxQuizCount,
              itemBuilder: (context, index) {
                final quizId = (index + 1).toString().padLeft(3, '0');
                final isCompleted = ref
                    .read(quizProgressProvider.notifier)
                    .isQuizCompleted(formattedStyleId, quizId);

                return InkWell(
                  onTap: () => context.push('/quiz/$formattedStyleId/$quizId'),
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: isCompleted
                        ? Image.asset(
                            'assets/images/quiz/$formattedStyleId/$quizId.png',
                            fit: BoxFit.cover,
                          )
                        : const Icon(
                            Icons.lock,
                            color: Colors.grey,
                            size: 32,
                          ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
