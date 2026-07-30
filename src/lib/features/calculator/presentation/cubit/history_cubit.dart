import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/calculation_history_entry.dart';
import '../../domain/repositories/calculation_history_repository.dart';
import 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit(this._repository) : super(const HistoryState());

  final CalculationHistoryRepository _repository;

  Future<void> clear() async {
    try {
      await _repository.clear();
      emit(const HistoryState(status: HistoryStatus.ready));
    } on Exception {
      emit(HistoryState(status: HistoryStatus.failure, entries: state.entries));
    }
  }

  Future<void> load() async {
    emit(HistoryState(entries: state.entries));
    try {
      final List<CalculationHistoryEntry> entries = await _repository.load();
      emit(HistoryState(status: HistoryStatus.ready, entries: entries));
    } on Exception {
      emit(HistoryState(status: HistoryStatus.failure, entries: state.entries));
    }
  }
}
