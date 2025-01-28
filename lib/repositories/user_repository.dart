import 'package:flutter_riverpod/flutter_riverpod.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

class UserRepository {
  Future<int> getCoins() async {
    // 실제 코인 데이터를 가져오는 로직을 구현하세요.
    return 100; // 예시로 100 코인을 반환
  }

  Future<int> getStars() async {
    // 실제 별 데이터를 가져오는 로직을 구현하세요.
    return 10; // 예시로 10 별을 반환
  }
}
