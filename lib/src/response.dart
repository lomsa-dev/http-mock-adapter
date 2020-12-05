import 'package:dio/dio.dart';
import 'package:http_mock_adapter/src/adapter_interface.dart';
import 'dart:typed_data';
import 'dart:convert';

class AdapterResponse extends ResponseBody implements Responsable {
  AdapterResponse(
    Stream<Uint8List> stream,
    int statusCode, {
    Map<String, List<String>> headers,
    String statusMessage,
    bool isRedirect,
    List<RedirectRecord> redirects,
  }) : super(
          stream,
          statusCode,
          headers: headers,
          statusMessage: statusMessage,
          isRedirect: isRedirect,
          redirects: redirects,
        );

  factory AdapterResponse.fromString(
    String text,
    int statusCode, {
    Map<String, List<String>> headers,
    String statusMessage,
    bool isRedirect,
  }) {
    Stream<Uint8List> stream = Stream.fromIterable(
        utf8.encode(text).map((e) => Uint8List.fromList([e])).toList());
    return AdapterResponse(
      stream,
      statusCode,
      headers: headers,
      statusMessage: statusMessage,
      isRedirect: isRedirect,
    );
  }
}
