import 'package:flutter_modular/flutter_modular.dart';
import 'package:micro_app_about/micro_app_about.dart';
import 'package:micro_app_search/micro_app_search.dart';

class AppModule extends Module {
  @override
  //ignore:overridden_fields
  final List<Bind> binds = [];

  @override
  //ignore:overridden_fields
  final List<ModularRoute> routes = [
    ModuleRoute(Modular.initialRoute, module: MicroAppSearchModule()),
    ModuleRoute('/about', module: MicroAppAboutModule()),
  ];
}
