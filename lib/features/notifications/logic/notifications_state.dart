import 'package:equatable/equatable.dart';

class NotificationsState extends Equatable {
  final bool enabled;
  final bool isLoading;
  const NotificationsState({this.enabled = true, this.isLoading = true});

  @override
  List<Object?> get props => [enabled, isLoading];
}