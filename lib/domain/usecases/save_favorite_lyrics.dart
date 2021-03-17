import 'package:shared/shared.dart';

abstract class SaveFavoriteLyrics {
  Future<void> save(List<LyricEntity> entities);
}
