import 'package:dio/dio.dart';
import 'package:http_mock_adapter/src/request.dart';

const defaultRequestMethod = RequestMethods.get;
const defaultQueryParameters = <String, dynamic>{};
const defaultHeaders = <String, dynamic>{
  Headers.contentTypeHeader: Headers.jsonContentType,
};
