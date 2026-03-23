import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
<<<<<<< Updated upstream
abstract class User with _$User {
=======
class User with _$User {
>>>>>>> Stashed changes
  const factory User({
    required String id,
    required String username,
    required String email,
<<<<<<< Updated upstream
    @JsonKey(name: 'is_active') required bool isActive,
=======
    required bool isActive,
>>>>>>> Stashed changes
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
