import 'package:clean_architecture_proposal/data/data.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

class LocalStorageSpy extends Mock implements LocalStorage {}

class LocalStorageAdapter implements SaveLocalStorage {
  final LocalStorage localStorage;

  LocalStorageAdapter({@required this.localStorage});

  @override
  Future<void> save({String key, String value}) async {
    await localStorage.setItem(key, value);
  }
}

void main() {
  test('Should call save with correct values', () async {
    final localStorageSpy = LocalStorageSpy();
    final sut = LocalStorageAdapter(localStorage: localStorageSpy);

    await sut.save(key: 'any-key', value: 'any-value');

    verify(localStorageSpy.setItem('any-key', 'any-value')).called(1);
  });
}
