import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http_mock_adapter/src/interfaces.dart';

/// Wrapper of [Dio]'s [ResponseBody].
class AdapterResponse extends ResponseBody implements Responsable {
  AdapterResponse(
    Stream<Uint8List> stream,
    int statusCode, {
    required Map<String, List<String>> headers,
    String? statusMessage,
    required bool isRedirect,
    List<RedirectRecord>? redirects,
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
    required Map<String, List<String>> headers,
    String? statusMessage,
    required bool isRedirect,
  }) =>
      AdapterResponse(
        Stream.fromIterable(
          utf8
              .encode(text)
              .map((elements) => Uint8List.fromList([elements]))
              .toList(),
        ),
        statusCode,
        headers: headers,
        statusMessage: statusMessage,
        isRedirect: isRedirect,
      );
}
