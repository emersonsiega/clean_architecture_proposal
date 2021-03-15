import 'dart:convert';

import 'package:clean_architecture_proposal/data/data.dart';
import 'package:clean_architecture_proposal/domain/domain.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

abstract class LoadFavoriteLyrics {
  Future<List<LyricEntity>> loadFavorites();
}

class LocalLoadFavoriteLyrics implements LoadFavoriteLyrics {
  final LoadLocalStorage loadLocalStorage;

  LocalLoadFavoriteLyrics({@required this.loadLocalStorage});

  @override
  Future<List<LyricEntity>> loadFavorites() async {
    final favorites = await loadLocalStorage.load('favorites');

    if (favorites?.isNotEmpty == true) {
      List favoriteMapList = jsonDecode(favorites);

      return favoriteMapList
          .map((entity) => LocalLyricModel.fromMap(entity).toEntity())
          .toList();
    }

    return null;
  }
}

abstract class LoadLocalStorage {
  Future<String> load(String key);
}

class LoadLocalStorageSpy extends Mock implements LoadLocalStorage {}

void main() {
  LoadLocalStorageSpy loadLocalStorageSpy;
  LocalLoadFavoriteLyrics sut;
  LyricEntity entity1;
  LyricEntity entity2;
  PostExpectation mockLoadLocalCall() => when(loadLocalStorageSpy.load(any));

  void mockSuccess() {
    mockLoadLocalCall().thenAnswer(
      (_) async =>
          '[{"artist":"${entity1.artist}","music":"${entity1.music}","lyric":"${entity1.lyric}"},{"artist":"${entity2.artist}","music":"${entity2.music}","lyric":"${entity2.lyric}"}]',
    );
  }

  void mockCustomSuccess(String response) {
    mockLoadLocalCall().thenAnswer((_) async => response);
  }

  setUp(() {
    loadLocalStorageSpy = LoadLocalStorageSpy();
    sut = LocalLoadFavoriteLyrics(loadLocalStorage: loadLocalStorageSpy);
    entity1 = LyricEntity(
      lyric: faker.lorem.sentence(),
      artist: faker.person.name(),
      music: faker.lorem.word(),
    );
    entity2 = LyricEntity(
      lyric: faker.lorem.sentence(),
      artist: faker.person.name(),
      music: faker.lorem.word(),
    );

    mockSuccess();
  });

  test('Should call LoadLocalStorage on load favorite', () async {
    await sut.loadFavorites();

    verify(loadLocalStorageSpy.load(any)).called(1);
  });

  test('Should call LoadLocalStorage with correct key', () async {
    await sut.loadFavorites();

    verify(loadLocalStorageSpy.load('favorites')).called(1);
  });

  test('Should return LyricEntity list on success', () async {
    final entities = await sut.loadFavorites();

    expect(entities, isNotNull);
    expect(entities, hasLength(2));
    expect(entities, containsAll([entity1, entity2]));
  });

  test('Should return null on null response', () async {
    mockCustomSuccess(null);

    final entities = await sut.loadFavorites();

    expect(entities, isNull);
  });

  test('Should return null on empty response', () async {
    mockCustomSuccess('');

    final entities = await sut.loadFavorites();

    expect(entities, isNull);
  });
}
