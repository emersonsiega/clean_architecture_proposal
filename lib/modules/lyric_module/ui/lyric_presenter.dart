import '../../../shared/shared.dart';

import './lyric_state.dart';

abstract class LyricPresenter implements BasePresenter<LyricState> {
  Future<void> addFavorite(LyricEntity entity);
  Future<void> checkIsFavorite(LyricEntity entity);
}
