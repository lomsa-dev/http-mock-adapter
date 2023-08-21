import 'dart:io';
import 'dart:typed_data';

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

    group('reply', () {
      test('sets response data for a status with Uint8List', () async {
        const statusCode = HttpStatus.ok;
        final inputData = Uint8List.fromList([1, 2, 3, 4, 5]);

        requestHandler.reply(
          statusCode,
          inputData,
        );

        final statusHandler = requestHandler.mockResponse;

        expect(statusHandler, isNotNull);

        final mockResponseBody =
            await statusHandler(RequestOptions(path: '')) as MockResponseBody;
        final resolvedData = await BackgroundTransformer().transformResponse(
          RequestOptions(path: '', responseType: ResponseType.bytes),
          mockResponseBody,
        );

        expect(resolvedData, inputData);
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
            await statusHandler(RequestOptions(path: '')) as MockResponseBody;

        final resolvedData = await BackgroundTransformer().transformResponse(
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
            await statusHandler(RequestOptions(path: '')) as MockResponseBody;

        final resolvedData = await BackgroundTransformer()
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
            await statusHandler(RequestOptions(path: '')) as MockResponseBody;

        final resolvedData = await BackgroundTransformer().transformResponse(
          RequestOptions(path: ''),
          mockResponseBody,
        );

        expect(resolvedData, inputData);
        expect(mockResponseBody.headers, headers);
      });
    });

    group('replyCallback', () {
      test('sets response data MockDataCallback ', () async {
        const statusCode = HttpStatus.ok;
        var data = {'data': 'OK'};

        inputData(RequestOptions options) => data;

        requestHandler.replyCallback(statusCode, inputData);

        final statusHandler = requestHandler.mockResponse;

        expect(statusHandler, isNotNull);

        final mockResponseBody =
            await statusHandler(RequestOptions(path: '')) as MockResponseBody;

        final resolvedData = await BackgroundTransformer()
            .transformResponse(RequestOptions(path: ''), mockResponseBody);

        expect(resolvedData, data);
      });
    });
    group('replyCallbackAsync', () {
      test('sets response data MockDataCallbackAsync ', () async {
        const statusCode = HttpStatus.ok;
        var data = {'data': 'OK'};

        inputData(RequestOptions options) => Future.value(data);

        requestHandler.replyCallbackAsync(statusCode, inputData);

        final statusHandler = requestHandler.mockResponse;

        expect(statusHandler, isNotNull);

        final mockResponseBody =
            await statusHandler(RequestOptions(path: '')) as MockResponseBody;

        final resolvedData = await BackgroundTransformer()
            .transformResponse(RequestOptions(path: ''), mockResponseBody);

        expect(resolvedData, data);
      });
    });
    group('throws', () {
      test('sets DioException for a status code', () async {
        const statusCode = HttpStatus.badRequest;
        final dioError = DioException(
          requestOptions: RequestOptions(
            path: 'path',
          ),
          type: DioExceptionType.badResponse,
        );

        requestHandler.throws(
          statusCode,
          dioError,
        );

        final statusHandler = requestHandler.mockResponse;

        expect(statusHandler, isNotNull);

        final mockDioException =
            await statusHandler(RequestOptions(path: '')) as MockDioException;

        expect(mockDioException.type, dioError.type);
      });
    });
  });
}
