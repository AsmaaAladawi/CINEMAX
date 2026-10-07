import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/core/selection/option_model.dart';

sealed class SelectionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SelectionLoading extends SelectionState {}

class SelectionError extends SelectionState {
  final String message;
  SelectionError(this.message);
  @override
  List<Object?> get props => [message];
}

class SelectionLoaded extends SelectionState {
  final List<OptionModel> options;
  final String selectedId;
  SelectionLoaded({required this.options, required this.selectedId});

  @override
  List<Object?> get props => [options.length, selectedId];
}