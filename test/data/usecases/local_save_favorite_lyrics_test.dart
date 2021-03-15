import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:clean_architecture_proposal/data/data.dart';
import 'package:clean_architecture_proposal/domain/domain.dart';

class SaveLocalStorageSpy extends Mock implements SaveLocalStorage {}

void main() {
  LocalSaveFavoriteLyrics sut;
  SaveLocalStorageSpy saveLocalStorageSpy;
  LyricEntity entity;

  setUp(() {
    saveLocalStorageSpy = SaveLocalStorageSpy();
    sut = LocalSaveFavoriteLyrics(saveLocalStorage: saveLocalStorageSpy);
    entity = LyricEntity(
      lyric: faker.lorem.words(5).join(" "),
      artist: faker.person.name(),
      music: faker.lorem.sentence(),
    );
  });

  test('Should call SaveLocalStorage on save favorite', () async {
    await sut.save([entity]);

    verify(
      saveLocalStorageSpy.save(
        key: anyNamed('key'),
        value: anyNamed('value'),
      ),
    ).called(1);
  });

  test('Should call SaveLocalStorage with correct values', () async {
    await sut.save([entity, entity]);

    verify(
      saveLocalStorageSpy.save(
        key: 'favorites',
        value:
            '[{"artist":"${entity.artist}","music":"${entity.music}","lyric":"${entity.lyric}"},{"artist":"${entity.artist}","music":"${entity.music}","lyric":"${entity.lyric}"}]',
      ),
    ).called(1);
  });

  test('Should throw unexpectedError on error', () async {
    when(saveLocalStorageSpy.save(
            key: anyNamed('key'), value: anyNamed('value')))
        .thenThrow(Exception());

    final future = sut.save([entity, entity]);

    expect(future, throwsA(DomainError.unexpected));
  });
}
