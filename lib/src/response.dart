import 'package:dio/dio.dart';
import 'package:http_mock_adapter/src/interfaces.dart';
import 'dart:typed_data';
import 'dart:convert';

/// wraper of  [Dio]'s ResponseBody
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

  static AdapterResponse from(
    String text,
    int statusCode, {
    Map<String, List<String>> headers,
    String statusMessage,
    bool isRedirect,
  }) {
    final stream = Stream.fromIterable(
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
