// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: json['id'] as String,
  username: json['username'] as String,
  email: json['email'] as String,
<<<<<<< Updated upstream
  isActive: json['is_active'] as bool,
=======
  isActive: json['isActive'] as bool,
>>>>>>> Stashed changes
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'email': instance.email,
<<<<<<< Updated upstream
  'is_active': instance.isActive,
=======
  'isActive': instance.isActive,
>>>>>>> Stashed changes
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};
