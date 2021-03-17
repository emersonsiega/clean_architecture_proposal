import 'package:meta/meta.dart';

abstract class SaveLocalStorage {
  Future<void> save({@required String key, @required String value});
}
