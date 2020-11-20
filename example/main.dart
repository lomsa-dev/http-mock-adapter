import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() async {
  final dio = Dio();
  final dioAdapter = DioAdapter();

  dio.httpClientAdapter = dioAdapter;

  const path = 'https://example.com';

  dioAdapter
      .onGet(path)
      .reply(200, {'message': 'Successfully mocked GET!'})
      .onPost(path)
      .reply(200, {'message': 'Successfully mocked POST!'});

  final onGetResponse = await dio.get(path);
  print(onGetResponse.data); // {message: Successfully mocked GET!}

  final onPostResponse = await dio.post(path);
  print(onPostResponse.data); // {message: Successfully mocked POST!}
}
