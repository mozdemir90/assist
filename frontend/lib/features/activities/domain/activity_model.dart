import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_model.freezed.dart';
part 'activity_model.g.dart';

@freezed
class ActivityModel with _$ActivityModel {
  const factory ActivityModel({
    required String id,
    required String title,
    @Default('') String description,
    @JsonKey(name: 'start_time') String? startTime,
    @JsonKey(name: 'end_time') String? endTime,
    int? duration, // in seconds
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'updated_at') String? updatedAt,
    @JsonKey(name: 'is_deleted') @Default(false) bool isDeleted,
  }) = _ActivityModel;

  factory ActivityModel.fromJson(Map<String, dynamic> json) => _$ActivityModelFromJson(json);
}
