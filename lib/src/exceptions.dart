import 'package:dio/dio.dart';
import 'package:http_mock_adapter/src/adapters/dio_adapter.dart';
import 'package:http_mock_adapter/src/handlers/request_handler.dart';
import 'package:http_mock_adapter/src/interceptors/dio_interceptor.dart';
import 'package:http_mock_adapter/src/response.dart';

/// [RequestHandlerException] is thrown when [RequestHandler] method
/// is called with generic type parameter.
/// Available types are: [DioInterceptor] and [DioAdapter].
class RequestHandlerException implements Exception {
  final dynamic message;

  RequestHandlerException([
    this.message =
        'Request handler should have generic type `DioAdapter` or `DioInterceptor`',
  ]);

  @override
  String toString() {
    if (message == null) {
      return 'Provide the message inside the exception';
    }

    return 'RequestHandlerException: $message';
  }
}

/// Wrapper of [Dio]'s [DioError] [Exception].
class MockDioError extends DioError implements MockResponse {
  MockDioError({
    required RequestOptions requestOptions,
    Response? response,
    DioErrorType type = DioErrorType.other,
    dynamic error,
  }) : super(
          requestOptions: requestOptions,
          response: response,
          type: type,
          error: error,
        );

  static MockDioError from(DioError dioError) => MockDioError(
        requestOptions: dioError.requestOptions,
        response: dioError.response,
        type: dioError.type,
        error: dioError.error,
      );
}

/// This [Exception] is thrown when throws gets wrong type of argument
/// in the place of the [DioError].
class UndefinedException implements Exception {
  final dynamic message;

  UndefinedException([
    this.message = 'Error should be either `DioError` or `MockDioError`',
  ]);

  @override
  String toString() {
    if (message == null) {
      return 'Provide the message inside the exception';
    }

    return 'UndefinedException: $message';
  }
}
