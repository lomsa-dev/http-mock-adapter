import 'package:dio/dio.dart';
import 'package:http_mock_adapter/src/adapter_interface.dart';
import 'package:http_mock_adapter/src/handlers/request_handler.dart';

typedef AdapterRequest = RequestHandler Function(
  String route, {
  dynamic data,
  dynamic headers,
});

typedef AdapterResponseBody = Responsable Function(RequestOptions options);
