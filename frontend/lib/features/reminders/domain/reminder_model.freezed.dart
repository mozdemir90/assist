// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reminder_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReminderModel {

 String get id; String get title; String? get message;@JsonKey(name: 'trigger_time') DateTime get triggerTime;@JsonKey(name: 'is_sent') bool get isSent;@JsonKey(name: 'task_id') String? get taskId;@JsonKey(name: 'activity_id') String? get activityId;@JsonKey(name: 'user_id') String get userId;@JsonKey(name: 'updated_at') DateTime? get updatedAt;@JsonKey(name: 'is_deleted') bool get isDeleted;
/// Create a copy of ReminderModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReminderModelCopyWith<ReminderModel> get copyWith => _$ReminderModelCopyWithImpl<ReminderModel>(this as ReminderModel, _$identity);

  /// Serializes this ReminderModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReminderModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.message, message) || other.message == message)&&(identical(other.triggerTime, triggerTime) || other.triggerTime == triggerTime)&&(identical(other.isSent, isSent) || other.isSent == isSent)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.activityId, activityId) || other.activityId == activityId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,message,triggerTime,isSent,taskId,activityId,userId,updatedAt,isDeleted);

@override
String toString() {
  return 'ReminderModel(id: $id, title: $title, message: $message, triggerTime: $triggerTime, isSent: $isSent, taskId: $taskId, activityId: $activityId, userId: $userId, updatedAt: $updatedAt, isDeleted: $isDeleted)';
}


}

/// @nodoc
abstract mixin class $ReminderModelCopyWith<$Res>  {
  factory $ReminderModelCopyWith(ReminderModel value, $Res Function(ReminderModel) _then) = _$ReminderModelCopyWithImpl;
@useResult
$Res call({
 String id, String title, String? message,@JsonKey(name: 'trigger_time') DateTime triggerTime,@JsonKey(name: 'is_sent') bool isSent,@JsonKey(name: 'task_id') String? taskId,@JsonKey(name: 'activity_id') String? activityId,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'updated_at') DateTime? updatedAt,@JsonKey(name: 'is_deleted') bool isDeleted
});




}
/// @nodoc
class _$ReminderModelCopyWithImpl<$Res>
    implements $ReminderModelCopyWith<$Res> {
  _$ReminderModelCopyWithImpl(this._self, this._then);

  final ReminderModel _self;
  final $Res Function(ReminderModel) _then;

/// Create a copy of ReminderModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? message = freezed,Object? triggerTime = null,Object? isSent = null,Object? taskId = freezed,Object? activityId = freezed,Object? userId = null,Object? updatedAt = freezed,Object? isDeleted = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,triggerTime: null == triggerTime ? _self.triggerTime : triggerTime // ignore: cast_nullable_to_non_nullable
as DateTime,isSent: null == isSent ? _self.isSent : isSent // ignore: cast_nullable_to_non_nullable
as bool,taskId: freezed == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String?,activityId: freezed == activityId ? _self.activityId : activityId // ignore: cast_nullable_to_non_nullable
as String?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ReminderModel].
extension ReminderModelPatterns on ReminderModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReminderModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReminderModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReminderModel value)  $default,){
final _that = this;
switch (_that) {
case _ReminderModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReminderModel value)?  $default,){
final _that = this;
switch (_that) {
case _ReminderModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String? message, @JsonKey(name: 'trigger_time')  DateTime triggerTime, @JsonKey(name: 'is_sent')  bool isSent, @JsonKey(name: 'task_id')  String? taskId, @JsonKey(name: 'activity_id')  String? activityId, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'updated_at')  DateTime? updatedAt, @JsonKey(name: 'is_deleted')  bool isDeleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReminderModel() when $default != null:
return $default(_that.id,_that.title,_that.message,_that.triggerTime,_that.isSent,_that.taskId,_that.activityId,_that.userId,_that.updatedAt,_that.isDeleted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String? message, @JsonKey(name: 'trigger_time')  DateTime triggerTime, @JsonKey(name: 'is_sent')  bool isSent, @JsonKey(name: 'task_id')  String? taskId, @JsonKey(name: 'activity_id')  String? activityId, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'updated_at')  DateTime? updatedAt, @JsonKey(name: 'is_deleted')  bool isDeleted)  $default,) {final _that = this;
switch (_that) {
case _ReminderModel():
return $default(_that.id,_that.title,_that.message,_that.triggerTime,_that.isSent,_that.taskId,_that.activityId,_that.userId,_that.updatedAt,_that.isDeleted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String? message, @JsonKey(name: 'trigger_time')  DateTime triggerTime, @JsonKey(name: 'is_sent')  bool isSent, @JsonKey(name: 'task_id')  String? taskId, @JsonKey(name: 'activity_id')  String? activityId, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'updated_at')  DateTime? updatedAt, @JsonKey(name: 'is_deleted')  bool isDeleted)?  $default,) {final _that = this;
switch (_that) {
case _ReminderModel() when $default != null:
return $default(_that.id,_that.title,_that.message,_that.triggerTime,_that.isSent,_that.taskId,_that.activityId,_that.userId,_that.updatedAt,_that.isDeleted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReminderModel implements ReminderModel {
  const _ReminderModel({required this.id, required this.title, this.message, @JsonKey(name: 'trigger_time') required this.triggerTime, @JsonKey(name: 'is_sent') this.isSent = false, @JsonKey(name: 'task_id') this.taskId, @JsonKey(name: 'activity_id') this.activityId, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'updated_at') this.updatedAt, @JsonKey(name: 'is_deleted') this.isDeleted = false});
  factory _ReminderModel.fromJson(Map<String, dynamic> json) => _$ReminderModelFromJson(json);

@override final  String id;
@override final  String title;
@override final  String? message;
@override@JsonKey(name: 'trigger_time') final  DateTime triggerTime;
@override@JsonKey(name: 'is_sent') final  bool isSent;
@override@JsonKey(name: 'task_id') final  String? taskId;
@override@JsonKey(name: 'activity_id') final  String? activityId;
@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;
@override@JsonKey(name: 'is_deleted') final  bool isDeleted;

/// Create a copy of ReminderModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReminderModelCopyWith<_ReminderModel> get copyWith => __$ReminderModelCopyWithImpl<_ReminderModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReminderModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReminderModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.message, message) || other.message == message)&&(identical(other.triggerTime, triggerTime) || other.triggerTime == triggerTime)&&(identical(other.isSent, isSent) || other.isSent == isSent)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.activityId, activityId) || other.activityId == activityId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,message,triggerTime,isSent,taskId,activityId,userId,updatedAt,isDeleted);

@override
String toString() {
  return 'ReminderModel(id: $id, title: $title, message: $message, triggerTime: $triggerTime, isSent: $isSent, taskId: $taskId, activityId: $activityId, userId: $userId, updatedAt: $updatedAt, isDeleted: $isDeleted)';
}


}

/// @nodoc
abstract mixin class _$ReminderModelCopyWith<$Res> implements $ReminderModelCopyWith<$Res> {
  factory _$ReminderModelCopyWith(_ReminderModel value, $Res Function(_ReminderModel) _then) = __$ReminderModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String? message,@JsonKey(name: 'trigger_time') DateTime triggerTime,@JsonKey(name: 'is_sent') bool isSent,@JsonKey(name: 'task_id') String? taskId,@JsonKey(name: 'activity_id') String? activityId,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'updated_at') DateTime? updatedAt,@JsonKey(name: 'is_deleted') bool isDeleted
});




}
/// @nodoc
class __$ReminderModelCopyWithImpl<$Res>
    implements _$ReminderModelCopyWith<$Res> {
  __$ReminderModelCopyWithImpl(this._self, this._then);

  final _ReminderModel _self;
  final $Res Function(_ReminderModel) _then;

/// Create a copy of ReminderModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? message = freezed,Object? triggerTime = null,Object? isSent = null,Object? taskId = freezed,Object? activityId = freezed,Object? userId = null,Object? updatedAt = freezed,Object? isDeleted = null,}) {
  return _then(_ReminderModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,triggerTime: null == triggerTime ? _self.triggerTime : triggerTime // ignore: cast_nullable_to_non_nullable
as DateTime,isSent: null == isSent ? _self.isSent : isSent // ignore: cast_nullable_to_non_nullable
as bool,taskId: freezed == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String?,activityId: freezed == activityId ? _self.activityId : activityId // ignore: cast_nullable_to_non_nullable
as String?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
