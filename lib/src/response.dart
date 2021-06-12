import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// Top level interface for [Dio]'s [ResponseBody] and also [Dio]'s [DioError].
/// This interface makes sure that we can save [DioError] and [ResponseBody]
/// inside the same list.
abstract class MockResponse {}

/// Wrapper of [Dio]'s [ResponseBody].
class MockResponseBody extends ResponseBody implements MockResponse {
  MockResponseBody(
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

  static MockResponseBody from(
    String text,
    int statusCode, {
    required Map<String, List<String>> headers,
    String? statusMessage,
    required bool isRedirect,
  }) =>
      MockResponseBody(
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
