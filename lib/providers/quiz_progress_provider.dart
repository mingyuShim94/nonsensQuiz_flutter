import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quiz_progress_provider.g.dart';

@riverpod
class QuizProgress extends _$QuizProgress {
  @override
  Map<String, Set<String>> build() {
    // styleId를 key로, 완료된 quizId Set을 value로 가지는 Map
    return {};
  }

  void completeQuiz(String styleId, String quizId) {
    final completedQuizzes = state[styleId] ?? {};
    completedQuizzes.add(quizId);
    state = {...state, styleId: completedQuizzes};
  }

  bool isQuizCompleted(String styleId, String quizId) {
    return state[styleId]?.contains(quizId) ?? false;
  }
}
