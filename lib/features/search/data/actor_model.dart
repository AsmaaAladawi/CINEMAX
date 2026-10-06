import 'package:flutter_application_1/core/networking/api_constants.dart';

class ActorModel {
  final int id;
  final String name;
  final String? profilePath;

  ActorModel({required this.id, required this.name, this.profilePath});

  factory ActorModel.fromJson(Map<String, dynamic> json) => ActorModel(
        id: json['id'],
        name: json['name'] ?? '',
        profilePath: json['profile_path'],
      );

  String? get profileUrl =>
      profilePath == null ? null : '${ApiConstants.imageBase}/w185$profilePath';
}