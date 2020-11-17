import 'package:http/src/base_response.dart';
import 'package:http/src/base_request.dart';
import 'package:http/src/streamed_response.dart';
import 'dart:convert';

class Response implements BaseResponse {
  @override
  final BaseRequest request;

  @override
  final int statusCode;

  @override
  final String reasonPhrase;

  @override
  final int contentLength;

  @override
  final Map<String, String> headers;

  @override
  final bool isRedirect;

  @override
  final bool persistentConnection;

  final dynamic body;

  Response(
    this.statusCode,
    this.body, {
    this.request,
    this.headers = const {},
    this.isRedirect = false,
    this.persistentConnection = true,
    this.reasonPhrase,
    this.contentLength,
  });

  @override
  String toString() {
    return body.toString();
  }
}

class PureHttpResponse {
  final BaseRequest request;
  final int statusCode;
  final String reasonPhrase;
  final int contentLength;
  final Map<String, String> headers;
  final bool isRedirect;
  final bool persistentConnection;
  final dynamic body;
  final String onMethod;

  PureHttpResponse(this.statusCode, this.body, this.onMethod,
      {this.reasonPhrase,
      this.contentLength,
      this.isRedirect,
      this.persistentConnection,
      this.headers,
      this.request})
      : assert(statusCode != null),
        assert(body != null);

  StreamedResponse buildResponse() {
    Stream<List<int>> streamedBody = Stream.value(utf8.encode(this.body));
    return StreamedResponse(
      streamedBody,
      this.statusCode,
      request: this.request,
      headers: this.headers,
      contentLength: this.contentLength,
      isRedirect: this.isRedirect,
      persistentConnection: this.persistentConnection,
    );
  }
}
