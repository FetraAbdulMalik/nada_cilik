import 'package:flutter/material.dart';
import 'package:pemrograman_mobile_project/models/song.dart';
import 'package:pemrograman_mobile_project/screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Instantiate our custom application-wide state controller
    final appState = AppState();

    return MaterialApp(
      title: 'Nada Cilik',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: Colors.blue.shade700,
        ),
        useMaterial3: true,
        fontFamily: 'Comic Sans MS', // Gives the kids app a friendly look & feel
      ),
      home: LoginScreen(state: appState),
    );
  }
}
