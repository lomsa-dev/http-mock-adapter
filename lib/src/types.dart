import 'package:dio/dio.dart';
import 'package:http_mock_adapter/src/history.dart';
import 'package:http_mock_adapter/src/interfaces.dart';
import 'package:http_mock_adapter/src/handlers/request_handler.dart';
import 'package:http_mock_adapter/src/request.dart';

/// Type for request chainers like onGet.
typedef AdapterRequest = RequestHandler Function(
  String route, {
  dynamic data,
  dynamic headers,
});

/// Type for [History]'s [ResponseBody], which takes [RequestOptions] as a parameter
/// and compares its signature to saved [Request]'s signature and chooses right response.
typedef AdapterResponseBody = Responsable Function(RequestOptions options);
