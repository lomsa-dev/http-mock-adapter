import 'package:dio/dio.dart';
import 'package:http_mock_adapter/src/adapter_interface.dart';

/// [RequestHandlerException] is thrown when, Request Handler method
/// is called with genreic type paramter.
/// available types are: DioInterceptor and DioAdapter
class RequestHandlerException implements Exception {
  final dynamic message;

  RequestHandlerException(
      [this.message =
          'Request handler should have generic type DioAdapter or DioInterceptor']);

  @override
  String toString() {
    if (message == null) return 'Provide the message inside the exception';
    return 'RequestHandlerException: $message';
  }
}

class AdapterError extends DioError implements Responsable {
  AdapterError({
    RequestOptions request,
    Response response,
    DioErrorType type = DioErrorType.DEFAULT,
    dynamic error,
  }) : super(
          request: request,
          response: response,
          type: type,
          error: error,
        );
}
