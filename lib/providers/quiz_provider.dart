import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nonsense_quiz/models/quiz.dart';
import 'package:flutter/services.dart';
import 'package:nonsense_quiz/data/quiz_data.dart';
import 'package:nonsense_quiz/providers/coins_provider.dart';
import 'package:nonsense_quiz/providers/hint_provider.dart';

final currentQuizProvider =
    FutureProvider.family<Quiz, ({String styleId, String quizId})>(
        (ref, params) async {
  return Quiz(
    id: params.quizId,
    question: '퀴즈 질문',
    answer: QuizData.getAnswer(params.styleId, params.quizId) ?? '',
    imageUrl: 'assets/images/quiz/${params.styleId}/${params.quizId}.png',
    hints: ['힌트1', '힌트2', '힌트3'],
    orderIndex: int.parse(params.quizId),
  );
});

final quizControllerProvider =
    StateNotifierProvider<QuizController, AsyncValue<void>>((ref) {
  return QuizController(ref);
});

class QuizController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  QuizController(this.ref) : super(const AsyncValue.data(null));

  Future<void> submitAnswer(
      String answer, String styleId, String quizId) async {
    try {
      state = const AsyncValue.loading();

      final correctAnswer = QuizData.getAnswer(styleId, quizId);
      final isCorrect = answer.trim() == correctAnswer?.trim();

      if (isCorrect) {
        HapticFeedback.mediumImpact();
        // 정답 처리 로직
      } else {
        HapticFeedback.heavyImpact();
        // 오답 처리 로직
      }

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<bool> useHint(String styleId, String quizId, int hintIndex) async {
    try {
      state = const AsyncValue.loading();

      // 나머지 힌트는 코인 소비
      final currentCoins = ref.read(coinsProvider).value ?? 0;
      final costs = [4, 6, 10]; // 각 힌트별 비용 (글자수 힌트 제거)
      final cost = costs[hintIndex];

      if (currentCoins < cost) {
        return false;
      }

      // 힌트 사용 처리
      ref
          .read(hintStateProvider.notifier)
          .useHint('$styleId/$quizId', hintIndex);

      // 코인 차감
      ref.read(coinsProvider.notifier).spendCoins(cost);

      state = const AsyncValue.data(null);
      return true;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return false;
    }
  }

  Future<void> skipQuiz() async {
    // 퀴즈 건너뛰기 로직 구현
  }
}
