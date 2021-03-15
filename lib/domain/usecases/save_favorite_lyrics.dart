import '../../domain/domain.dart';

abstract class SaveFavoriteLyrics {
  Future<void> save(List<LyricEntity> entities);
}
