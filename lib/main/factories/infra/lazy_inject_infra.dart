import 'package:http/http.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared/shared.dart';

void lazyInjectInfra() {
  Get.i().lazyPut<HttpClient>(
    () => HttpAdapter(Client()),
  );

  Get.i().lazyPut<LocalStorageComposite>(
    () => LocalStorageAdapter(
      localStorage: LocalStorage('clean_arch_app.json'),
    ),
  );
}
