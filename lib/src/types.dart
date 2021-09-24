import 'package:dio/dio.dart';
import 'package:http_mock_adapter/src/handlers/request_handler.dart';
import 'package:http_mock_adapter/src/mixins/mixins.dart';
import 'package:http_mock_adapter/src/request.dart';
import 'package:http_mock_adapter/src/response.dart';

/// Type for request handler callbacks in the [RequestHandling].
typedef MockServerCallback = void Function(MockServer server);

/// Type for [Recording]'s [ResponseBody], which takes [RequestOptions] as a parameter
/// and compares its signature to saved [Request]'s signature and chooses right response.
typedef MockResponseBodyCallback = MockResponse Function(
  RequestOptions options,
);

/// Type for expect data as function
typedef MockDataCallback = dynamic Function(RequestOptions options);
