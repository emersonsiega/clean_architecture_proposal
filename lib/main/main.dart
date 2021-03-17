import 'package:flutter/material.dart';
import 'package:lyric_search_module/lyric_search_module.dart';

import '../ui/ui.dart';

import './factories/factories.dart';

void main() {
  lazyInjectInfra();
  lazyInjectUsecases();
  lazyInjectPresenters();

  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      theme: _makeAppTheme(),
      routes: _makeAppRoutes(),
    );
  }
}

Map<String, WidgetBuilder> _makeAppRoutes() {
  return {
    '/': (_) => LyricsSearchPage(),
    '/lyric': (_) => LyricPage(),
  };
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
