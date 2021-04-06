import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';

import '../../../shared/ui/helpers/helpers.dart';

part 'lyric_state.g.dart';

@CopyWith(generateCopyWithNull: true)
class LyricState extends Equatable implements BaseState {
  final String successMessage;
  final bool isFavorite;
  @override
  final String localError;
  @override
  final bool isLoading;
  @override
  final PageConfig navigateTo;

  LyricState({
    this.successMessage,
    this.isFavorite: false,
    this.isLoading: false,
    this.localError,
    this.navigateTo,
  });

  factory LyricState.initial() {
    return LyricState(
      isLoading: false,
      localError: null,
      navigateTo: null,
      successMessage: null,
    );
  }

  factory LyricState.loading() {
    return LyricState(
      isLoading: true,
      localError: null,
      navigateTo: null,
      successMessage: null,
    );
  }

  @override
  bool get isFormValid => true;

  @override
  List<Object> get props => [
        this.successMessage,
        this.isFavorite,
        this.isLoading,
        this.localError,
        this.navigateTo,
      ];
}
