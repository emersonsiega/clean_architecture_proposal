import './base_state.dart';

abstract class BasePresenter<S extends BaseState> {
  Stream<S> get stateStream;

  void dispose();
}
