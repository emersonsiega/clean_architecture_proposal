import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:clean_architecture_proposal/shared/data/data.dart';
import 'package:clean_architecture_proposal/shared/domain/domain.dart';

import 'package:clean_architecture_proposal/modules/lyrics_search_module/data/data.dart';
import 'package:clean_architecture_proposal/modules/lyrics_search_module/domain/domain.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  String url;
  LyricsSearchParams params;
  RemoteLyricsSearch sut;
  HttpClientSpy httpClientSpy;
  LyricEntity entity;

  PostExpectation mockHttpClientCall() =>
      when(httpClientSpy.request(url: anyNamed('url')));

  void mockError(HttpError error) {
    mockHttpClientCall().thenThrow(error);
  }

  void mockSuccess() {
    mockHttpClientCall().thenAnswer((_) async => {'lyrics': entity.lyric});
  }

  setUp(() {
    params = LyricsSearchParams(
      artist: "Eric Clapton",
      music: 'Tears in Heaven',
    );

    entity = LyricEntity(
      lyric: faker.lorem.sentence(),
      artist: params.artist,
      music: params.music,
    );

    url = faker.internet.httpUrl();
    httpClientSpy = HttpClientSpy();
    sut = RemoteLyricsSearch(url: url, httpClient: httpClientSpy);

    mockSuccess();
  });

  test('Should call HttpClient with correct values', () async {
    await sut.search(params);

    verify(
      httpClientSpy.request(
        url: "$url/Eric Clapton/Tears in Heaven",
        method: 'get',
      ),
    ).called(1);
  });

  test('Should throw a invalidQuery error if httpClient throws 404', () async {
    mockError(HttpError.notFound);

    final future = sut.search(params);

    expect(future, throwsA(DomainError.invalidQuery));
  });

  test('Should throw a unexpectedError if httpClient throws 500', () async {
    mockError(HttpError.serverError);

    final future = sut.search(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should return LyricsEntity on success', () async {
    final lyrics = await sut.search(params);

    expect(lyrics, entity);
  });
}
