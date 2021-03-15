import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:clean_architecture_proposal/presentation/presenters/presenters.dart';
import 'package:clean_architecture_proposal/domain/domain.dart';

class SaveFavoriteLyricsSpy extends Mock implements SaveFavoriteLyrics {}

class LoadFavoriteLyricsSpy extends Mock implements LoadFavoriteLyrics {}

void main() {
  StreamLyricPresenter sut;
  SaveFavoriteLyricsSpy saveFavoriteLyricsSpy;
  LoadFavoriteLyricsSpy loadFavoriteLyricsSpy;
  LyricEntity entity;
  PostExpectation mockLoadFavoritesCall() =>
      when(loadFavoriteLyricsSpy.loadFavorites());

  void mockLoadResponse(List<LyricEntity> response) {
    mockLoadFavoritesCall().thenAnswer((_) async => response);
  }

  void mockLoadSuccess() {
    mockLoadResponse([
      entity,
      LyricEntity(
        lyric: 'other-lyric',
        artist: 'other-artist',
        music: 'other-music',
      )
    ]);
  }

  setUp(() {
    saveFavoriteLyricsSpy = SaveFavoriteLyricsSpy();
    loadFavoriteLyricsSpy = LoadFavoriteLyricsSpy();
    sut = StreamLyricPresenter(
      saveFavoriteLyrics: saveFavoriteLyricsSpy,
      loadFavoriteLyrics: loadFavoriteLyricsSpy,
    );

    entity = LyricEntity(
      lyric: faker.lorem.sentence(),
      artist: faker.person.name(),
      music: faker.lorem.word(),
    );

    mockLoadSuccess();
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

  test('Should call LoadFavoriteLyrics on checkIsFavorite', () async {
    await sut.checkIsFavorite(entity);

    verify(loadFavoriteLyricsSpy.loadFavorites()).called(1);
  });

  test('Should emit isFavorite true event on checkIsFavorite', () async {
    expectLater(sut.isFavoriteStream, emits(true));

    await sut.checkIsFavorite(entity);
  });

  test('Should emit isFavorite false event if checkIsFavorite returns null',
      () async {
    mockLoadResponse(null);

    expectLater(sut.isFavoriteStream, emits(false));

    await sut.checkIsFavorite(entity);
  });
}
