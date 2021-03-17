import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:shared/shared.dart';

abstract class LyricsSearch {
  Future<LyricEntity> search(LyricsSearchParams params);
}

class LyricsSearchParams extends Equatable {
  final String artist;
  final String music;

  LyricsSearchParams({
    @required this.artist,
    @required this.music,
  });

  String toUrlString() => "$artist/$music";

  @override
  List<Object> get props => [artist, music];
}
