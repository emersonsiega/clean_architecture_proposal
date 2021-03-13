import 'package:meta/meta.dart';

import '../../domain/domain.dart';

abstract class LyricsSearch {
  Future<LyricEntity> search(LyricsSearchParams params);
}

class LyricsSearchParams {
  final String artist;
  final String music;

  LyricsSearchParams({
    @required this.artist,
    @required this.music,
  });

  String toUrlString() => "$artist/$music";
}
