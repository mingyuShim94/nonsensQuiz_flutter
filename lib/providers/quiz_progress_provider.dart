import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'quiz_progress_provider.g.dart';

@Riverpod(keepAlive: true)
class QuizProgress extends _$QuizProgress {
  static const _progressKey = 'quiz_progress';
  late SharedPreferences _prefs;

  @override
  Map<String, Set<String>> build() {
    _initPrefs();
    return {};
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    final savedProgress = _prefs.getStringList(_progressKey) ?? [];

    final progressMap = <String, Set<String>>{};
    for (final progress in savedProgress) {
      final parts = progress.split(':');
      if (parts.length == 2) {
        final styleId = parts[0];
        final quizId = parts[1];
        progressMap.putIfAbsent(styleId, () => {}).add(quizId);
      }
    }

    state = progressMap;
  }

  Future<void> _saveProgress() async {
    final progressList = <String>[];
    state.forEach((styleId, quizIds) {
      for (final quizId in quizIds) {
        progressList.add('$styleId:$quizId');
      }
    });
    await _prefs.setStringList(_progressKey, progressList);
  }

  bool isQuizCompleted(String styleId, String quizId) {
    return state[styleId]?.contains(quizId) ?? false;
  }

  Future<void> completeQuiz(String styleId, String quizId) async {
    final newState = Map<String, Set<String>>.from(state);
    newState.putIfAbsent(styleId, () => {}).add(quizId);
    state = newState;
    await _saveProgress();
  }

  Future<void> resetProgress() async {
    await _prefs.remove(_progressKey);
    state = {};
  }
}
