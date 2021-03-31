import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';

import '../helpers/base_state.dart';
import '../ui.dart';

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
