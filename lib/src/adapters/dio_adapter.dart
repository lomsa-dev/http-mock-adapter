import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:http_mock_adapter/src/constants.dart' as constants;
import 'package:http_mock_adapter/src/exceptions.dart';
import 'package:http_mock_adapter/src/handlers/request_handler.dart';
import 'package:http_mock_adapter/src/mixins/mixins.dart';
import 'package:http_mock_adapter/src/request.dart';
import 'package:http_mock_adapter/src/response.dart';
import 'package:http_mock_adapter/src/types.dart';

/// [HttpClientAdapter] extension with data mocking and recording functionality.
class DioAdapter extends HttpClientAdapter with Recording, RequestHandling {
  /// State of [DioAdapter] that can be closed to prohibit functionality.
  bool _isClosed = false;

  /// An HTTP method such as [RequestMethods.get] or [RequestMethods.post].
  RequestMethods method;

  /// The payload.
  dynamic data;

  /// Query parameters to encompass additional parameters to the query.
  Map<String, dynamic> queryParameters;

  /// Headers to encompass content-types.
  Map<String, dynamic> headers;

  DioAdapter({
    this.method = constants.defaultRequestMethod,
    this.data,
    this.queryParameters = constants.defaultQueryParameters,
    this.headers = constants.defaultHeaders,
  });

  /// Takes in [route], [request], sets corresponding [RequestHandler],
  /// adds an instance of [RequestMatcher] in [history].
  @override
  void onRoute(
    Pattern route,
    RequestHandlerCallback requestHandlerCallback, {
    required Request request,
  }) {
    final requestData = request.data ?? data;
    Map<String, dynamic> requestHeaders = {...request.headers ?? headers};

    if (requestData != null) {
      requestHeaders.putIfAbsent(
        Headers.contentLengthHeader,
        () => Matchers.integer,
      );
    }

    request = Request(
      route: route,
      method: request.method ?? method,
      data: requestData,
      queryParameters: request.queryParameters ?? queryParameters,
      headers: requestHeaders,
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
    if (_isClosed) {
      throw ClosedException(
        'Cannot establish connection after [$runtimeType] got closed!',
      );
    }

    final response = mockResponse(requestOptions);

    // Throws DioError if response type is MockDioError.
    if (isMockDioError(response)) {
      throw response as DioError;
    }

    return response as MockResponseBody;
  }

  /// Closes the [DioAdapter] by force.
  @override
  void close({bool force = false}) => _isClosed = true;
}
