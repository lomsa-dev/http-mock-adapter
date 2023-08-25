import 'package:dio/dio.dart';
import 'package:http_mock_adapter/src/logger/logger.dart';
import 'package:http_mock_adapter/src/matchers/http_matcher.dart';
import 'package:http_mock_adapter/src/mixins/mixins.dart';
import 'package:http_mock_adapter/src/response.dart';
import 'package:logger/logger.dart';

/// [DioInterceptor] is a class for mocking [Dio] requests with [Interceptor].
class DioInterceptor extends Interceptor with Recording, RequestHandling {
  @override
  final Dio dio;

  @override
  final HttpRequestMatcher matcher;

  @override
  late Logger logger;

  final bool printLogs;

  @override
  final bool failOnMissingMock;

  /// Constructs a [DioInterceptor] and configures the passed [Dio] instance.
  DioInterceptor({
    required this.dio,
    this.matcher = const FullHttpRequestMatcher(),
    this.printLogs = false,
    this.failOnMissingMock = true,
  }) {
    dio.interceptors.add(this);
    logger = getLogger(printLogs);
  }

  /// Dio [Interceptor]`s [onRequest] configuration intended to catch and return
  /// mocked request and data respectively.
  @override
  void onRequest(requestOptions, requestInterceptorHandler) async {
    await setDefaultRequestHeaders(dio, requestOptions);
    final response = await mockResponse(requestOptions);

    if (response == null) {
      requestInterceptorHandler.next(requestOptions);
      return;
    }

    // Reject the response if type is MockDioException.
    if (isMockDioException(response)) {
      requestInterceptorHandler.reject(response as DioException);

      return;
    }

    final responseBody = response as MockResponseBody;

    requestInterceptorHandler.resolve(
      Response(
        data: await dio.transformer.transformResponse(
          requestOptions,
          responseBody,
        ),
        headers: Headers.fromMap(responseBody.headers),
        isRedirect: responseBody.isRedirect,
        redirects: responseBody.redirects ?? [],
        requestOptions: requestOptions,
        statusCode: responseBody.statusCode,
        statusMessage: responseBody.statusMessage,
      ),
    );
  }
}
