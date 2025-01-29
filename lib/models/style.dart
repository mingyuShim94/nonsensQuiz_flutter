import 'package:freezed_annotation/freezed_annotation.dart';

part 'style.freezed.dart';
part 'style.g.dart';

@freezed
class Style with _$Style {
  const factory Style({
    required String id,
    required String name,
    required String thumbnailPath,
    @Default(0) int progress,
    @Default(0) int requiredStars,
  }) = _Style;

  factory Style.fromJson(Map<String, dynamic> json) => _$StyleFromJson(json);
}
