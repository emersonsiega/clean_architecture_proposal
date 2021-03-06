import '../ui.dart';

abstract class LyricsSearchPresenter
    implements
        FormValidManager,
        LoadingManager,
        LocalErrorManager,
        NavigationManager {
  Stream<String> get artistErrorStream;
  Stream<String> get musicErrorStream;

  void validateArtist(String artist);
  void validateMusic(String music);

  Future<void> search();

  void dispose();
}
