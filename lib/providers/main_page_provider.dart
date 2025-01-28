import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nonsense_quiz/models/style.dart';
import 'package:nonsense_quiz/repositories/style_repository.dart';
import 'package:nonsense_quiz/repositories/user_repository.dart';

final styleListProvider = FutureProvider<List<Style>>((ref) async {
  final styleRepository = ref.read(styleRepositoryProvider);
  return await styleRepository.getStyles();
});

final coinsProvider = FutureProvider<int>((ref) async {
  final userRepository = ref.read(userRepositoryProvider);
  return await userRepository.getCoins();
});

final starsProvider = FutureProvider<int>((ref) async {
  final userRepository = ref.read(userRepositoryProvider);
  return await userRepository.getStars();
});
