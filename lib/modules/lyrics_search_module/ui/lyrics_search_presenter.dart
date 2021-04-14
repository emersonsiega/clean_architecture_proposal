import '../../../shared/shared.dart';

import './lyrics_search_state.dart';

abstract class LyricsSearchPresenter
    implements FormBasePresenter<LyricsSearchState> {
  Future<void> search();
  Future<void> loadFavorites();
  Future<void> openFavorite(LyricEntity entity);
}
