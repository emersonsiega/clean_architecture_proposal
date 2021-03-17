import 'package:flutter/material.dart';

import '../ui/ui.dart';

import './factories/factories.dart';

void main() {
  lazyInjectInfra();
  lazyInjectUsecases();

  injectModulesDependencies();

  runApp(App());
}
