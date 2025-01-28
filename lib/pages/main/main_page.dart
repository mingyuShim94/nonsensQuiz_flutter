import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nonsense_quiz/widgets/main/style_list.dart';
import 'package:nonsense_quiz/providers/main_page_provider.dart';
import 'package:nonsense_quiz/widgets/common/ad_banner.dart';

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final styles = ref.watch(styleListProvider);
    final coins = ref.watch(coinsProvider);
    final stars = ref.watch(starsProvider);

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.settings),
              iconSize: 24,
              padding: const EdgeInsets.all(12),
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                coins.when(
                  data: (coinCount) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('💰'),
                        const SizedBox(width: 4),
                        Text(
                          '$coinCount',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSecondaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                  loading: () => const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, stack) => const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(width: 12),
                stars.when(
                  data: (starCount) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('⭐'),
                        const SizedBox(width: 4),
                        Text(
                          '$starCount',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                  loading: () => const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, stack) => const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 48), // 설정 버튼과 대칭을 맞추기 위한 여백
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(styleListProvider);
                ref.invalidate(coinsProvider);
                ref.invalidate(starsProvider);
              },
              child: styles.when(
                data: (styleList) => Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: stars.when(
                    data: (starCount) =>
                        StyleList(styleList: styleList, stars: starCount),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => Center(
                      child: SelectableText.rich(
                        TextSpan(
                          text: '오류 발생: $error',
                          style: TextStyle(color: theme.colorScheme.error),
                        ),
                      ),
                    ),
                  ),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: SelectableText.rich(
                    TextSpan(
                      text: '오류 발생: $error',
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const AdBanner(),
        ],
      ),
    );
  }
}
