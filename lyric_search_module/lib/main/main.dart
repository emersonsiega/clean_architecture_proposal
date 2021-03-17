import 'package:lyric_search_module/main/inject_usecases/inject_usecases.dart';

import './inject_presenters/inject_presenters.dart';

void startModule() {
  /// USECASES
  remoteLyricsSearchFactory();

  /// PRESENTERS
  streamLyricsSearchPresenterFactory();
}
