import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// Top level interface for [Dio]'s [ResponseBody] and also [Dio]'s [DioError].
/// This interface makes sure that we can save [DioError] and [ResponseBody]
/// inside the same list.
abstract class MockResponse {
  /// Delays this response by the given duration.
  Duration? get delay;
}

/// Wrapper of [Dio]'s [ResponseBody].
class MockResponseBody extends ResponseBody implements MockResponse {
  @override
  final Duration? delay;

  MockResponseBody(
    Stream<Uint8List> stream,
    int statusCode, {
    required Map<String, List<String>> headers,
    String? statusMessage,
    required bool isRedirect,
    List<RedirectRecord>? redirects,
    this.delay,
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
    Duration? delay,
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
        delay: delay,
      );
}
