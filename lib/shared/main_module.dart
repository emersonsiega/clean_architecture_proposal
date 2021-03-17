import 'package:flutter/widgets.dart';

abstract class MainModule {
  Widget get page;
  void injectDependencies();
}
