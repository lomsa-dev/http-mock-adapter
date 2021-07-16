import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:http_mock_adapter/src/exceptions.dart';
import 'package:http_mock_adapter/src/response.dart';

/// Something that can respond to requests.
abstract class MockServer {
  void reply(
    int statusCode,
    dynamic data, {
    Map<String, List<String>> headers = const {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
    String? statusMessage,
    bool isRedirect = false,
  });

  void throws(
    int statusCode,
    DioError dioError,
  );
}

/// The handler implements [MockServer] and
/// constructs the configured [MockResponse].
class RequestHandler implements MockServer {
  /// This is the response.
  late MockResponse Function() mockResponse;

  /// Stores [MockResponse] in [mockResponse].
  @override
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

    mockResponse = () => MockResponseBody.from(
          isJsonContentType ? jsonEncode(data) : data,
          statusCode,
          headers: headers,
          statusMessage: statusMessage,
          isRedirect: isRedirect,
        );
  }

  /// Stores the [DioError] inside the [mockResponse].
  @override
  void throws(int statusCode, DioError dioError) {
    mockResponse = () => MockDioError.from(dioError);
  }
}
