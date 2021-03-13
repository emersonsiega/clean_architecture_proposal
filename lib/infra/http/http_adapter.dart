import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:http/http.dart';

import '../../data/data.dart';

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

    var response = Response('', 500);

    try {
      if (method == 'get') {
        response = await client.get(
          url,
          headers: defaultHeaders,
        );
      }
    } catch (error) {
      throw HttpError.serverError;
    }

    return _handleResponse(response);
  }

  Map _handleResponse(Response response) {
    if (response.statusCode == 200) {
      return response.body.isEmpty ? null : jsonDecode(response.body);
    } else if (response.statusCode == 204) {
      return null;
    } else if (response.statusCode == 404) {
      throw HttpError.notFound;
    }

    throw HttpError.serverError;
  }
}
