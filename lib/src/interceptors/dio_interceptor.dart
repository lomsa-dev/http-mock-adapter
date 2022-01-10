import 'package:dio/dio.dart';
import 'package:http_mock_adapter/src/matchers/http_matcher.dart';
import 'package:http_mock_adapter/src/mixins/mixins.dart';
import 'package:http_mock_adapter/src/response.dart';

/// [DioInterceptor] is a class for mocking [Dio] requests with [Interceptor].
class DioInterceptor extends Interceptor with Recording, RequestHandling {
  @override
  final Dio dio;

  @override
  final HttpRequestMatcher matcher;

  /// Constructs a [DioInterceptor] and configures the passed [Dio] instance.
  DioInterceptor({
    required this.dio,
    this.matcher = const FullHttpRequestMatcher(),
  }) {
    dio.interceptors.add(this);
  }

  /// Dio [Interceptor]`s [onRequest] configuration intended to catch and return
  /// mocked request and data respectively.
  @override
  void onRequest(requestOptions, requestInterceptorHandler) async {
    await setDefaultRequestHeaders(dio, requestOptions);
    final response = mockResponse(requestOptions);

    // Reject the response if type is MockDioError.
    if (isMockDioError(response)) {
      requestInterceptorHandler.reject(response as DioError);

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
