import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nonsense_quiz/providers/quiz_progress_provider.dart';
import 'package:nonsense_quiz/providers/coins_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsDialog extends ConsumerWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('설정'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.refresh),
            title: const Text('게임 초기화'),
            onTap: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('게임 초기화'),
                  content: const Text('모든 진행 상황이 삭제됩니다.\n정말 초기화하시겠습니까?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('취소'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(
                        '초기화',
                        style: TextStyle(color: theme.colorScheme.error),
                      ),
                    ),
                  ],
                ),
              );

              if (confirmed == true) {
                // 게임 데이터 초기화
                await ref.read(quizProgressProvider.notifier).resetProgress();
                await ref.read(coinsProvider.notifier).resetCoins();
                if (context.mounted) {
                  Navigator.pop(context); // 설정 다이얼로그 닫기
                }
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.star),
            title: const Text('리뷰하기'),
            onTap: () {
              launchUrl(Uri.parse(
                'market://details?id=com.your.package.name', // 실제 패키지명으로 변경 필요
              ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('현재 버전'),
            trailing: const Text('1.0.0'), // 실제 버전으로 변경 필요
          )
        ],
      ),
    );
  }
}
