import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_model.freezed.dart';
part 'task_model.g.dart';

@freezed
<<<<<<< Updated upstream
abstract class TaskModel with _$TaskModel {
=======
class TaskModel with _$TaskModel {
>>>>>>> Stashed changes
  const factory TaskModel({
    required String id,
    required String title,
    @Default('') String description,
    @JsonKey(name: 'is_completed') @Default(false) bool isCompleted,
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'list_id') String? listId,
<<<<<<< Updated upstream
=======
    String? deadline,
    @JsonKey(name: 'remind_via_email') @Default(false) bool remindViaEmail,
>>>>>>> Stashed changes
    @JsonKey(name: 'updated_at') String? updatedAt,
    @JsonKey(name: 'is_deleted') @Default(false) bool isDeleted,
  }) = _TaskModel;

  factory TaskModel.fromJson(Map<String, dynamic> json) => _$TaskModelFromJson(json);
}
