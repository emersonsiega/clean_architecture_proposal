import 'package:http/http.dart';
import 'package:localstorage/localstorage.dart';

import '../../../infra/infra.dart';
import '../../../data/data.dart';
import '../../../dependency_management/dependency_management.dart';

void lazyInjectInfra() {
  Get.i().lazyPut<HttpClient>(
    () => HttpAdapter(Client()),
  );

  Get.i().lazyPut<SaveLocalStorage>(
    () => LocalStorageAdapter(
      localStorage: LocalStorage('clean_arch_app.json'),
    ),
  );
}
