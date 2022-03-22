import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:http_mock_adapter/src/exceptions.dart';
import 'package:http_mock_adapter/src/response.dart';
import 'package:http_mock_adapter/src/types.dart';

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
    Duration? delay,
  });

  void throws(
    int statusCode,
    DioError dioError, {
    Duration? delay,
  });
}

/// The handler implements [MockServer] and
/// constructs the configured [MockResponse].
class RequestHandler implements MockServer {
  /// This is the response.
  late MockResponse Function(RequestOptions options) mockResponse;

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
    Duration? delay,
  }) {
    final isJsonContentType = headers[Headers.contentTypeHeader]?.contains(
          Headers.jsonContentType,
        ) ??
        false;

    mockResponse = (requestOptions) {
      var rawData = data;
      if (data is MockDataCallback) {
        rawData = data(requestOptions);
      }

      return MockResponseBody.from(
        isJsonContentType ? jsonEncode(rawData) : rawData,
        statusCode,
        headers: headers,
        statusMessage: statusMessage,
        isRedirect: isRedirect,
        delay: delay,
      );
    };
  }

  /// Stores the [DioError] inside the [mockResponse].
  @override
  void throws(int statusCode, DioError dioError, {Duration? delay}) {
    mockResponse = (requestOptions) => MockDioError.from(dioError, delay);
  }
}
