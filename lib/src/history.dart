import 'package:dio/dio.dart';
import 'package:http_mock_adapter/src/handlers/request_handler.dart';

import 'request.dart';

/// Intended to keep track of request history.
class History {
  /// The index of request invocations.
  int _requestInvocationIndex;

  RequestMatcher requestMatcher;

  /// The history content containing [RequestMatcher] objects.
  List<RequestMatcher> data = [];

  /// Gets current [RequestMatcher].
  RequestMatcher get current => data[_requestInvocationIndex];

  /// Getter for the current request invocation's intended [response].
  ResponseBody Function(String route, String method) get response =>
      (route, method) {
        final signature = '$route/$method';

        data.forEach((element) {
          if (signature == '${element.route}/${element.request.method.value}') {
            _requestInvocationIndex = data.indexOf(element);

            current.response =
                requestHandler.requestMap[requestHandler.statusCode];
          }
        });

        final response = current.response;

        return response;
      };

  /// Getter for the current request invocation's [RequestHandler].
  RequestHandler get requestHandler => current.requestHandler;
}

/// An ability that lets a construct to have a [History] instance.
mixin Tracked {
  final history = History();
}
