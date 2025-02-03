import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nonsense_quiz/data/quiz_data.dart';
import 'package:nonsense_quiz/providers/main_page_provider.dart';
import 'package:nonsense_quiz/providers/quiz_provider.dart';
import 'package:nonsense_quiz/providers/hint_provider.dart';
import 'package:nonsense_quiz/widgets/quiz/image/quiz_image_container.dart';
import 'package:nonsense_quiz/widgets/quiz/input/answer_input_field.dart';
import 'package:nonsense_quiz/widgets/quiz/feedback/answer_feedback.dart';
import 'package:nonsense_quiz/widgets/quiz/hint/hint_button.dart';
import 'package:nonsense_quiz/providers/quiz_progress_provider.dart';
import 'package:nonsense_quiz/utils/hint_generator.dart';
import 'package:nonsense_quiz/widgets/quiz/hint/hint_display.dart';
import 'package:nonsense_quiz/widgets/common/ad_banner.dart';
import 'package:nonsense_quiz/providers/coins_provider.dart';
import 'package:nonsense_quiz/services/ad_service.dart';
import 'package:url_launcher/url_launcher.dart';

class QuizPage extends ConsumerStatefulWidget {
  final String styleId;
  final String quizId;

  const QuizPage({
    super.key,
    required this.styleId,
    required this.quizId,
  });

  @override
  ConsumerState<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends ConsumerState<QuizPage> {
  bool _showFeedback = false;
  bool _isCorrect = false;
  String _feedbackMessage = '';
  final FocusNode _answerFocusNode = FocusNode();
  bool _isLoadingAd = false;

  @override
  void didUpdateWidget(QuizPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 퀴즈 ID가 변경되면 상태 초기화
    if (oldWidget.quizId != widget.quizId) {
      setState(() {
        _showFeedback = false;
        _isCorrect = false;
        _feedbackMessage = '';
      });
    }
  }

  @override
  void dispose() {
    _answerFocusNode.dispose();
    super.dispose();
  }

  void _handleAnswer(String answer) async {
    await ref
        .read(quizControllerProvider.notifier)
        .submitAnswer(answer, widget.styleId, widget.quizId);

    setState(() {
      _showFeedback = true;
      final correctAnswer =
          QuizData.getAnswer(widget.styleId, widget.quizId) ?? '';
      _isCorrect = answer.trim() == correctAnswer.trim();
      _feedbackMessage = _isCorrect ? "정답입니다!" : "틀렸습니다. 다시 시도해보세요.";
    });

    if (_isCorrect) {
      HapticFeedback.mediumImpact();
      ref
          .read(quizProgressProvider.notifier)
          .completeQuiz(widget.styleId, widget.quizId);
    } else {
      HapticFeedback.heavyImpact();
    }

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showFeedback = false;
        });
      }
    });
  }

  void _handleHintRequest(int hintIndex) async {
    if (hintIndex == 2) {
      // 정답 보기 (광고 시청)
      setState(() {
        _isLoadingAd = true;
      });

      final correctAnswer =
          QuizData.getAnswer(widget.styleId, widget.quizId) ?? '';

      await AdService.showRewardedAd(
        onRewarded: () {
          if (mounted) {
            setState(() {
              _isLoadingAd = false;
            });
            _handleAnswer(correctAnswer);
          }
        },
        onAdFailed: () {
          if (mounted) {
            setState(() {
              _isLoadingAd = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('광고 로드에 실패했습니다. 다시 시도해주세요.')),
            );
          }
        },
      );
    } else {
      // 기존 힌트 로직 (코인 사용)
      final hintCosts = [4, 6, 10];
      final cost = hintCosts[hintIndex];

      final success = await ref.read(coinsProvider.notifier).spendCoins(cost);

      if (success) {
        ref.read(hintStateProvider.notifier).useHint(
              '${widget.styleId}/${widget.quizId}',
              hintIndex,
            );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('코인이 부족합니다!')),
        );
      }
    }
  }

  int _getMaxQuizCount(String styleId) {
    switch (styleId) {
      case 'style_01':
        return 9;
      case 'style_02':
        return 9;
      case 'style_03':
        return 9;
      default:
        return 0;
    }
  }

  // 코인 구매 다이얼로그를 보여주는 메서드
  void _showCoinPurchaseDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Text('💰 '),
            Text('공짜 코인'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.play_circle_outline),
              title: const Text('광고 시청'),
              subtitle: const Text('20코인'),
              onTap: () async {
                Navigator.pop(context);
                await AdService.showCoinRewardedAd(
                  onRewarded: () {
                    // 광고 시청 완료 시 20코인 지급
                    ref.read(coinsProvider.notifier).addCoins(20);
                  },
                  onAdFailed: () {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('광고 로드에 실패했습니다. 다시 시도해주세요.'),
                      ),
                    );
                  },
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.star_outline),
              title: const Text('앱 리뷰 작성'),
              subtitle: const Text('50코인'),
              onTap: () {
                Navigator.pop(context);
                debugPrint('✍️ 앱 리뷰 작성 버튼이 눌렸습니다');
                // TODO: 스토어 배포 후 리뷰 작성 링크 연결
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.favorite_outline),
              title: const Text('SNS 팔로우'),
              subtitle: const Text('50코인'),
              onTap: () async {
                Navigator.pop(context);
                final Uri url = Uri.parse('https://x.com/ggugguday');
                if (!await launchUrl(url)) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('링크를 여는데 실패했습니다.'),
                    ),
                  );
                }
                // TODO: SNS 팔로우 확인 후 코인 지급 로직 구현
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('닫기'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final quiz = ref.watch(currentQuizProvider((
      styleId: widget.styleId,
      quizId: widget.quizId,
    )));
    final theme = Theme.of(context);
    final correctAnswer =
        QuizData.getAnswer(widget.styleId, widget.quizId) ?? '';

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          ref.watch(coinsProvider).when(
                data: (coins) => Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: theme.colorScheme.secondaryContainer,
                      foregroundColor: theme.colorScheme.onSecondaryContainer,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 0,
                      ),
                    ),
                    onPressed: _showCoinPurchaseDialog,
                    icon: const Text(
                      '💰',
                      style: TextStyle(fontSize: 16),
                    ),
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          coins.toString(),
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSecondaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.add_box_rounded,
                          size: 20,
                          color: Colors.green,
                        ),
                      ],
                    ),
                  ),
                ),
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                ),
                error: (_, __) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(
                    Icons.error_outline,
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // 공유 기능 구현
            },
          ),
        ],
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            // 화면의 빈 공간을 터치하면 키보드를 닫음
            FocusScope.of(context).unfocus();
          },
          // 이벤트가 하위 위젯으로 전달되도록 설정
          behavior: HitTestBehavior.translucent,
          child: Column(
            children: [
              Expanded(
                child: quiz.when(
                  data: (quizData) => Column(
                    children: [
                      //문제 이미지
                      Expanded(
                        child: Stack(
                          children: [
                            QuizImageContainer(imageUrl: quizData.imageUrl),
                            if (_showFeedback)
                              Positioned(
                                bottom: 16,
                                left: 16,
                                right: 16,
                                child: AnswerFeedback(
                                  isCorrect: _isCorrect,
                                  message: _feedbackMessage,
                                ),
                              ),
                          ],
                        ),
                      ),
                      //힌트 표시
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: HintDisplay(
                          answer: correctAnswer,
                          usedHints: List.generate(
                            3,
                            (index) =>
                                ref
                                    .watch(hintStateProvider)[
                                        '${widget.styleId}/${widget.quizId}']
                                    ?.contains(index) ??
                                false,
                          ),
                          isCorrect: _isCorrect,
                          onTap: () {
                            if (!_isCorrect) {
                              _answerFocusNode.requestFocus();
                            }
                          },
                        ),
                      ),

                      //정답칸과 힌트/다음 버튼
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            if (!_isCorrect) ...[
                              //정답칸
                              AnswerInputField(
                                onSubmitted: _handleAnswer,
                                isEnabled: !_showFeedback,
                                focusNode: _answerFocusNode,
                              ),
                              const SizedBox(height: 16),
                              //힌트버튼
                              HintButton(
                                hints:
                                    HintGenerator.generateHints(correctAnswer),
                                usedHints: List.generate(
                                  3,
                                  (index) =>
                                      ref
                                          .watch(hintStateProvider)[
                                              '${widget.styleId}/${widget.quizId}']
                                          ?.contains(index) ??
                                      false,
                                ),
                                onHintRequested: _handleHintRequest,
                                isEnabled: !_showFeedback,
                                isLoading: _isLoadingAd,
                              ),
                            ] else ...[
                              //다음 문제 버튼
                              FilledButton.icon(
                                onPressed: () {
                                  // 다음 풀지 않은 퀴즈 찾기
                                  final maxQuizCount =
                                      _getMaxQuizCount(widget.styleId);
                                  String? nextQuizId;

                                  for (int i = 1; i <= maxQuizCount; i++) {
                                    final quizId = i.toString().padLeft(3, '0');
                                    final isCompleted = ref
                                        .read(quizProgressProvider.notifier)
                                        .isQuizCompleted(
                                            widget.styleId, quizId);

                                    if (!isCompleted) {
                                      nextQuizId = quizId;
                                      break;
                                    }
                                  }

                                  if (nextQuizId != null) {
                                    context.pushReplacement(
                                        '/quiz/${widget.styleId}/$nextQuizId');
                                  } else {
                                    // 모든 문제를 풀었으면 퀴즈 세트 페이지로 이동
                                    context.pop();
                                  }
                                },
                                icon: const Icon(Icons.arrow_forward),
                                label: const Text('다음 문제'),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(
                    child: Text(
                      '오류 발생: $error',
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
