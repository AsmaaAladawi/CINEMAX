import 'package:equatable/equatable.dart';

class EditProfileState extends Equatable {
  final bool isSaving;
  final bool saved;
  final String? error;

  const EditProfileState({this.isSaving = false, this.saved = false, this.error});

  @override
  List<Object?> get props => [isSaving, saved, error];
}