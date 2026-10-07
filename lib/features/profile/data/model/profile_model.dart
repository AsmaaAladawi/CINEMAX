import 'package:equatable/equatable.dart';

class ProfileModel extends Equatable {
  final String name;
  final String email;
  final String phone;
  final String avatarUrl;

  const ProfileModel({
    required this.name,
    required this.avatarUrl,
    this.email = '',
    this.phone = '',
  });

  ProfileModel copyWith({String? name, String? email, String? phone}) =>
      ProfileModel(
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        avatarUrl: avatarUrl,
      );

  @override
  List<Object?> get props => [name, email, phone, avatarUrl];
}