// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'style.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StyleImpl _$$StyleImplFromJson(Map<String, dynamic> json) => _$StyleImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      thumbnailPath: json['thumbnailPath'] as String,
      progress: (json['progress'] as num).toInt(),
    );

Map<String, dynamic> _$$StyleImplToJson(_$StyleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'thumbnailPath': instance.thumbnailPath,
      'progress': instance.progress,
    };
