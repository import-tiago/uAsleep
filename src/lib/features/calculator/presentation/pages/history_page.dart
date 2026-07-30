import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/services/result_exporter.dart';
import '../../../../features/settings/presentation/cubit/settings_cubit.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/calculation_history_entry.dart';
import '../cubit/history_cubit.dart';
import '../cubit/history_state.dart';
import '../formatters/calculation_presentation_formatter.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({required this.resultExporter, super.key});

  final ResultExporter resultExporter;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final int precision = context.select(
      (SettingsCubit cubit) => cubit.state.settings.precision,
    );
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (BuildContext context, HistoryState state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.historyTitle),
            actions: <Widget>[
              if (state.entries.isNotEmpty)
                IconButton(
                  key: const Key('clearHistoryButton'),
                  tooltip: l10n.historyClearTooltip,
                  onPressed: () => _confirmClear(context),
                  icon: const Icon(Icons.delete_sweep_outlined),
                ),
            ],
          ),
          body: SafeArea(
            child: switch (state.status) {
              HistoryStatus.loading => Center(
                child: CircularProgressIndicator(
                  semanticsLabel: l10n.loadingLabel,
                ),
              ),
              HistoryStatus.failure => _HistoryMessage(
                icon: Icons.error_outline,
                title: l10n.historyLoadFailure,
              ),
              HistoryStatus.ready when state.entries.isEmpty => _HistoryMessage(
                icon: Icons.history_rounded,
                title: l10n.historyEmptyTitle,
                description: l10n.historyEmptyDescription,
              ),
              HistoryStatus.ready => ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.page,
                  AppSpacing.medium,
                  AppSpacing.page,
                  AppSpacing.xLarge,
                ),
                itemCount: state.entries.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.small),
                itemBuilder: (BuildContext context, int index) {
                  return _HistoryCard(
                    entry: state.entries[index],
                    precision: precision,
                    onOpen: () =>
                        Navigator.of(context).pop(state.entries[index]),
                    onExport: () =>
                        _export(context, state.entries[index], precision),
                  );
                },
              ),
            },
          ),
        );
      },
    );
  }

  Future<void> _confirmClear(BuildContext context) async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final bool confirmed =
        await showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) => AlertDialog(
            title: Text(l10n.historyClearTitle),
            content: Text(l10n.historyClearMessage),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text(l10n.cancelButton),
              ),
              FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text(l10n.historyClearButton),
              ),
            ],
          ),
        ) ??
        false;
    if (confirmed && context.mounted) {
      await context.read<HistoryCubit>().clear();
    }
  }

  Future<void> _export(
    BuildContext context,
    CalculationHistoryEntry entry,
    int precision,
  ) async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final bool exported = await resultExporter.export(
      subject: l10n.exportSubject,
      body: const CalculationPresentationFormatter().report(
        context,
        profile: entry.profile,
        result: entry.result,
        precision: precision,
        createdAt: entry.createdAt,
      ),
    );
    if (!exported && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.exportUnavailable)));
    }
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({
    required this.entry,
    required this.precision,
    required this.onOpen,
    required this.onExport,
  });

  final CalculationHistoryEntry entry;
  final int precision;
  final VoidCallback onOpen;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    const CalculationPresentationFormatter formatter =
        CalculationPresentationFormatter();
    final int inputDigits = precision == 0 ? 2 : 4;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        key: ValueKey<String>('historyEntry-${entry.id}'),
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.medium),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Icon(Icons.battery_full_rounded),
              const SizedBox(width: AppSpacing.medium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      formatter.duration(
                        context,
                        entry.result.hours,
                        precision,
                      ),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xSmall),
                    Text(formatter.dateTime(context, entry.createdAt)),
                    const SizedBox(height: AppSpacing.xSmall),
                    Text(
                      '${formatter.number(context, entry.profile.batteryCapacity, inputDigits)} '
                      '${entry.profile.batteryCapacityUnit.symbol} • '
                      '${l10n.averageCurrentValue(formatter.number(context, entry.result.averageCurrentMilliamperes, inputDigits))}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: AppSpacing.xSmall),
                    Text(
                      l10n.historyReuseHint,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                key: ValueKey<String>('exportHistory-${entry.id}'),
                tooltip: l10n.exportTooltip,
                onPressed: onExport,
                icon: const Icon(Icons.ios_share_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistoryMessage extends StatelessWidget {
  const _HistoryMessage({
    required this.icon,
    required this.title,
    this.description,
  });

  final IconData icon;
  final String title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 56),
            const SizedBox(height: AppSpacing.medium),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            if (description case final String value) ...<Widget>[
              const SizedBox(height: AppSpacing.small),
              Text(value, textAlign: TextAlign.center),
            ],
          ],
        ),
      ),
    );
  }
}
