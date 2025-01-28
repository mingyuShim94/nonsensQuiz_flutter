class HintGenerator {
  static List<String> generateHints(String answer) {
    return [
      _generateInitialSoundHint(answer),
      _generateRevealLetterHint(answer),
      _generateAnswerHint(answer),
    ];
  }

  static String _generateInitialSoundHint(String answer) {
    final initialSounds = answer.split('').map((char) {
      final code = char.codeUnitAt(0);
      if (code >= 0xAC00 && code <= 0xD7A3) {
        return String.fromCharCode(((code - 0xAC00) ~/ 28 ~/ 21) + 0x1100);
      }
      return char;
    }).join(' ');
    return '초성: $initialSounds';
  }

  static String _generateRevealLetterHint(String answer) {
    final revealed = List.filled(answer.length, '_');
    final randomIndex = (answer.length ~/ 2);
    revealed[randomIndex] = answer[randomIndex];
    return revealed.join(' ');
  }

  static String _generateAnswerHint(String answer) {
    return '정답: $answer';
  }
}
