import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HintButton extends StatelessWidget {
  final List<String> hints;
  final List<bool> usedHints;
  final Function(int) onHintRequested;
  final bool isEnabled;
  final bool isLoading;

  const HintButton({
    super.key,
    required this.hints,
    required this.usedHints,
    required this.onHintRequested,
    required this.isEnabled,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nextHintIndex = usedHints.indexOf(false);

    // 힌트 정보 정의
    final hintInfo = [
      (label: '초성', cost: 4),
      (label: '한 글자', cost: 6),
      (label: '정답 보기', cost: 10),
    ];

    String getButtonLabel() {
      if (nextHintIndex == -1) return '힌트 모두 사용';
      final info = hintInfo[nextHintIndex];
      // 마지막 힌트(정답 보기)의 경우 광고 아이콘 표시
      if (nextHintIndex == 2) {
        return info.label;
      }
      return '${info.label} 힌트 (💰 ${info.cost})';
    }

    // 정답 보기 버튼이고 로딩 중일 때의 위젯
    if (nextHintIndex == 2 && isLoading) {
      return FilledButton.icon(
        onPressed: null, // 로딩 중에는 비활성화
        icon: const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
        label: const Text('광고 로딩 중...'),
        style: FilledButton.styleFrom(
          backgroundColor: theme.colorScheme.secondaryContainer,
          foregroundColor: theme.colorScheme.onSecondaryContainer,
        ),
      );
    }

    return FilledButton.icon(
      onPressed: isEnabled && nextHintIndex != -1 && !isLoading
          ? () => onHintRequested(nextHintIndex)
          : null,
      icon: nextHintIndex == 2
          ? const Icon(Icons.play_circle_outline)
          : const Icon(Icons.lightbulb_outline),
      label: Text(getButtonLabel()),
      style: FilledButton.styleFrom(
        backgroundColor: theme.colorScheme.secondaryContainer,
        foregroundColor: theme.colorScheme.onSecondaryContainer,
      ),
    );
  }
}
