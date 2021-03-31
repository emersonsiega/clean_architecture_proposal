import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../domain/domain.dart';
import '../../ui/ui.dart';

import '../presentation.dart';

class BlocLyricsSearchPresenter
    extends Bloc<LyricsSearchEvent, LyricsSearchState>
    implements LyricsSearchPresenter {
  final Validation validation;
  final LyricsSearch lyricsSearch;

  BlocLyricsSearchPresenter({
    @required this.validation,
    @required this.lyricsSearch,
  }) : super(LyricsSearchState());

  Stream<LyricsSearchState> _search() async* {
    var newState = state
        .copyWith(isLoading: true)
        .copyWithNull(navigateTo: true, localError: true);

    try {
      yield newState;

      final entity = await lyricsSearch.search(
        LyricsSearchParams(artist: state.artist, music: state.music),
      );

      newState = newState.copyWith(
        navigateTo: PageConfig('/lyric', arguments: entity),
      );
    } on DomainError catch (error) {
      newState = newState.copyWith(localError: error.description);
    } finally {
      newState = newState.copyWith(isLoading: false);
    }

    yield newState;
  }

  Stream<LyricsSearchState> _validateArtist(String artist) async* {
    final error = validation.validate(field: 'artist', value: artist);

    yield state.copyWith(artist: artist, artistError: error).copyWithNull(
        localError: true, navigateTo: true, artistError: error == null);
  }

  Stream<LyricsSearchState> _validateMusic(String music) async* {
    final error = validation.validate(field: 'music', value: music);

    yield state.copyWith(music: music, musicError: error).copyWithNull(
        localError: true, navigateTo: true, musicError: error == null);
  }

  @override
  void dispose() {}

  @override
  Stream<LyricsSearchState> mapEventToState(event) async* {
    if (event is ValidateMusicEvent) {
      yield* _validateMusic(event.music);
    } else if (event is ValidateArtistEvent) {
      yield* _validateArtist(event.artist);
    } else if (event is SearchLyricEvent) {
      yield* _search();
    }
  }

  @override
  Stream<LyricsSearchState> get stateStream => this.stream;

  @override
  void fireEvent(LyricsSearchEvent event) {
    this.add(event);
  }
}
