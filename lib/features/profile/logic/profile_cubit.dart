import 'package:flutter_application_1/features/profile/data/repo/profile_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/features/profile/logic/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo _repo;
  ProfileCubit(this._repo) : super(ProfileLoading());

  Future<void> load() async {
    if (state is! ProfileSuccess) emit(ProfileLoading());
    try {
      emit(ProfileSuccess(await _repo.getProfile()));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> clearCache() => _repo.clearCache();

  Future<void> logout() => _repo.logout();
}