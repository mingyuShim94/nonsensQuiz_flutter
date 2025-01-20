import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/quiz.dart';

part 'quiz_provider.g.dart';

@riverpod
class CurrentQuiz extends _$CurrentQuiz {
  @override
  Future<Quiz> build() async {
    // JSON 파일 로드
    final jsonString = await rootBundle.loadString('assets/data/quizzes.json');
    final json = jsonDecode(jsonString) as Map<String, dynamic>;

    // 랜덤 퀴즈 선택
    final quizzes =
        (json['quizzes'] as List).map((quiz) => Quiz.fromJson(quiz)).toList();
    quizzes.shuffle();

    return quizzes.first;
  }

  Future<bool> checkAnswer(String answer) async {
    final quiz = await future;
    return quiz.answer == answer;
  }
}
