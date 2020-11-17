class DuplicatedException implements Exception {
  final dynamic message;

  DuplicatedException([this.message]);

  String toString() {
    if (message == null) return "Provide the message inside the exception";
    return "DuplicatedRouteException: $message";
  }
}
