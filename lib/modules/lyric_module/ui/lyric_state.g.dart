// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lyric_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

extension LyricStateCopyWith on LyricState {
  LyricState copyWith({
    String errorMessage,
    bool isFavorite,
    bool isLoading,
    String message,
  }) {
    return LyricState(
      errorMessage: errorMessage ?? this.errorMessage,
      isFavorite: isFavorite ?? this.isFavorite,
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
    );
  }

  LyricState copyWithNull({
    bool errorMessage = false,
    bool isFavorite = false,
    bool isLoading = false,
    bool message = false,
  }) {
    return LyricState(
      errorMessage: errorMessage == true ? null : this.errorMessage,
      isFavorite: isFavorite == true ? null : this.isFavorite,
      isLoading: isLoading == true ? null : this.isLoading,
      message: message == true ? null : this.message,
    );
  }
}
