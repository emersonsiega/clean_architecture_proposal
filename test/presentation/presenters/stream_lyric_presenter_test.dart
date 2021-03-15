import 'dart:async';

import 'package:clean_architecture_proposal/domain/domain.dart';
import 'package:clean_architecture_proposal/ui/ui.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

abstract class LyricPresenter implements LocalErrorManager {
  Future<void> addFavorite(LyricEntity entity);

  void dispose();
}

class LyricState {
  String localError;
}

class StreamLyricPresenter implements LyricPresenter {
  final SaveFavoriteLyrics saveFavoriteLyrics;
  final _state = LyricState();
  final _stateController = StreamController<LyricState>.broadcast();

  StreamLyricPresenter({@required this.saveFavoriteLyrics});

  @override
  Stream<String> get localErrorStream =>
      _stateController.stream.map((state) => state.localError).distinct();

  @override
  Future<void> addFavorite(LyricEntity entity) async {
    try {
      await saveFavoriteLyrics.save([entity]);
    } on DomainError catch (error) {
      _state.localError = error.description;
    } finally {
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
}
