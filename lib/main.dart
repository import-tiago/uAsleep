import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:uasleep/blocs/CalculatorScreenBloc.dart';
import 'package:uasleep/blocs/ConfigScreenBloc.dart';
import 'package:uasleep/blocs/NavigationBloc.dart';
import 'package:uasleep/screens/CalculatorScreen.dart';
import 'package:uasleep/screens/ConfigScreen.dart';
import 'package:uasleep/services/DataPersistence.dart';

void main() async {

 DataPersistence dataPersistence = DataPersistence();
  await dataPersistence.loadAppLenguage();

  return runApp(MicroAsleep());
}

class MicroAsleep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      blocs: [
        Bloc((i) => CalculatorScreenBloc()),
        Bloc((i) => NavigationBloc()),
        Bloc((i) => ConfigScreenBloc())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "uAsleep",
        theme: ThemeData(
          primaryColor: Color(0xFF571379),
          accentColor: Color(0xFF69089A),
        ),
        home: CalculatorScreen(),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => CalculatorScreen(),
          '/config': (BuildContext context) => ConfigScreen(),
        },
      ),
    );
  }
}
