import 'package:http_mock_adapter/src/handlers/request_handler.dart';

import 'request.dart';

/// Intended to keep track of request history.
class History {
  /// The count of request invocations.
  int _requestInvocationCount = 0;

  /// The history content containing [RequestMatcher] objects.
  List<RequestMatcher> data = [];

  /// Gets current [RequestMatcher].
  RequestMatcher get current => data[_requestInvocationCount];

  /// Getter for the current request invocation's intended [response].
  dynamic get response => () {
        current.response = requestHandler.requestMap[requestHandler.statusCode];

        final response = current.response.toString();

        _advance();

        return response;
      }();

  /// Getter for the current request invocation's [RequestHandler].
  RequestHandler get requestHandler => current.requestHandler;

  /// Advances the request history by incrementing request invocation count.
  void _advance() => _requestInvocationCount++;
}

/// An ability that lets a construct to have a [History] instance.
mixin Tracked {
  final history = History();
}
