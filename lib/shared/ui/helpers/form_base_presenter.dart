import './base_presenter.dart';
import './base_state.dart';

abstract class FormBasePresenter<S extends BaseState> extends BasePresenter<S> {
  void validate(String fieldName, String value);
}
