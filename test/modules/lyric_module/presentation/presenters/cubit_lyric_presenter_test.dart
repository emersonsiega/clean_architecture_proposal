import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:clean_architecture_proposal/shared/domain/domain.dart';

import 'package:clean_architecture_proposal/modules/lyric_module/presentation/presenters/presenters.dart';
import 'package:clean_architecture_proposal/modules/lyric_module/domain/domain.dart';
import 'package:clean_architecture_proposal/modules/lyric_module/ui/ui.dart';

class SaveFavoriteLyricsSpy extends Mock implements SaveFavoriteLyrics {}

class LoadFavoriteLyricsSpy extends Mock implements LoadFavoriteLyrics {}

void main() {
  CubitLyricPresenter sut;
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
    sut = CubitLyricPresenter(
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
      sut.stream,
      emitsInOrder([
        LyricState(errorMessage: null, isLoading: true),
        LyricState(
            errorMessage: 'Something wrong happened. Please, try again!',
            isLoading: false)
      ]),
    );

    await sut.addFavorite(entityToAdd);
  });

  test('Should emit correct events on SaveFavoriteLyrics', () async {
    expectLater(
      sut.stateStream,
      emitsInOrder([
        LyricState(isLoading: true, isFavorite: false),
        LyricState(
          isLoading: false,
          message: "Lyric was added to favorites!",
          isFavorite: true,
        ),
      ]),
    );

    await sut.addFavorite(entityToAdd);
  });

  test('Should call LoadFavoriteLyrics on checkIsFavorite', () async {
    await sut.checkIsFavorite(entity);

    verify(loadFavoriteLyricsSpy.loadFavorites()).called(1);
  });

  test('Should emit isFavorite true event on checkIsFavorite', () async {
    expectLater(
      sut.stateStream,
      emitsInOrder(
        [
          LyricState(isFavorite: false, isLoading: true),
          LyricState(isFavorite: true, isLoading: false)
        ],
      ),
    );

    await sut.checkIsFavorite(entity);
  });

  test('Should emit isFavorite false event if checkIsFavorite returns null',
      () async {
    mockLoadResponse(null);

    expectLater(
      sut.stateStream,
      emitsInOrder(
        [
          LyricState(isFavorite: false, isLoading: true),
          LyricState(isFavorite: false, isLoading: false)
        ],
      ),
    );

    await sut.checkIsFavorite(entity);
  });

  test('Should emit isFavorite false event on checkIsFavorite', () async {
    expectLater(
      sut.stateStream,
      emitsInOrder(
        [
          LyricState(isFavorite: false, isLoading: true),
          LyricState(isFavorite: false, isLoading: false)
        ],
      ),
    );

    await sut.checkIsFavorite(
      LyricEntity(lyric: 'other', artist: 'other', music: 'other'),
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

  test('Should emit correct events  on remove entity from favorites', () async {
    expectLater(
      sut.stateStream,
      emitsInOrder([
        LyricState(isLoading: true, isFavorite: false),
        LyricState(
          isLoading: false,
          message: "Lyric was removed from favorites!",
          isFavorite: false,
        ),
      ]),
    );

    await sut.addFavorite(entity);
  });

  test('Should emits error if checkIsFavorite fails', () async {
    when(loadFavoriteLyricsSpy.loadFavorites())
        .thenThrow(DomainError.unexpected);

    expectLater(
      sut.stateStream,
      emitsInOrder([
        LyricState(isLoading: true, isFavorite: false),
        LyricState(
          errorMessage: 'Something wrong happened. Please, try again!',
          isLoading: false,
          isFavorite: false,
        ),
      ]),
    );

    await sut.checkIsFavorite(entity);
  });
}
