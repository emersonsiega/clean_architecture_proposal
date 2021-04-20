import 'package:flutter/material.dart';
import 'package:micro_core/micro_core.dart';
import 'package:micro_app_home/micro_app_home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget with BaseApp {
  final RouteSettings initialRouteSettings =
      RouteSettings(name: '/home', arguments: null);

  @override
  Widget build(BuildContext context) {
    super.registerRouters();

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: navigatorKey,
      onGenerateRoute: (_) => super.generateRoute(initialRouteSettings),
    );
  }

  @override
  Map<String, WidgetBuilderArgs> get baseRoutes => {};

  @override
  List<MicroApp> get microApps => [
        MicroAppHomeResolver(),
      ];
}
