import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class LyricEntity extends Equatable {
  final String id;
  final String lyric;
  final String artist;
  final String music;

  LyricEntity({
    @required this.lyric,
    @required this.artist,
    @required this.music,
  }) : this.id = "${artist.toLowerCase()}-${music.toLowerCase()}";

  @override
  List<Object> get props => [id];
}
