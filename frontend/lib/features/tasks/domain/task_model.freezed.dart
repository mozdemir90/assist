// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TaskModel {

<<<<<<< Updated upstream
 String get id; String get title; String get description;@JsonKey(name: 'is_completed') bool get isCompleted;@JsonKey(name: 'user_id') String? get userId;@JsonKey(name: 'list_id') String? get listId;@JsonKey(name: 'updated_at') String? get updatedAt;@JsonKey(name: 'is_deleted') bool get isDeleted;
=======
 String get id; String get title; String get description;@JsonKey(name: 'is_completed') bool get isCompleted;@JsonKey(name: 'user_id') String? get userId;@JsonKey(name: 'list_id') String? get listId; String? get deadline;@JsonKey(name: 'remind_via_email') bool get remindViaEmail;@JsonKey(name: 'updated_at') String? get updatedAt;@JsonKey(name: 'is_deleted') bool get isDeleted;
>>>>>>> Stashed changes
/// Create a copy of TaskModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskModelCopyWith<TaskModel> get copyWith => _$TaskModelCopyWithImpl<TaskModel>(this as TaskModel, _$identity);

  /// Serializes this TaskModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
<<<<<<< Updated upstream
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.listId, listId) || other.listId == listId)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted));
=======
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.listId, listId) || other.listId == listId)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.remindViaEmail, remindViaEmail) || other.remindViaEmail == remindViaEmail)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted));
>>>>>>> Stashed changes
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
<<<<<<< Updated upstream
int get hashCode => Object.hash(runtimeType,id,title,description,isCompleted,userId,listId,updatedAt,isDeleted);

@override
String toString() {
  return 'TaskModel(id: $id, title: $title, description: $description, isCompleted: $isCompleted, userId: $userId, listId: $listId, updatedAt: $updatedAt, isDeleted: $isDeleted)';
=======
int get hashCode => Object.hash(runtimeType,id,title,description,isCompleted,userId,listId,deadline,remindViaEmail,updatedAt,isDeleted);

@override
String toString() {
  return 'TaskModel(id: $id, title: $title, description: $description, isCompleted: $isCompleted, userId: $userId, listId: $listId, deadline: $deadline, remindViaEmail: $remindViaEmail, updatedAt: $updatedAt, isDeleted: $isDeleted)';
>>>>>>> Stashed changes
}


}

/// @nodoc
abstract mixin class $TaskModelCopyWith<$Res>  {
  factory $TaskModelCopyWith(TaskModel value, $Res Function(TaskModel) _then) = _$TaskModelCopyWithImpl;
@useResult
$Res call({
<<<<<<< Updated upstream
 String id, String title, String description,@JsonKey(name: 'is_completed') bool isCompleted,@JsonKey(name: 'user_id') String? userId,@JsonKey(name: 'list_id') String? listId,@JsonKey(name: 'updated_at') String? updatedAt,@JsonKey(name: 'is_deleted') bool isDeleted
=======
 String id, String title, String description,@JsonKey(name: 'is_completed') bool isCompleted,@JsonKey(name: 'user_id') String? userId,@JsonKey(name: 'list_id') String? listId, String? deadline,@JsonKey(name: 'remind_via_email') bool remindViaEmail,@JsonKey(name: 'updated_at') String? updatedAt,@JsonKey(name: 'is_deleted') bool isDeleted
>>>>>>> Stashed changes
});




}
/// @nodoc
class _$TaskModelCopyWithImpl<$Res>
    implements $TaskModelCopyWith<$Res> {
  _$TaskModelCopyWithImpl(this._self, this._then);

  final TaskModel _self;
  final $Res Function(TaskModel) _then;

/// Create a copy of TaskModel
/// with the given fields replaced by the non-null parameter values.
<<<<<<< Updated upstream
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? isCompleted = null,Object? userId = freezed,Object? listId = freezed,Object? updatedAt = freezed,Object? isDeleted = null,}) {
=======
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? isCompleted = null,Object? userId = freezed,Object? listId = freezed,Object? deadline = freezed,Object? remindViaEmail = null,Object? updatedAt = freezed,Object? isDeleted = null,}) {
>>>>>>> Stashed changes
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,listId: freezed == listId ? _self.listId : listId // ignore: cast_nullable_to_non_nullable
<<<<<<< Updated upstream
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
=======
as String?,deadline: freezed == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as String?,remindViaEmail: null == remindViaEmail ? _self.remindViaEmail : remindViaEmail // ignore: cast_nullable_to_non_nullable
as bool,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
>>>>>>> Stashed changes
as String?,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskModel].
extension TaskModelPatterns on TaskModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskModel value)  $default,){
final _that = this;
switch (_that) {
case _TaskModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskModel value)?  $default,){
final _that = this;
switch (_that) {
case _TaskModel() when $default != null:
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

<<<<<<< Updated upstream
@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String description, @JsonKey(name: 'is_completed')  bool isCompleted, @JsonKey(name: 'user_id')  String? userId, @JsonKey(name: 'list_id')  String? listId, @JsonKey(name: 'updated_at')  String? updatedAt, @JsonKey(name: 'is_deleted')  bool isDeleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskModel() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.isCompleted,_that.userId,_that.listId,_that.updatedAt,_that.isDeleted);case _:
=======
@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String description, @JsonKey(name: 'is_completed')  bool isCompleted, @JsonKey(name: 'user_id')  String? userId, @JsonKey(name: 'list_id')  String? listId,  String? deadline, @JsonKey(name: 'remind_via_email')  bool remindViaEmail, @JsonKey(name: 'updated_at')  String? updatedAt, @JsonKey(name: 'is_deleted')  bool isDeleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskModel() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.isCompleted,_that.userId,_that.listId,_that.deadline,_that.remindViaEmail,_that.updatedAt,_that.isDeleted);case _:
>>>>>>> Stashed changes
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

<<<<<<< Updated upstream
@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String description, @JsonKey(name: 'is_completed')  bool isCompleted, @JsonKey(name: 'user_id')  String? userId, @JsonKey(name: 'list_id')  String? listId, @JsonKey(name: 'updated_at')  String? updatedAt, @JsonKey(name: 'is_deleted')  bool isDeleted)  $default,) {final _that = this;
switch (_that) {
case _TaskModel():
return $default(_that.id,_that.title,_that.description,_that.isCompleted,_that.userId,_that.listId,_that.updatedAt,_that.isDeleted);case _:
=======
@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String description, @JsonKey(name: 'is_completed')  bool isCompleted, @JsonKey(name: 'user_id')  String? userId, @JsonKey(name: 'list_id')  String? listId,  String? deadline, @JsonKey(name: 'remind_via_email')  bool remindViaEmail, @JsonKey(name: 'updated_at')  String? updatedAt, @JsonKey(name: 'is_deleted')  bool isDeleted)  $default,) {final _that = this;
switch (_that) {
case _TaskModel():
return $default(_that.id,_that.title,_that.description,_that.isCompleted,_that.userId,_that.listId,_that.deadline,_that.remindViaEmail,_that.updatedAt,_that.isDeleted);case _:
>>>>>>> Stashed changes
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

<<<<<<< Updated upstream
@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String description, @JsonKey(name: 'is_completed')  bool isCompleted, @JsonKey(name: 'user_id')  String? userId, @JsonKey(name: 'list_id')  String? listId, @JsonKey(name: 'updated_at')  String? updatedAt, @JsonKey(name: 'is_deleted')  bool isDeleted)?  $default,) {final _that = this;
switch (_that) {
case _TaskModel() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.isCompleted,_that.userId,_that.listId,_that.updatedAt,_that.isDeleted);case _:
=======
@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String description, @JsonKey(name: 'is_completed')  bool isCompleted, @JsonKey(name: 'user_id')  String? userId, @JsonKey(name: 'list_id')  String? listId,  String? deadline, @JsonKey(name: 'remind_via_email')  bool remindViaEmail, @JsonKey(name: 'updated_at')  String? updatedAt, @JsonKey(name: 'is_deleted')  bool isDeleted)?  $default,) {final _that = this;
switch (_that) {
case _TaskModel() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.isCompleted,_that.userId,_that.listId,_that.deadline,_that.remindViaEmail,_that.updatedAt,_that.isDeleted);case _:
>>>>>>> Stashed changes
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskModel implements TaskModel {
<<<<<<< Updated upstream
  const _TaskModel({required this.id, required this.title, this.description = '', @JsonKey(name: 'is_completed') this.isCompleted = false, @JsonKey(name: 'user_id') this.userId, @JsonKey(name: 'list_id') this.listId, @JsonKey(name: 'updated_at') this.updatedAt, @JsonKey(name: 'is_deleted') this.isDeleted = false});
=======
  const _TaskModel({required this.id, required this.title, this.description = '', @JsonKey(name: 'is_completed') this.isCompleted = false, @JsonKey(name: 'user_id') this.userId, @JsonKey(name: 'list_id') this.listId, this.deadline, @JsonKey(name: 'remind_via_email') this.remindViaEmail = false, @JsonKey(name: 'updated_at') this.updatedAt, @JsonKey(name: 'is_deleted') this.isDeleted = false});
>>>>>>> Stashed changes
  factory _TaskModel.fromJson(Map<String, dynamic> json) => _$TaskModelFromJson(json);

@override final  String id;
@override final  String title;
@override@JsonKey() final  String description;
@override@JsonKey(name: 'is_completed') final  bool isCompleted;
@override@JsonKey(name: 'user_id') final  String? userId;
@override@JsonKey(name: 'list_id') final  String? listId;
<<<<<<< Updated upstream
=======
@override final  String? deadline;
@override@JsonKey(name: 'remind_via_email') final  bool remindViaEmail;
>>>>>>> Stashed changes
@override@JsonKey(name: 'updated_at') final  String? updatedAt;
@override@JsonKey(name: 'is_deleted') final  bool isDeleted;

/// Create a copy of TaskModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskModelCopyWith<_TaskModel> get copyWith => __$TaskModelCopyWithImpl<_TaskModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskModelToJson(this, );
}

@override
bool operator ==(Object other) {
<<<<<<< Updated upstream
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.listId, listId) || other.listId == listId)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted));
=======
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.listId, listId) || other.listId == listId)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.remindViaEmail, remindViaEmail) || other.remindViaEmail == remindViaEmail)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted));
>>>>>>> Stashed changes
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
<<<<<<< Updated upstream
int get hashCode => Object.hash(runtimeType,id,title,description,isCompleted,userId,listId,updatedAt,isDeleted);

@override
String toString() {
  return 'TaskModel(id: $id, title: $title, description: $description, isCompleted: $isCompleted, userId: $userId, listId: $listId, updatedAt: $updatedAt, isDeleted: $isDeleted)';
=======
int get hashCode => Object.hash(runtimeType,id,title,description,isCompleted,userId,listId,deadline,remindViaEmail,updatedAt,isDeleted);

@override
String toString() {
  return 'TaskModel(id: $id, title: $title, description: $description, isCompleted: $isCompleted, userId: $userId, listId: $listId, deadline: $deadline, remindViaEmail: $remindViaEmail, updatedAt: $updatedAt, isDeleted: $isDeleted)';
>>>>>>> Stashed changes
}


}

/// @nodoc
abstract mixin class _$TaskModelCopyWith<$Res> implements $TaskModelCopyWith<$Res> {
  factory _$TaskModelCopyWith(_TaskModel value, $Res Function(_TaskModel) _then) = __$TaskModelCopyWithImpl;
@override @useResult
$Res call({
<<<<<<< Updated upstream
 String id, String title, String description,@JsonKey(name: 'is_completed') bool isCompleted,@JsonKey(name: 'user_id') String? userId,@JsonKey(name: 'list_id') String? listId,@JsonKey(name: 'updated_at') String? updatedAt,@JsonKey(name: 'is_deleted') bool isDeleted
=======
 String id, String title, String description,@JsonKey(name: 'is_completed') bool isCompleted,@JsonKey(name: 'user_id') String? userId,@JsonKey(name: 'list_id') String? listId, String? deadline,@JsonKey(name: 'remind_via_email') bool remindViaEmail,@JsonKey(name: 'updated_at') String? updatedAt,@JsonKey(name: 'is_deleted') bool isDeleted
>>>>>>> Stashed changes
});




}
/// @nodoc
class __$TaskModelCopyWithImpl<$Res>
    implements _$TaskModelCopyWith<$Res> {
  __$TaskModelCopyWithImpl(this._self, this._then);

  final _TaskModel _self;
  final $Res Function(_TaskModel) _then;

/// Create a copy of TaskModel
/// with the given fields replaced by the non-null parameter values.
<<<<<<< Updated upstream
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? isCompleted = null,Object? userId = freezed,Object? listId = freezed,Object? updatedAt = freezed,Object? isDeleted = null,}) {
=======
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? isCompleted = null,Object? userId = freezed,Object? listId = freezed,Object? deadline = freezed,Object? remindViaEmail = null,Object? updatedAt = freezed,Object? isDeleted = null,}) {
>>>>>>> Stashed changes
  return _then(_TaskModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,listId: freezed == listId ? _self.listId : listId // ignore: cast_nullable_to_non_nullable
<<<<<<< Updated upstream
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
=======
as String?,deadline: freezed == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as String?,remindViaEmail: null == remindViaEmail ? _self.remindViaEmail : remindViaEmail // ignore: cast_nullable_to_non_nullable
as bool,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
>>>>>>> Stashed changes
as String?,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
