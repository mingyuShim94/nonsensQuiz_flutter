// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuizImpl _$$QuizImplFromJson(Map<String, dynamic> json) => _$QuizImpl(
      id: json['id'] as String,
      question: json['question'] as String,
      answer: json['answer'] as String,
      imageUrl: json['imageUrl'] as String,
      hints: (json['hints'] as List<dynamic>).map((e) => e as String).toList(),
      orderIndex: (json['orderIndex'] as num).toInt(),
    );

Map<String, dynamic> _$$QuizImplToJson(_$QuizImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'question': instance.question,
      'answer': instance.answer,
      'imageUrl': instance.imageUrl,
      'hints': instance.hints,
      'orderIndex': instance.orderIndex,
    };
