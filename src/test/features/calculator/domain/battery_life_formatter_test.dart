import 'package:flutter_test/flutter_test.dart';
import 'package:uasleep/features/calculator/domain/services/battery_life_formatter.dart';

void main() {
  const BatteryLifeFormatter formatter = BatteryLifeFormatter();

  test('selects hours below two days', () {
    final BatteryLifeDisplay display = formatter.selectDisplay(12.345);
    expect(display.unit, BatteryLifeDisplayUnit.hours);
    expect(display.value, 12.345);
  });

  test('selects days below two months', () {
    final BatteryLifeDisplay display = formatter.selectDisplay(24 * 10);
    expect(display.unit, BatteryLifeDisplayUnit.days);
    expect(display.value, 10);
  });

  test('selects months below two years', () {
    final BatteryLifeDisplay display = formatter.selectDisplay(24 * 120);
    expect(display.unit, BatteryLifeDisplayUnit.months);
    expect(display.value, 4);
  });

  test('selects years for long results', () {
    final BatteryLifeDisplay display = formatter.selectDisplay(24 * 730);
    expect(display.unit, BatteryLifeDisplayUnit.years);
    expect(display.value, closeTo(2, 1e-12));
  });
}
