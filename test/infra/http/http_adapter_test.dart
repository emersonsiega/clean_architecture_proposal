import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

import 'package:clean_architecture_proposal/data/data.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client);

  @override
  Future<Map<String, String>> request({
    @required String url,
    String method = 'get',
  }) async {
    await client.get(url);
  }
}

class ClientSpy extends Mock implements Client {}

void main() {
  test('Should call get with correct values', () async {
    final url = faker.internet.httpUrl();
    final clientSpy = ClientSpy();

    final sut = HttpAdapter(clientSpy);
    await sut.request(url: url, method: 'get');

    verify(clientSpy.get(url));
  });
}
