import 'package:http_mock_adapter/src/handlers/request_handler.dart';

/// Intended to keep track of request history.
class History {
  /// The count of request invokations.
  int _invokeCount = 0;

  /// The history content containing [RequestMatcher] objects.
  List<RequestMatcher> data = [];

  /// Gets current [RequestMatcher].
  RequestMatcher get current => data[_invokeCount];

  /// Advances the request history by incrementing incokation count.
  void advance() => _invokeCount++;
}

/// An ability that lets a construct to have a [History] instance.
mixin Tracking {
  final History history = History();
}
