import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../shared/shared.dart';

import '../../domain/domain.dart';
import '../../ui/ui.dart';

class CubitLyricPresenter extends Cubit<LyricState> implements LyricPresenter {
  final SaveFavoriteLyrics saveFavoriteLyrics;
  final LoadFavoriteLyrics loadFavoriteLyrics;

  CubitLyricPresenter({
    @required this.saveFavoriteLyrics,
    @required this.loadFavoriteLyrics,
  }) : super(LyricState.initial());

  @override
  Stream<LyricState> get stateStream => this.stream;

  @override
  Future<void> addFavorite(LyricEntity entity) async {
    var newState = LyricState.loading();

    try {
      emit(newState);

      final favorites = await loadFavoriteLyrics.loadFavorites() ?? [];

      if (favorites.contains(entity)) {
        favorites.remove(entity);
        await saveFavoriteLyrics.save(favorites);

        newState = newState.copyWith(
          isFavorite: false,
          successMessage: "Lyric was removed from favorites!",
        );
      } else {
        await saveFavoriteLyrics.save([...favorites, entity]);
        newState = newState.copyWith(
          isFavorite: true,
          successMessage: "Lyric was added to favorites!",
        );
      }
    } on DomainError catch (error) {
      newState = newState.copyWith(localError: error.description);
    } finally {
      newState = newState.copyWith(isLoading: false);

      emit(newState);
    }
  }

  @override
  Future<void> checkIsFavorite(LyricEntity entity) async {
    var newState = LyricState.loading().copyWith(isFavorite: false);
    emit(newState);

    try {
      final favorites = await loadFavoriteLyrics.loadFavorites();

      newState = newState.copyWith(
        isFavorite: favorites?.contains(entity) ?? false,
      );
    } on DomainError catch (error) {
      newState = newState.copyWith(localError: error.description);
    } finally {
      emit(newState.copyWith(isLoading: false));
    }
  }

  @override
  void dispose() {
    this.close();
  }
}
