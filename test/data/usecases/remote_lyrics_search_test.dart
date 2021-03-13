import 'package:faker/faker.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';

import 'package:test/test.dart';

abstract class HttpClient {
  Future<void> request({
    @required String url,
    String method: 'get',
  });
}

class RemoteLyricsSearch {
  final HttpClient httpClient;
  final String url;

  RemoteLyricsSearch({
    @required this.httpClient,
    @required this.url,
  });

  Future<void> search({
    @required String artist,
    @required String music,
  }) async {
    final lyricsRequest = "$url/$artist/$music";

    await httpClient.request(url: lyricsRequest);
  }
}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  String url;
  String artist;
  String music;
  RemoteLyricsSearch sut;
  HttpClientSpy httpClientSpy;

  setUp(() {
    artist = faker.person.name();
    music = faker.lorem.sentence();
    url = faker.internet.httpUrl();
    httpClientSpy = HttpClientSpy();
    sut = RemoteLyricsSearch(url: url, httpClient: httpClientSpy);
  });

  test('Should call HttpClient with correct values', () async {
    await sut.search(artist: artist, music: music);

    verify(
      httpClientSpy.request(url: "$url/$artist/$music", method: 'get'),
    ).called(1);
  });
}
