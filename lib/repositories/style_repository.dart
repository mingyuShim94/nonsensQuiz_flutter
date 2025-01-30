import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nonsense_quiz/models/style.dart';

final styleRepositoryProvider = Provider<StyleRepository>((ref) {
  return StyleRepository();
});

class StyleRepository {
  Future<List<Style>> getStyles() async {
    // 각 스타일에 맞는 thumbnailPath 설정
    return [
      const Style(
        id: '1',
        name: '레벨 1',
        thumbnailPath: 'assets/images/quiz/style_01/001.png',
        requiredStars: 0,
      ),
      const Style(
        id: '2',
        name: '레벨 2',
        thumbnailPath: 'assets/images/quiz/style_02/001.png',
        requiredStars: 5,
      ),
      const Style(
        id: '3',
        name: '레벨 3',
        thumbnailPath: 'assets/images/quiz/style_03/001.png',
        requiredStars: 10,
      ),
      // 필요한 만큼 더 많은 스타일 추가
    ];
  }
}
