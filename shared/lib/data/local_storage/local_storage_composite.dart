import 'package:shared/shared.dart';

import './local_storage.dart';

abstract class LocalStorageComposite
    implements LoadLocalStorage, SaveLocalStorage {}
