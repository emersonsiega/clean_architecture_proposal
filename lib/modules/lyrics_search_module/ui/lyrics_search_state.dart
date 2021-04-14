import 'package:copy_with_extension/copy_with_extension.dart';

import '../../../shared/shared.dart';

part 'lyrics_search_state.g.dart';

@CopyWith(generateCopyWithNull: true)
class LyricsSearchState extends BaseState
    with NavigationState, ErrorMessageState, LoadingState, FormValidState {
  @override
  final bool isLoading;
  @override
  final String errorMessage;
  @override
  final PageConfig navigateTo;
  @override
  bool get isFormValid => !form.hasError;

  final List<LyricEntity> favorites;
  final FormState form;

  LyricsSearchState({
    this.form,
    this.isLoading: false,
    this.errorMessage,
    this.navigateTo,
    this.favorites,
  });

  factory LyricsSearchState.initial({
    String artist,
    String artistError,
    String music,
    String musicError,
  }) {
    return LyricsSearchState(
      form: FormState([
        FieldState(name: 'artist', value: artist, error: artistError),
        FieldState(name: 'music', value: music, error: musicError),
      ]),
    );
  }

  @override
  List<Object> get props => [
        this.form,
        this.isLoading,
        this.errorMessage,
        this.navigateTo,
        this.favorites,
      ];
}
