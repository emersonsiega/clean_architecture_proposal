import 'package:shared/shared.dart';

void lazyInjectUsecases() {
  Get.i().lazyPut<LoadFavoriteLyrics>(
    () => LocalLoadFavoriteLyrics(
      loadLocalStorage: Get.i().get<LocalStorageComposite>(),
    ),
  );
}
