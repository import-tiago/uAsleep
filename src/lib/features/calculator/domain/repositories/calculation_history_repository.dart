import '../entities/calculation_history_entry.dart';

abstract interface class CalculationHistoryRepository {
  Future<void> add(CalculationHistoryEntry entry);

  Future<void> clear();

  Future<List<CalculationHistoryEntry>> load();
}
