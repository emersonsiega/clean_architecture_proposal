import 'dart:convert';

import 'package:clean_architecture_proposal/domain/domain.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

abstract class SaveLocalStorage {
  Future<void> save({@required String key, @required String value});
}

abstract class SaveFavoriteLyrics {
  Future<void> save(List<LyricEntity> entities);
}

class LocalLyricEntity extends LyricEntity {
  LocalLyricEntity._({
    @required String lyric,
    @required String artist,
    @required String music,
  }) : super(artist: artist, music: music, lyric: lyric);

  factory LocalLyricEntity.fromEntity(LyricEntity entity) {
    return LocalLyricEntity._(
      artist: entity.artist,
      lyric: entity.lyric,
      music: entity.music,
    );
  }

  Map toMap() {
    return {
      'artist': artist,
      'music': music,
      'lyric': lyric,
    };
  }
}

class LocalSaveFavoriteLyrics implements SaveFavoriteLyrics {
  final SaveLocalStorage saveLocalStorage;

  LocalSaveFavoriteLyrics({@required this.saveLocalStorage});

  @override
  Future<void> save(List<LyricEntity> entities) async {
    try {
      final localEntity = entities
          .map((entity) => LocalLyricEntity.fromEntity(entity).toMap())
          .toList();

      await saveLocalStorage.save(
        key: 'favorites',
        value: jsonEncode(localEntity),
      );
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}

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
