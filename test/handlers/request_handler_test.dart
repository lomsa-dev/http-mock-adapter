import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_mock_adapter/src/exceptions.dart';
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

      expect(requestHandler.statusCode, statusCode);
      final statusHandler = requestHandler.requestMap[statusCode];
      expect(statusHandler, isNotNull);
      final adapterResponse = statusHandler!() as AdapterResponse;
      final resolvedData = await DefaultTransformer().transformResponse(
        RequestOptions(path: ''),
        adapterResponse,
      );
      expect(resolvedData, inputData);
      expect(
        adapterResponse.headers,
        {
          Headers.contentTypeHeader: [
            Headers.jsonContentType,
          ],
        },
      );
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

      expect(requestHandler.statusCode, statusCode);
      final statusHandler = requestHandler.requestMap[statusCode];
      expect(statusHandler, isNotNull);
      final adapterResponse = statusHandler!() as AdapterResponse;
      final resolvedData = await DefaultTransformer().transformResponse(
        RequestOptions(path: ''),
        adapterResponse,
      );
      expect(resolvedData, inputData);
      expect(adapterResponse.headers, headers);
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

      expect(requestHandler.statusCode, statusCode);
      final statusHandler = requestHandler.requestMap[statusCode];
      expect(statusHandler, isNotNull);
      final adapterError = statusHandler!() as AdapterError;
      expect(adapterError.type, dioError.type);
    });
  });
}
