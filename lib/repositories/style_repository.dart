import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nonsense_quiz/models/style.dart';

final styleRepositoryProvider = Provider<StyleRepository>((ref) {
  return StyleRepository();
});

class StyleRepository {
  Future<List<Style>> getStyles() async {
    // 각 스타일에 맞는 thumbnailPath 설정
    return [
      Style(
        id: '1',
        name: '화풍 1',
        thumbnailPath: 'assets/images/quiz/style_01/001.png',
        progress: 50,
      ),
      Style(
        id: '2',
        name: '화풍 2',
        thumbnailPath: 'assets/images/quiz/style_02/001.png',
        progress: 30,
      ),
      Style(
        id: '3',
        name: '화풍 3',
        thumbnailPath: 'assets/images/quiz/style_03/001.png',
        progress: 70,
      ),
      // 필요한 만큼 더 많은 스타일 추가
    ];
  }
}
