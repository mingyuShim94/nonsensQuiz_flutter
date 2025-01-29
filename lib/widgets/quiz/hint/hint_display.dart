import 'package:flutter/material.dart';

class HintDisplay extends StatelessWidget {
  final String answer;
  final List<bool> usedHints;
  final bool isCorrect;
  final VoidCallback? onTap;

  const HintDisplay({
    super.key,
    required this.answer,
    required this.usedHints,
    required this.isCorrect,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final letterCount = answer.length;

    if (isCorrect) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          letterCount,
          (index) => Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                answer[index],
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ),
        ),
      );
    }

    final showInitialSounds = usedHints.isNotEmpty && usedHints[0];
    final showOneChar = usedHints.length >= 2 && usedHints[1];
    final showAnswer = usedHints.length >= 3 && usedHints[2];

    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(letterCount, (index) {
          String displayText = '';

          if (showAnswer) {
            displayText = answer[index];
          } else if (showOneChar && index == letterCount ~/ 2) {
            displayText = answer[index];
          } else if (showInitialSounds) {
            final code = answer[index].codeUnitAt(0);
            if (code >= 0xAC00 && code <= 0xD7A3) {
              displayText =
                  String.fromCharCode(((code - 0xAC00) ~/ 28 ~/ 21) + 0x1100);
            }
          }

          return Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.outline),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                displayText,
                style: theme.textTheme.titleMedium,
              ),
            ),
          );
        }),
      ),
    );
  }
}
