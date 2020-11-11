import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  test('initial test', () async {
    final dio = Dio();
    final dioAdapter = DioAdapter();

    dioAdapter
        .onRoute('https://example.com')
        .reply(200, {'message': 'Success!'});

    dio.httpClientAdapter = dioAdapter;

    final response = await dio.get('https://example.com');

    expect(jsonEncode({'message': 'Success!'}).toString(), response.data);
  });
}
