import '../../../../dependency_management/dependency_management.dart';
import '../../../../presentation/presentation.dart';
import '../../../../validation/validation.dart';
import '../../../../domain/domain.dart';
import '../../../../ui/ui.dart';

import '../../../builders/builders.dart';

void streamLyricsSearchPresenterFactory() {
  Get.i().lazyPut<LyricsSearchPresenter>(
    () => StreamLyricsSearchPresenter(
      validation: _makeValidations(),
      lyricsSearch: Get.i().get<LyricsSearch>(),
      loadFavoriteLyrics: Get.i().get<LoadFavoriteLyrics>(),
    ),
  );
}

ValidationComposite _makeValidations() {
  return ValidationComposite([
    ...ValidationBuilder.forField('artist').required().minLength(2).build(),
    ...ValidationBuilder.forField('music').required().minLength(2).build(),
  ]);
}
