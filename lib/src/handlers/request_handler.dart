import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:http_mock_adapter/src/exceptions.dart';
import 'package:http_mock_adapter/src/adapter_interface.dart';
import 'package:http_mock_adapter/src/interceptors/dio_interceptor.dart';

/// The handler of requests sent by clients.
class RequestHandler<T> {
  /// An HTTP status code such as - `200`, `404`, `500`, etc.
  int statusCode;

  /// Map of <[statusCode], [ResponseBody]>.
  final Map<int, ResponseBody> requestMap = {};

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

    requestMap[this.statusCode] = ResponseBody.fromString(
      jsonEncode(data),
      HttpStatus.ok,
      headers: headers,
      statusMessage: statusMessage,
      isRedirect: isRedirect,
    );

    return createChain();
  }

  // TODO implement doThrow method
  AdapterInterface doThrow() => createChain();
  // TODO take requestMap out of the function to maintain DRY principle

  // TODO somehow catch the request in here, to generate solid DioError instance

  /// Saving type of the typed parter T in the getter
  /// for [createChain] Function
  Type get chainType => chainType.runtimeType;

  /// Checking the type of the `type parameter`
  /// and returning the relevant Class Instance
  /// If type parameter of the class is none of the following [DioAdapter], [DioInterceptor], [dynamic],
  /// throws [RequestHandlerException]
  AdapterInterface createChain() {
    switch (chainType) {
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
