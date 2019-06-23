import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uasleep/models/math.dart';



class ConfigScreenBloc extends BlocBase {


//Precision Resul Stream
  var _changeLanguage_Stream = BehaviorSubject<int>();
  Stream<int> get outputChangeLanguageStream => _changeLanguage_Stream.stream;
  Sink<int> get inputChangeLanguageStream => _changeLanguage_Stream.sink;




  @override
  void dispose() {
    _changeLanguage_Stream.close();

    super.dispose();
  }
}
