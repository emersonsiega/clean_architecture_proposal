import 'dart:convert';
import 'dart:math';

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
  Future<Map> request({
    @required String url,
    String method = 'get',
  }) async {
    final defaultHeaders = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };

    final response = await client.get(
      url,
      headers: defaultHeaders,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
  }
}

class ClientSpy extends Mock implements Client {}

void main() {
  String url;
  ClientSpy clientSpy;
  HttpAdapter sut;
  String response;

  void mockSuccess() {
    when(clientSpy.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => Response(response, 200));
  }

  setUp(() {
    url = faker.internet.httpUrl();
    response = '{"any-key":"any-value"}';
    clientSpy = ClientSpy();
    sut = HttpAdapter(clientSpy);

    mockSuccess();
  });

  test('Should call get with correct values', () async {
    await sut.request(url: url, method: 'get');

    verify(clientSpy.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    ));
  });

  test('Should returns value on 200', () async {
    final response = await sut.request(url: url, method: 'get');

    expect(response, {'any-key': 'any-value'});
  });
}
