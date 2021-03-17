import 'package:meta/meta.dart';

import '../../shared.dart';

class LocalLyricModel {
  LyricEntity _entity;

  LocalLyricModel._({
    @required String lyric,
    @required String artist,
    @required String music,
  }) : _entity = LyricEntity(artist: artist, music: music, lyric: lyric);

  factory LocalLyricModel.fromEntity(LyricEntity entity) {
    return LocalLyricModel._(
      artist: entity.artist,
      lyric: entity.lyric,
      music: entity.music,
    );
  }

  factory LocalLyricModel.fromMap(Map json) {
    return LocalLyricModel._(
      artist: json["artist"],
      lyric: json["lyric"],
      music: json["music"],
    );
  }

  Map toMap() {
    return {
      'artist': _entity.artist,
      'music': _entity.music,
      'lyric': _entity.lyric,
    };
  }

  LyricEntity toEntity() {
    return _entity;
  }
}
