import 'package:shared/shared.dart';

import '../../../domain/domain.dart';
import '../../../data/data.dart';

import '../../factories/factories.dart';

void lazyInjectUsecases() {
  Get.i().lazyPut<LyricsSearch>(
    () => RemoteLyricsSearch(
      httpClient: Get.i().get<HttpClient>(),
      url: lyricsApiUrlFactory(),
    ),
  );

  Get.i().lazyPut<SaveFavoriteLyrics>(
    () => LocalSaveFavoriteLyrics(
      saveLocalStorage: Get.i().get<LocalStorageComposite>(),
    ),
  );

  Get.i().lazyPut<LoadFavoriteLyrics>(
    () => LocalLoadFavoriteLyrics(
      loadLocalStorage: Get.i().get<LocalStorageComposite>(),
    ),
  );
}
