import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uasleep/features/calculator/domain/value_objects/measurement_units.dart';
import 'package:uasleep/features/calculator/presentation/cubit/calculator_cubit.dart';
import 'package:uasleep/features/calculator/presentation/cubit/calculator_state.dart';

void main() {
  group('CalculatorCubit', () {
    test('has an empty, sleep-enabled initial state', () {
      final CalculatorCubit cubit = CalculatorCubit();
      expect(cubit.state, const CalculatorState());
      expect(cubit.state.sleepEnabled, isTrue);
      expect(cubit.state.result, isNull);
      cubit.close();
    });

    blocTest<CalculatorCubit, CalculatorState>(
      'updates a field and clears prior output',
      build: CalculatorCubit.new,
      act: (CalculatorCubit cubit) => cubit.batteryCapacityChanged('2,5'),
      expect: () => <CalculatorState>[
        const CalculatorState(
          status: CalculatorStatus.editing,
          batteryCapacity: '2,5',
        ),
      ],
    );

    blocTest<CalculatorCubit, CalculatorState>(
      'updates measurement units',
      build: CalculatorCubit.new,
      act: (CalculatorCubit cubit) {
        cubit.batteryCapacityUnitChanged(BatteryCapacityUnit.ampereHour);
        cubit.activeCurrentUnitChanged(CurrentUnit.ampere);
        cubit.activeDurationUnitChanged(TimeUnit.millisecond);
      },
      verify: (CalculatorCubit cubit) {
        expect(cubit.state.batteryCapacityUnit, BatteryCapacityUnit.ampereHour);
        expect(cubit.state.activeCurrentUnit, CurrentUnit.ampere);
        expect(cubit.state.activeDurationUnit, TimeUnit.millisecond);
      },
    );

    blocTest<CalculatorCubit, CalculatorState>(
      'calculates a valid sleep profile',
      build: CalculatorCubit.new,
      act: (CalculatorCubit cubit) {
        cubit
          ..batteryCapacityChanged('2000')
          ..activeCurrentChanged('20')
          ..sleepCurrentChanged('10')
          ..activeDurationChanged('1')
          ..wakeupsPerHourChanged('60')
          ..calculate();
      },
      skip: 5,
      expect: () => <Matcher>[
        isA<CalculatorState>()
            .having(
              (CalculatorState state) => state.status,
              'status',
              CalculatorStatus.success,
            )
            .having(
              (CalculatorState state) => state.result?.hours,
              'hours',
              closeTo(5828.071879669743, 1e-6),
            ),
      ],
    );

    blocTest<CalculatorCubit, CalculatorState>(
      'reports all missing required fields',
      build: CalculatorCubit.new,
      act: (CalculatorCubit cubit) => cubit.calculate(),
      expect: () => <Matcher>[
        isA<CalculatorState>()
            .having(
              (CalculatorState state) => state.status,
              'status',
              CalculatorStatus.invalid,
            )
            .having(
              (CalculatorState state) => state.issues.length,
              'issues',
              5,
            ),
      ],
    );

    blocTest<CalculatorCubit, CalculatorState>(
      'calculates without sleep using only capacity and active current',
      build: CalculatorCubit.new,
      act: (CalculatorCubit cubit) {
        cubit
          ..sleepEnabledChanged(value: false)
          ..batteryCapacityChanged('1000')
          ..activeCurrentChanged('100')
          ..calculate();
      },
      skip: 3,
      expect: () => <Matcher>[
        isA<CalculatorState>().having(
          (CalculatorState state) => state.result?.hours,
          'hours',
          10,
        ),
      ],
    );

    blocTest<CalculatorCubit, CalculatorState>(
      'maps an overlong active period to the duration field',
      build: CalculatorCubit.new,
      act: (CalculatorCubit cubit) {
        cubit
          ..batteryCapacityChanged('1000')
          ..activeCurrentChanged('10')
          ..sleepCurrentChanged('0')
          ..activeDurationChanged('61')
          ..wakeupsPerHourChanged('60')
          ..calculate();
      },
      skip: 5,
      expect: () => <Matcher>[
        isA<CalculatorState>().having(
          (CalculatorState state) =>
              state.errorFor(CalculatorField.activeDuration),
          'duration error',
          CalculatorInputError.activeDurationExceedsCycle,
        ),
      ],
    );

    blocTest<CalculatorCubit, CalculatorState>(
      'rejects a non-finite value',
      build: CalculatorCubit.new,
      act: (CalculatorCubit cubit) {
        cubit
          ..sleepEnabledChanged(value: false)
          ..batteryCapacityChanged('Infinity')
          ..activeCurrentChanged('10')
          ..calculate();
      },
      skip: 3,
      expect: () => <Matcher>[
        isA<CalculatorState>().having(
          (CalculatorState state) =>
              state.errorFor(CalculatorField.batteryCapacity),
          'capacity error',
          CalculatorInputError.nonFinite,
        ),
      ],
    );

    blocTest<CalculatorCubit, CalculatorState>(
      'warns about potentially unrealistic scales',
      build: CalculatorCubit.new,
      act: (CalculatorCubit cubit) {
        cubit
          ..sleepEnabledChanged(value: false)
          ..batteryCapacityChanged('10000001')
          ..activeCurrentChanged('1')
          ..calculate();
      },
      skip: 3,
      verify: (CalculatorCubit cubit) {
        expect(cubit.state.warnings, const <CalculatorWarning>[
          CalculatorWarning.potentiallyUnrealistic,
        ]);
      },
    );

    blocTest<CalculatorCubit, CalculatorState>(
      'resets every field and result',
      build: CalculatorCubit.new,
      act: (CalculatorCubit cubit) {
        cubit
          ..batteryCapacityChanged('1000')
          ..reset();
      },
      skip: 1,
      expect: () => <CalculatorState>[const CalculatorState()],
    );
  });
}
