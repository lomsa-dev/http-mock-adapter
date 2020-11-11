import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:http_mock_adapter/src/constants.dart';
import 'package:http_mock_adapter/src/mock_provider.dart';
import 'package:http_mock_adapter/src/request_handler.dart';
import 'package:http_mock_adapter/src/utils.dart';

import 'history.dart';

class DioAdapter extends HttpClientAdapter with MockProvider, Tracking {
  DefaultHttpClientAdapter _adapter = DefaultHttpClientAdapter();

  Map<RequestMethod, Map<String, RequestHandler>> _requestHandlers =
      Map.fromIterable(
    RequestMethod.values,
    key: (element) => element,
    value: (element) => {},
  );

  RequestHandler onRoute(String route, {Request request = const Request()}) {
    _requestHandlers[request.method][route] = RequestHandler(route);

    final requestHandler = _requestHandlers[request.method][route];

    history.data.add(RequestMatcher(request, requestHandler));

    return requestHandler;
  }

  @override
  Future<ResponseBody> fetch(RequestOptions options,
      Stream<List<int>> requestStream, Future cancelFuture) async {
    final mockFileName = getMockFileName(options.uri.path);

    final filePath = '${options.method}$mockFileName.json';
    final fullPath = '$rootDirectoryPath/$mockDirectoryPath/$filePath';

    return await File(fullPath).exists().then((bool exists) {
      if (exists) {
        history.advance();

        return readMock(fullPath);
      } else {
        return createMock(
          fullPath,
          history.current.requestHandler
              .requestMap[history.current.requestHandler.statusCode],
        );
      }
    });
  }

  @override
  void close({bool force = false}) => _adapter.close(force: force);
}
