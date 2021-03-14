import 'package:get_it/get_it.dart';

import '../dependency_management.dart';

///
/// Dependency Manager implemented with GetIt package.
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
    return GetIt.I.get<T>();
  }

  @override
  void put<T>(T instance) {
    delete<T>();
    GetIt.I.registerSingleton<T>(instance);
  }

  @override
  void lazyPut<T>(T Function() instanceBuilder) {
    GetIt.I.registerLazySingleton<T>(instanceBuilder);
  }

  @override
  void delete<T>() {
    if (GetIt.I.isRegistered<T>()) {
      GetIt.I.unregister<T>();
    }
  }
}
