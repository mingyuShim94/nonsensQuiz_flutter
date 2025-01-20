import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum QuizStyle {
  @JsonValue('style_01')
  style01('스타일 1'),

  @JsonValue('style_02')
  style02('스타일 2'),

  @JsonValue('style_03')
  style03('스타일 3'),

  @JsonValue('style_04')
  style04('스타일 4');

  final String displayName;
  const QuizStyle(this.displayName);

  String get folderPath =>
      'assets/images/quiz/style_${(index + 1).toString().padLeft(2, '0')}/';
}
