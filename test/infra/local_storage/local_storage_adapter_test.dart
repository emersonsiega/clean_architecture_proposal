import 'package:localstorage/localstorage.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:clean_architecture_proposal/infra/infra.dart';

class LocalStorageSpy extends Mock implements LocalStorage {}

void main() {
  LocalStorageAdapter sut;
  LocalStorageSpy localStorageSpy;

  setUp(() {
    localStorageSpy = LocalStorageSpy();
    sut = LocalStorageAdapter(localStorage: localStorageSpy);
  });

  test('Should call save with correct values', () async {
    await sut.save(key: 'any-key', value: 'any-value');

    verify(localStorageSpy.setItem('any-key', 'any-value')).called(1);
  });

  test('Should rethrow error if save fails', () async {
    when(localStorageSpy.setItem(any, any)).thenThrow('error');

    final future = sut.save(key: 'any-key', value: 'any-value');

    expect(future, throwsA('error'));
  });
}
