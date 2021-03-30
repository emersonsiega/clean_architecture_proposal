import 'package:localstorage/localstorage.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:clean_architecture_proposal/shared/data/local_storage/local_storage_error.dart';
import 'package:clean_architecture_proposal/shared/infra/infra.dart';

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

    expect(future, throwsA(LocalStorageError.unexpected));
  });

  test('Should throw invalidKey error if key is null', () async {
    final future = sut.save(key: null, value: 'any-value');

    expect(future, throwsA(LocalStorageError.invalidKey));
  });

  test('Should throw invalidKey error if key is empty', () async {
    final future = sut.save(key: '', value: 'any-value');

    expect(future, throwsA(LocalStorageError.invalidKey));
  });

  test('Should call load with correct values', () async {
    await sut.load('any-key');

    verify(localStorageSpy.getItem('any-key')).called(1);
  });

  test('Should rethrow error if load fails', () async {
    when(localStorageSpy.getItem(any)).thenThrow('error');

    final future = sut.load('any-key');

    expect(future, throwsA(LocalStorageError.unexpected));
  });

  test('Should throw invalidKey error if key is null', () async {
    final future = sut.load(null);

    expect(future, throwsA(LocalStorageError.invalidKey));
  });

  test('Should get correct values from load', () async {
    when(localStorageSpy.getItem(any)).thenAnswer((_) => 'any-value');

    final value = await sut.load('any-key');

    expect(value, 'any-value');
  });
}
