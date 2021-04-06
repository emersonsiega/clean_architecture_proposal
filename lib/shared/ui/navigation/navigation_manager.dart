import 'package:flutter_modular/flutter_modular.dart';

import 'interfaces/interfaces.dart';

// ignore: non_constant_identifier_names
final _NavigationManager Nav = _NavigationManager();

class _NavigationManager implements Navigation {
  @override
  Future<T> pushNamed<T>(String path, {dynamic arguments}) async {
    return await Modular.to.pushNamed(path, arguments: arguments);
  }

  @override
  Future<T> pushReplacementNamed<T>(String path, {dynamic arguments}) async {
    return await Modular.to.pushReplacementNamed(path, arguments: arguments);
  }

  @override
  dynamic pop({dynamic response}) {
    return Modular.to.pop(response);
  }

  @override
  bool canPop() {
    return Modular.to.canPop();
  }
}
