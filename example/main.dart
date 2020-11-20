import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  // How to mock with DioAdapter
  group('DioAdapter usage', () {
    // Creating dio instance for mocking.
    // For instance: you can use your own instance from injection and replace
    // dio.httpClientAdapter with mocker DioAdapter
    final dio = Dio();
    final dioAdapter = DioAdapter();

    dio.httpClientAdapter = dioAdapter;

    const path = 'https://example.com';

    test('Expects Dioadapter to mock the data', () async {
      dioAdapter
          .onGet(path)
          .reply(200,
              {'message': 'Successfully mocked GET!'}) // only use double quotes
          .onPost(path)
          .reply(200, {'message': 'Successfully mocked POST!'});
      final getResponse = await dio.get(path);

      // Making dio.get request on the path an expecting mocked response
      expect(jsonEncode({'message': 'Successfully mocked GET!'}),
          getResponse.data);

      // Making dio.post request on the path an expecting mocked response
      final postResposne = await dio.post(path);
      expect(jsonEncode({'message': 'Successfully mocked POST!'}),
          postResposne.data);
    });
  });

  // Alternatively, for mocking requests, you can use dio Interceptor
  group('DioAdapter usage', () {
    // Creating dio instance for mocking.
    // For instance: you can use your own instance from injection and add
    // DioInterceptor in dio.interceptors list
    final dioForInterceptor = Dio();
    final dioInterceptor =
        DioInterceptor(); // creating DioInterceptor instance for mocking requests

    dioForInterceptor.interceptors.add(dioInterceptor);

    const path = 'https://example2.com';

    test('Expects Dioadapter to mock the data', () async {
      // Defining request types and their responses respectively with their paths
      dioInterceptor
          .onDelete(path)
          .reply(200,
              {'message': 'Successfully mocked GET!'}) // only use double quotes
          .onPatch(path)
          .reply(200, {'message': 'Successfully mocked POST!'});

      // Making dio.delete request on the path an expecting mocked response
      final getResponse = await dioForInterceptor.delete(path);
      expect(jsonEncode({'message': 'Successfully mocked GET!'}),
          getResponse.data);

      // Making dio.patch request on the path an expecting mocked response
      final postResposne = await dioForInterceptor.patch(path);
      expect(jsonEncode({'message': 'Successfully mocked POST!'}),
          postResposne.data);
    });
  });
}
