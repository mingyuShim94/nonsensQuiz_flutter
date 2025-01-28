import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nonsense_quiz/pages/main/main_page.dart';
import 'package:nonsense_quiz/pages/quiz/quiz_page.dart';
import 'package:nonsense_quiz/pages/quiz_set/quiz_set_page.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainPage(),
    ),
    GoRoute(
      path: '/quiz-set/:styleId',
      builder: (context, state) => QuizSetPage(
        styleId: state.pathParameters['styleId']!,
      ),
    ),
    GoRoute(
      path: '/quiz/:styleId/:quizId',
      builder: (context, state) => QuizPage(
        styleId: state.pathParameters['styleId']!,
        quizId: state.pathParameters['quizId']!,
      ),
    ),
    // GoRoute(
    //   path: '/settings',
    //   builder: (context, state) => const SettingsPage(), // 아직 미구현
    // ),
  ],
);
