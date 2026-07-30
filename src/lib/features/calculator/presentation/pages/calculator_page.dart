import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/router/app_router.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/services/result_exporter.dart';
import '../../../../features/settings/presentation/cubit/settings_cubit.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/calculation_history_entry.dart';
import '../../domain/value_objects/measurement_units.dart';
import '../cubit/calculator_cubit.dart';
import '../cubit/calculator_state.dart';
import '../formatters/calculation_presentation_formatter.dart';
import '../widgets/battery_result_card.dart';
import '../widgets/engineering_section.dart';
import '../widgets/numeric_fields.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({required this.resultExporter, super.key});

  final ResultExporter resultExporter;

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _activeCurrentController =
      TextEditingController();
  final TextEditingController _sleepCurrentController = TextEditingController();
  final TextEditingController _activeDurationController =
      TextEditingController();
  final TextEditingController _wakeupsController = TextEditingController();

  final FocusNode _capacityFocus = FocusNode();
  final FocusNode _activeCurrentFocus = FocusNode();
  final FocusNode _sleepCurrentFocus = FocusNode();
  final FocusNode _activeDurationFocus = FocusNode();
  final FocusNode _wakeupsFocus = FocusNode();

  @override
  void dispose() {
    _capacityController.dispose();
    _activeCurrentController.dispose();
    _sleepCurrentController.dispose();
    _activeDurationController.dispose();
    _wakeupsController.dispose();
    _capacityFocus.dispose();
    _activeCurrentFocus.dispose();
    _sleepCurrentFocus.dispose();
    _activeDurationFocus.dispose();
    _wakeupsFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final int precision = context.select(
      (SettingsCubit cubit) => cubit.state.settings.precision,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: <Widget>[
          IconButton(
            key: const Key('historyButton'),
            tooltip: l10n.historyTooltip,
            onPressed: _openHistory,
            icon: const Icon(Icons.history_rounded),
          ),
          IconButton(
            key: const Key('settingsButton'),
            tooltip: l10n.settingsTooltip,
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.settings),
            icon: const Icon(Icons.tune_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<CalculatorCubit, CalculatorState>(
          builder: (BuildContext context, CalculatorState state) {
            return LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.page,
                    AppSpacing.small,
                    AppSpacing.page,
                    AppSpacing.xLarge,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: AppSpacing.maxContentWidth,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          EngineeringSection(
                            icon: Icons.battery_5_bar_rounded,
                            title: l10n.batterySectionTitle,
                            description: l10n.batterySectionDescription,
                            children: <Widget>[
                              MeasurementField<BatteryCapacityUnit>(
                                controller: _capacityController,
                                fieldKey: const Key('capacityField'),
                                focusNode: _capacityFocus,
                                label: l10n.batteryCapacityLabel,
                                unit: state.batteryCapacityUnit,
                                units: BatteryCapacityUnit.values,
                                unitSymbol: (BatteryCapacityUnit unit) =>
                                    unit.symbol,
                                errorText: _errorText(
                                  l10n,
                                  state.errorFor(
                                    CalculatorField.batteryCapacity,
                                  ),
                                ),
                                onChanged: context
                                    .read<CalculatorCubit>()
                                    .batteryCapacityChanged,
                                onUnitChanged: context
                                    .read<CalculatorCubit>()
                                    .batteryCapacityUnitChanged,
                                onSubmitted: (_) =>
                                    _activeCurrentFocus.requestFocus(),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.medium),
                          EngineeringSection(
                            icon: Icons.memory_rounded,
                            title: l10n.activeSectionTitle,
                            description: l10n.activeSectionDescription,
                            children: <Widget>[
                              MeasurementField<CurrentUnit>(
                                controller: _activeCurrentController,
                                fieldKey: const Key('activeCurrentField'),
                                focusNode: _activeCurrentFocus,
                                label: l10n.activeCurrentLabel,
                                unit: state.activeCurrentUnit,
                                units: CurrentUnit.values,
                                unitSymbol: (CurrentUnit unit) => unit.symbol,
                                errorText: _errorText(
                                  l10n,
                                  state.errorFor(CalculatorField.activeCurrent),
                                ),
                                onChanged: context
                                    .read<CalculatorCubit>()
                                    .activeCurrentChanged,
                                onUnitChanged: context
                                    .read<CalculatorCubit>()
                                    .activeCurrentUnitChanged,
                                onSubmitted: (_) => state.sleepEnabled
                                    ? _sleepCurrentFocus.requestFocus()
                                    : _calculate(context),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.medium),
                          _SleepModeCard(
                            enabled: state.sleepEnabled,
                            onChanged: (bool value) => context
                                .read<CalculatorCubit>()
                                .sleepEnabledChanged(value: value),
                          ),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 180),
                            alignment: Alignment.topCenter,
                            child: state.sleepEnabled
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                      top: AppSpacing.medium,
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        EngineeringSection(
                                          icon: Icons.bedtime_outlined,
                                          title: l10n.sleepSectionTitle,
                                          description:
                                              l10n.sleepSectionDescription,
                                          children: <Widget>[
                                            MeasurementField<CurrentUnit>(
                                              controller:
                                                  _sleepCurrentController,
                                              fieldKey: const Key(
                                                'sleepCurrentField',
                                              ),
                                              focusNode: _sleepCurrentFocus,
                                              label: l10n.sleepCurrentLabel,
                                              unit: state.sleepCurrentUnit,
                                              units: CurrentUnit.values,
                                              unitSymbol: (CurrentUnit unit) =>
                                                  unit.symbol,
                                              errorText: _errorText(
                                                l10n,
                                                state.errorFor(
                                                  CalculatorField.sleepCurrent,
                                                ),
                                              ),
                                              onChanged: context
                                                  .read<CalculatorCubit>()
                                                  .sleepCurrentChanged,
                                              onUnitChanged: context
                                                  .read<CalculatorCubit>()
                                                  .sleepCurrentUnitChanged,
                                              onSubmitted: (_) =>
                                                  _activeDurationFocus
                                                      .requestFocus(),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: AppSpacing.medium,
                                        ),
                                        EngineeringSection(
                                          icon: Icons.schedule_rounded,
                                          title: l10n.cycleSectionTitle,
                                          description:
                                              l10n.cycleSectionDescription,
                                          children: <Widget>[
                                            MeasurementField<TimeUnit>(
                                              controller:
                                                  _activeDurationController,
                                              fieldKey: const Key(
                                                'activeDurationField',
                                              ),
                                              focusNode: _activeDurationFocus,
                                              label: l10n.activeDurationLabel,
                                              unit: state.activeDurationUnit,
                                              units: TimeUnit.values,
                                              unitSymbol: (TimeUnit unit) =>
                                                  unit.symbol,
                                              errorText: _errorText(
                                                l10n,
                                                state.errorFor(
                                                  CalculatorField
                                                      .activeDuration,
                                                ),
                                              ),
                                              onChanged: context
                                                  .read<CalculatorCubit>()
                                                  .activeDurationChanged,
                                              onUnitChanged: context
                                                  .read<CalculatorCubit>()
                                                  .activeDurationUnitChanged,
                                              onSubmitted: (_) =>
                                                  _wakeupsFocus.requestFocus(),
                                            ),
                                            const SizedBox(
                                              height: AppSpacing.medium,
                                            ),
                                            NumericField(
                                              controller: _wakeupsController,
                                              fieldKey: const Key(
                                                'wakeupsField',
                                              ),
                                              focusNode: _wakeupsFocus,
                                              label: l10n.wakeupsPerHourLabel,
                                              textInputAction:
                                                  TextInputAction.done,
                                              errorText: _errorText(
                                                l10n,
                                                state.errorFor(
                                                  CalculatorField
                                                      .wakeupsPerHour,
                                                ),
                                              ),
                                              onChanged: context
                                                  .read<CalculatorCubit>()
                                                  .wakeupsPerHourChanged,
                                              onSubmitted: (_) =>
                                                  _calculate(context),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                          if (state.errorFor(CalculatorField.form)
                              case final CalculatorInputError
                                  formError) ...<Widget>[
                            const SizedBox(height: AppSpacing.medium),
                            _FormError(
                              message:
                                  _errorText(l10n, formError) ??
                                  l10n.validationInvalidNumber,
                            ),
                          ],
                          const SizedBox(height: AppSpacing.large),
                          _CalculatorActions(
                            onReset: () => _reset(context),
                            onCalculate: () => _calculate(context),
                          ),
                          const SizedBox(height: AppSpacing.large),
                          BatteryResultCard(
                            result: state.result,
                            precision: precision,
                            showWarning: state.warnings.contains(
                              CalculatorWarning.potentiallyUnrealistic,
                            ),
                            onExport:
                                state.result != null && state.profile != null
                                ? () => _export(context, state, precision)
                                : null,
                          ),
                          const SizedBox(height: AppSpacing.medium),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Icon(
                                Icons.info_outline_rounded,
                                size: 20,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: AppSpacing.small),
                              Expanded(
                                child: Text(
                                  l10n.estimateNotice,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _calculate(BuildContext context) {
    FocusScope.of(context).unfocus();
    context.read<CalculatorCubit>().calculate();
  }

  Future<void> _export(
    BuildContext context,
    CalculatorState state,
    int precision,
  ) async {
    final result = state.result;
    final profile = state.profile;
    if (result == null || profile == null) {
      return;
    }
    final AppLocalizations l10n = AppLocalizations.of(context);
    final bool exported = await widget.resultExporter.export(
      subject: l10n.exportSubject,
      body: const CalculationPresentationFormatter().report(
        context,
        profile: profile,
        result: result,
        precision: precision,
      ),
    );
    if (!exported && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.exportUnavailable)));
    }
  }

  Future<void> _openHistory() async {
    final Object? selected = await Navigator.of(
      context,
    ).pushNamed(AppRoutes.history);
    if (!mounted || selected is! CalculationHistoryEntry) {
      return;
    }

    final CalculatorCubit cubit = context.read<CalculatorCubit>()
      ..loadProfile(selected.profile);
    final CalculatorState restored = cubit.state;
    _setControllerText(_capacityController, restored.batteryCapacity);
    _setControllerText(_activeCurrentController, restored.activeCurrent);
    _setControllerText(_sleepCurrentController, restored.sleepCurrent);
    _setControllerText(_activeDurationController, restored.activeDuration);
    _setControllerText(_wakeupsController, restored.wakeupsPerHour);
  }

  void _reset(BuildContext context) {
    _capacityController.clear();
    _activeCurrentController.clear();
    _sleepCurrentController.clear();
    _activeDurationController.clear();
    _wakeupsController.clear();
    context.read<CalculatorCubit>().reset();
    _capacityFocus.requestFocus();
  }

  void _setControllerText(TextEditingController controller, String value) {
    controller.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }

  String? _errorText(AppLocalizations l10n, CalculatorInputError? error) {
    return switch (error) {
      CalculatorInputError.required => l10n.validationRequired,
      CalculatorInputError.invalidNumber => l10n.validationInvalidNumber,
      CalculatorInputError.nonFinite => l10n.validationNonFinite,
      CalculatorInputError.mustBePositive => l10n.validationMustBePositive,
      CalculatorInputError.cannotBeNegative => l10n.validationCannotBeNegative,
      CalculatorInputError.activeDurationExceedsCycle =>
        l10n.validationActiveDurationTooLong,
      CalculatorInputError.zeroAverageCurrent =>
        l10n.validationZeroAverageCurrent,
      null => null,
    };
  }
}

class _CalculatorActions extends StatelessWidget {
  const _CalculatorActions({required this.onReset, required this.onCalculate});

  final VoidCallback onReset;
  final VoidCallback onCalculate;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double textScale = MediaQuery.textScalerOf(context).scale(1);
        final bool stack = constraints.maxWidth < 360 || textScale > 1.3;
        final Widget reset = OutlinedButton.icon(
          key: const Key('resetButton'),
          onPressed: onReset,
          icon: const Icon(Icons.restart_alt_rounded),
          label: Text(
            l10n.resetButton,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        );
        final Widget calculate = FilledButton.icon(
          key: const Key('calculateButton'),
          onPressed: onCalculate,
          icon: const Icon(Icons.bolt_rounded),
          label: Text(
            l10n.calculateButton,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        );

        if (stack) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(width: double.infinity, child: calculate),
              const SizedBox(height: AppSpacing.small),
              SizedBox(width: double.infinity, child: reset),
            ],
          );
        }
        return Row(
          children: <Widget>[
            Expanded(child: reset),
            const SizedBox(width: AppSpacing.small),
            Expanded(flex: 2, child: calculate),
          ],
        );
      },
    );
  }
}

class _SleepModeCard extends StatelessWidget {
  const _SleepModeCard({required this.enabled, required this.onChanged});

  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Card(
      child: SwitchListTile(
        key: const Key('sleepModeSwitch'),
        value: enabled,
        onChanged: onChanged,
        secondary: const Icon(Icons.mode_night_outlined),
        title: Text(l10n.sleepModeTitle),
        subtitle: Text(l10n.sleepModeSubtitle),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.medium,
          vertical: AppSpacing.small,
        ),
      ),
    );
  }
}

class _FormError extends StatelessWidget {
  const _FormError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Semantics(
      liveRegion: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.errorContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.medium),
          child: Row(
            children: <Widget>[
              Icon(Icons.error_outline, color: colors.onErrorContainer),
              const SizedBox(width: AppSpacing.small),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(color: colors.onErrorContainer),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
