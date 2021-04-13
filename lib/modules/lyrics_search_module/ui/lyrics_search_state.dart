import 'package:copy_with_extension/copy_with_extension.dart';

import '../../../shared/shared.dart';

part 'lyrics_search_state.g.dart';

@CopyWith(generateCopyWithNull: true)
class LyricsSearchState extends BaseState
    with NavigationState, ErrorMessageState, LoadingState, FormValidState {
  final String artist;
  final String music;
  final String artistError;
  final String musicError;
  final List<LyricEntity> favorites;
  @override
  final bool isLoading;
  @override
  final String errorMessage;
  @override
  final PageConfig navigateTo;
  @override
  bool get isFormValid =>
      artist?.isNotEmpty == true &&
      artistError?.isNotEmpty != true &&
      music?.isNotEmpty == true &&
      musicError?.isNotEmpty != true;

  LyricsSearchState({
    this.artist,
    this.music,
    this.isLoading: false,
    this.artistError,
    this.errorMessage,
    this.musicError,
    this.navigateTo,
    this.favorites,
  });

  factory LyricsSearchState.initial() {
    return LyricsSearchState(
      errorMessage: null,
      navigateTo: null,
    );
  }

  @override
  List<Object> get props => [
        this.artist,
        this.music,
        this.isLoading,
        this.artistError,
        this.errorMessage,
        this.musicError,
        this.navigateTo,
        this.favorites,
      ];
}
