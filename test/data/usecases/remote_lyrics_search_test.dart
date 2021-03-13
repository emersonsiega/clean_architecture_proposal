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

abstract class LyricsSearch {
  Future<void> search(LyricsSearchParams params);
}

class LyricsSearchParams {
  final String artist;
  final String music;

  LyricsSearchParams({@required this.artist, @required this.music});

  String toUrlString() => "$artist/$music";
}

class RemoteLyricsSearch implements LyricsSearch {
  final HttpClient httpClient;
  final String url;

  RemoteLyricsSearch({
    @required this.httpClient,
    @required this.url,
  });

  Future<void> search(LyricsSearchParams params) async {
    final lyricsRequest = "$url/${params.toUrlString()}";

    await httpClient.request(url: lyricsRequest);
  }
}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  String url;
  LyricsSearchParams params;
  RemoteLyricsSearch sut;
  HttpClientSpy httpClientSpy;

  setUp(() {
    params = LyricsSearchParams(
      artist: faker.person.name(),
      music: faker.lorem.sentence(),
    );

    url = faker.internet.httpUrl();
    httpClientSpy = HttpClientSpy();
    sut = RemoteLyricsSearch(url: url, httpClient: httpClientSpy);
  });

  test('Should call HttpClient with correct values', () async {
    await sut.search(params);

    verify(
      httpClientSpy.request(
        url: "$url/${params.artist}/${params.music}",
        method: 'get',
      ),
    ).called(1);
  });
}
