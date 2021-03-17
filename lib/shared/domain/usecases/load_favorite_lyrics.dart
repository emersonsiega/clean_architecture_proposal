import '../../shared.dart';

abstract class LoadFavoriteLyrics {
  Future<List<LyricEntity>> loadFavorites();
}
