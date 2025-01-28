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
          onPressed: () => context.go('/'),
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
                                  final success = await ref
                                      .read(quizControllerProvider.notifier)
                                      .useHint(
                                          widget.styleId, widget.quizId, index);

                                  if (!success) {
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
                                  // 다음 퀴즈로 이동
                                  final nextQuizId =
                                      (int.parse(widget.quizId) + 1)
                                          .toString()
                                          .padLeft(3, '0');
                                  context.go(
                                      '/quiz/${widget.styleId}/$nextQuizId');
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
              const AdBanner(),
            ],
          ),
        ),
      ),
    );
  }
}
