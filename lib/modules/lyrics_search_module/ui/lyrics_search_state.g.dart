// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lyrics_search_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

extension LyricsSearchStateCopyWith on LyricsSearchState {
  LyricsSearchState copyWith({
    String errorMessage,
    List<LyricEntity> favorites,
    FormState form,
    bool isLoading,
    PageConfig navigateTo,
  }) {
    return LyricsSearchState(
      errorMessage: errorMessage ?? this.errorMessage,
      favorites: favorites ?? this.favorites,
      form: form ?? this.form,
      isLoading: isLoading ?? this.isLoading,
      navigateTo: navigateTo ?? this.navigateTo,
    );
  }

  LyricsSearchState copyWithNull({
    bool errorMessage = false,
    bool favorites = false,
    bool form = false,
    bool isLoading = false,
    bool navigateTo = false,
  }) {
    return LyricsSearchState(
      errorMessage: errorMessage == true ? null : this.errorMessage,
      favorites: favorites == true ? null : this.favorites,
      form: form == true ? null : this.form,
      isLoading: isLoading == true ? null : this.isLoading,
      navigateTo: navigateTo == true ? null : this.navigateTo,
    );
  }
}
