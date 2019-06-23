import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:uasleep/blocs/CalculatorScreenBloc.dart';
import 'package:uasleep/blocs/ConfigScreenBloc.dart';
import 'package:uasleep/blocs/MathBloc.dart';
import 'package:uasleep/blocs/NavigationBloc.dart';
import 'package:uasleep/main.dart';
import 'package:uasleep/services/DataPersistence.dart';
import 'package:uasleep/services/EmailSender.dart';
import 'package:uasleep/services/Singleton.dart';
import 'package:uasleep/models/math.dart';

class ConfigScreen extends StatefulWidget {
  @override
  _ConfigScreenState createState() => _ConfigScreenState();
}

final MathBloc mathBloc = BlocProvider.getBloc<MathBloc>();

int _languageOption = 1;
int langPT_BR = 0;
int langEN = 1;

int _resultOption = 0;
int simpleResult = 0;
int precisionResult = 1;

final NavigationBloc blocNav = BlocProvider.getBloc<NavigationBloc>();
final CalculatorScreenBloc bloc = BlocProvider.getBloc<CalculatorScreenBloc>();
final ConfigScreenBloc bloc2 = BlocProvider.getBloc<ConfigScreenBloc>();
DataPersistence dataPersistence = DataPersistence();

//final snackBar = SnackBar(content: Text("Disponível em breve..."));

class _ConfigScreenState extends State<ConfigScreen> {
  static var _singleton = Singleton();

  int _currentIndex = 0;
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (index == 1) {
        Navigator.of(context).pushNamed('/config');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Container(),
            onPressed: () => Navigator.of(context).pop(null),
          ),
        ],
        leading: Container(),
        title: Text(_singleton.language[0]["AppBar"]["title"]),
        centerTitle: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .popAndPushNamed(blocNav.push(NavigationBloc.HOME));
          bloc.inputbatteryLifeStream.add("");
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
                  if (index != snapshot.data) if (index == 0) {
                    final snackBar = SnackBar(
                      content: Text(
                          _singleton.language[0]["Others"]["InDevelopment"]),
                    );

                    Scaffold.of(context).showSnackBar(snackBar);
                  } else {
                    Navigator.of(context).pushNamed(blocNav.push(index));
                  }
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
                          child: Text(_singleton.language[0]["BottomBar"]
                              ["button_1"]))),
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
                          child: Text(_singleton.language[0]["BottomBar"]
                              ["button_2"]))),
                ]);
          }),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _singleton.language[0]["ConfigScreen"]["LanguageTitle"],
                style: TextStyle(fontSize: 18),
              ),
              Container(
                padding: EdgeInsets.only(top: 15, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Radio(
                      value: 0,
                      groupValue: _singleton.currentLanguage,
                      onChanged: (value) {
                         _singleton.currentLanguage = value;
                         dataPersistence.writeFile();
                        dataPersistence.readFile();
                        setState(() {
                         _singleton.needRestart = true;
                          //dataPersistence.writeFile();
                         
                         
                        });
                      },
                    ),
                    Text(
                      _singleton.language[0]["ConfigScreen"]["LangOption_1"],
                      style: TextStyle(fontSize: 16),
                    ),
                    Radio(
                      value: 1,
                      groupValue: _singleton.currentLanguage,
                      onChanged: (value) {
                         _singleton.currentLanguage = value;
                         dataPersistence.writeFile();
                        dataPersistence.readFile();
                        setState(() {
                         _singleton.needRestart = true;
                          //dataPersistence.writeFile();
                         
                        
                        });
                      },
                    ),
                    Text(
                      _singleton.language[0]["ConfigScreen"]["LangOption_2"],
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              Center(
                child: Visibility              
                (
                  visible: _singleton.needRestart,
                  child: Text("restart the APP",
                  style: TextStyle(fontSize: 18, color: Colors.red),
                  
                  )),
              ),
              Text(
                _singleton.language[0]["ConfigScreen"]["ResultTitle"],
                style: TextStyle(fontSize: 20),
              ),
              Container(
                padding: EdgeInsets.only(top: 15, bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Radio(
                      value: 0,
                      groupValue: _singleton.resultPrecision,
                      onChanged: (value) {
                        //  mathBloc.precisionUpdate(value);
                        setState(() {
                          _singleton.resultPrecision = value;
                          dataPersistence.writeFile();
                          setState(() {});
                        });
                      },
                    ),
                    Text(
                      _singleton.language[0]["ConfigScreen"]["ResultOption_1"],
                      style: TextStyle(fontSize: 16),
                    ),
                    Radio(
                      value: 1,
                      groupValue: _singleton.resultPrecision,
                      onChanged: (value) {
                        setState(() {
                          _singleton.resultPrecision = value;
                          dataPersistence.writeFile();
                          setState(() {});
                        });
                      },
                    ),
                    Text(
                      _singleton.language[0]["ConfigScreen"]["ResultOption_2"],
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              Center(
                child: Container(
                  padding: EdgeInsets.only(top: 40, bottom: 10),
                  child: Text(
                    _singleton.language[0]["ConfigScreen"]["FeedbackTitle"],
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 5),
                child: Text(
                  _singleton.language[0]["ConfigScreen"]["FeedbackName"],
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Container(
                height: 55,
                padding: EdgeInsets.only(top: 5, bottom: 10),
                child: TextField(
                  onChanged: (text) {
                    _singleton.feedbackName = text;
                  },
                  style: TextStyle(fontSize: 18),
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal))),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 5),
                child: Text(
                  _singleton.language[0]["ConfigScreen"]["FeedbackEmail"],
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Container(
                height: 55,
                padding: EdgeInsets.only(top: 5, bottom: 10),
                child: TextField(
                
                  onChanged: (text) {
                    _singleton.feedbackEmail = text;
                  },
                  
                  style: TextStyle(fontSize: 18),
                  keyboardType: TextInputType.emailAddress,
                  maxLines: 1,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal))),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 5),
                child: Text(
                  _singleton.language[0]["ConfigScreen"]["FeedbackMessage"],
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 5),
                child: TextField(
                  onChanged: (text) {
                    _singleton.feedbackMessage = text;
                  },
                  style: TextStyle(fontSize: 18),
                  keyboardType: TextInputType.multiline,
                  maxLines: 9,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal))),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  RaisedButton(
                    padding: const EdgeInsets.all(8.0),
                    textColor: Colors.white,
                    color: Color(0xFF571379),
                    onPressed: () {
                      final Email email = Email(
                        body: _singleton.feedbackMessage,
                        subject: "uAsleep - Feedback",
                        recipients: ["tiagodepaulasilva@gmail.com"],
                      );

                      FlutterEmailSender.send(email);
                    },
                    child: Text(
                        _singleton.language[0]["ConfigScreen"]["SendButton"]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
