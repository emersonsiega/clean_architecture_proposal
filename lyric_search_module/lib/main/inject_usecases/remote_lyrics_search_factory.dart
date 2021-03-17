import 'package:shared/shared.dart';

import '../../domain/domain.dart';
import '../../data/data.dart';

void remoteLyricsSearchFactory() {
  Get.i().lazyPut<LyricsSearch>(
    () => RemoteLyricsSearch(
      httpClient: Get.i().get<HttpClient>(),
      url: _lyricsApiUrlFactory(),
    ),
  );
}

String _lyricsApiUrlFactory({String path: ""}) {
  final baseUrl = "https://api.lyrics.ovh/v1";

  return "$baseUrl$path";
}
