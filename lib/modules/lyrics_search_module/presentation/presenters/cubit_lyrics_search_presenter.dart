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
    emit(state.copyWith(
      navigateTo: PageConfig(
        AppRoute.lyric,
        arguments: entity,
        whenComplete: loadFavorites,
      ),
    ));
  }

  @override
  Future<void> search() async {
    var newState = state
        .copyWith(isLoading: true)
        .copyWithNull(navigateTo: true, errorMessage: true);

    try {
      emit(newState);

      final entity = await lyricsSearch.search(
        LyricsSearchParams(artist: state.artist, music: state.music),
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
  void validateArtist(String artist) {
    var newState = state
        .copyWith(artist: artist)
        .copyWithNull(errorMessage: true, artistError: true);

    final error = validation.validate(field: 'artist', value: artist);

    newState = newState.copyWith(artistError: error);

    emit(newState);
  }

  @override
  void validateMusic(String music) {
    var newState = state
        .copyWith(music: music)
        .copyWithNull(errorMessage: true, musicError: true);

    final error = validation.validate(field: 'music', value: music);

    newState = newState.copyWith(musicError: error);

    emit(newState);
  }

  @override
  void dispose() {
    this.close();
  }
}
