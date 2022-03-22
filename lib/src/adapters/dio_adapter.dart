import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http_mock_adapter/src/exceptions.dart';
import 'package:http_mock_adapter/src/matchers/http_matcher.dart';
import 'package:http_mock_adapter/src/mixins/mixins.dart';
import 'package:http_mock_adapter/src/response.dart';

/// [HttpClientAdapter] extension with data mocking and recording functionality.
class DioAdapter extends HttpClientAdapter with Recording, RequestHandling {
  /// State of [DioAdapter] that can be closed to prohibit functionality.
  bool _isClosed = false;

  @override
  final Dio dio;

  @override
  final HttpRequestMatcher matcher;

  /// Constructs a [DioAdapter] and configures the passed [Dio] instance.
  DioAdapter({
    required this.dio,
    this.matcher = const FullHttpRequestMatcher(),
  }) {
    dio.httpClientAdapter = this;
  }

  /// [DioAdapter]`s [fetch] configuration intended to work with mock data.
  /// Returns a [Future<ResponseBody>] from [history] based on [RequestOptions].
  @override
  Future<ResponseBody> fetch(
    RequestOptions requestOptions,
    Stream<Uint8List>? requestStream,
    Future? cancelFuture,
  ) async {
    if (_isClosed) {
      throw ClosedException(
        'Cannot establish connection after [$runtimeType] got closed!',
      );
    }

    await setDefaultRequestHeaders(dio, requestOptions);
    final response = mockResponse(requestOptions);

    // Waits for defined duration.
    if (response.delay != null) await Future.delayed(response.delay!);

    // Throws DioError if response type is MockDioError.
    if (isMockDioError(response)) throw response as DioError;

    return response as MockResponseBody;
  }

  /// Closes the [DioAdapter] by force.
  @override
  void close({bool force = false}) => _isClosed = true;
}
