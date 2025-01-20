// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuizImpl _$$QuizImplFromJson(Map<String, dynamic> json) => _$QuizImpl(
      id: json['id'] as String,
      fileName: json['fileName'] as String,
      answer: json['answer'] as String,
      hints: (json['hints'] as List<dynamic>).map((e) => e as String).toList(),
      style: $enumDecode(_$QuizStyleEnumMap, json['style']),
      isSolved: json['isSolved'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$QuizImplToJson(_$QuizImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fileName': instance.fileName,
      'answer': instance.answer,
      'hints': instance.hints,
      'style': _$QuizStyleEnumMap[instance.style]!,
      'isSolved': instance.isSolved,
      'created_at': instance.createdAt.toIso8601String(),
    };

const _$QuizStyleEnumMap = {
  QuizStyle.style01: 'style_01',
  QuizStyle.style02: 'style_02',
  QuizStyle.style03: 'style_03',
  QuizStyle.style04: 'style_04',
};
