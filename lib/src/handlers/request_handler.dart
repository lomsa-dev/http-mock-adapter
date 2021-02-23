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
  int statusCode;

  /// Map of <[statusCode], [Responsable]>.
  final Map<int, Responsable Function()> requestMap = {};

  /// Stores [Responsable] in [requestMap] and returns [DioAdapter] or [DioInterceptor]
  /// the latter which is utilized for method chaining.
  AdapterInterface reply(
    int statusCode,
    dynamic data, {
    Map<String, List<String>> headers = const {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
    String statusMessage,
    bool isRedirect,
  }) {
    this.statusCode = statusCode;

    requestMap[this.statusCode] = () => AdapterResponse.from(
          jsonEncode(data),
          this.statusCode,
          headers: headers,
          statusMessage: statusMessage,
          isRedirect: isRedirect,
        );

    return _createChain();
  }

  /// Stores the [DioError] inside the [requestMap]
  /// and returns [DioAdapter] or [DioInterceptor],
  /// the latter which is utilized for method chaining.
  AdapterInterface throws(int statusCode, DioError dioError) {
    if (dioError.runtimeType != DioError &&
        dioError.runtimeType != AdapterError) {
      return throw ThrowsException();
    }

    this.statusCode = statusCode;
    requestMap[this.statusCode] = () => AdapterError.from(dioError);

    return _createChain();
  }

  /// Checking the type of the `type parameter`
  /// and returning the relevant Class Instance
  /// If type parameter of the class is none of the following:
  /// [DioAdapter], [DioInterceptor], [dynamic], throws [RequestHandlerException].
  AdapterInterface _createChain() {
    switch (T) {
      case DioInterceptor:
        return DioInterceptor();
        break;
      case DioAdapter:
        return DioAdapter();
        break;
      case dynamic:
        return DioAdapter();
        break;
      default:
        return throw RequestHandlerException();
        break;
    }
  }
}
