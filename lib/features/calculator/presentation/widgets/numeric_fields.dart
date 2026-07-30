import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/theme/app_spacing.dart';

final TextInputFormatter engineeringNumberFormatter =
    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,+\-\s]'));

class MeasurementField<T extends Enum> extends StatelessWidget {
  const MeasurementField({
    required this.controller,
    required this.label,
    required this.unit,
    required this.units,
    required this.unitSymbol,
    required this.onChanged,
    required this.onUnitChanged,
    this.errorText,
    this.fieldKey,
    this.focusNode,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final T unit;
  final List<T> units;
  final String Function(T unit) unitSymbol;
  final ValueChanged<String> onChanged;
  final ValueChanged<T> onUnitChanged;
  final String? errorText;
  final Key? fieldKey;
  final FocusNode? focusNode;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Widget valueField = TextField(
          key: fieldKey,
          controller: controller,
          focusNode: focusNode,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
            signed: true,
          ),
          inputFormatters: <TextInputFormatter>[engineeringNumberFormatter],
          textInputAction: textInputAction,
          onSubmitted: onSubmitted,
          onChanged: onChanged,
          decoration: InputDecoration(labelText: label, errorText: errorText),
        );
        final Widget unitField = DropdownButtonFormField<T>(
          key: ValueKey<T>(unit),
          initialValue: unit,
          isExpanded: true,
          decoration: InputDecoration(labelText: unitSymbol(unit)),
          items: units
              .map(
                (T value) => DropdownMenuItem<T>(
                  value: value,
                  child: Text(unitSymbol(value)),
                ),
              )
              .toList(growable: false),
          onChanged: (T? value) {
            if (value != null) {
              onUnitChanged(value);
            }
          },
        );

        if (constraints.maxWidth < 400) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              valueField,
              const SizedBox(height: AppSpacing.small),
              unitField,
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(flex: 3, child: valueField),
            const SizedBox(width: AppSpacing.small),
            SizedBox(width: 128, child: unitField),
          ],
        );
      },
    );
  }
}

class NumericField extends StatelessWidget {
  const NumericField({
    required this.controller,
    required this.label,
    required this.onChanged,
    this.errorText,
    this.fieldKey,
    this.focusNode,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final ValueChanged<String> onChanged;
  final String? errorText;
  final Key? fieldKey;
  final FocusNode? focusNode;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: fieldKey,
      controller: controller,
      focusNode: focusNode,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
        signed: true,
      ),
      inputFormatters: <TextInputFormatter>[engineeringNumberFormatter],
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      onChanged: onChanged,
      decoration: InputDecoration(labelText: label, errorText: errorText),
    );
  }
}
