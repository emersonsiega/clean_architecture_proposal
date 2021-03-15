import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:clean_architecture_proposal/presentation/presenters/presenters.dart';
import 'package:clean_architecture_proposal/domain/domain.dart';

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
