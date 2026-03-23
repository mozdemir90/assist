import 'package:freezed_annotation/freezed_annotation.dart';

part 'list_model.freezed.dart';
part 'list_model.g.dart';

@freezed
<<<<<<< Updated upstream
abstract class ListModel with _$ListModel {
=======
class ListModel with _$ListModel {
>>>>>>> Stashed changes
  const factory ListModel({
    required String id,
    required String name,
    required String color,
  }) = _ListModel;

  factory ListModel.fromJson(Map<String, dynamic> json) => _$ListModelFromJson(json);
}
