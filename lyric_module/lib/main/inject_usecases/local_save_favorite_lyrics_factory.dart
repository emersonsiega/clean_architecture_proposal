import 'package:shared/shared.dart';

import '../../domain/domain.dart';
import '../../data/data.dart';

void localSaveFavoriteLyricsFactory() {
  Get.i().lazyPut<SaveFavoriteLyrics>(
    () => LocalSaveFavoriteLyrics(
      saveLocalStorage: Get.i().get<LocalStorageComposite>(),
    ),
  );
}
