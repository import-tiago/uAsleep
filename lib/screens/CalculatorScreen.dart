import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:uasleep/blocs/CalculatorScreenBloc.dart';
import 'package:uasleep/blocs/NavigationBloc.dart';
import 'package:uasleep/services/DataPersistence.dart';
import 'package:uasleep/services/Singleton.dart';
import 'package:uasleep/models/math.dart';
import 'ConfigScreen.dart';

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final CalculatorScreenBloc bloc =
      BlocProvider.getBloc<CalculatorScreenBloc>();

   

  final NavigationBloc blocNav = BlocProvider.getBloc<NavigationBloc>();

  final MathOperations calc = MathOperations();
  bool isChecked = true;
  static var _singleton = Singleton();

  String selectedUnit;
  String lastUnit;
  var stream;

  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();
  final TextEditingController _controller5 = TextEditingController();
  int _currentIndex = 0;
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (index == 1) {
        Navigator.of(context).pushNamed('/config');
      }
    });
  }
/*
@override
initState() async {
  super.initState();
  DataPersistence dataPersistence = DataPersistence();
  await dataPersistence.loadAppLenguage();

 
}
*/
//DataPersistence
/*
  _update() {
    stream = bloc.outputBatteryCapacityStream;
    bloc.inputBatteryCapacityStream.add(_singleton.batteryCapacityUnit);
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_singleton.language[0]["AppBar"]["title"]),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Container(),
              onPressed: () => Navigator.of(context).pop(null),
            ),
          ],
          leading: Container(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            calc.getBatteryLife();
          },
          child: Icon(Icons.battery_unknown),
          isExtended: true,
          elevation: 3,
          backgroundColor: Color(0xFF40ACE1),
          foregroundColor: Colors.white,
        ),
        bottomNavigationBar: StreamBuilder(
            stream: blocNav.outputNavigationBarStream,
            initialData: 1,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return BottomNavigationBar(
                  onTap: (index) {
                    if (index != snapshot.data) if (index !=
                        snapshot.data) if (index == 0) {
                      //Histórico.
                      final snackBar = SnackBar(
                        content: Text(_singleton.language[0]["Others"]["InDevelopment"]),
                      );

                      Scaffold.of(context).showSnackBar(snackBar);
                    } else
                      Navigator.of(context)
                          .popAndPushNamed(blocNav.push(index));
                  },
                  currentIndex: snapshot.data,
                  elevation: 20,
                  iconSize: 30,
                  items: [
                    BottomNavigationBarItem(
                        icon: Container(
                            // padding: EdgeInsets.only(right: 5),
                            child: Icon(Icons.history)),
                        title: Container(
                            // padding: EdgeInsets.only(right: 5),
                            child: Text(_singleton.language[0]["BottomBar"]["button_1"]))),
                    BottomNavigationBarItem(
                      icon: Container(),
                      title: Container(),
                    ),
                    BottomNavigationBarItem(
                        icon: Container(
                            // padding: EdgeInsets.only(left: 5),
                            child: Icon(Icons.settings)),
                        title: Container(
                            //  padding: EdgeInsets.only(left: 5),
                            child: Text(_singleton.language[0]["BottomBar"]["button_2"]))),
                  ]);
            }),
        body: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Container(
                    padding: EdgeInsets.only(top: 20, bottom: 10),
                    child: Image.asset("lib/images/batteryImage.png"),
                  ),
                ),
                Row(
                  children: <Widget>[
                    StreamBuilder(
                        stream: bloc.outputSleepModeStatusStream,
                        initialData: true,
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          return Checkbox(
                              value: snapshot.data,
                              onChanged: (value) {
                                bloc.inputSleepModeStatusStream.add(value);
                                MathOperations.modoSleep = value;
                                bloc.inputbatteryLifeStream.add("");
                                _controller1.clear();
                                _controller2.clear();
                                _controller3.clear();
                                _controller4.clear();
                                _controller5.clear();
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                              });
                        }),
                    Text(_singleton.language[0]["HomeScreen"]["Checkbox"], style: TextStyle(fontSize: 16)),
                  ],
                ),
                StreamBuilder(
                    stream: bloc.outputSleepModeStatusStream,
                    initialData: true,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      return Column(
                        children: <Widget>[
                          _filed_1(
                              CalculatorScreenBloc.PARAMETER_BATTERY_CAPACITY),
                          Visibility(
                              visible: snapshot.data,
                              child: _filed_2(CalculatorScreenBloc
                                  .PARAMETER_SLEEP_CURRENT)),
                          _filed_3(
                              CalculatorScreenBloc.PARAMETER_AWAKE_CURRENT),
                          Visibility(
                              visible: snapshot.data,
                              child: _filed_4(
                                  CalculatorScreenBloc.PARAMETER_AWAKE_TIME)),
                          Visibility(
                              visible: snapshot.data,
                              child: _filed_5(CalculatorScreenBloc
                                  .PARAMETER_WAKEUPS_PER_HOUR)),
                        ],
                      );
                    }),
                Container(
                  padding:
                      EdgeInsets.only(top: 15, bottom: 50, left: 20, right: 20),
                  child: Center(
                    child: StreamBuilder(
                        stream: bloc.outputbatteryLifesStream,
                        initialData: "",
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          return Text(
                            snapshot.data,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          );
                        }),
                  ),
                )
              ]),
        ));
  }

  Widget _filed_1(String parameterName) {
    return Container(
      padding: EdgeInsets.only(right: 20, left: 20, bottom: 10),
      child: Row(
        children: <Widget>[
          Text(
            parameterName,
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                controller: _controller1,
                onChanged: (text) {
                  MathOperations.strC = text;
                },
                keyboardType: TextInputType.number,
                textAlign: parameterName ==
                        CalculatorScreenBloc.PARAMETER_WAKEUPS_PER_HOUR
                    ? TextAlign.center
                    : TextAlign.end,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                ),
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
            ),
          ),
          StreamBuilder(
              stream: bloc.outputBatteryCapacityStream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return Visibility(
                  visible: parameterName ==
                          CalculatorScreenBloc.PARAMETER_WAKEUPS_PER_HOUR
                      ? false
                      : true,
                  child: DropdownButton<String>(
                    onChanged: (String newValue) {
                      _reOrganize(newValue, parameterName);

                      bloc.inputBatteryCapacityStream.add(newValue);
                      _singleton.batteryCapacityUnit = newValue;
                    },
                    value: snapshot.data == null
                        ? _reOrganize(
                            _singleton.batteryCapacityUnit, parameterName)
                        : snapshot.data,
                    items: CalculatorScreenBloc.energyUnits,
                  ),
                );
              }),
        ],
      ),
    );
  }

  String _reOrganize(String newValue, String parameterName) {
    var x, y, z;
    Map<dynamic, dynamic> oldArray = Map();

    if (parameterName == CalculatorScreenBloc.PARAMETER_BATTERY_CAPACITY) {
      for (int i = 0; i < CalculatorScreenBloc.energyUnits.length; i++) {
        oldArray[i] = CalculatorScreenBloc.energyUnits[i].value.toString();
      }
    } else if (parameterName == CalculatorScreenBloc.PARAMETER_SLEEP_CURRENT) {
      for (int i = 0; i < CalculatorScreenBloc.currentSleepUnits.length; i++) {
        oldArray[i] =
            CalculatorScreenBloc.currentSleepUnits[i].value.toString();
      }
    } else if (parameterName == CalculatorScreenBloc.PARAMETER_AWAKE_CURRENT) {
      for (int i = 0; i < CalculatorScreenBloc.currentWakeUnits.length; i++) {
        oldArray[i] = CalculatorScreenBloc.currentWakeUnits[i].value.toString();
      }
    } else if (parameterName == CalculatorScreenBloc.PARAMETER_AWAKE_TIME) {
      for (int i = 0; i < CalculatorScreenBloc.timeUnits.length; i++) {
        oldArray[i] = CalculatorScreenBloc.timeUnits[i].value.toString();
      }
    }

    for (int i = 0; i < oldArray.length; i++) {
      if (oldArray[i] == newValue) {
        x = i;
        y = oldArray[0];
        oldArray[0] = newValue;
        oldArray[i] = y;
      }
    }

    if (parameterName == CalculatorScreenBloc.PARAMETER_BATTERY_CAPACITY) {
      CalculatorScreenBloc.energyUnits.clear();
      for (int i = 0; i < oldArray.length; i++) {
        CalculatorScreenBloc.energyUnits +=
            <String>[oldArray[i]].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList();
      }
    } else if (parameterName == CalculatorScreenBloc.PARAMETER_SLEEP_CURRENT) {
      CalculatorScreenBloc.currentSleepUnits.clear();
      for (int i = 0; i < oldArray.length; i++) {
        CalculatorScreenBloc.currentSleepUnits +=
            <String>[oldArray[i]].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList();
      }
    } else if (parameterName == CalculatorScreenBloc.PARAMETER_AWAKE_CURRENT) {
      CalculatorScreenBloc.currentWakeUnits.clear();
      for (int i = 0; i < oldArray.length; i++) {
        CalculatorScreenBloc.currentWakeUnits +=
            <String>[oldArray[i]].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList();
      }
    } else if (parameterName == CalculatorScreenBloc.PARAMETER_AWAKE_TIME) {
      CalculatorScreenBloc.timeUnits.clear();
      for (int i = 0; i < oldArray.length; i++) {
        CalculatorScreenBloc.timeUnits +=
            <String>[oldArray[i]].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList();
      }
    }

    return newValue;
  }

  Widget _filed_2(String parameterName) {
    return Container(
      padding: EdgeInsets.only(right: 20, left: 20, bottom: 10),
      child: Row(
        children: <Widget>[
          Text(
            parameterName,
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                controller: _controller2,
                onChanged: (text) {
                  MathOperations.strAs = text;
                },
                keyboardType: TextInputType.number,
                textAlign: parameterName ==
                        CalculatorScreenBloc.PARAMETER_WAKEUPS_PER_HOUR
                    ? TextAlign.center
                    : TextAlign.end,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                ),
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
            ),
          ),
          StreamBuilder(
              stream: bloc.outputSleepCurrentStream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return Visibility(
                  visible: parameterName ==
                          CalculatorScreenBloc.PARAMETER_WAKEUPS_PER_HOUR
                      ? false
                      : true,
                  child: DropdownButton<String>(
                    onChanged: (String newValue) {
                      _reOrganize(newValue, parameterName);
                      bloc.inputSleepCurrentStream.add(newValue);
                      _singleton.sleepCurrentUnit = newValue;
                    },
                    value: snapshot.data == null
                        ? _reOrganize(
                            _singleton.sleepCurrentUnit, parameterName)
                        : snapshot.data,
                    items: CalculatorScreenBloc.currentSleepUnits,
                  ),
                );
              }),
        ],
      ),
    );
  }

  Widget _filed_3(String parameterName) {
    return Container(
      padding: EdgeInsets.only(right: 20, left: 20, bottom: 10),
      child: Row(
        children: <Widget>[
          Text(
            parameterName,
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                controller: _controller3,
                onChanged: (text) {
                  MathOperations.strAw = text;
                },
                keyboardType: TextInputType.number,
                textAlign: parameterName ==
                        CalculatorScreenBloc.PARAMETER_WAKEUPS_PER_HOUR
                    ? TextAlign.center
                    : TextAlign.end,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                ),
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
            ),
          ),
          StreamBuilder(
              stream: bloc.outputAwakeCurrentStream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return Visibility(
                  visible: parameterName ==
                          CalculatorScreenBloc.PARAMETER_WAKEUPS_PER_HOUR
                      ? false
                      : true,
                  child: DropdownButton<String>(
                    onChanged: (String newValue) {
                      _reOrganize(newValue, parameterName);
                      bloc.inputAwakeCurrentStream.add(newValue);
                      _singleton.awakeCurrentUnit = newValue;
                    },
                    value: snapshot.data == null
                        ? _reOrganize(
                            _singleton.awakeCurrentUnit, parameterName)
                        : snapshot.data,
                    items: CalculatorScreenBloc.currentWakeUnits,
                  ),
                );
              }),
        ],
      ),
    );
  }

  Widget _filed_4(String parameterName) {
    return Container(
      padding: EdgeInsets.only(right: 20, left: 20, bottom: 10),
      child: Row(
        children: <Widget>[
          Text(
            parameterName,
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                controller: _controller4,
                onChanged: (text) {
                  MathOperations.strTw = text;
                },
                keyboardType: TextInputType.number,
                textAlign: parameterName ==
                        CalculatorScreenBloc.PARAMETER_WAKEUPS_PER_HOUR
                    ? TextAlign.center
                    : TextAlign.end,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                ),
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
            ),
          ),
          StreamBuilder(
              stream: bloc.outputAwakeTimeStream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return Visibility(
                  visible: parameterName ==
                          CalculatorScreenBloc.PARAMETER_WAKEUPS_PER_HOUR
                      ? false
                      : true,
                  child: DropdownButton<String>(
                    onChanged: (String newValue) {
                      _reOrganize(newValue, parameterName);
                      bloc.inputAwakeTimeStream.add(newValue);
                      _singleton.awakeTime = newValue;
                    },
                    value: snapshot.data == null
                        ? _reOrganize(_singleton.awakeTime, parameterName)
                        : snapshot.data,
                    items: CalculatorScreenBloc.timeUnits,
                  ),
                );
              }),
        ],
      ),
    );
  }

  Widget _filed_5(String parameterName) {
    return Container(
      padding: EdgeInsets.only(right: 20, left: 20, bottom: 10),
      child: Row(
        children: <Widget>[
          Text(
            parameterName,
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                controller: _controller5,
                onChanged: (text) {
                  MathOperations.strWph = text;
                },
                keyboardType: TextInputType.number,
                textAlign: parameterName ==
                        CalculatorScreenBloc.PARAMETER_WAKEUPS_PER_HOUR
                    ? TextAlign.center
                    : TextAlign.end,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                ),
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
