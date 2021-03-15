import 'package:localstorage/localstorage.dart';

import 'package:meta/meta.dart';

import '../../data/data.dart';

class LocalStorageAdapter implements SaveLocalStorage {
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
}
