import 'package:flutter_application_1/core/networking/api_constants.dart';


class UserModel {
  final int id;
  final String name;
  final String username;
  final String? avatarPath;
  final String? gravatarHash;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    this.avatarPath,
    this.gravatarHash,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        name: (json['name'] as String?)?.isNotEmpty == true ? json['name'] : json['username'],
        username: json['username'] ?? '',
        avatarPath: json['avatar']?['tmdb']?['avatar_path'],
        gravatarHash: json['avatar']?['gravatar']?['hash'],
      );

  String get avatarUrl => avatarPath != null
      ? '${ApiConstants.imageBase}/w200$avatarPath'
      : 'https://www.gravatar.com/avatar/$gravatarHash?s=200&d=identicon';
}