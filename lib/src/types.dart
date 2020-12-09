import 'package:dio/dio.dart';
import 'package:http_mock_adapter/src/interfaces.dart';
import 'package:http_mock_adapter/src/handlers/request_handler.dart';

/// type for request chainers like [onGet]
typedef AdapterRequest = RequestHandler Function(
  String route, {
  dynamic data,
  dynamic headers,
});

/// type for historys responsebody, which takes [RequestOptions] as a parameter
/// and compares its signature to saved request's signature and chooses right response
typedef AdapterResponseBody = Responsable Function(RequestOptions options);
