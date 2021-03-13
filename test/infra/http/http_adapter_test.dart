import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:http/http.dart';

import 'package:clean_architecture_proposal/infra/infra.dart';
import 'package:clean_architecture_proposal/data/data.dart';

class ClientSpy extends Mock implements Client {}

void main() {
  String url;
  ClientSpy clientSpy;
  HttpAdapter sut;
  String response;

  void mockResponse(String data, {int statusCode: 200}) {
    when(clientSpy.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => Response(data, statusCode));
  }

  setUp(() {
    url = faker.internet.httpUrl();
    response = '{"any-key":"any-value"}';
    clientSpy = ClientSpy();
    sut = HttpAdapter(clientSpy);

    mockResponse(response);
  });

  test('Should call get with correct values', () async {
    await sut.request(url: url);

    verify(clientSpy.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    ));
  });

  test('Should return value on 200', () async {
    final response = await sut.request(url: url);

    expect(response, {'any-key': 'any-value'});
  });

  test('Should return null on 200 with no data', () async {
    mockResponse('');

    final response = await sut.request(url: url);

    expect(response, null);
  });

  test('Should return null on 204', () async {
    mockResponse('', statusCode: 204);

    final response = await sut.request(url: url);

    expect(response, null);
  });

  test('Should throw notFound error on 404', () async {
    mockResponse('', statusCode: 404);

    final future = sut.request(url: url);

    expect(future, throwsA(HttpError.notFound));
  });

  test('Should throw serverError on error', () async {
    mockResponse('', statusCode: 500);

    final future = sut.request(url: url);

    expect(future, throwsA(HttpError.serverError));
  });
}
