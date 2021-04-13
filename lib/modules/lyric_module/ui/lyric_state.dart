import 'package:copy_with_extension/copy_with_extension.dart';

import '../../../shared/ui/ui.dart';

part 'lyric_state.g.dart';

@CopyWith(generateCopyWithNull: true)
class LyricState extends BaseState
    with LoadingState, ErrorMessageState, SuccessMessageState {
  final bool isFavorite;
  @override
  final String message;
  @override
  final String errorMessage;
  @override
  final bool isLoading;

  LyricState({
    this.message,
    this.isFavorite: false,
    this.isLoading: false,
    this.errorMessage,
  });

  factory LyricState.initial() {
    return LyricState(
      isLoading: false,
      errorMessage: null,
      message: null,
    );
  }

  factory LyricState.loading() {
    return LyricState(
      isLoading: true,
      errorMessage: null,
      message: null,
    );
  }

  @override
  List<Object> get props => [
        this.message,
        this.isFavorite,
        this.isLoading,
        this.errorMessage,
      ];
}
