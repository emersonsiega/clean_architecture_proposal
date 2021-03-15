import 'package:clean_architecture_proposal/domain/domain.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

abstract class SaveLocalStorage {
  Future<void> save({@required String key, @required String value});
}

abstract class SaveFavoriteLyrics {
  Future<void> save(LyricEntity entity);
}

class LocalSaveFavoriteLyrics implements SaveFavoriteLyrics {
  final SaveLocalStorage saveLocalStorage;

  LocalSaveFavoriteLyrics({@required this.saveLocalStorage});

  @override
  Future<void> save(LyricEntity entity) async {
    await saveLocalStorage.save(key: 'favorites', value: entity.toString());
  }
}

class SaveLocalStorageSpy extends Mock implements SaveLocalStorage {}

void main() {
  test('Should call SaveLocalStorage on save favorite', () async {
    final saveLocalStorageSpy = SaveLocalStorageSpy();
    final sut = LocalSaveFavoriteLyrics(saveLocalStorage: saveLocalStorageSpy);
    final entity = LyricEntity(
      lyric: faker.lorem.words(5).join(" "),
      artist: faker.person.name(),
      music: faker.lorem.sentence(),
    );

    await sut.save(entity);

    verify(
      saveLocalStorageSpy.save(
        key: anyNamed('key'),
        value: anyNamed('value'),
      ),
    ).called(1);
  });
}
