import 'package:faker/faker.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';

import 'package:test/test.dart';

abstract class HttpClient {
  Future<void> request({@required String url});
}

class RemoteLyricsSearch {
  final HttpClient httpClient;
  final String url;

  RemoteLyricsSearch({
    @required this.httpClient,
    @required this.url,
  });

  Future<void> search() async {
    await httpClient.request(url: url);
  }
}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  String url;
  RemoteLyricsSearch sut;
  HttpClientSpy httpClientSpy;

  setUp(() {
    url = faker.internet.httpUrl();
    httpClientSpy = HttpClientSpy();
    sut = RemoteLyricsSearch(url: url, httpClient: httpClientSpy);
  });

  test('Should call HttpClient with correct values', () {
    sut.search();

    verify(httpClientSpy.request(url: url)).called(1);
  });
}
