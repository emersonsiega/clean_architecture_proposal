import '../../../../shared/shared.dart';

import '../../domain/domain.dart';

class RemoteLyricModel {
  LyricEntity entity;

  RemoteLyricModel(this.entity);

  factory RemoteLyricModel.fromJson(LyricsSearchParams params, Map json) {
    final entity = LyricEntity(
      lyric: json["lyrics"],
      artist: params.artist,
      music: params.music,
    );

    return RemoteLyricModel(entity);
  }
}
