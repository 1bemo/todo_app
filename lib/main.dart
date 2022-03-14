import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/pages/home.dart';
//import 'package:todo_app/pages/mainScreen.dart';

void main() async {

  //инициализация файрбейс (СТРОГО ДО ВЫЗОВА runApp)
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    theme: ThemeData(
      colorScheme: ColorScheme.fromSwatch(
          brightness: Brightness.light,
          primarySwatch: Colors.deepOrange
      ).copyWith(
          secondary: Colors.yellow
      )
    ),
    home: const Home(),
  ));

  // runApp(MaterialApp(
  //   theme: ThemeData(
  //       colorScheme: ColorScheme.fromSwatch(
  //           brightness: Brightness.light,
  //           primarySwatch: Colors.deepOrange
  //       ).copyWith(
  //           secondary: Colors.yellow
  //       )
  //   ),
  //   initialRoute: '/',
  //   routes: {
  //     '/': (context) => const MainScreen(),
  //     '/todo': (context) => const Home(),
  //   },
  // ));
}


