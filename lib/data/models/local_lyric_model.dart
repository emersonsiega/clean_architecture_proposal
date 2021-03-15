import 'package:meta/meta.dart';

import '../../domain/domain.dart';

class LocalLyricModel extends LyricEntity {
  LocalLyricModel._({
    @required String lyric,
    @required String artist,
    @required String music,
  }) : super(artist: artist, music: music, lyric: lyric);

  factory LocalLyricModel.fromEntity(LyricEntity entity) {
    return LocalLyricModel._(
      artist: entity.artist,
      lyric: entity.lyric,
      music: entity.music,
    );
  }

  Map toMap() {
    return {
      'artist': artist,
      'music': music,
      'lyric': lyric,
    };
  }
}
