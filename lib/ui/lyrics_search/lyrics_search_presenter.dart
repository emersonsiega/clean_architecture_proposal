import '../../domain/domain.dart';

import '../ui.dart';

abstract class LyricsSearchPresenter
    implements
        FormValidManager,
        LoadingManager,
        LocalErrorManager,
        NavigationManager {
  Stream<String> get artistErrorStream;
  Stream<String> get musicErrorStream;
  Stream<List<LyricEntity>> get favoritesStream;

  void validateArtist(String artist);
  void validateMusic(String music);

  Future<void> search();
  Future<void> loadFavorites();

  void dispose();
}
