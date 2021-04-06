// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lyric_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

extension LyricStateCopyWith on LyricState {
  LyricState copyWith({
    bool isFavorite,
    bool isLoading,
    String localError,
    PageConfig navigateTo,
    String successMessage,
  }) {
    return LyricState(
      isFavorite: isFavorite ?? this.isFavorite,
      isLoading: isLoading ?? this.isLoading,
      localError: localError ?? this.localError,
      navigateTo: navigateTo ?? this.navigateTo,
      successMessage: successMessage ?? this.successMessage,
    );
  }

  LyricState copyWithNull({
    bool isFavorite = false,
    bool isLoading = false,
    bool localError = false,
    bool navigateTo = false,
    bool successMessage = false,
  }) {
    return LyricState(
      isFavorite: isFavorite == true ? null : this.isFavorite,
      isLoading: isLoading == true ? null : this.isLoading,
      localError: localError == true ? null : this.localError,
      navigateTo: navigateTo == true ? null : this.navigateTo,
      successMessage: successMessage == true ? null : this.successMessage,
    );
  }
}
