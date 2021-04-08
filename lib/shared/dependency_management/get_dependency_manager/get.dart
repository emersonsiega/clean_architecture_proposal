import 'package:flutter_modular/flutter_modular.dart';

import '../dependency_management.dart';

///
/// Dependency Manager implemented with Modular package.
///
class Get implements DependencyManager {
  Get._();
  static Get _instance;

  static Get i() {
    if (_instance == null) {
      _instance = Get._();
    }

    return _instance;
  }

  @override
  T get<T>() {
    return Modular.get<T>();
  }

  @override
  @deprecated
  void put<T>(T instance) {
    delete<T>();
    //GetIt.I.registerSingleton<T>(instance);
  }

  @override
  @deprecated
  void lazyPut<T>(T Function() instanceBuilder) {
    //GetIt.I.registerLazySingleton<T>(instanceBuilder);
  }

  @override
  @deprecated
  void delete<T>() {
    // if (GetIt.I.isRegistered<T>()) {
    //   GetIt.I.unregister<T>();
    // }
  }
}
