class QuizData {
  static const Map<String, Map<String, String>> answers = {
    'style_01': {
      '001': '다이소',
      '002': '삼계탕',
      '003': '사냥개',
      '004': '양말',
      '005': '좌약',
      '006': '다이아몬드',
      '007': '카놀라유',
      '008': '해리포터',
      '009': '우왕좌왕',
    },
    'style_02': {
      '001': '도서관',
      '002': '발명품',
      '003': '파노라마',
      '004': '소신발언',
      '005': '신세계',
      '006': '줄다리기',
      '007': '검사',
      '008': '뱀파이어',
      '009': '개런티',
    },
    'style_03': {
      '001': '약혼자',
      '002': '푸들',
      '003': '포크레인',
      '004': '백댄서',
      '005': '콩나물',
      '006': '매운탕',
      '007': '사계절',
      '008': '거북선',
      '009': '킹콩',
    },
  };

  static String? getAnswer(String styleId, String quizId) {
    return answers[styleId]?[quizId];
  }

  // 스타일별 퀴즈 개수 반환
  static int getQuizCount(String styleId) {
    // styleId가 'style_01' 또는 '1' 형식 모두 처리
    final formattedStyleId =
        styleId.contains('_') ? styleId : 'style_${styleId.padLeft(2, '0')}';

    return answers[formattedStyleId]?.length ?? 0;
  }
}
