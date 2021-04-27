import 'package:flutter_modular/flutter_modular.dart';
import 'package:micro_app_about/app/ui/pages/about/about_page.dart';

class MicroAppAboutModule extends Module {
  @override
  //ignore:overridden_fields
  final List<Bind> binds = [];

  @override
  //ignore:overridden_fields
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => AboutPage()),
  ];
}
