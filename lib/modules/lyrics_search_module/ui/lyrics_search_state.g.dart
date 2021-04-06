// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lyrics_search_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

extension LyricsSearchStateCopyWith on LyricsSearchState {
  LyricsSearchState copyWith({
    String artist,
    String artistError,
    List<LyricEntity> favorites,
    bool isLoading,
    String localError,
    String music,
    String musicError,
    PageConfig navigateTo,
  }) {
    return LyricsSearchState(
      artist: artist ?? this.artist,
      artistError: artistError ?? this.artistError,
      favorites: favorites ?? this.favorites,
      isLoading: isLoading ?? this.isLoading,
      localError: localError ?? this.localError,
      music: music ?? this.music,
      musicError: musicError ?? this.musicError,
      navigateTo: navigateTo ?? this.navigateTo,
    );
  }

  LyricsSearchState copyWithNull({
    bool artist = false,
    bool artistError = false,
    bool favorites = false,
    bool isLoading = false,
    bool localError = false,
    bool music = false,
    bool musicError = false,
    bool navigateTo = false,
  }) {
    return LyricsSearchState(
      artist: artist == true ? null : this.artist,
      artistError: artistError == true ? null : this.artistError,
      favorites: favorites == true ? null : this.favorites,
      isLoading: isLoading == true ? null : this.isLoading,
      localError: localError == true ? null : this.localError,
      music: music == true ? null : this.music,
      musicError: musicError == true ? null : this.musicError,
      navigateTo: navigateTo == true ? null : this.navigateTo,
    );
  }
}
