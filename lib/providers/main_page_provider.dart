import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nonsense_quiz/models/style.dart';
import 'package:nonsense_quiz/repositories/style_repository.dart';
import 'package:nonsense_quiz/repositories/user_repository.dart';
import 'package:nonsense_quiz/providers/quiz_progress_provider.dart';
import 'package:nonsense_quiz/config/quiz_config.dart';
import 'package:nonsense_quiz/data/quiz_data.dart';

final styleListProvider = FutureProvider<List<Style>>((ref) async {
  final styleRepository = ref.read(styleRepositoryProvider);
  final styles = await styleRepository.getStyles();
  final progress = ref.watch(quizProgressProvider);

  // 각 스타일의 진행도 계산
  return styles.map((style) {
    final styleId = 'style_${style.id.padLeft(2, '0')}';
    final completedQuizzes = progress[styleId]?.length ?? 0;
    final maxQuizCount = QuizData.getQuizCount(style.id);
    final progressPercent = (completedQuizzes * 100 ~/ maxQuizCount);

    return style.copyWith(progress: progressPercent);
  }).toList();
});

final starsProvider = Provider<AsyncValue<int>>((ref) {
  final progress = ref.watch(quizProgressProvider);
  int totalStars = 0;

  progress.forEach((_, quizIds) {
    totalStars += quizIds.length;
  });

  return AsyncValue.data(totalStars);
});
