import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:http_mock_adapter/src/handlers/request_handler.dart';

import '../history.dart';
import '../request.dart';

/// [HttpClientAdapter] extension with data mocking and tracking functionality.
class DioAdapter extends HttpClientAdapter with RequestRouted, Tracked {
  /// [Dio]`s default HTTP client adapter implementation.
  final _defaultHttpClientAdapter = DefaultHttpClientAdapter();

  /// [DioAdapter]'s private constructor method.
  DioAdapter._construct();

  /// [DioAdapter]'s singleton instance.
  static final DioAdapter _dioAdapter = DioAdapter._construct();

  /// Factory method of [DioAdapter] utilized to return [_dioAdapter]
  /// singleton instance each time it is called;
  factory DioAdapter() {
    return _dioAdapter;
  }

  /// Takes in route, request, sets corresponding [RequestHandler],
  /// adds an instance of [RequestMatcher] in [History.data].
  @override
  RequestHandler onRoute(String route, {Request request = const Request()}) {
    final requestHandler = RequestHandler();

    history.data.add(RequestMatcher(route, request, requestHandler));

    return requestHandler;
  }

  /// [DioAdapter]`s [fetch] configuration intended to work with mock data.
  /// Returns a [Future<ResponseBody>] from [History] based on [RequestOptions].
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>> requestStream,
    Future cancelFuture,
  ) async =>
      history.response(
        options.path,
        options.method,
      );

  /// Closes the [DioAdapter] by force.
  @override
  void close({bool force = false}) =>
      _defaultHttpClientAdapter.close(force: force);
}
