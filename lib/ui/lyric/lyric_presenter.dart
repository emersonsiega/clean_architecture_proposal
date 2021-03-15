import '../../domain/domain.dart';

import '../ui.dart';

abstract class LyricPresenter implements LocalErrorManager, LoadingManager {
  Future<void> addFavorite(LyricEntity entity);

  Stream<String> get successMessageStream;
  Stream<bool> get isFavoriteStream;

  void dispose();
}
