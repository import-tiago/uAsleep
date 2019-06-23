import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uasleep/models/math.dart';
class MathBloc extends BlocBase {


//Precision Resul Stream
  var _precisionResult_Stream = BehaviorSubject<int>();
  Stream<int> get outputPrecisionStream => _precisionResult_Stream.stream;
  Sink<int> get inputPrecisionStream => _precisionResult_Stream.sink;


precisionUpdate(int value){
  if(value == 0)
  MathOperations.precision = 0;
  else if(value == 0)
  MathOperations.precision = 2;
}

  @override
  void dispose() {
    _precisionResult_Stream.close();

    super.dispose();
  }
}
