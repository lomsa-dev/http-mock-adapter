import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

/// The handler of requests sent by clients.
class RequestHandler {
  /// An HTTP status code such as - `200`, `404`, `500`, etc.
  int statusCode;

  /// Map of <[statusCode], [ResponseBody]>.
  final Map<int, ResponseBody> requestMap = {};

  /// Stores [ResponseBody] in [requestMap] and returns [DioAdapter]
  /// the latter which is utilized for method chaining.
  DioAdapter reply(
    int statusCode,
    dynamic data, {
    Map<String, List<String>> headers,
    String statusMessage,
    bool isRedirect,
  }) {
    this.statusCode = statusCode;

    requestMap[this.statusCode] = ResponseBody.fromString(
      jsonEncode(data),
      HttpStatus.ok,
      headers: headers,
      statusMessage: statusMessage,
      isRedirect: isRedirect,
    );

    return DioAdapter();
  }
}
