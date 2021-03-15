import '../../domain/domain.dart';

abstract class LoadFavoriteLyrics {
  Future<List<LyricEntity>> loadFavorites();
}
