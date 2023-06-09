import 'package:dio/dio.dart';
import 'package:http_mock_adapter/src/adapters/dio_adapter.dart';
import 'package:http_mock_adapter/src/interceptors/dio_interceptor.dart';
import 'package:http_mock_adapter/src/response.dart';

/// Wrapper of [Dio]'s [DioException] [Exception].
class MockDioException extends DioException implements MockResponse {
  @override
  final Duration? delay;

  MockDioException({
    required RequestOptions requestOptions,
    Response? response,
    DioExceptionType type = DioExceptionType.unknown,
    dynamic error,
    this.delay,
  }) : super(
          requestOptions: requestOptions,
          response: response,
          type: type,
          error: error,
        );

  static MockDioException from(DioException dioError, [Duration? delay]) =>
      MockDioException(
        requestOptions: dioError.requestOptions,
        response: dioError.response,
        type: dioError.type,
        error: dioError.error,
        delay: delay,
      );
}

/// [ClosedException] is thrown when [DioAdapter] or [DioInterceptor]
/// get closed and and then accessed.
class ClosedException implements Exception {
  final dynamic message;

  const ClosedException([this.message = 'Cannot establish connection!']);

  @override
  String toString() => 'ClosedException: $message';
}
