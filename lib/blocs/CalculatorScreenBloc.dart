import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uasleep/services/Singleton.dart';

class CalculatorScreenBloc extends BlocBase {
  //CONSTANTES
  static int ENERGY_UNITS = 1;
  static int CURRENT_UNITS = 2;
  static int TIME_UNITS = 3;

  static  String PARAMETER_BATTERY_CAPACITY = _singleton.language[0]["HomeScreen"]["FieldBox_1"];
  static  String PARAMETER_SLEEP_CURRENT = _singleton.language[0]["HomeScreen"]["FieldBox_2"];
  static  String PARAMETER_AWAKE_CURRENT = _singleton.language[0]["HomeScreen"]["FieldBox_3"];
  static  String PARAMETER_AWAKE_TIME = _singleton.language[0]["HomeScreen"]["FieldBox_4"];
  static  String PARAMETER_WAKEUPS_PER_HOUR = _singleton.language[0]["HomeScreen"]["FieldBox_5"];

  static String LastField;

//OBJETOS
  bool changeProfilePicture = false;
  static var _singleton = Singleton();

//UNITS LISTS
  static List<DropdownMenuItem<String>> timeUnits = <String>[
    "µs",
    "ms",
    "s",
    "min",
    "hr"
  ].map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value, textAlign: TextAlign.center),
    );
  }).toList();

  static List<DropdownMenuItem<String>> currentSleepUnits =
      <String>["nA", "µA", "mA"].map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value, textAlign: TextAlign.center),
    );
  }).toList();

  static List<DropdownMenuItem<String>> currentWakeUnits =
      <String>["µA", "mA", "A"].map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value, textAlign: TextAlign.center),
    );
  }).toList();

  static List<DropdownMenuItem<String>> energyUnits =
      <String>["mAh", "Ah"].map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value, textAlign: TextAlign.center),
    );
  }).toList();

//STREAMS

//Unit Battery Capacity Stream
  var _batteryCapacity_Stream = BehaviorSubject<String>();
  Stream<String> get outputBatteryCapacityStream =>
      _batteryCapacity_Stream.stream;
  Sink<String> get inputBatteryCapacityStream => _batteryCapacity_Stream.sink;

//Unit Current Sleeping
  var _sleepCurrent_Stream = BehaviorSubject<String>();
  Stream<String> get outputSleepCurrentStream => _sleepCurrent_Stream.stream;
  Sink<String> get inputSleepCurrentStream => _sleepCurrent_Stream.sink;

//Unit Current Awake
  var _awakeCurrent_Stream = BehaviorSubject<String>();
  Stream<String> get outputAwakeCurrentStream => _awakeCurrent_Stream.stream;
  Sink<String> get inputAwakeCurrentStream => _awakeCurrent_Stream.sink;

//Unit Time Awake
  var _awakeTime_Stream = BehaviorSubject<String>();
  Stream<String> get outputAwakeTimeStream => _awakeTime_Stream.stream;
  Sink<String> get inputAwakeTimeStream => _awakeTime_Stream.sink;

//Number of Wakeups Per Hour
  var _numberWakeups_Stream = BehaviorSubject<String>();
  Stream<String> get outputNumberWakeupsStream => _numberWakeups_Stream.stream;
  Sink<String> get inputNumberWakeupsStream => _numberWakeups_Stream.sink;

//Battery Life Calc
  var _batteryLife_Stream = BehaviorSubject<String>();
  Stream<String> get outputbatteryLifesStream => _batteryLife_Stream.stream;
  Sink<String> get inputbatteryLifeStream => _batteryLife_Stream.sink;

  //Sleep Mode ON/OFF
  var _sleepModeStatus_Stream = BehaviorSubject<bool>();
  Stream<bool> get outputSleepModeStatusStream => _sleepModeStatus_Stream.stream;
  Sink<bool> get inputSleepModeStatusStream => _sleepModeStatus_Stream.sink;

//FUNÇÕES

  String lastField() {
    return LastField;
  }

  void returnVoid() {}

  getLastUnitSingleton() {
    inputBatteryCapacityStream.add(_singleton.batteryCapacityUnit);
    inputSleepCurrentStream.add(_singleton.sleepCurrentUnit);
    inputAwakeCurrentStream.add(_singleton.awakeCurrentUnit);
    inputAwakeTimeStream.add(_singleton.awakeTime);
    inputNumberWakeupsStream.add(_singleton.wakeupsPerHour);
  }

  @override
  void dispose() {
    _batteryCapacity_Stream.close();
    _sleepCurrent_Stream.close();
    _awakeCurrent_Stream.close();
    _awakeTime_Stream.close();
    _numberWakeups_Stream.close();
    _batteryLife_Stream.close();
    _sleepModeStatus_Stream.close();

    super.dispose();
  }
}
