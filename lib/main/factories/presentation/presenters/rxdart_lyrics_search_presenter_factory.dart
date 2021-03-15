import '../../../../dependency_management/dependency_management.dart';
import '../../../../presentation/presentation.dart';
import '../../../../validation/validation.dart';
import '../../../../domain/domain.dart';
import '../../../../ui/ui.dart';

import '../../../builders/builders.dart';

void rxDartLyricsSearchPresenterFactory() {
  Get.i().lazyPut<LyricsSearchPresenter>(
    () => RxDartLyricsSearchPresenter(
      validation: _makeValidations(),
      lyricsSearch: Get.i().get<LyricsSearch>(),
    ),
  );
}

ValidationComposite _makeValidations() {
  return ValidationComposite([
    ...ValidationBuilder.forField('artist').required().minLength(2).build(),
    ...ValidationBuilder.forField('music').required().minLength(2).build(),
  ]);
}
