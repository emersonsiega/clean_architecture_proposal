import 'package:flutter/widgets.dart';

abstract class BaseModule {
  Route onGenerateRoute(RouteSettings settings);
  void injectDependencies();
}
