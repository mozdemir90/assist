// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReminderModel _$ReminderModelFromJson(Map<String, dynamic> json) =>
    _ReminderModel(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String?,
      triggerTime: DateTime.parse(json['trigger_time'] as String),
      isSent: json['is_sent'] as bool? ?? false,
      taskId: json['task_id'] as String?,
      activityId: json['activity_id'] as String?,
      userId: json['user_id'] as String,
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      isDeleted: json['is_deleted'] as bool? ?? false,
    );

Map<String, dynamic> _$ReminderModelToJson(_ReminderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'message': instance.message,
      'trigger_time': instance.triggerTime.toIso8601String(),
      'is_sent': instance.isSent,
      'task_id': instance.taskId,
      'activity_id': instance.activityId,
      'user_id': instance.userId,
      'updated_at': instance.updatedAt?.toIso8601String(),
      'is_deleted': instance.isDeleted,
    };
