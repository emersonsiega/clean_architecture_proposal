import 'package:dio/dio.dart';

abstract class HttpInterface {
  Future<Response<dynamic>> get(String path);
}
