import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/quiz_provider.dart';
import 'package:flutter/services.dart'; // 진동을 위한 import 추가

class QuizScreen extends HookConsumerWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizState = ref.watch(currentQuizProvider);

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFF8F9FA),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 상단 바
              const _TopBar(),

              // 그림 영역
              const Expanded(
                child: _QuizImage(),
              ),

              // 힌트 버튼들
              const _HintButtons(),

              // 정답 입력 영역
              _AnswerInput(
                onSubmit: (answer) {
                  // TODO: 정답 체크 로직 구현
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 뒤로 가기 버튼
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back_rounded),
            tooltip: '뒤로 가기',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 44,
              minHeight: 44,
            ),
          ),

          // 코인 표시
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.monetization_on_rounded,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  '999',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // 공유 버튼
          IconButton(
            onPressed: () {
              // TODO: 공유 기능 구현
            },
            icon: const Icon(Icons.share_rounded),
            tooltip: '공유하기',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 44,
              minHeight: 44,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuizImage extends ConsumerWidget {
  const _QuizImage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizState = ref.watch(currentQuizProvider);

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: quizState.when(
        data: (quiz) => Image.asset(
          quiz.imagePath,
          fit: BoxFit.contain,
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Text('이미지를 불러올 수 없습니다: $error'),
        ),
      ),
    );
  }
}

class _HintButtons extends ConsumerWidget {
  const _HintButtons();

  void _showHint(BuildContext context, String hint) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _HintBottomSheet(hint: hint),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizState = ref.watch(currentQuizProvider);

    return quizState.when(
      data: (quiz) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (var i = 0; i < quiz.hints.length; i++)
              _HintButton(
                label: '힌트 ${i + 1}',
                price: (i + 1) * 10,
                onTap: () => _showHint(context, quiz.hints[i]),
              ),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('힌트를 불러올 수 없습니다: $error'),
      ),
    );
  }
}

class _HintButton extends StatelessWidget {
  const _HintButton({
    required this.label,
    required this.price,
    required this.onTap,
  });

  final String label;
  final int price;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // 힌트 레이블
            Center(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // 코인 가격
            Positioned(
              right: 8,
              bottom: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$price',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HintBottomSheet extends StatelessWidget {
  const _HintBottomSheet({required this.hint});

  final String hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 드래그 핸들
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // 힌트 아이콘
          Icon(
            Icons.lightbulb_outline,
            size: 48,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 16),
          // 힌트 텍스트
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Text(
              hint,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // 닫기 버튼
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '확인',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _AnswerInput extends HookConsumerWidget {
  const _AnswerInput({required this.onSubmit});

  final void Function(String answer) onSubmit;

  // 틀린 횟수에 따른 메시지
  static const List<String> failMessages = [
    '틀렸어요! 다시 한번 생각해보세요 🤔',
    '땡! 조금만 더 고민해볼까요? 🧐',
    '으음... 힌트를 보는 건 어떨까요? 🤫',
    '아깝네요! 거의 다 와가는 것 같은데! 💪',
    '포기하지 마세요! 할 수 있어요! 🔥',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final isError = useState(false);
    final failCount = useState(0); // 틀린 횟수 추가

    void shakeError() {
      isError.value = true;
      // 진동 효과 추가
      HapticFeedback.heavyImpact();

      // 이모티콘 애니메이션 표시
      showDialog(
        context: context,
        barrierColor: Colors.transparent,
        builder: (_) => _WrongAnswerAnimation(),
      );

      Future.delayed(const Duration(milliseconds: 500), () {
        isError.value = false;
      });
    }

    Future<void> checkAnswer(String value) async {
      if (value.isEmpty) return; // 빈 값 체크 추가

      final isCorrect =
          await ref.read(currentQuizProvider.notifier).checkAnswer(value);

      if (isCorrect) {
        HapticFeedback.mediumImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('정답입니다! 🎉'),
            backgroundColor: Colors.green,
          ),
        );
        // TODO: 다음 퀴즈로 이동
      } else {
        failCount.value++; // 틀린 횟수 증가
        shakeError();
        controller.text = '';

        // 틀린 횟수에 따른 다른 메시지 표시
        final message = failMessages[failCount.value % failMessages.length];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 500),
            tween: Tween(begin: 0, end: isError.value ? 1.0 : 0.0),
            builder: (context, value, child) => Transform.translate(
              offset: Offset(sin(value * 4 * pi) * 8, 0),
              child: child,
            ),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: '정답을 입력하세요',
                filled: true,
                fillColor: const Color(0xFFF8F9FA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isError.value ? Colors.red : Colors.transparent,
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isError.value
                        ? Colors.red
                        : Theme.of(context).primaryColor,
                    width: 2,
                  ),
                ),
              ),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isError.value ? Colors.red : null,
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: checkAnswer,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => checkAnswer(controller.text),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                '제출하기',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 틀렸을 때 표시될 애니메이션 위젯
class _WrongAnswerAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 800),
        tween: Tween(begin: 0, end: 1),
        onEnd: () => Navigator.of(context).pop(),
        builder: (context, value, child) {
          return Opacity(
            opacity: 1 - value,
            child: Transform.translate(
              offset: Offset(0, -50 * value),
              child: const Text(
                '❌',
                style: TextStyle(fontSize: 60),
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      ),
    );
  }
}
