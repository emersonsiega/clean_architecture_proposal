import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../data/data.dart';

class HttpAdapter implements HttpClient {
  final Dio client;

  HttpAdapter(this.client);

  @override
  Future<Map> request({
    @required String url,
    String method = 'get',
    Duration timeout: const Duration(seconds: 10),
  }) async {
    final defaultHeaders = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };

    client.options = BaseOptions(
      headers: defaultHeaders,
      connectTimeout: timeout.inMilliseconds,
      receiveTimeout: timeout.inMilliseconds,
      sendTimeout: timeout.inMilliseconds,
    );

    var response = Response(data: '', statusCode: 500);

    try {
      if (method == 'get') {
        response = await client.get(url);
      }
    } catch (error) {
      throw HttpError.serverError;
    }

    return _handleResponse(response);
  }

  Map _handleResponse(Response response) {
    if (response.statusCode == 200) {
      return response.data.isEmpty ? null : jsonDecode(response.data);
    } else if (response.statusCode == 204) {
      return null;
    } else if (response.statusCode == 404) {
      throw HttpError.notFound;
    }

    throw HttpError.serverError;
  }
}
