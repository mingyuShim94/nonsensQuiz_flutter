import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HintButton extends StatelessWidget {
  final List<String> hints;
  final List<bool> usedHints;
  final Function(int) onHintRequested;
  final bool isEnabled;

  const HintButton({
    super.key,
    required this.hints,
    required this.usedHints,
    required this.onHintRequested,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nextHintIndex = usedHints.indexOf(false);

    // 힌트 정보 정의
    final hintInfo = [
      (label: '초성', cost: 4),
      (label: '한 글자', cost: 6),
      (label: '정답', cost: 10),
    ];

    String getButtonLabel() {
      if (nextHintIndex == -1) return '힌트 모두 사용';
      final info = hintInfo[nextHintIndex];
      return '${info.label} 힌트 (💰 ${info.cost})';
    }

    return FilledButton.icon(
      onPressed: isEnabled && nextHintIndex != -1
          ? () => onHintRequested(nextHintIndex)
          : null,
      icon: const Icon(Icons.lightbulb_outline),
      label: Text(getButtonLabel()),
      style: FilledButton.styleFrom(
        backgroundColor: theme.colorScheme.secondaryContainer,
        foregroundColor: theme.colorScheme.onSecondaryContainer,
      ),
    );
  }
}
