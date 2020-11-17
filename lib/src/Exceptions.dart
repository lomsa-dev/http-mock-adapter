class DuplicatedException implements Exception {
  final dynamic message;

  DuplicatedException([this.message]);

  String toString() {
    if (message == null) return "Provide the message inside the exception";
    return "DuplicatedRouteException: $message";
  }
}

class RequestHandlerException implements Exception {
  final dynamic message;

  RequestHandlerException(
      [this.message =
          "Request handler should have genric type DioAdapter or MainInterceptor"]);

  String toString() {
    if (message == null) return "Provide the message inside the exception";
    return "DuplicatedRouteException: $message";
  }
}
