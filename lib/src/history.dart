import 'package:http_mock_adapter/src/request_handler.dart';

class History {
  int _invokeCount = 0;
  List<RequestMatcher> data = [];

  RequestMatcher get current => data[_invokeCount];

  void advance() => _invokeCount++;
}

mixin Tracking {
  final History history = History();
}
