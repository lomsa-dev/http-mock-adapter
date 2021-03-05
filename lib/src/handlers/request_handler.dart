import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:http_mock_adapter/src/exceptions.dart';
import 'package:http_mock_adapter/src/interceptors/dio_interceptor.dart';
import 'package:http_mock_adapter/src/interfaces.dart';
import 'package:http_mock_adapter/src/response.dart';

/// The handler of requests sent by clients.
class RequestHandler<T> {
  /// An HTTP status code such as - `200`, `404`, `500`, etc.
  late int statusCode;

  /// Map of <[statusCode], [Responsable]>.
  final Map<int, Responsable Function()> requestMap = {};

  /// Stores [Responsable] in [requestMap] and returns [DioAdapter] or [DioInterceptor]
  /// the latter which is utilized for method chaining.
  void reply(
    int statusCode,
    dynamic data, {
    Map<String, List<String>> headers = const {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
    String? statusMessage,
    bool isRedirect = false,
  }) {
    this.statusCode = statusCode;

    requestMap[this.statusCode] = () => AdapterResponse.from(
          jsonEncode(data),
          this.statusCode,
          headers: headers,
          statusMessage: statusMessage,
          isRedirect: isRedirect,
        );
  }

  /// Stores the [DioError] inside the [requestMap]
  /// and returns [DioAdapter] or [DioInterceptor],
  /// the latter which is utilized for method chaining.
  void throws(int statusCode, DioError dioError) {
    if (dioError.runtimeType != DioError &&
        dioError.runtimeType != AdapterError) {
      throw ThrowsException();
    }

    this.statusCode = statusCode;
    requestMap[this.statusCode] = () => AdapterError.from(dioError);
  }
}
