import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:clean_architecture_proposal/data/data.dart';
import 'package:clean_architecture_proposal/domain/domain.dart';

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
