import 'package:http/http.dart';

import '../../../infra/infra.dart';
import '../../../data/data.dart';
import '../../../dependency_management/dependency_management.dart';

void lazyInjectInfra() {
  Get.i().lazyPut<HttpClient>(
    () => HttpAdapter(Client()),
  );
}
