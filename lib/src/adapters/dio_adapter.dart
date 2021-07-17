import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
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

  /// These should be the same [BaseOptions] that are configured for [Dio].
  final BaseOptions baseOptions;

  DioAdapter({
    required this.baseOptions,
  });

  /// Simple helper function to create an adapter
  /// and configure it correctly with an existing [Dio] instance.
  factory DioAdapter.configure({required Dio dio}) {
    final adapter = DioAdapter(baseOptions: dio.options);
    dio.httpClientAdapter = adapter;
    return adapter;
  }

  /// Takes in [route], [request], sets corresponding [RequestHandler],
  /// adds an instance of [RequestMatcher] in [history].
  @override
  void onRoute(
    Pattern route,
    MockServerCallback requestHandlerCallback, {
    required Request request,
  }) {
    final requestData = request.data;
    final requestMethod =
        request.method ?? RequestMethods.forName(name: baseOptions.method);

    Map<String, dynamic> requestHeaders = {...request.headers ?? {}};

    if (requestMethod.isAllowedPayloadMethod ||
        baseOptions.setRequestContentTypeWhenNoPayload) {
      requestHeaders.putIfAbsent(
        Headers.contentTypeHeader,
        () => Headers.jsonContentType,
      );
    }

    if (requestMethod.isAllowedPayloadMethod && requestData != null) {
      requestHeaders.putIfAbsent(
        Headers.contentLengthHeader,
        () => Matchers.integer,
      );
    }

    request = Request(
      route: route,
      method:
          request.method ?? RequestMethods.forName(name: baseOptions.method),
      data: requestData,
      queryParameters: request.queryParameters ?? baseOptions.queryParameters,
      headers: requestHeaders,
    );

    final matcher = RequestMatcher(request);
    requestHandlerCallback(matcher);
    history.add(matcher);
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
