import 'dart:async';

import 'package:meta/meta.dart';

import '../../ui/ui.dart';

import '../presentation.dart';

class LyricsSearchState {
  String artist;
  String music;
  String artistError;
  String musicError;

  bool get isFormValid =>
      artist?.isNotEmpty == true &&
      artistError?.isNotEmpty != true &&
      music?.isNotEmpty == true &&
      musicError?.isNotEmpty != true;
}

class StreamLyricsSearchPresenter implements LyricsSearchPresenter {
  final Validation validation;
  final _state = LyricsSearchState();
  final _stateController = StreamController<LyricsSearchState>.broadcast();

  StreamLyricsSearchPresenter({@required this.validation}) {
    _stateController.add(_state);
  }

  @override
  Stream<String> get artistErrorStream =>
      _stateController.stream.map((state) => state.artistError);

  @override
  Stream<String> get musicErrorStream =>
      _stateController.stream.map((state) => state.musicError);

  @override
  Stream<bool> get isFormValidStream =>
      _stateController.stream.map((state) => state.isFormValid);

  @override
  Stream<bool> get isLoadingStream => throw UnimplementedError();

  @override
  Stream<String> get localErrorStream => throw UnimplementedError();

  @override
  Future<void> search() {
    throw UnimplementedError();
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
