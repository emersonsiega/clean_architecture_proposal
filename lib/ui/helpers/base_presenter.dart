import './base_state.dart';

abstract class BasePresenter<S extends BaseState, E> {
  Stream<S> get stateStream;
  void fireEvent(E event);

  void dispose();
}
