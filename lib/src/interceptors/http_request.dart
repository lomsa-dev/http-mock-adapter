import 'package:http/src/base_request.dart';
import 'package:http/src/byte_stream.dart';
import 'package:http/src/streamed_response.dart';

class Request implements BaseRequest {
  @override
  int contentLength;

  @override
  bool followRedirects;

  @override
  int maxRedirects;

  @override
  bool persistentConnection;

  @override
  bool finalized;

  @override
  Map<String, String> headers;

  @override
  final String method;

  @override
  final Uri url;

  Request(this.url, this.method);

  @override
  ByteStream finalize() {
    return null;
  }

  @override
  Future<StreamedResponse> send() {
    return null;
  }
}
