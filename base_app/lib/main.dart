import 'package:clean_architecture_proposal/app/app_widget.dart';
import 'package:clean_architecture_proposal/app/base_app_module.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';

void main() => runApp(ModularApp(module: AppModule(), child: AppWidget()));
