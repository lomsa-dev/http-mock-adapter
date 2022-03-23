import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:test/test.dart';

void main() async {
  late Dio dio;
  late DioAdapter dioAdapter;

  Response<dynamic> response;

  group('Accounts', () {
    const baseUrl = 'https://example.com';

    const userCredentials = <String, dynamic>{
      'email': 'test@example.com',
      'password': 'password',
    };

    setUp(() {
      dio = Dio(BaseOptions(baseUrl: baseUrl));
      dioAdapter = DioAdapter(dio: dio);
    });

    test('signs up user', () async {
      const route = '/signup';

      dioAdapter.onPost(
        route,
        (server) => server.reply(
          201,
          null,
          // Adds one-sec delay to reply method.
          // Basically, I'd wait for one second before returning reply data.
          // See -> issue:[106] & pr:[126]
          delay: const Duration(seconds: 1),
        ),
        data: userCredentials,
      );

      // Returns a response with 201 Created success status response code.
      response = await dio.post(route, data: userCredentials);

      expect(response.statusCode, 201);
    });

    test('signs in user and fetches account information', () async {
      const signInRoute = '/signin';
      const accountRoute = '/account';

      const accessToken = <String, dynamic>{
        'token': 'ACCESS_TOKEN',
      };

      final headers = <String, dynamic>{
        'Authentication': 'Bearer $accessToken',
      };

      const userInformation = <String, dynamic>{
        'id': 1,
        'email': 'test@example.com',
        'password': 'password',
        'email_verified': false,
      };

      dioAdapter
        ..onPost(
          signInRoute,
          (server) => server.throws(
            401,
            DioError(
              requestOptions: RequestOptions(
                path: signInRoute,
              ),
            ),
          ),
        )
        ..onPost(
          signInRoute,
          (server) => server.reply(200, accessToken),
          data: userCredentials,
        )
        ..onGet(
          accountRoute,
          (server) => server.reply(200, userInformation),
          headers: headers,
        );

      // Throws without user credentials.
      expect(
        () async => await dio.post(signInRoute),
        throwsA(isA<DioError>()),
      );

      // Returns an access token if user credentials are provided.
      response = await dio.post(signInRoute, data: userCredentials);

      expect(response.data, accessToken);

      // Returns user information if an access token is provided in headers.
      response = await dio.get(
        accountRoute,
        options: Options(headers: headers),
      );

      expect(response.data, userInformation);
    });
  });
}
