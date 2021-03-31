import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../domain/domain.dart';
import '../../ui/ui.dart';

class StreamLyricPresenter extends Bloc<LyricEvent, LyricState>
    implements LyricPresenter {
  final SaveFavoriteLyrics saveFavoriteLyrics;
  final LoadFavoriteLyrics loadFavoriteLyrics;

  StreamLyricPresenter({
    @required this.saveFavoriteLyrics,
    @required this.loadFavoriteLyrics,
  }) : super(_initialState());

  static LyricState _initialState() {
    return LyricState()
        .copyWith(isFavorite: false, isLoading: false)
        .copyWithNull(localError: true, successMessage: true);
  }

  Stream<LyricState> _addFavorite(LyricEntity entity) async* {
    var newState = _initialState().copyWith(isLoading: true);
    yield newState;

    try {
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
    }

    yield newState;
  }

  Stream<LyricState> _checkIsFavorite(LyricEntity entity) async* {
    var newState =
        state.copyWith(isFavorite: false).copyWithNull(successMessage: true);

    try {
      final favorites = await loadFavoriteLyrics.loadFavorites();

      newState =
          newState.copyWith(isFavorite: favorites?.contains(entity) ?? false);
    } on DomainError catch (error) {
      newState = newState.copyWith(localError: error.description);
    }

    yield newState;
  }

  @override
  void dispose() {}

  @override
  void fireEvent(LyricEvent event) {
    this.add(event);
  }

  @override
  Stream<LyricState> get stateStream => this.stream;

  @override
  Stream<LyricState> mapEventToState(LyricEvent event) async* {
    if (event is CheckFavoriteEvent) {
      yield* _checkIsFavorite(event.entity);
    } else if (event is AddFavoriteEvent) {
      yield* _addFavorite(event.entity);
    }
  }
}
