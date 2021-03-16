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
  LyricEntity otherEntity;
  LyricEntity entityToAdd;
  PostExpectation mockLoadFavoritesCall() =>
      when(loadFavoriteLyricsSpy.loadFavorites());

  void mockLoadResponse(List<LyricEntity> response) {
    mockLoadFavoritesCall().thenAnswer((_) async => response);
  }

  void mockLoadSuccess() {
    mockLoadResponse([entity, otherEntity]);
  }

  setUp(() {
    saveFavoriteLyricsSpy = SaveFavoriteLyricsSpy();
    loadFavoriteLyricsSpy = LoadFavoriteLyricsSpy();
    sut = StreamLyricPresenter(
      saveFavoriteLyrics: saveFavoriteLyricsSpy,
      loadFavoriteLyrics: loadFavoriteLyricsSpy,
    );

    entity = LyricEntity(
      lyric: faker.lorem.sentence().toLowerCase(),
      artist: faker.person.name().toLowerCase(),
      music: faker.lorem.word().toLowerCase(),
    );

    otherEntity = LyricEntity(
      lyric: 'other-lyric',
      artist: 'other-artist',
      music: 'other-music',
    );

    entityToAdd = LyricEntity(
      lyric: faker.lorem.sentence(),
      artist: faker.person.name(),
      music: faker.lorem.word(),
    );

    mockLoadSuccess();
  });

  test('Should call SaveFavoriteLyrics on addFavorite', () async {
    await sut.addFavorite(entityToAdd);

    verify(saveFavoriteLyricsSpy.save(any)).called(1);
  });

  test('Should emits error if SaveFavoriteLyrics fails', () async {
    when(saveFavoriteLyricsSpy.save(any)).thenThrow(DomainError.unexpected);

    expectLater(
      sut.localErrorStream,
      emitsInOrder([null, 'Something wrong happened. Please, try again!']),
    );

    await sut.addFavorite(entityToAdd);
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

    await sut.addFavorite(entityToAdd);
  });

  test('Should emit isFavorite event on SaveFavoriteLyrics success', () async {
    expectLater(sut.isFavoriteStream, emitsInOrder([false, true]));

    await sut.addFavorite(entityToAdd);
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

  test('Should emit isFavorite false event on checkIsFavorite', () async {
    mockLoadResponse(null);

    expectLater(sut.isFavoriteStream, emits(false));

    await sut.checkIsFavorite(
      LyricEntity(lyric: 'other', artist: 'other', music: 'other'),
    );
  });

  test('Should emit isFavorite true event on similar entities', () async {
    mockLoadResponse([entity]);

    expectLater(sut.isFavoriteStream, emits(true));

    await sut.checkIsFavorite(
      LyricEntity(
          lyric: entity.lyric,
          artist: entity.artist.toUpperCase(),
          music: entity.music.toUpperCase()),
    );
  });

  test('Should load favorites before add new one', () async {
    await sut.addFavorite(entity);

    verify(loadFavoriteLyricsSpy.loadFavorites()).called(1);
  });

  test('Should add entity to the list of favorites on save', () async {
    await sut.addFavorite(entityToAdd);

    verify(saveFavoriteLyricsSpy.save([entity, otherEntity, entityToAdd]))
        .called(1);
  });

  test('Should remove entity from favorites on save if entity is favorite',
      () async {
    await sut.addFavorite(entity);

    verify(saveFavoriteLyricsSpy.save([otherEntity])).called(1);
  });

  test('Should emit isFavorite false on remove entity from favorites',
      () async {
    expectLater(sut.isFavoriteStream, emits(false));

    await sut.addFavorite(entity);
  });

  test('Should emit success message event on remove from favorites', () async {
    expectLater(
      sut.successMessageStream,
      emitsInOrder([null, "Lyric was removed from favorites!"]),
    );

    await sut.addFavorite(entity);
  });
}
