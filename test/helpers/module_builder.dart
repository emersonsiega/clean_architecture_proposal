import 'package:flutter_modular/flutter_modular.dart';

///
/// Initializes FlutterModular module with correct bind instances
///
class ModuleBuilder {
  Module _module;

  ModuleBuilder._();
  static ModuleBuilder _instance;

  static ModuleBuilder module(Module module) {
    _instance = ModuleBuilder._();
    _instance._module = module;
    return _instance;
  }

  ModuleBuilder bind<T>(T Function() instanceBuilder) {
    var newBind = Bind.factory<T>((_) => instanceBuilder());

    final indexToChange = _module.binds.indexWhere(
      (bind) => bind.runtimeType == newBind.runtimeType,
    );

    if (indexToChange >= 0) {
      _module.binds[indexToChange] = newBind;
    }

    return this;
  }

  void build() {
    Modular.init(_module);
  }
}
