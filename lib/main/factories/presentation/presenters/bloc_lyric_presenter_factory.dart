import '../../../../dependency_management/dependency_management.dart';
import '../../../../presentation/presentation.dart';
import '../../../../domain/domain.dart';
import '../../../../ui/ui.dart';

void streamLyricPresenterFactory() {
  Get.i().lazyPut<LyricPresenter>(
    () => BlocLyricPresenter(
      saveFavoriteLyrics: Get.i().get<SaveFavoriteLyrics>(),
      loadFavoriteLyrics: Get.i().get<LoadFavoriteLyrics>(),
    ),
  );
}
