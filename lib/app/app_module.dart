import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart';
import 'package:localstorage/localstorage.dart';

import '../modules/modules.dart';
import '../shared/shared.dart';

import 'app_route.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind<HttpClient>(
      (_) => HttpAdapter(Client()),
    ),
    Bind<LocalStorageComposite>(
      (_) => LocalStorageAdapter(
        localStorage: LocalStorage('clean_arch_app.json'),
      ),
    ),
    Bind<LoadFavoriteLyrics>(
      (i) => LocalLoadFavoriteLyrics(
        loadLocalStorage: i.get<LocalStorageComposite>(),
      ),
    ),
  ];

  @override
  final List<ModularRoute> routes = [
    ModuleRoute(AppRoute.home, module: LyricsSearchModule()),
    ModuleRoute(AppRoute.lyric, module: LyricModule()),
  ];
}
