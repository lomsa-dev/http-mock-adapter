import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

void main() {
  late Dio dio;
  late DioAdapterMockito dioAdapterMockito;

  Response<dynamic> response;

  setUpAll(() {
    dioAdapterMockito = DioAdapterMockito();
    dio = Dio()..httpClientAdapter = dioAdapterMockito;
  });

  group('DioAdapterMockito', () {
    test('mocks any request/response via fetch method', () async {
      final responsePayload = jsonEncode({'response_code': '200'});

      final responseBody = ResponseBody.fromString(
        responsePayload,
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );

      final expected = {'response_code': '200'};

      when(dioAdapterMockito.fetch(any, any, any)).thenAnswer(
        (_) async => responseBody,
      );

      response = await dio.get('/route');

      expect(expected, response.data);
    });
  });
}
