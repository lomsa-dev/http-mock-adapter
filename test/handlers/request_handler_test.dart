import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:http_mock_adapter/src/handlers/request_handler.dart';
import 'package:http_mock_adapter/src/response.dart';
import 'package:test/test.dart';

void main() {
  group('RequestHandler', () {
    late RequestHandler requestHandler;

    setUp(() {
      requestHandler = RequestHandler();
    });

    test('sets response data for a status with JSON by default', () async {
      const statusCode = HttpStatus.ok;
      const inputData = {'data': 'OK'};

      requestHandler.reply(
        statusCode,
        inputData,
      );

      final statusHandler = requestHandler.mockResponse;

      expect(statusHandler, isNotNull);

      final mockResponseBody =
          statusHandler(RequestOptions(path: '')) as MockResponseBody;

      final resolvedData = await DefaultTransformer().transformResponse(
        RequestOptions(path: ''),
        mockResponseBody,
      );

      expect(resolvedData, inputData);
      expect(
        mockResponseBody.headers,
        {
          Headers.contentTypeHeader: [
            Headers.jsonContentType,
          ],
        },
      );
    });

    test('sets response data MockDataCallback ', () async {
      const statusCode = HttpStatus.ok;
      var data = {'data': 'OK'};

      inputData(RequestOptions options) => data;

      requestHandler.reply(statusCode, inputData);

      final statusHandler = requestHandler.mockResponse;

      expect(statusHandler, isNotNull);

      final mockResponseBody =
          statusHandler(RequestOptions(path: '')) as MockResponseBody;

      final resolvedData = await DefaultTransformer()
          .transformResponse(RequestOptions(path: ''), mockResponseBody);

      expect(resolvedData, data);
    });

    test(
        'sets response data for a status without JSON if content type header is set',
        () async {
      const statusCode = HttpStatus.created;
      const inputData = 'Plain text response';
      const headers = {
        Headers.contentTypeHeader: [
          Headers.textPlainContentType,
        ],
      };

      requestHandler.reply(
        statusCode,
        inputData,
        headers: headers,
      );

      final statusHandler = requestHandler.mockResponse;

      expect(statusHandler, isNotNull);

      final mockResponseBody =
          statusHandler(RequestOptions(path: '')) as MockResponseBody;

      final resolvedData = await DefaultTransformer().transformResponse(
        RequestOptions(path: ''),
        mockResponseBody,
      );

      expect(resolvedData, inputData);
      expect(mockResponseBody.headers, headers);
    });

    test('sets DioError for a status code', () async {
      const statusCode = HttpStatus.badRequest;
      final dioError = DioError(
        requestOptions: RequestOptions(
          path: 'path',
        ),
        type: DioErrorType.response,
      );

      requestHandler.throws(
        statusCode,
        dioError,
      );

      final statusHandler = requestHandler.mockResponse;

      expect(statusHandler, isNotNull);

      final mockDioError =
          statusHandler(RequestOptions(path: '')) as MockDioError;

      expect(mockDioError.type, dioError.type);
    });
  });
}
