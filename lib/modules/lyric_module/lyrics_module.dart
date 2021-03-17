import 'package:flutter/material.dart';

import '../../shared/shared.dart';

import './data/data.dart';
import './domain/domain.dart';
import './presentation/presentation.dart';
import './ui/ui.dart';

class LyricModule implements BaseModule {
  LyricModule() {
    injectDependencies();
  }

  @override
  void injectDependencies() {
    Get.i().lazyPut<SaveFavoriteLyrics>(
      () => LocalSaveFavoriteLyrics(
        saveLocalStorage: Get.i().get<LocalStorageComposite>(),
      ),
    );

    Get.i().lazyPut<LyricPresenter>(
      () => StreamLyricPresenter(
        saveFavoriteLyrics: Get.i().get<SaveFavoriteLyrics>(),
        loadFavoriteLyrics: Get.i().get<LoadFavoriteLyrics>(),
      ),
    );
  }

  @override
  Route onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => LyricPage(entity: settings.arguments),
    );
  }
}
