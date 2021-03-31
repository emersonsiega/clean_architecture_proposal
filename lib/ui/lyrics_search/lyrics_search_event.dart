import 'package:equatable/equatable.dart';

abstract class LyricsSearchEvent {}

class ValidateMusicEvent extends Equatable implements LyricsSearchEvent {
  final String music;

  ValidateMusicEvent(this.music);

  @override
  List<Object> get props => [music];
}

class ValidateArtistEvent extends Equatable implements LyricsSearchEvent {
  final String artist;

  ValidateArtistEvent(this.artist);

  @override
  List<Object> get props => [artist];
}

class SearchLyricEvent extends Equatable implements LyricsSearchEvent {
  @override
  List<Object> get props => [];
}
