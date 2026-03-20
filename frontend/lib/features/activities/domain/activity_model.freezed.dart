// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ActivityModel {

 String get id; String get title; String get description;@JsonKey(name: 'start_time') String? get startTime;@JsonKey(name: 'end_time') String? get endTime; int? get duration;// in seconds
@JsonKey(name: 'user_id') String? get userId;@JsonKey(name: 'updated_at') String? get updatedAt;@JsonKey(name: 'is_deleted') bool get isDeleted;
/// Create a copy of ActivityModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityModelCopyWith<ActivityModel> get copyWith => _$ActivityModelCopyWithImpl<ActivityModel>(this as ActivityModel, _$identity);

  /// Serializes this ActivityModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,startTime,endTime,duration,userId,updatedAt,isDeleted);

@override
String toString() {
  return 'ActivityModel(id: $id, title: $title, description: $description, startTime: $startTime, endTime: $endTime, duration: $duration, userId: $userId, updatedAt: $updatedAt, isDeleted: $isDeleted)';
}


}

/// @nodoc
abstract mixin class $ActivityModelCopyWith<$Res>  {
  factory $ActivityModelCopyWith(ActivityModel value, $Res Function(ActivityModel) _then) = _$ActivityModelCopyWithImpl;
@useResult
$Res call({
 String id, String title, String description,@JsonKey(name: 'start_time') String? startTime,@JsonKey(name: 'end_time') String? endTime, int? duration,@JsonKey(name: 'user_id') String? userId,@JsonKey(name: 'updated_at') String? updatedAt,@JsonKey(name: 'is_deleted') bool isDeleted
});




}
/// @nodoc
class _$ActivityModelCopyWithImpl<$Res>
    implements $ActivityModelCopyWith<$Res> {
  _$ActivityModelCopyWithImpl(this._self, this._then);

  final ActivityModel _self;
  final $Res Function(ActivityModel) _then;

/// Create a copy of ActivityModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? startTime = freezed,Object? endTime = freezed,Object? duration = freezed,Object? userId = freezed,Object? updatedAt = freezed,Object? isDeleted = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String?,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivityModel].
extension ActivityModelPatterns on ActivityModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivityModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivityModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivityModel value)  $default,){
final _that = this;
switch (_that) {
case _ActivityModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivityModel value)?  $default,){
final _that = this;
switch (_that) {
case _ActivityModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String description, @JsonKey(name: 'start_time')  String? startTime, @JsonKey(name: 'end_time')  String? endTime,  int? duration, @JsonKey(name: 'user_id')  String? userId, @JsonKey(name: 'updated_at')  String? updatedAt, @JsonKey(name: 'is_deleted')  bool isDeleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivityModel() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.startTime,_that.endTime,_that.duration,_that.userId,_that.updatedAt,_that.isDeleted);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String description, @JsonKey(name: 'start_time')  String? startTime, @JsonKey(name: 'end_time')  String? endTime,  int? duration, @JsonKey(name: 'user_id')  String? userId, @JsonKey(name: 'updated_at')  String? updatedAt, @JsonKey(name: 'is_deleted')  bool isDeleted)  $default,) {final _that = this;
switch (_that) {
case _ActivityModel():
return $default(_that.id,_that.title,_that.description,_that.startTime,_that.endTime,_that.duration,_that.userId,_that.updatedAt,_that.isDeleted);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String description, @JsonKey(name: 'start_time')  String? startTime, @JsonKey(name: 'end_time')  String? endTime,  int? duration, @JsonKey(name: 'user_id')  String? userId, @JsonKey(name: 'updated_at')  String? updatedAt, @JsonKey(name: 'is_deleted')  bool isDeleted)?  $default,) {final _that = this;
switch (_that) {
case _ActivityModel() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.startTime,_that.endTime,_that.duration,_that.userId,_that.updatedAt,_that.isDeleted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActivityModel implements ActivityModel {
  const _ActivityModel({required this.id, required this.title, this.description = '', @JsonKey(name: 'start_time') this.startTime, @JsonKey(name: 'end_time') this.endTime, this.duration, @JsonKey(name: 'user_id') this.userId, @JsonKey(name: 'updated_at') this.updatedAt, @JsonKey(name: 'is_deleted') this.isDeleted = false});
  factory _ActivityModel.fromJson(Map<String, dynamic> json) => _$ActivityModelFromJson(json);

@override final  String id;
@override final  String title;
@override@JsonKey() final  String description;
@override@JsonKey(name: 'start_time') final  String? startTime;
@override@JsonKey(name: 'end_time') final  String? endTime;
@override final  int? duration;
// in seconds
@override@JsonKey(name: 'user_id') final  String? userId;
@override@JsonKey(name: 'updated_at') final  String? updatedAt;
@override@JsonKey(name: 'is_deleted') final  bool isDeleted;

/// Create a copy of ActivityModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityModelCopyWith<_ActivityModel> get copyWith => __$ActivityModelCopyWithImpl<_ActivityModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActivityModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,startTime,endTime,duration,userId,updatedAt,isDeleted);

@override
String toString() {
  return 'ActivityModel(id: $id, title: $title, description: $description, startTime: $startTime, endTime: $endTime, duration: $duration, userId: $userId, updatedAt: $updatedAt, isDeleted: $isDeleted)';
}


}

/// @nodoc
abstract mixin class _$ActivityModelCopyWith<$Res> implements $ActivityModelCopyWith<$Res> {
  factory _$ActivityModelCopyWith(_ActivityModel value, $Res Function(_ActivityModel) _then) = __$ActivityModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String description,@JsonKey(name: 'start_time') String? startTime,@JsonKey(name: 'end_time') String? endTime, int? duration,@JsonKey(name: 'user_id') String? userId,@JsonKey(name: 'updated_at') String? updatedAt,@JsonKey(name: 'is_deleted') bool isDeleted
});




}
/// @nodoc
class __$ActivityModelCopyWithImpl<$Res>
    implements _$ActivityModelCopyWith<$Res> {
  __$ActivityModelCopyWithImpl(this._self, this._then);

  final _ActivityModel _self;
  final $Res Function(_ActivityModel) _then;

/// Create a copy of ActivityModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? startTime = freezed,Object? endTime = freezed,Object? duration = freezed,Object? userId = freezed,Object? updatedAt = freezed,Object? isDeleted = null,}) {
  return _then(_ActivityModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String?,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
