import 'package:flutter/material.dart';
import 'package:todo_app/pages/home.dart';
import 'package:todo_app/pages/mainScreen.dart';

void main() => runApp(MaterialApp(
  theme: ThemeData(
    colorScheme: ColorScheme.fromSwatch(
      brightness: Brightness.light,
      primarySwatch: Colors.deepOrange
    ).copyWith(
      secondary: Colors.yellow
    )
  ),
  initialRoute: '/',
  routes: {
    '/': (context) => const MainScreen(),
    '/todo': (context) => const Home(),
  },
));
