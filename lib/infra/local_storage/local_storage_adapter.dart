import 'package:localstorage/localstorage.dart';

import 'package:meta/meta.dart';

import '../../data/data.dart';

class LocalStorageAdapter implements SaveLocalStorage, LoadLocalStorage {
  final LocalStorage localStorage;

  LocalStorageAdapter({@required this.localStorage});

  @override
  Future<void> save({@required String key, @required String value}) async {
    if (key?.isNotEmpty != true) {
      throw LocalStorageError.invalidKey;
    }

    try {
      await localStorage.setItem(key, value);
    } catch (error) {
      throw LocalStorageError.unexpected;
    }
  }

  @override
  Future<String> load(String key) async {
    if (key?.isNotEmpty != true) {
      throw LocalStorageError.invalidKey;
    }

    try {
      return await localStorage.getItem(key);
    } catch (error) {
      throw LocalStorageError.unexpected;
    }
  }
}
