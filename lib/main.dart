import 'package:flutter/material.dart';
import 'package:todo_app/pages/home.dart';
import 'package:todo_app/utils/totoStorage.dart';

void main() => runApp(MaterialApp(
  theme: ThemeData(
    colorScheme: ColorScheme.fromSwatch(
      brightness: Brightness.light,
      primarySwatch: Colors.deepOrange
    ).copyWith(
      secondary: Colors.yellow
    )
  ),
  home: Home(storage: ToDoStorage()),
));
