import 'package:flutter_modular/flutter_modular.dart';

import './base_state.dart';

abstract class BasePresenter<S extends BaseState> implements Disposable {
  Stream<S> get stateStream;
}
