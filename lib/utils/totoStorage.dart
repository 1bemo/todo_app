import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ToDoStorage {

  int _index = 0;

  //геттер пути до каталогов
  Future<String> get _localPath async {
    final dir  = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  //геттер пути до файла
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/todo$_index.txt');
  }

  //геттер пути до файла с кол-вом
  Future<File> get _localFileCount async {
    final path = await _localPath;
    return File('$path/countTodo.txt');
  }

  //получаем содержимое файла
  Future<String> readTodo(int index) async {
    _index = index;
    try {
      final file = await _localFile;
      final content = await file.readAsString();
      return content;
    } catch (e) {
      //return e.toString();
      return 'ADM:file_not_exist#35698751-12_88';
    }
  }

  //получаеам кол-во задач
  Future<int> readCountTodo() async {
    try {
      final file = await _localFileCount;
      final content = await file.readAsString();
      return int.parse(content);
    } catch (e) {
      return 0;
    }
  }

  //запись в файл задачу
  void writeTodo(String todoString) async {
    final file = await _localFile;
    file.writeAsString(todoString);
  }

  //запись в файл кол-во задач
  void writeCountTodo(int countTodo) async {
    final file = await _localFileCount;
    file.writeAsString('$countTodo');
  }

  void deleteFile() async {
    final file = await _localFile;
    file.delete();
  }
}