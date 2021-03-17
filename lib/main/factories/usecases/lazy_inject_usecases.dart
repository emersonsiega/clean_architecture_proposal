import 'package:shared/shared.dart';

import '../../../domain/domain.dart';
import '../../../data/data.dart';

void lazyInjectUsecases() {
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
