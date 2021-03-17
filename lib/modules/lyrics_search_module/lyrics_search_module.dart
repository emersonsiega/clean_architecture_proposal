import 'package:flutter/material.dart';

import '../../shared/shared.dart';

import './domain/domain.dart';
import './data/data.dart';
import './presentation/presentation.dart';
import './ui/ui.dart';

class LyricsSearchModule implements BaseModule {
  String _lyricsApiUrlFactory({String path: ""}) {
    final baseUrl = "https://api.lyrics.ovh/v1";

    return "$baseUrl$path";
  }

  LyricsSearchModule() {
    injectDependencies();
  }

  @override
  void injectDependencies() {
    Get.i().lazyPut<LyricsSearch>(
      () => RemoteLyricsSearch(
        httpClient: Get.i().get<HttpClient>(),
        url: _lyricsApiUrlFactory(),
      ),
    );

    Get.i().lazyPut<LyricsSearchPresenter>(
      () => StreamLyricsSearchPresenter(
        validation: ValidationComposite([
          ...ValidationBuilder.forField('artist')
              .required()
              .minLength(2)
              .build(),
          ...ValidationBuilder.forField('music')
              .required()
              .minLength(2)
              .build(),
        ]),
        lyricsSearch: Get.i().get<LyricsSearch>(),
        loadFavoriteLyrics: Get.i().get<LoadFavoriteLyrics>(),
      ),
    );
  }

  @override
  Route onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (_) => LyricsSearchPage());
  }
}
