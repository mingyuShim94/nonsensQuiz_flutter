import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'coins_provider.g.dart';

@Riverpod(keepAlive: true)
class Coins extends _$Coins {
  static const _coinsKey = 'user_coins';
  late SharedPreferences _prefs;

  @override
  Future<int> build() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs.getInt(_coinsKey) ?? 100; // 초기 코인 100개
  }

  Future<bool> spendCoins(int amount) async {
    final currentState = await future;

    if (currentState >= amount) {
      final newAmount = currentState - amount;
      await _prefs.setInt(_coinsKey, newAmount);
      state = AsyncData(newAmount);
      return true;
    }
    return false;
  }

  Future<void> resetCoins() async {
    await _prefs.remove(_coinsKey);
    state = const AsyncData(100); // 초기 코인으로 리셋
  }

  Future<void> addCoins(int amount) async {
    try {
      final currentCoins = await future;
      final newAmount = currentCoins + amount;
      await _prefs.setInt(_coinsKey, newAmount);
      state = AsyncData(newAmount);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
