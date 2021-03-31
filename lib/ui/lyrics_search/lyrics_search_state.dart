import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';

import '../helpers/base_state.dart';
import '../ui.dart';

part 'lyrics_search_state.g.dart';

@CopyWith(generateCopyWithNull: true)
class LyricsSearchState extends Equatable implements BaseState {
  final String artist;
  final String music;
  final String artistError;
  final String musicError;
  @override
  final bool isLoading;
  @override
  final String localError;
  @override
  final PageConfig navigateTo;

  LyricsSearchState({
    this.artist,
    this.music,
    this.isLoading: false,
    this.artistError,
    this.localError,
    this.musicError,
    this.navigateTo,
  });

  @override
  bool get isFormValid =>
      artist?.isNotEmpty == true &&
      artistError?.isNotEmpty != true &&
      music?.isNotEmpty == true &&
      musicError?.isNotEmpty != true;

  @override
  List<Object> get props => [
        this.artist,
        this.music,
        this.isLoading,
        this.artistError,
        this.localError,
        this.musicError,
        this.navigateTo,
      ];
}
