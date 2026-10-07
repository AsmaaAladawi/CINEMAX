import 'package:flutter_application_1/features/notifications/data/notifications_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/features/notifications/logic/notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepo _repo;
  NotificationsCubit(this._repo) : super(const NotificationsState());

  Future<void> load() async => emit(
      NotificationsState(enabled: await _repo.getEnabled(), isLoading: false));

  Future<void> toggle(bool value) async {
    emit(NotificationsState(enabled: value, isLoading: false));
    await _repo.setEnabled(value);
  }
}