import 'package:flutter_application_1/features/profile/data/model/profile_model.dart';
import 'package:flutter_application_1/features/profile/data/repo/profile_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/features/edit_profile/logic/edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  final ProfileRepo _repo;
  final ProfileModel initial; 
  EditProfileCubit(this._repo, this.initial) : super(const EditProfileState());

  Future<void> save({
    required String name,
    required String email,
    required String phone,
  }) async {
    final n = name.trim(), e = email.trim(), p = phone.trim();
    if (n.isEmpty) {
      emit(const EditProfileState(error: 'Full name is required'));
      return;
    }
    if (e.isNotEmpty && !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(e)) {
      emit(const EditProfileState(error: 'Enter a valid email'));
      return;
    }
    emit(const EditProfileState(isSaving: true));
    try {
      await _repo.saveProfile(initial.copyWith(name: n, email: e, phone: p));
      emit(const EditProfileState(saved: true));
    } catch (err) {
      emit(EditProfileState(error: err.toString()));
    }
  }
}