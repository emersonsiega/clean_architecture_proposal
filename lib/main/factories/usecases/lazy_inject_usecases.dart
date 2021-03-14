import '../../../dependency_management/dependency_management.dart';
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
}
