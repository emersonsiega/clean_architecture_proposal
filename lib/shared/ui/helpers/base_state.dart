import '../../ui/ui.dart';

class BaseState {
  final bool isLoading;
  final String localError;
  final PageConfig navigateTo;
  final bool isFormValid;

  BaseState({
    this.isLoading,
    this.localError,
    this.navigateTo,
    this.isFormValid,
  });
}
