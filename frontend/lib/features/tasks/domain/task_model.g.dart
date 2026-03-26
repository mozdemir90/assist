// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TaskModel _$TaskModelFromJson(Map<String, dynamic> json) => _TaskModel(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String? ?? '',
  isCompleted: json['is_completed'] as bool? ?? false,
  userId: json['user_id'] as String?,
  listId: json['list_id'] as String?,
  updatedAt: json['updated_at'] as String?,
  isDeleted: json['is_deleted'] as bool? ?? false,
);

Map<String, dynamic> _$TaskModelToJson(_TaskModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'is_completed': instance.isCompleted,
      'user_id': instance.userId,
      'list_id': instance.listId,
      'updated_at': instance.updatedAt,
      'is_deleted': instance.isDeleted,
    };
