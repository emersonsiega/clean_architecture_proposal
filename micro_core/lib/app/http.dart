import 'package:micro_core/app/http_interface.dart';
import 'package:dio/dio.dart';

class Http implements HttpInterface {
  final dio = Dio();

  @override
  Future<Response> get(String path) => dio.get(path);
}
