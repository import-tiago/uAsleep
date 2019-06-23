import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:uasleep/blocs/CalculatorScreenBloc.dart';
import 'package:uasleep/services/Singleton.dart';

class MathOperations {
  final CalculatorScreenBloc bloc =
      BlocProvider.getBloc<CalculatorScreenBloc>();
  static String strC = "0";
  static String strAs = "0";
  static String strAw = "0";
  static String strTw = "0";
  static String strWph = "0";

  final double hour_ms = 3600000.0;
  final double hour_s = 3600.0;
  final double hour_min = 60.0;
  static var _singleton = Singleton();
  double C;
  double As;
  double Aw;
  double Wt;
  double Wph;
  double Twph;
  double Tsph;
  double Aavg;

  double hours;
  double days;
  double months;
  double years;

  String batteryLife = "";

  static bool modoSleep;

  static int precision = 0;

  String getBatteryLife() {
    if (modoSleep == true || modoSleep == null)
      _sleepModeOn();
    else if (!modoSleep) _sleepModeOff();
  }

  _sleepModeOn() {
    if (_singleton.resultPrecision == 1)
      precision = 2;
    else
      precision = 0;

    C = double.parse(strC);
    As = double.parse(strAs);
    Aw = double.parse(strAw);
    Wt = double.parse(strTw);
    Wph = double.parse(strWph);

    if (CalculatorScreenBloc.energyUnits[0].value == "Ah") C *= 1000.0;

    if (CalculatorScreenBloc.currentSleepUnits[0].value == "µA")
      As /= 1000.0;
    else if (CalculatorScreenBloc.currentSleepUnits[0].value == "nA")
      As /= 1000000.0;

    if (CalculatorScreenBloc.currentWakeUnits[0].value == "A")
      Aw *= 1000.0;
    else if (CalculatorScreenBloc.currentWakeUnits[0].value == "µA")
      Aw /= 1000.0;

    if (CalculatorScreenBloc.timeUnits[0].value == "s")
      Wt *= 1000.0;
    else if (CalculatorScreenBloc.timeUnits[0].value == "µs")
      Wt /= 1000.0;
    else if (CalculatorScreenBloc.timeUnits[0].value == "ns")
      Wt /= 1000000.0;
    else if (CalculatorScreenBloc.timeUnits[0].value == "min")
      Wt *= 60000.0;
    else if (CalculatorScreenBloc.timeUnits[0].value == "hr") Wt *= 3600000.0;

    Twph = ((Wph * Wt) / hour_ms) * hour_ms;
    Tsph = hour_ms - Twph;
    Aavg = ((Aw * Twph) + (As * Tsph)) / hour_ms;

    hours = C / Aavg;
    days = hours / 24;
    months = days / 30;
    years = days / 365;

    if (years > 1) {
      batteryLife = "= " +
          months.toStringAsFixed(precision) +
          " " +
          _singleton.language[0]["MathResults"]["PluralMonth"] +
          " ≅ " +
          years.toStringAsFixed(precision) +
          " " +
          _singleton.language[0]["MathResults"]["PluralYear"];
    } else if (months > 1) {
      batteryLife = "= " +
          days.toStringAsFixed(precision) +
          " " +
          _singleton.language[0]["MathResults"]["PluralDay"] +
          " ≅ " +
          months.toStringAsFixed(precision) +
          " " +
          _singleton.language[0]["MathResults"]["PluralMonth"];
    } else if (days > 1) {
      batteryLife = "= " +
          hours.toStringAsFixed(precision) +
          " " +
          _singleton.language[0]["MathResults"]["PluralHour"] +
          " ≅ " +
          days.toStringAsFixed(precision) +
          " " +
          _singleton.language[0]["MathResults"]["PluralDay"];
    } else if (hours > 1) {
      batteryLife = "= " +
          hours.toStringAsFixed(2) +
          " " +
          _singleton.language[0]["MathResults"]["PluralHour"];
    }
    bloc.inputbatteryLifeStream.add(batteryLife);
  }

  _sleepModeOff() {
       if (_singleton.resultPrecision == 1)
      precision = 2;
    else
      precision = 0;
    C = double.parse(strC);
    Aw = double.parse(strAw);

    if (CalculatorScreenBloc.energyUnits[0].value == "Ah") C *= 1000.0;

    if (CalculatorScreenBloc.currentWakeUnits[0].value == "A")
      Aw *= 1000.0;
    else if (CalculatorScreenBloc.currentWakeUnits[0].value == "µA")
      Aw /= 1000.0;

    hours = C / Aw;
    days = hours / 24;
    months = days / 30;
    years = days / 365;

    if (years > 1) {
      batteryLife = "= " +
          months.toStringAsFixed(precision) +
          " " +
          _singleton.language[0]["MathResults"]["PluralMonth"] +
          " ≅ " +
          years.toStringAsFixed(precision) +
          " " +
          _singleton.language[0]["MathResults"]["PluralYear"];
    } else if (months > 1) {
      batteryLife = "= " +
          days.toStringAsFixed(precision) +
          " " +
          _singleton.language[0]["MathResults"]["PluralDay"] +
          " ≅ " +
          months.toStringAsFixed(precision) +
          " " +
          _singleton.language[0]["MathResults"]["PluralMonth"];
    } else if (days > 1) {
      batteryLife = "= " +
          hours.toStringAsFixed(precision) +
          " " +
          _singleton.language[0]["MathResults"]["PluralHour"] +
          " ≅ " +
          days.toStringAsFixed(precision) +
          " " +
          _singleton.language[0]["MathResults"]["PluralDay"];
    } else if (hours > 1) {
      batteryLife = "= " +
          hours.toStringAsFixed(precision) +
          " " +
          _singleton.language[0]["MathResults"]["PluralHour"];
    }
    bloc.inputbatteryLifeStream.add(batteryLife);
  }
}
