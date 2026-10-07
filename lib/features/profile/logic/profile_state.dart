import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/features/profile/data/model/profile_model.dart';

sealed class ProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileLoading extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
  @override
  List<Object?> get props => [message];
}

class ProfileSuccess extends ProfileState {
  final ProfileModel profile;
  ProfileSuccess(this.profile);
  @override
  List<Object?> get props => [profile];
}