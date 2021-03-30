import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import './app_route.dart';

class AppPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoute.home,
      theme: _makeAppTheme(),
    ).modular();
  }
}

ThemeData _makeAppTheme() {
  return ThemeData(
    primaryColor: Colors.deepPurple,
    accentColor: Colors.deepPurple[800],
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
      ),
    ),
  );
}
