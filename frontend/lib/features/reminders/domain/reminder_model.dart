import 'package:freezed_annotation/freezed_annotation.dart';

part 'reminder_model.freezed.dart';
part 'reminder_model.g.dart';

@freezed
abstract class ReminderModel with _$ReminderModel {
  const factory ReminderModel({
    required String id,
    required String title,
    String? message,
    @JsonKey(name: 'trigger_time') required DateTime triggerTime,
    @JsonKey(name: 'is_sent') @Default(false) bool isSent,
    @JsonKey(name: 'task_id') String? taskId,
    @JsonKey(name: 'activity_id') String? activityId,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'is_deleted') @Default(false) bool isDeleted,
  }) = _ReminderModel;

  factory ReminderModel.fromJson(Map<String, dynamic> json) => _$ReminderModelFromJson(json);
}
