import '../../../shared/shared.dart';

abstract class LyricPresenter implements LocalErrorManager, LoadingManager {
  Future<void> addFavorite(LyricEntity entity);
  Future<void> checkIsFavorite(LyricEntity entity);

  Stream<String> get successMessageStream;
  Stream<bool> get isFavoriteStream;

  void dispose();
}
