import '../entities/entities.dart';

abstract class LoadFavoriteLyrics {
  Future<List<LyricEntity>> loadFavorites();
}
