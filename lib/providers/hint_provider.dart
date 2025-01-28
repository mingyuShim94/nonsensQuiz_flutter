import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hint_provider.g.dart';

@riverpod
class HintState extends _$HintState {
  @override
  Map<String, Set<int>> build() {
    return {};
  }

  bool isHintUsed(String quizId, int hintIndex) {
    return state[quizId]?.contains(hintIndex) ?? false;
  }

  List<bool> getUsedHints(String quizId) {
    final usedHints = state[quizId] ?? {};
    return List.generate(3, (index) => usedHints.contains(index));
  }

  void useHint(String quizId, int hintIndex) {
    final usedHints = state[quizId] ?? {};
    usedHints.add(hintIndex);
    state = {...state, quizId: usedHints};
  }
}
