import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/core/selection/option_model.dart';
import 'package:flutter_application_1/core/selection/selection_state.dart';

class SelectionCubit extends Cubit<SelectionState> {
  final Future<List<OptionModel>> Function() _loader;
  final Future<String> Function() _getSelected;
  final Future<void> Function(String) _save;

  SelectionCubit(this._loader, this._getSelected, this._save)
      : super(SelectionLoading());

  Future<void> load() async {
    emit(SelectionLoading());
    try {
      final options = await _loader();
      final selected = await _getSelected();
      emit(SelectionLoaded(options: options, selectedId: selected));
    } catch (e) {
      emit(SelectionError(e.toString()));
    }
  }

  Future<void> select(String id) async {
    final current = state;
    if (current is! SelectionLoaded || current.selectedId == id) return;
    emit(SelectionLoaded(options: current.options, selectedId: id));
    await _save(id);
  }
}
