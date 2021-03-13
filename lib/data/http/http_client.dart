import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

abstract class HttpClient {
  Future<Map<String, String>> request({
    @required String url,
    String method: 'get',
  });
}
