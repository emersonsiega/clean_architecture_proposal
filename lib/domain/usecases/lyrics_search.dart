import 'package:meta/meta.dart';

abstract class LyricsSearch {
  Future<void> search(LyricsSearchParams params);
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
