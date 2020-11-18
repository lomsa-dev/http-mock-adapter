/// [RequestHandlerException] is thrown when, Request Handler method
/// is called with genreic type paramter.
/// available types are: [DioInterceptor] and [DioAdapter]
class RequestHandlerException implements Exception {
  final dynamic message;

  RequestHandlerException(
      [this.message =
          "Request handler should have genric type DioAdapter or MainInterceptor"]);

  String toString() {
    if (message == null) return "Provide the message inside the exception";
    return "RequestHandlerException: $message";
  }
}
