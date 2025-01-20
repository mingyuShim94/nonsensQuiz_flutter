import 'package:freezed_annotation/freezed_annotation.dart';
import 'quiz_style.dart';

part 'quiz.freezed.dart';
part 'quiz.g.dart';

@freezed
class Quiz with _$Quiz {
  const Quiz._(); // getter를 위한 private constructor 추가

  const factory Quiz({
    required String id,
    required String fileName,
    required String answer,
    required List<String> hints,
    required QuizStyle style,
    @Default(false) bool isSolved,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _Quiz;

  factory Quiz.fromJson(Map<String, dynamic> json) => _$QuizFromJson(json);

  String get imagePath => '${style.folderPath}$fileName';
}
