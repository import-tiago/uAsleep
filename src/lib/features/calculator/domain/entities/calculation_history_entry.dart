import 'package:equatable/equatable.dart';

import 'battery_life_result.dart';
import 'battery_usage_profile.dart';

class CalculationHistoryEntry extends Equatable {
  const CalculationHistoryEntry({
    required this.id,
    required this.createdAt,
    required this.profile,
    required this.result,
  });

  final String id;
  final DateTime createdAt;
  final BatteryUsageProfile profile;
  final BatteryLifeResult result;

  @override
  List<Object> get props => <Object>[id, createdAt, profile, result];
}
