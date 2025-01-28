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
    },
    'style_02': {
      '001': '도서관',
      '002': '발명품',
      '003': '파노라마',
      '004': '소신발언',
    },
    'style_03': {
      '001': '약혼자',
      '002': '푸들',
      '003': '포크레인',
      '004': '백댄서',
      '005': '콩나물',
      '006': '매운탕',
      '007': '사계절',
    },
  };

  static String? getAnswer(String styleId, String quizId) {
    return answers[styleId]?[quizId];
  }
}
