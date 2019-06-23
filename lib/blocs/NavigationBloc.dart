import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

class NavigationBloc extends BlocBase {
  static const int HOME = 1;
  static const int CONFIG = 2;
  static const int HISTORY = 0;

//Navigation Index Stream
  var _navigationBar_Stream = BehaviorSubject<int>();
  Stream<int> get outputNavigationBarStream => _navigationBar_Stream.stream;
  Sink<int> get inputNavigationBarStream => _navigationBar_Stream.sink;

  String push(int index) {
    
 inputNavigationBarStream.add(index);
 
    switch (index) {
      case HOME:
        return "/home";
         
        break;

      case CONFIG:
       return "/config";
        break;

      case HISTORY:
      return "/log";
        break;
    }
    
  }

  @override
  void dispose() {
    _navigationBar_Stream.close();

    super.dispose();
  }
}
