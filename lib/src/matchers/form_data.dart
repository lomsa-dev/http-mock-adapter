import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:http_mock_adapter/src/matchers/matcher.dart';
import 'package:http_parser/http_parser.dart';

/// Matches [FormData] instance by comparing
/// filename, contentType and length.
///
/// Does NOT compare file contents.
class FormDataMatcher extends Matcher {
  final FormData expected;

  const FormDataMatcher({required this.expected});

  @override
  bool matches(dynamic actual) =>
      actual is FormData &&
      const MapEquality<String, String>().equals(
        Map.fromEntries(expected.fields),
        Map.fromEntries(actual.fields),
      ) &&
      MapEquality<String, MultipartFile>(
        values: MultiEquality([
          EqualityBy<MultipartFile, String?>((file) => file.filename),
          EqualityBy<MultipartFile, MediaType?>((file) => file.contentType),
          EqualityBy<MultipartFile, int?>((file) => file.length),
        ]),
      ).equals(
        Map.fromEntries(expected.files),
        Map.fromEntries(actual.files),
      );

  @override
  String toString() =>
      'FormDataMatcher { fields: ${expected.fields.length}, files ${expected.files.length} }';
}
