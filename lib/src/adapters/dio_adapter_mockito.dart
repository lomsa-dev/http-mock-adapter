// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http_mock_adapter/src/adapters/dio_adapter.dart';
import 'package:http_mock_adapter/src/request.dart';
import 'package:http_mock_adapter/src/types.dart';
import 'package:mockito/mockito.dart';

/// [Mock]ed version of [DioAdapter].
class DioAdapterMockito extends Mock implements DioAdapter {
  @override
  Future<void> onRoute(
    dynamic route,
    RequestHandlerCallback callback, {
    Request request = const Request(),
    Duration delay = Duration.zero,
  }) async =>
      super.noSuchMethod(Invocation.method(#onRoute, [
        route,
        request,
        callback,
      ]));

  @override
  Future<ResponseBody> fetch(
    RequestOptions? options,
    Stream<List<int>>? requestStream,
    Future? cancelFuture,
  ) async =>
      super.noSuchMethod(
          Invocation.method(#fetch, [
            options,
            requestStream,
            cancelFuture,
          ]),
          returnValue: Future.value(ResponseBody(
            Stream.value(Uint8List(1)),
            0,
          )));

  @override
  void close({bool? force = false}) => super.noSuchMethod(
        Invocation.method(#close, [force]),
      );
}

