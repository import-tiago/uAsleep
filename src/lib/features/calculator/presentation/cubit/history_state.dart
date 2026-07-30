import 'package:equatable/equatable.dart';

import '../../domain/entities/calculation_history_entry.dart';

enum HistoryStatus { loading, ready, failure }

class HistoryState extends Equatable {
  const HistoryState({
    this.status = HistoryStatus.loading,
    this.entries = const <CalculationHistoryEntry>[],
  });

  final HistoryStatus status;
  final List<CalculationHistoryEntry> entries;

  @override
  List<Object> get props => <Object>[status, entries];
}
