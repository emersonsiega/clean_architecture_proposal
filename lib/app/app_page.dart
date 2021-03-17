import 'package:flutter/material.dart';

import '../shared/shared.dart';
import '../modules/modules.dart';

import './app_route.dart';

class AppPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoute.home.name,
      theme: _makeAppTheme(),
      onGenerateRoute: _onGenerateRoute,
    );
  }
}

Route _onGenerateRoute(RouteSettings settings) {
  print("CHANGING ROUTE ${settings.name} ${settings.arguments}");

  switch (appRouteFromString(settings.name)) {
    case AppRoute.home:
      return Get.i().get<LyricsSearchModule>().onGenerateRoute(settings);
    case AppRoute.lyric:
      return Get.i().get<LyricModule>().onGenerateRoute(settings);
  }

  return null;
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
