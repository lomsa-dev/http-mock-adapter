import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
// ignore: implementation_imports
import 'package:dio/src/parameter.dart' show ListParam;
import 'package:http_mock_adapter/src/matchers/matcher.dart';

/// Matches [ListParam] instance by comparing
/// value and [ListFormat].
class ListParamMatcher<T> extends Matcher {
  final ListParam<T> expected;

  const ListParamMatcher({required this.expected});

  @override
  bool matches(dynamic actual) {
    return actual is ListParam<T> &&
        ListEquality<T>().equals(
          actual.value,
          expected.value,
        ) &&
        actual.format == expected.format;
  }

  @override
  String toString() =>
      'ListParamMatcher { values: ${expected.value.length}, format ${expected.format} }';
}
