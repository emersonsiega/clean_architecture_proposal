import 'package:flutter/foundation.dart';

enum AppRoute { home, lyric }

extension AppRouteName on AppRoute {
  String get name => describeEnum(this);
}

AppRoute appRouteFromString(String route) {
  return AppRoute.values.firstWhere(
    (element) => element.name == route.replaceFirst('/', ''),
    orElse: null,
  );
}
