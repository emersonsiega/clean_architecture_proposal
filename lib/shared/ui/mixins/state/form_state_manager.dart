import '../../helpers/helpers.dart';

mixin FormStateManager on BaseState {
  FormState get form;

  bool get isFormValid => !form.hasError;
}
