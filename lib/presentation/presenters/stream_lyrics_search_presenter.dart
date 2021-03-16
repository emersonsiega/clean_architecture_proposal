import 'dart:async';

import 'package:clean_architecture_proposal/domain/domain.dart';
import 'package:meta/meta.dart';

import '../../ui/ui.dart';

import '../presentation.dart';

class LyricsSearchState {
  String artist;
  String music;
  String artistError;
  String musicError;
  String localError;
  PageConfig navigateTo;
  bool isLoading = false;
  List<LyricEntity> favorites;

  bool get isFormValid =>
      artist?.isNotEmpty == true &&
      artistError?.isNotEmpty != true &&
      music?.isNotEmpty == true &&
      musicError?.isNotEmpty != true;
}

class StreamLyricsSearchPresenter implements LyricsSearchPresenter {
  final Validation validation;
  final LyricsSearch lyricsSearch;
  final LoadFavoriteLyrics loadFavoriteLyrics;
  final _state = LyricsSearchState();
  final _stateController = StreamController<LyricsSearchState>.broadcast();

  StreamLyricsSearchPresenter({
    @required this.validation,
    @required this.lyricsSearch,
    @required this.loadFavoriteLyrics,
  }) {
    _stateController.add(_state);
  }

  @override
  Stream<String> get artistErrorStream =>
      _stateController.stream.map((state) => state.artistError).distinct();

  @override
  Stream<String> get musicErrorStream =>
      _stateController.stream.map((state) => state.musicError).distinct();

  @override
  Stream<bool> get isFormValidStream =>
      _stateController.stream.map((state) => state.isFormValid).distinct();

  @override
  Stream<bool> get isLoadingStream =>
      _stateController.stream.map((state) => state.isLoading).distinct();

  @override
  Stream<String> get localErrorStream =>
      _stateController.stream.map((state) => state.localError).distinct();

  @override
  Stream<PageConfig> get navigateToStream =>
      _stateController.stream.map((state) => state.navigateTo).distinct();

  @override
  Stream<List<LyricEntity>> get favoritesStream =>
      _stateController.stream.map((state) => state.favorites).distinct();

  @override
  Future<void> search() async {
    try {
      _state.isLoading = true;
      _state.localError = null;
      _state.navigateTo = null;
      _update();

      final entity = await lyricsSearch.search(
        LyricsSearchParams(artist: _state.artist, music: _state.music),
      );

      _state.navigateTo = PageConfig('/lyric', arguments: entity);
    } on DomainError catch (error) {
      _state.localError = error.description;
    } finally {
      _state.isLoading = false;
      _update();
    }
  }

  @override
  Future<void> loadFavorites() async {
    await loadFavoriteLyrics.loadFavorites();
  }

  void _update() => _stateController.add(_state);

  @override
  void validateArtist(String artist) {
    _state.artist = artist;
    final error = validation.validate(field: 'artist', value: artist);
    _state.artistError = error;
    _update();
  }

  @override
  void validateMusic(String music) {
    _state.music = music;
    final error = validation.validate(field: 'music', value: music);
    _state.musicError = error;
    _update();
  }

  @override
  void dispose() {
    _stateController.close();
  }
}
