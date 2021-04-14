import 'package:flutter_modular/flutter_modular.dart';

import '../../shared/shared.dart';

import './domain/domain.dart';
import './data/data.dart';
import './presentation/presentation.dart';
import './ui/ui.dart';

class LyricsSearchModule extends Module {
  @override
  final List<Bind> binds = [
    Bind<LyricsSearch>(
      (i) => RemoteLyricsSearch(
        httpClient: i.get<HttpClient>(),
        url: lyricsApiUrlFactory(),
      ),
    ),
    Bind<LyricsSearchPresenter>(
      (i) => CubitLyricsSearchPresenter(
        validation: ValidationComposite([
          ...ValidationBuilder.forField(LyricsSearchFields.artist)
              .required()
              .minLength(2)
              .build(),
          ...ValidationBuilder.forField(LyricsSearchFields.music)
              .required()
              .minLength(2)
              .build(),
        ]),
        lyricsSearch: i.get<LyricsSearch>(),
        loadFavoriteLyrics: i.get<LoadFavoriteLyrics>(),
      ),
    ),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, __) => LyricsSearchPage()),
  ];
}
