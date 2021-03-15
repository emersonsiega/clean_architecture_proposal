import 'package:clean_architecture_proposal/domain/domain.dart';
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
    await loadLocalStorage.load('favorites');
    return null;
  }
}

abstract class LoadLocalStorage {
  Future<String> load(String key);
}

class LoadLocalStorageSpy extends Mock implements LoadLocalStorage {}

void main() {
  test('Should call LoadLocalStorage on load favorite', () async {
    final loadLocalStorageSpy = LoadLocalStorageSpy();
    final sut = LocalLoadFavoriteLyrics(loadLocalStorage: loadLocalStorageSpy);

    await sut.loadFavorites();

    verify(loadLocalStorageSpy.load(any)).called(1);
  });
}
