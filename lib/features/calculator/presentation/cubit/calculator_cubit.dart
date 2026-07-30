import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/validation/localized_number_parser.dart';
import '../../domain/entities/battery_usage_profile.dart';
import '../../domain/errors/battery_life_exception.dart';
import '../../domain/services/battery_life_calculator.dart';
import '../../domain/value_objects/measurement_units.dart';
import 'calculator_state.dart';

class CalculatorCubit extends Cubit<CalculatorState> {
  factory CalculatorCubit({
    BatteryLifeCalculator calculator = const BatteryLifeCalculator(),
    LocalizedNumberParser parser = const LocalizedNumberParser(),
  }) {
    return CalculatorCubit._(calculator, parser);
  }

  CalculatorCubit._(this._calculator, this._parser)
    : super(const CalculatorState());

  final BatteryLifeCalculator _calculator;
  final LocalizedNumberParser _parser;

  void batteryCapacityChanged(String value) {
    emit(_editing(state.copyWith(batteryCapacity: value)));
  }

  void batteryCapacityUnitChanged(BatteryCapacityUnit value) {
    emit(_editing(state.copyWith(batteryCapacityUnit: value)));
  }

  void activeCurrentChanged(String value) {
    emit(_editing(state.copyWith(activeCurrent: value)));
  }

  void activeCurrentUnitChanged(CurrentUnit value) {
    emit(_editing(state.copyWith(activeCurrentUnit: value)));
  }

  void sleepEnabledChanged({required bool value}) {
    emit(_editing(state.copyWith(sleepEnabled: value)));
  }

  void sleepCurrentChanged(String value) {
    emit(_editing(state.copyWith(sleepCurrent: value)));
  }

  void sleepCurrentUnitChanged(CurrentUnit value) {
    emit(_editing(state.copyWith(sleepCurrentUnit: value)));
  }

  void activeDurationChanged(String value) {
    emit(_editing(state.copyWith(activeDuration: value)));
  }

  void activeDurationUnitChanged(TimeUnit value) {
    emit(_editing(state.copyWith(activeDurationUnit: value)));
  }

  void wakeupsPerHourChanged(String value) {
    emit(_editing(state.copyWith(wakeupsPerHour: value)));
  }

  void reset() => emit(const CalculatorState());

  void calculate() {
    final List<CalculatorIssue> issues = <CalculatorIssue>[];
    final double? capacity = _requiredNumber(
      state.batteryCapacity,
      CalculatorField.batteryCapacity,
      issues,
    );
    final double? activeCurrent = _requiredNumber(
      state.activeCurrent,
      CalculatorField.activeCurrent,
      issues,
    );
    final double? sleepCurrent = state.sleepEnabled
        ? _requiredNumber(
            state.sleepCurrent,
            CalculatorField.sleepCurrent,
            issues,
          )
        : 0;
    final double? activeDuration = state.sleepEnabled
        ? _requiredNumber(
            state.activeDuration,
            CalculatorField.activeDuration,
            issues,
          )
        : 1;
    final double? wakeups = state.sleepEnabled
        ? _requiredNumber(
            state.wakeupsPerHour,
            CalculatorField.wakeupsPerHour,
            issues,
          )
        : 1;

    if (issues.isNotEmpty) {
      emit(
        state.copyWith(
          status: CalculatorStatus.invalid,
          clearResult: true,
          issues: issues,
          warnings: const <CalculatorWarning>[],
        ),
      );
      return;
    }
    if (capacity == null ||
        activeCurrent == null ||
        sleepCurrent == null ||
        activeDuration == null ||
        wakeups == null) {
      return;
    }

    final BatteryUsageProfile profile = BatteryUsageProfile(
      batteryCapacity: capacity,
      batteryCapacityUnit: state.batteryCapacityUnit,
      activeCurrent: activeCurrent,
      activeCurrentUnit: state.activeCurrentUnit,
      sleepEnabled: state.sleepEnabled,
      sleepCurrent: sleepCurrent,
      sleepCurrentUnit: state.sleepCurrentUnit,
      activeDuration: activeDuration,
      activeDurationUnit: state.activeDurationUnit,
      wakeupsPerHour: wakeups,
    );

    try {
      final result = _calculator.calculate(profile);
      emit(
        state.copyWith(
          status: CalculatorStatus.success,
          result: result,
          issues: const <CalculatorIssue>[],
          warnings: _warningsFor(profile, result.hours),
        ),
      );
    } on BatteryLifeException catch (error) {
      emit(
        state.copyWith(
          status: CalculatorStatus.invalid,
          clearResult: true,
          issues: <CalculatorIssue>[_issueFor(error.code)],
          warnings: const <CalculatorWarning>[],
        ),
      );
    }
  }

  CalculatorState _editing(CalculatorState next) {
    return next.copyWith(
      status: CalculatorStatus.editing,
      clearResult: true,
      issues: const <CalculatorIssue>[],
      warnings: const <CalculatorWarning>[],
    );
  }

  double? _requiredNumber(
    String input,
    CalculatorField field,
    List<CalculatorIssue> issues,
  ) {
    if (input.trim().isEmpty) {
      issues.add(
        CalculatorIssue(field: field, error: CalculatorInputError.required),
      );
      return null;
    }
    final double? value = _parser.parse(input);
    if (value == null) {
      issues.add(
        CalculatorIssue(
          field: field,
          error: CalculatorInputError.invalidNumber,
        ),
      );
      return null;
    }
    if (!value.isFinite) {
      issues.add(
        CalculatorIssue(field: field, error: CalculatorInputError.nonFinite),
      );
      return null;
    }
    return value;
  }

  CalculatorIssue _issueFor(BatteryLifeErrorCode code) {
    return switch (code) {
      BatteryLifeErrorCode.nonFiniteValue => const CalculatorIssue(
        field: CalculatorField.form,
        error: CalculatorInputError.nonFinite,
      ),
      BatteryLifeErrorCode.nonPositiveCapacity => const CalculatorIssue(
        field: CalculatorField.batteryCapacity,
        error: CalculatorInputError.mustBePositive,
      ),
      BatteryLifeErrorCode.negativeCurrent => CalculatorIssue(
        field: _negativeCurrentField(),
        error: CalculatorInputError.cannotBeNegative,
      ),
      BatteryLifeErrorCode.nonPositiveActiveDuration => const CalculatorIssue(
        field: CalculatorField.activeDuration,
        error: CalculatorInputError.mustBePositive,
      ),
      BatteryLifeErrorCode.nonPositiveWakeupFrequency => const CalculatorIssue(
        field: CalculatorField.wakeupsPerHour,
        error: CalculatorInputError.mustBePositive,
      ),
      BatteryLifeErrorCode.activeDurationExceedsCycle => const CalculatorIssue(
        field: CalculatorField.activeDuration,
        error: CalculatorInputError.activeDurationExceedsCycle,
      ),
      BatteryLifeErrorCode.zeroAverageCurrent => const CalculatorIssue(
        field: CalculatorField.form,
        error: CalculatorInputError.zeroAverageCurrent,
      ),
    };
  }

  CalculatorField _negativeCurrentField() {
    final double? active = _parser.parse(state.activeCurrent);
    if (active != null && active < 0) {
      return CalculatorField.activeCurrent;
    }
    return CalculatorField.sleepCurrent;
  }

  List<CalculatorWarning> _warningsFor(
    BatteryUsageProfile profile,
    double resultHours,
  ) {
    final double capacityMah = profile.batteryCapacityUnit.toMilliampereHours(
      profile.batteryCapacity,
    );
    final double activeCurrentMa = profile.activeCurrentUnit.toMilliamperes(
      profile.activeCurrent,
    );
    if (capacityMah > 10000000 ||
        activeCurrentMa > 1000000 ||
        resultHours > 876000) {
      return const <CalculatorWarning>[
        CalculatorWarning.potentiallyUnrealistic,
      ];
    }
    return const <CalculatorWarning>[];
  }
}
