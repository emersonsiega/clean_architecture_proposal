import 'package:shared/shared.dart';

import '../../../../presentation/presentation.dart';
import '../../../../domain/domain.dart';
import '../../../../ui/ui.dart';

void streamLyricPresenterFactory() {
  Get.i().lazyPut<LyricPresenter>(
    () => StreamLyricPresenter(
      saveFavoriteLyrics: Get.i().get<SaveFavoriteLyrics>(),
      loadFavoriteLyrics: Get.i().get<LoadFavoriteLyrics>(),
    ),
  );
}
