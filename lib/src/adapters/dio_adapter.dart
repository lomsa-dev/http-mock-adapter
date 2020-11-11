import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:http_mock_adapter/src/constants.dart';
import 'package:http_mock_adapter/src/handlers/mock_handler.dart';
import 'package:http_mock_adapter/src/handlers/request_handler.dart';
import 'package:http_mock_adapter/src/utils.dart';

import '../history.dart';

/// [HttpClientAdapter] extension with data mocking and tracking functionality.
class DioAdapter extends HttpClientAdapter with Tracking {
  /// [Dio]`s default HTTP client adapter implementation.
  DefaultHttpClientAdapter _adapter = DefaultHttpClientAdapter();

  /// [MockHandler] abstracts away the functionality necessary to handle
  /// client requests.
  final _mockHandler = MockHandler();

  /// Map of <[RequestMethod], <(String) [RequestMethod], [RequestHandler]>>.
  Map<RequestMethod, Map<String, RequestHandler>> _requestHandlers =
      Map.fromIterable(
    RequestMethod.values,
    key: (element) => element,
    value: (element) => {},
  );

  /// Takes in route, request, and sets corresponding [RequestHandler].
  RequestHandler onRoute(String route, {Request request = const Request()}) {
    _requestHandlers[request.method][route] = RequestHandler(route);

    final requestHandler = _requestHandlers[request.method][route];

    history.data.add(RequestMatcher(request, requestHandler));

    return requestHandler;
  }

  /// [DioAdapter]`s custom configuration intended to work with mock data.
  @override
  Future<ResponseBody> fetch(RequestOptions options,
      Stream<List<int>> requestStream, Future cancelFuture) async {
    final mockFileName = getMockFileName(options.uri.path);

    final filePath = '${options.method}$mockFileName.json';
    final fullPath = '$rootDirectoryPath/$mockDirectoryPath/$filePath';

    return await File(fullPath).exists().then((bool exists) {
      if (exists) {
        history.advance();

        return _mockHandler.readMock(fullPath);
      } else {
        return _mockHandler.createMock(
          fullPath,
          history.current.requestHandler
              .requestMap[history.current.requestHandler.statusCode],
        );
      }
    });
  }

  /// Closes the [DioAdapter] by force.
  @override
  void close({bool force = false}) => _adapter.close(force: force);
}
