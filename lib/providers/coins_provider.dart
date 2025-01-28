import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'coins_provider.g.dart';

@riverpod
class Coins extends _$Coins {
  @override
  AsyncValue<int> build() {
    return const AsyncValue.data(10); // 초기 코인 10개
  }

  void spendCoins(int amount) {
    final currentCoins = state.value ?? 0;
    if (currentCoins >= amount) {
      state = AsyncValue.data(currentCoins - amount);
    }
  }
}
