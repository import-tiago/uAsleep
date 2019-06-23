import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uasleep/services/Singleton.dart';
import 'dart:convert';

//JSON File Structure - Keys
const String keyLenguage = '\"CurrentLenguage\"';
const String keyResult = '\"ResultPrecision\"';
enum FileEvent { createFile, updateFile }

//PROTÓTIPOS
abstract class BaseDataPersistence {
  Future<bool> checkFileExists();
  Future<void> createFile();
  Future<List> readFile();
  Future<void> writeFile();
  Future<void> loadData();
}

class DataPersistence implements BaseDataPersistence {
  //VARIÁVEIS GLOBAIS
  final String _fileName = "DataPersistence";
  var _singleton = Singleton();
  Map<String, String> fileAsJSON = Map();
  List fileAsList;
  bool fileExists = false;

  //MÉTODOS

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File("$path/" + _fileName + ".txt");
  }

  Future<File> getLocalPersistentFile() async {
    return await _localFile;
  }

  Future<void> createFile() async {
    final file = await _localFile;

    fileAsJSON[keyLenguage] = '\"EN\"';
    fileAsJSON[keyResult] = '\"Simple\"';

    String _x = fileAsJSON.toString();

    file.writeAsString("$_x" + "\r\n");
  }

  Future<bool> checkFileExists() async {
    File x = await getLocalPersistentFile();
    return x.exists();
  }

  Future<void> writeFile() async {
    final file = await _localFile;

_singleton.currentLanguage == 0 ?
    fileAsJSON[keyLenguage] = '\"PT-BR\"': 
    fileAsJSON[keyLenguage] = '\"EN\"';


    _singleton.resultPrecision == 0 ?
    fileAsJSON[keyResult] = '\"Simple\"': 
    fileAsJSON[keyResult] = '\"Precision\"';



  

    String _x = fileAsJSON.toString();

    await file.writeAsString("$_x" + "\r\n");


    
  }

  Future<List> readFile() async {
    try {
      final file = await _localFile;
      var contents = await file.readAsLines();

      fileAsList = json.decode(contents.toString());

      if (fileAsList[0]["CurrentLenguage"] == "EN")
       {
        _singleton.currentLanguage = 1;
        String _stringEN = await rootBundle.loadString('lib/languages/EN.js');
        //  _singleton.language = json.decode(_stringEN);
        await singletonInject(_stringEN);
      } 
      else if (fileAsList[0]["CurrentLenguage"] == "PT-BR")
       {
        _singleton.currentLanguage = 0;
         String _stringPT_BR = await rootBundle.loadString('lib/languages/PT-BR.js');
       // _singleton.language = json.decode(_stringPT_BR);
        await singletonInject(_stringPT_BR);
      }

      if(fileAsList[0]["ResultPrecision"] == "Simple")
       _singleton.resultPrecision = 0;
       else if(fileAsList[0]["ResultPrecision"] == "Precision")
       _singleton.resultPrecision = 1;

      // _updateSingleton();

      return fileAsList;
    } catch (e) {
      return null;
    }
  }

  Future<void> singletonInject(var __stringEN) async {
    _singleton.language = json.decode(__stringEN);
  }

  Future<void> loadAppLenguage() async {
    try {
    //  final file = await _localFile;
     // file.delete();
      if (!await checkFileExists()) {
        await createFile();
        await readFile();
      } else
        await readFile();
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> loadData() {
    // TODO: implement loadData
    return null;
  }
/*
  void _updateSingleton() {
    _singleton.userID = fileAsList[0]["userID"];
    _singleton.userEmail = fileAsList[0]["userEmail"];
    _singleton.userNickname = fileAsList[0]["userNickname"];
    _singleton.userName = fileAsList[0]["userName"];
    _singleton.profileLink = fileAsList[0]["profileLink"];
    _singleton.profileDescription = fileAsList[0]["profileDescription"];
    _singleton.picURL = fileAsList[0]["picURL"];
  }
  */

  void _list2JSON(var _triggerEvent) {
    if (_triggerEvent == FileEvent.updateFile) {
    } else if (_triggerEvent == FileEvent.createFile) {
      fileAsJSON[keyLenguage] = '"' + fileAsList[0]["CurrentLenguage"] + '"';
    }
  }
}
