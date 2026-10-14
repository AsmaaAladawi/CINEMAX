import 'package:equatable/equatable.dart';

class OptionModel extends Equatable {
  final String id;
  final String label;
  const OptionModel({required this.id, required this.label});

  @override
  List<Object?> get props => [id, label];
}