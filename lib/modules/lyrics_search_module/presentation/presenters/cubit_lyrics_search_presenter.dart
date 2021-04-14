import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../shared/shared.dart';
import '../../../../app/app_route.dart';

import '../../domain/domain.dart';
import '../../ui/ui.dart';

class CubitLyricsSearchPresenter extends Cubit<LyricsSearchState>
    implements LyricsSearchPresenter {
  final Validation validation;
  final LyricsSearch lyricsSearch;
  final LoadFavoriteLyrics loadFavoriteLyrics;

  CubitLyricsSearchPresenter({
    @required this.validation,
    @required this.lyricsSearch,
    @required this.loadFavoriteLyrics,
  }) : super(LyricsSearchState.initial());

  @override
  Stream<LyricsSearchState> get stateStream => this.stream;

  void _navigateToLyric(LyricEntity entity) {
    emit(state
        .copyWith(
          navigateTo: PageConfig(
            AppRoute.lyric,
            arguments: entity,
            whenComplete: loadFavorites,
          ),
        )
        .copyWithNull(errorMessage: true));
  }

  @override
  Future<void> search() async {
    var newState = state
        .copyWith(isLoading: true)
        .copyWithNull(navigateTo: true, errorMessage: true);

    try {
      emit(newState);

      final entity = await lyricsSearch.search(
        LyricsSearchParams(
          artist: state.form.value(LyricsSearchFields.artist),
          music: state.form.value(LyricsSearchFields.music),
        ),
      );

      _navigateToLyric(entity);
    } on DomainError catch (error) {
      newState = newState.copyWith(errorMessage: error.description);
    } finally {
      newState = newState.copyWith(isLoading: false);
      emit(newState);
    }
  }

  @override
  Future<void> loadFavorites() async {
    var newState = state
        .copyWith(isLoading: true)
        .copyWithNull(errorMessage: true, favorites: true, navigateTo: true);
    try {
      emit(newState);

      final favorites = await loadFavoriteLyrics.loadFavorites();
      newState = newState.copyWith(favorites: favorites);
    } on DomainError catch (error) {
      newState = newState.copyWith(errorMessage: error.description);
    } finally {
      emit(newState.copyWith(isLoading: false));
    }
  }

  @override
  Future<void> openFavorite(LyricEntity entity) async {
    _navigateToLyric(entity);
  }

  @override
  void validate(String fieldName, String value) {
    final error = validation.validate(field: fieldName, value: value);

    var newState = state
        .copyWith(
          form: state.form.copyWith(
            fieldName,
            value: value,
            error: error,
            clearError: error == null,
          ),
        )
        .copyWithNull(errorMessage: true);

    emit(newState);
  }

  @override
  void dispose() {
    this.close();
  }
}
