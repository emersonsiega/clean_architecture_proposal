import '../../domain/domain.dart';

import '../ui.dart';

abstract class LyricPresenter implements LocalErrorManager, FormLoadingManager {
  Future<void> addFavorite(LyricEntity entity);

  Stream<String> get successMessageStream;
  Stream<bool> get isFavoriteStream;

  void dispose();
}
