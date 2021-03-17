import './inject_usecases/inject_usecases.dart';
import './inject_presenters/inject_presenters.dart';

void startModule() {
  /// USECASES
  localSaveFavoriteLyricsFactory();

  /// PRESENTERS
  streamLyricPresenterFactory();
}
