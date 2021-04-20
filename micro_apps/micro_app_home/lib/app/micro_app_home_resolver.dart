import 'package:micro_core/micro_core.dart';

import 'ui/pages/home/home_page.dart';

class MicroAppHomeResolver implements MicroApp {
  @override
  String get microAppName => 'micro_app_home';

  @override
  Map<String, WidgetBuilderArgs> get routes => {
        '/home': (context, args) => HomePage(
              title: 'Demo App',
            ),
      };
}