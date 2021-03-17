import '../../../shared/shared.dart';

abstract class LyricsSearchPresenter
    implements
        FormValidManager,
        LoadingManager,
        LocalErrorManager,
        NavigationManager {
  Stream<String> get artistErrorStream;
  Stream<String> get musicErrorStream;
  Stream<List<LyricEntity>> get favoritesStream;
  Stream<bool> get isLoadingFavoritesStream;

  void validateArtist(String artist);
  void validateMusic(String music);

  Future<void> search();
  Future<void> loadFavorites();
  Future<void> openFavorite(LyricEntity entity);

  void dispose();
}
