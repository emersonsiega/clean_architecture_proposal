import 'dart:async';

import 'package:clean_architecture_proposal/domain/domain.dart';
import 'package:clean_architecture_proposal/ui/ui.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

abstract class LyricPresenter implements LocalErrorManager, FormLoadingManager {
  Future<void> addFavorite(LyricEntity entity);

  Stream<String> get successMessageStream;
  Stream<bool> get isFavoriteStream;

  void dispose();
}

class LyricState {
  String localError;
  String successMessage;
  bool isLoading = false;
  bool isFavorite = false;
}

class StreamLyricPresenter implements LyricPresenter {
  final SaveFavoriteLyrics saveFavoriteLyrics;
  LyricState _state;
  final _stateController = StreamController<LyricState>.broadcast();

  void _initialState() {
    _state = LyricState()
      ..isFavorite = false
      ..isLoading = false
      ..localError = null
      ..successMessage = null;
  }

  StreamLyricPresenter({@required this.saveFavoriteLyrics}) {
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

      await saveFavoriteLyrics.save([entity]);

      _state.isFavorite = true;
      _state.successMessage = "Lyric was added to favorites!";
    } on DomainError catch (error) {
      _state.localError = error.description;
    } finally {
      _state.isLoading = false;
      _update();
    }
  }

  void _update() => _stateController.add(_state);

  @override
  void dispose() {
    _stateController.close();
  }
}

class SaveFavoriteLyricsSpy extends Mock implements SaveFavoriteLyrics {}

void main() {
  StreamLyricPresenter sut;
  SaveFavoriteLyricsSpy saveFavoriteLyricsSpy;
  LyricEntity entity;

  setUp(() {
    saveFavoriteLyricsSpy = SaveFavoriteLyricsSpy();
    sut = StreamLyricPresenter(saveFavoriteLyrics: saveFavoriteLyricsSpy);
    entity = LyricEntity(
      lyric: faker.lorem.sentence(),
      artist: faker.person.name(),
      music: faker.lorem.word(),
    );
  });

  test('Should call SaveFavoriteLyrics with correct values', () async {
    await sut.addFavorite(entity);

    verify(saveFavoriteLyricsSpy.save([entity])).called(1);
  });

  test('Should emits error if SaveFavoriteLyrics fails', () async {
    when(saveFavoriteLyricsSpy.save(any)).thenThrow(DomainError.unexpected);

    expectLater(
      sut.localErrorStream,
      emits('Something wrong happened. Please, try again!'),
    );

    await sut.addFavorite(entity);
  });

  test('Should emit loading events on SaveFavoriteLyrics', () async {
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    await sut.addFavorite(entity);
  });

  test('Should emit success message event on SaveFavoriteLyrics success',
      () async {
    expectLater(
      sut.successMessageStream,
      emitsInOrder([null, "Lyric was added to favorites!"]),
    );

    await sut.addFavorite(entity);
  });

  test('Should emit isFavorite event on SaveFavoriteLyrics success', () async {
    expectLater(sut.isFavoriteStream, emitsInOrder([false, true]));

    await sut.addFavorite(entity);
  });
}
