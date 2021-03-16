import 'dart:async';

import 'package:meta/meta.dart';

import '../../domain/domain.dart';
import '../../ui/ui.dart';

class LyricState {
  String localError;
  String successMessage;
  bool isLoading = false;
  bool isFavorite = false;
}

class StreamLyricPresenter implements LyricPresenter {
  final SaveFavoriteLyrics saveFavoriteLyrics;
  final LoadFavoriteLyrics loadFavoriteLyrics;
  LyricState _state;
  final _stateController = StreamController<LyricState>.broadcast();

  void _initialState() {
    _state = LyricState()
      ..isFavorite = false
      ..isLoading = false
      ..localError = null
      ..successMessage = null;
  }

  StreamLyricPresenter({
    @required this.saveFavoriteLyrics,
    @required this.loadFavoriteLyrics,
  }) {
    _initialState();
  }

  @override
  Stream<String> get localErrorStream =>
      _stateController.stream.map((state) => state.localError).distinct();

  @override
  Stream<bool> get isLoadingStream =>
      _stateController.stream.map((state) => state.isLoading).distinct();

  @override
  Stream<String> get successMessageStream =>
      _stateController.stream.map((state) => state.successMessage).distinct();

  @override
  Stream<bool> get isFavoriteStream =>
      _stateController.stream.map((state) => state.isFavorite).distinct();

  @override
  Future<void> addFavorite(LyricEntity entity) async {
    try {
      _initialState();
      _state.isLoading = true;
      _update();

      final favorites = await loadFavoriteLyrics.loadFavorites() ?? [];

      if (favorites.contains(entity)) {
        favorites.remove(entity);
        await saveFavoriteLyrics.save(favorites);
        _state.isFavorite = false;
      } else {
        await saveFavoriteLyrics.save([...favorites, entity]);
        _state.isFavorite = true;
        _state.successMessage = "Lyric was added to favorites!";
      }
    } on DomainError catch (error) {
      _state.localError = error.description;
    } finally {
      _state.isLoading = false;
      _update();
    }
  }

  @override
  Future<void> checkIsFavorite(LyricEntity entity) async {
    final favorites = await loadFavoriteLyrics.loadFavorites();

    _state.isFavorite = favorites?.contains(entity) ?? false;

    _update();
  }

  void _update() => _stateController.add(_state);

  @override
  void dispose() {
    _stateController.close();
  }
}
