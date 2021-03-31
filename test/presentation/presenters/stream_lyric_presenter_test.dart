import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:clean_architecture_proposal/ui/ui.dart';
import 'package:clean_architecture_proposal/presentation/presentation.dart';
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

  Future<void> _fireEvent(event) async {
    sut.fireEvent(event);
    await Future.delayed(Duration.zero);
  }

  test('Should call SaveFavoriteLyrics on addFavorite', () async {
    await _fireEvent(AddFavoriteEvent(entityToAdd));

    verify(saveFavoriteLyricsSpy.save(any)).called(1);
  });

  test('Should emits error if SaveFavoriteLyrics fails', () async {
    when(saveFavoriteLyricsSpy.save(any)).thenThrow(DomainError.unexpected);

    expectLater(
      sut.stateStream,
      emitsInOrder([
        LyricState(isLoading: true),
        LyricState(
          isLoading: false,
          localError: 'Something wrong happened. Please, try again!',
        )
      ]),
    );

    await _fireEvent(AddFavoriteEvent(entityToAdd));
  });

  test('Should emit correct events on SaveFavoriteLyrics with new entity',
      () async {
    expectLater(
      sut.stateStream,
      emitsInOrder(
        [
          LyricState(isLoading: true, isFavorite: false, successMessage: null),
          LyricState(
            isLoading: false,
            isFavorite: true,
            successMessage: "Lyric was added to favorites!",
          )
        ],
      ),
    );

    await _fireEvent(AddFavoriteEvent(entityToAdd));
  });

  test('Should call LoadFavoriteLyrics on checkIsFavorite', () async {
    await _fireEvent(CheckFavoriteEvent(entity));

    verify(loadFavoriteLyricsSpy.loadFavorites()).called(1);
  });

  test('Should emit isFavorite true event on checkIsFavorite', () async {
    expectLater(sut.stateStream, emits(LyricState(isFavorite: true)));

    await _fireEvent(CheckFavoriteEvent(entity));
  });

  test('Should emit isFavorite false event if checkIsFavorite returns null',
      () async {
    mockLoadResponse(null);

    expectLater(sut.stateStream, emits(LyricState(isFavorite: false)));

    await _fireEvent(CheckFavoriteEvent(entity));
  });

  test('Should emit isFavorite false event on checkIsFavorite', () async {
    mockLoadResponse(null);

    expectLater(sut.stateStream, emits(LyricState(isFavorite: false)));

    await _fireEvent(CheckFavoriteEvent(
      LyricEntity(lyric: 'other', artist: 'other', music: 'other'),
    ));
  });

  test('Should emit isFavorite true event on similar entities', () async {
    mockLoadResponse([entity]);

    expectLater(sut.stateStream, emits(LyricState(isFavorite: true)));

    await _fireEvent(
      CheckFavoriteEvent(
        LyricEntity(
            lyric: entity.lyric,
            artist: entity.artist.toUpperCase(),
            music: entity.music.toUpperCase()),
      ),
    );
  });

  test('Should load favorites before add new one', () async {
    await _fireEvent(AddFavoriteEvent(entity));

    verify(loadFavoriteLyricsSpy.loadFavorites()).called(1);
  });

  test('Should add entity to the list of favorites on save', () async {
    await _fireEvent(AddFavoriteEvent(entityToAdd));

    verify(saveFavoriteLyricsSpy.save([entity, otherEntity, entityToAdd]))
        .called(1);
  });

  test('Should remove entity from favorites on save if entity is favorite',
      () async {
    await _fireEvent(AddFavoriteEvent(entity));

    verify(saveFavoriteLyricsSpy.save([otherEntity])).called(1);
  });

  test('Should emit success message event on remove from favorites', () async {
    expectLater(
      sut.stateStream,
      emitsInOrder([
        LyricState(isLoading: true, successMessage: null),
        LyricState(
          isLoading: false,
          isFavorite: false,
          successMessage: "Lyric was removed from favorites!",
        ),
      ]),
    );

    await _fireEvent(AddFavoriteEvent(entity));
  });

  test('Should emits error if checkIsFavorite fails', () async {
    when(loadFavoriteLyricsSpy.loadFavorites())
        .thenThrow(DomainError.unexpected);

    expectLater(
      sut.stateStream,
      emits(
        LyricState(localError: 'Something wrong happened. Please, try again!'),
      ),
    );

    await _fireEvent(CheckFavoriteEvent(entity));
  });
}
