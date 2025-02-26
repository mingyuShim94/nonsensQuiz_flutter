// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'style.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Style _$StyleFromJson(Map<String, dynamic> json) {
  return _Style.fromJson(json);
}

/// @nodoc
mixin _$Style {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get thumbnailPath => throw _privateConstructorUsedError;
  int get progress => throw _privateConstructorUsedError;
  int get requiredStars => throw _privateConstructorUsedError;

  /// Serializes this Style to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Style
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StyleCopyWith<Style> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StyleCopyWith<$Res> {
  factory $StyleCopyWith(Style value, $Res Function(Style) then) =
      _$StyleCopyWithImpl<$Res, Style>;
  @useResult
  $Res call(
      {String id,
      String name,
      String thumbnailPath,
      int progress,
      int requiredStars});
}

/// @nodoc
class _$StyleCopyWithImpl<$Res, $Val extends Style>
    implements $StyleCopyWith<$Res> {
  _$StyleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Style
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? thumbnailPath = null,
    Object? progress = null,
    Object? requiredStars = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnailPath: null == thumbnailPath
          ? _value.thumbnailPath
          : thumbnailPath // ignore: cast_nullable_to_non_nullable
              as String,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as int,
      requiredStars: null == requiredStars
          ? _value.requiredStars
          : requiredStars // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StyleImplCopyWith<$Res> implements $StyleCopyWith<$Res> {
  factory _$$StyleImplCopyWith(
          _$StyleImpl value, $Res Function(_$StyleImpl) then) =
      __$$StyleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String thumbnailPath,
      int progress,
      int requiredStars});
}

/// @nodoc
class __$$StyleImplCopyWithImpl<$Res>
    extends _$StyleCopyWithImpl<$Res, _$StyleImpl>
    implements _$$StyleImplCopyWith<$Res> {
  __$$StyleImplCopyWithImpl(
      _$StyleImpl _value, $Res Function(_$StyleImpl) _then)
      : super(_value, _then);

  /// Create a copy of Style
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? thumbnailPath = null,
    Object? progress = null,
    Object? requiredStars = null,
  }) {
    return _then(_$StyleImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnailPath: null == thumbnailPath
          ? _value.thumbnailPath
          : thumbnailPath // ignore: cast_nullable_to_non_nullable
              as String,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as int,
      requiredStars: null == requiredStars
          ? _value.requiredStars
          : requiredStars // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StyleImpl implements _Style {
  const _$StyleImpl(
      {required this.id,
      required this.name,
      required this.thumbnailPath,
      this.progress = 0,
      this.requiredStars = 0});

  factory _$StyleImpl.fromJson(Map<String, dynamic> json) =>
      _$$StyleImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String thumbnailPath;
  @override
  @JsonKey()
  final int progress;
  @override
  @JsonKey()
  final int requiredStars;

  @override
  String toString() {
    return 'Style(id: $id, name: $name, thumbnailPath: $thumbnailPath, progress: $progress, requiredStars: $requiredStars)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StyleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.thumbnailPath, thumbnailPath) ||
                other.thumbnailPath == thumbnailPath) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.requiredStars, requiredStars) ||
                other.requiredStars == requiredStars));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, thumbnailPath, progress, requiredStars);

  /// Create a copy of Style
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StyleImplCopyWith<_$StyleImpl> get copyWith =>
      __$$StyleImplCopyWithImpl<_$StyleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StyleImplToJson(
      this,
    );
  }
}

abstract class _Style implements Style {
  const factory _Style(
      {required final String id,
      required final String name,
      required final String thumbnailPath,
      final int progress,
      final int requiredStars}) = _$StyleImpl;

  factory _Style.fromJson(Map<String, dynamic> json) = _$StyleImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get thumbnailPath;
  @override
  int get progress;
  @override
  int get requiredStars;

  /// Create a copy of Style
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StyleImplCopyWith<_$StyleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
