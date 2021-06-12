import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:http_mock_adapter/src/exceptions.dart';
import 'package:http_mock_adapter/src/response.dart';
import 'package:http_mock_adapter/src/utils.dart';

/// The handler of requests sent by clients.
class RequestHandler<T> {
  /// Signature built from [buildRequestSignature].
  final String requestSignature;

  RequestHandler({
    required this.requestSignature,
  });

  /// Map of <[requestSignature], [MockResponse]>.
  final Map<String, MockResponse Function()> mockResponses = {};

  /// Stores [MockResponse] in [mockResponses].
  void reply(
    int statusCode,
    dynamic data, {
    Map<String, List<String>> headers = const {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
    String? statusMessage,
    bool isRedirect = false,
  }) {
    final isJsonContentType = headers[Headers.contentTypeHeader]?.contains(
          Headers.jsonContentType,
        ) ??
        false;

    mockResponses[requestSignature] = () => MockResponseBody.from(
          isJsonContentType ? jsonEncode(data) : data,
          statusCode,
          headers: headers,
          statusMessage: statusMessage,
          isRedirect: isRedirect,
        );
  }

  /// Stores the [DioError] inside the [mockResponses].
  void throws(int statusCode, DioError dioError) {
    if (dioError is! DioError && dioError is! MockDioError) {
      throw UndefinedException();
    }

    mockResponses[requestSignature] = () => MockDioError.from(dioError);
  }
}
