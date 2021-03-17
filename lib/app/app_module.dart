import 'package:http/http.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter/material.dart';

import '../modules/modules.dart';
import '../shared/shared.dart';

import './app_page.dart';

class AppModule implements MainModule {
  AppModule() {
    injectDependencies();
  }

  @override
  void injectDependencies() {
    /// Shared Infra
    Get.i().lazyPut<HttpClient>(
      () => HttpAdapter(Client()),
    );
    Get.i().lazyPut<LocalStorageComposite>(
      () => LocalStorageAdapter(
        localStorage: LocalStorage('clean_arch_app.json'),
      ),
    );

    /// Shared Usecases
    Get.i().lazyPut<LoadFavoriteLyrics>(
      () => LocalLoadFavoriteLyrics(
        loadLocalStorage: Get.i().get<LocalStorageComposite>(),
      ),
    );

    /// Submodules
    Get.i().lazyPut<LyricsSearchModule>(() => LyricsSearchModule());
    Get.i().lazyPut<LyricModule>(() => LyricModule());
  }

  @override
  Widget get page => AppPage();
}
