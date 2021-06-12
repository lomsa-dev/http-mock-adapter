import 'dart:typed_data';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:http_mock_adapter/src/handlers/request_handler.dart';
import 'package:http_mock_adapter/src/matchers/matchers.dart';
import 'package:http_mock_adapter/src/mixins/mixins.dart';
import 'package:http_mock_adapter/src/request.dart';
import 'package:http_mock_adapter/src/response.dart';
import 'package:http_mock_adapter/src/types.dart';

/// [HttpClientAdapter] extension with data mocking and tracking functionality.
class DioAdapter extends HttpClientAdapter with Recording, RequestHandling {
  /// [Dio]`s default HTTP client adapter implementation.
  final _defaultHttpClientAdapter = DefaultHttpClientAdapter();

  /// An HTTP method such as [RequestMethods.get] or [RequestMethods.post].
  RequestMethods method;

  /// The payload.
  dynamic data;

  /// Query parameters to encompass additional parameters to the query.
  Map<String, dynamic>? queryParameters;

  /// Headers to encompass content-types.
  Map<String, dynamic>? headers;

  DioAdapter({
    this.method = RequestMethods.get,
    this.data,
    this.queryParameters = const {},
    this.headers = const {
      Headers.contentTypeHeader: Headers.jsonContentType,
      Headers.contentLengthHeader: Matchers.integer,
    },
  });

  /// Takes in [route], [request], sets corresponding [RequestHandler],
  /// adds an instance of [RequestMatcher] in [history].
  @override
  void onRoute(
    Pattern route,
    RequestHandlerCallback requestHandlerCallback, {
    required Request request,
  }) {
    request = Request(
      route: route,
      method: request.method ?? method,
      data: request.data ?? data,
      queryParameters: request.queryParameters ?? queryParameters,
      headers: request.headers ?? headers,
    );

    final requestHandler = RequestHandler<DioAdapter>(
      requestSignature: request.signature,
    );

    requestHandlerCallback(requestHandler);

    history.add(
      RequestMatcher(
        request,
        requestHandler,
      ),
    );
  }

  /// [DioAdapter]`s [fetch] configuration intended to work with mock data.
  /// Returns a [Future<ResponseBody>] from [history] based on [RequestOptions].
  @override
  Future<ResponseBody> fetch(
    RequestOptions requestOptions,
    Stream<Uint8List>? requestStream,
    Future? cancelFuture,
  ) async {
    final response = mockResponse(requestOptions);

    // Throws DioError if response type is MockDioError.
    if (isError(response)) {
      throw response as DioError;
    }

    return response as MockResponseBody;
  }

  /// Closes the [DioAdapter] by force.
  @override
  void close({bool force = false}) => _defaultHttpClientAdapter.close(
        force: force,
      );
}
