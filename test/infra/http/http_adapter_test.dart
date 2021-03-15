import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:dio/dio.dart';

import 'package:clean_architecture_proposal/infra/infra.dart';
import 'package:clean_architecture_proposal/data/data.dart';

class ClientSpy extends Mock implements Dio {}

void main() {
  String url;
  ClientSpy clientSpy;
  HttpAdapter sut;
  String response;

  PostExpectation mockClientCall() =>
      when(clientSpy.get(any, options: anyNamed('options')));

  void mockResponse(String data, {int statusCode: 200}) {
    mockClientCall().thenAnswer(
      (_) async => Response(data: data, statusCode: statusCode),
    );
  }

  void mockError() {
    mockClientCall().thenThrow(Exception());
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

    verify(clientSpy.get(url)).called(1);
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

  test('Should throw serverError if invalid method is provided', () async {
    mockResponse('', statusCode: 200);

    final future = sut.request(url: url, method: 'invalid');

    expect(future, throwsA(HttpError.serverError));
  });

  test('Should throw serverError if client throws', () async {
    mockError();

    final future = sut.request(url: url);

    expect(future, throwsA(HttpError.serverError));
  });
}
