String lyricsApiUrlFactory({String path: ""}) {
  final baseUrl = "https://api.lyrics.ovh/v1";

  return "$baseUrl$path";
}
