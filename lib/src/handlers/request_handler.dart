import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:http_mock_adapter/src/exceptions.dart';
import 'package:http_mock_adapter/src/adapter_interface.dart';
import 'package:http_mock_adapter/src/interceptors/dio_interceptor.dart';
import 'package:http_mock_adapter/src/response.dart';

/// The handler of requests sent by clients.
class RequestHandler<T> {
  /// An HTTP status code such as - `200`, `404`, `500`, etc.
  int statusCode;

  /// Map of <[statusCode], [ResponseBody]>.
  final Map<int, Responsable> requestMap = {};

  /// Stores [ResponseBody] in [requestMap] and returns [DioAdapter]
  /// the latter which is utilized for method chaining.
  AdapterInterface reply(
    int statusCode,
    dynamic data, {
    Map<String, List<String>> headers,
    String statusMessage,
    bool isRedirect,
  }) {
    this.statusCode = statusCode;

    requestMap[this.statusCode] = AdapterResponse.fromString(
      jsonEncode(data),
      HttpStatus.ok,
      headers: headers,
      statusMessage: statusMessage,
      isRedirect: isRedirect,
    );

    return _createChain();
  }

  // TODO implement doThrow method
  AdapterInterface doThrow(int statusCode, AdapterError dioError) {
    this.statusCode = statusCode;
    requestMap[this.statusCode] = dioError;
    return _createChain();
  }
  // TODO take requestMap out of the function to maintain DRY principle

  // TODO somehow catch the request in here, to generate solid DioError instance

  /// Checking the type of the `type parameter`
  /// and returning the relevant Class Instance
  /// If type parameter of the class is none of the following [DioAdapter], [DioInterceptor], [dynamic],
  /// throws [RequestHandlerException]
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
