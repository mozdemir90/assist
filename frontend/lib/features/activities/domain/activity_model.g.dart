// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ActivityModel _$ActivityModelFromJson(Map<String, dynamic> json) =>
    _ActivityModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      startTime: json['start_time'] as String?,
      endTime: json['end_time'] as String?,
      duration: (json['duration'] as num?)?.toInt(),
      userId: json['user_id'] as String?,
      updatedAt: json['updated_at'] as String?,
      isDeleted: json['is_deleted'] as bool? ?? false,
    );

Map<String, dynamic> _$ActivityModelToJson(_ActivityModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'duration': instance.duration,
      'user_id': instance.userId,
      'updated_at': instance.updatedAt,
      'is_deleted': instance.isDeleted,
    };
