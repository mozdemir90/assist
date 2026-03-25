import 'package:freezed_annotation/freezed_annotation.dart';

part 'list_model.freezed.dart';
part 'list_model.g.dart';

@freezed
abstract class ListModel with _$ListModel {
  const factory ListModel({
    required String id,
    required String name,
    required String color,
  }) = _ListModel;

  factory ListModel.fromJson(Map<String, dynamic> json) =>
      _$ListModelFromJson(json);
}
