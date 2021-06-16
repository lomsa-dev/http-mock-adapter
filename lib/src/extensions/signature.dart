import 'package:dio/dio.dart';
import 'package:http_mock_adapter/src/request.dart';
import 'package:http_mock_adapter/src/utils.dart';

/// [Signature] extension method adds [signature] getter to [RequestOptions]
/// in order to easily retrieve [Request]'s body representation as [String].
extension Signature on RequestOptions {
  /// [signature] is the [String] representation of the [RequestOptions]'s body.
  String get signature => buildRequestSignature(
        method,
        path,
        data,
        queryParameters,
        headers,
      );
}
