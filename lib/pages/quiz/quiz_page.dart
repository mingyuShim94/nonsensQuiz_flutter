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

  int _getMaxQuizCount(String styleId) {
    switch (styleId) {
      case 'style_01':
        return 7;
      case 'style_02':
        return 4;
      case 'style_03':
        return 7;
      default:
        return 0;
    }
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
                data: (coins) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Center(child: Text('💰 $coins')),
                ),
                loading: () => const CircularProgressIndicator(),
                error: (_, __) => const Icon(Icons.error),
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
                                onHintRequested: (index) async {
                                  // 힌트 비용 계산
                                  final hintCosts = [4, 6, 10];
                                  final cost = hintCosts[index];

                                  // 코인 차감 시도
                                  final success = await ref
                                      .read(coinsProvider.notifier)
                                      .spendCoins(cost);

                                  if (success) {
                                    // 코인 차감 성공 시 힌트 사용
                                    ref.read(hintStateProvider.notifier).useHint(
                                        '${widget.styleId}/${widget.quizId}',
                                        index);
                                  } else {
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('코인이 부족합니다!')),
                                    );
                                  }
                                },
                                isEnabled: !_showFeedback,
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
