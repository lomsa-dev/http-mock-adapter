import 'dart:typed_data';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:http_mock_adapter/src/handlers/request_handler.dart';
import 'package:http_mock_adapter/src/history.dart';
import 'package:http_mock_adapter/src/request.dart';
import 'package:http_mock_adapter/src/types.dart';

/// [HttpClientAdapter] extension with data mocking and tracking functionality.
class DioAdapter extends HttpClientAdapter with RequestRouted, Tracked {
  /// [Dio]`s default HTTP client adapter implementation.
  final _defaultHttpClientAdapter = DefaultHttpClientAdapter();

  /// Takes in [route], [request], sets corresponding [RequestHandler],
  /// adds an instance of [RequestMatcher] in [History.data].
  @override
  Future<void> onRoute(
    dynamic route,
    RequestHandlerCallback callback, {
    Request request = const Request(),
    Duration delay = Duration.zero,
  }) async {
    await Future.delayed(delay);
    final handler = RequestHandler<DioAdapter>();
    callback(handler);
    history.data.add(
      RequestMatcher(
        Request(
          route: route,
          method: request.method,
          data: request.data,
          queryParameters: request.queryParameters,
          headers: request.headers,
        ),
        handler,
      ),
    );
  }

  /// [DioAdapter]`s [fetch] configuration intended to work with mock data.
  /// Returns a [Future<ResponseBody>] from [History] based on [RequestOptions].
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future? cancelFuture,
  ) async {
    dynamic responseBody = history.responseBody(options);

    // throws error if response type is AdapterError
    if (isError(responseBody)) {
      throw responseBody as DioError;
    }

    responseBody.headers = responseBody.headers ??
        const {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        };

    return responseBody;
  }

  /// Closes the [DioAdapter] by force.
  @override
  void close({bool force = false}) =>
      _defaultHttpClientAdapter.close(force: force);
}

