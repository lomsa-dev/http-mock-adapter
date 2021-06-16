import 'package:dio/dio.dart';
// ignore: implementation_imports
import 'package:dio/src/parameter.dart' show ListParam;
import 'package:http_mock_adapter/src/matchers/any.dart';
import 'package:http_mock_adapter/src/matchers/boolean.dart';
import 'package:http_mock_adapter/src/matchers/decimal.dart';
import 'package:http_mock_adapter/src/matchers/form_data.dart';
import 'package:http_mock_adapter/src/matchers/integer.dart';
import 'package:http_mock_adapter/src/matchers/is_a.dart';
import 'package:http_mock_adapter/src/matchers/list_param.dart';
import 'package:http_mock_adapter/src/matchers/matcher.dart';
import 'package:http_mock_adapter/src/matchers/number.dart';
import 'package:http_mock_adapter/src/matchers/regexp.dart';
import 'package:http_mock_adapter/src/matchers/string.dart';

export 'package:http_mock_adapter/src/matchers/matcher.dart';
export 'package:http_mock_adapter/src/matchers/matchers.dart' show Matchers;

/// [Matchers] is an interface for various [Matcher] types.
abstract class Matchers {
  /// [any] matches any typed value.
  static const AnyMatcher any = AnyMatcher();

  /// [isA] matches any value of type [T].
  static IsAMatcher<T> isA<T>() => IsAMatcher<T>();

  /// [boolean] matches any [bool] alike value.
  static const BooleanMatcher boolean = BooleanMatcher(strict: false);

  /// [integer] matches any [int] alike value.
  static const IntegerMatcher integer = IntegerMatcher(strict: false);

  /// [decimal] matches any [double] alike value.
  static const DecimalMatcher decimal = DecimalMatcher(strict: false);

  /// [number] matches any [int] alike or [double] alike value.
  static const NumberMatcher number = NumberMatcher(strict: false);

  /// [string] matches any [String] value.
  static const StringMatcher string = StringMatcher();

  /// [strict] is an accessor used to expose strict [Matcher] types
  /// that only match by pure, unprocessed value.
  static const StrictMatchers strict = StrictMatchers();

  /// [pattern] matches value by utilizing [RegExp] through building it via
  /// [String] typed pattern, [multiLine] and [caseSensitive].
  /// It is mainly used as a shorthand for matching via [RegExp].
  static RegExpMatcher pattern(
    String pattern, {
    bool? multiLine,
    bool? caseSensitive,
  }) =>
      RegExpMatcher(
        pattern: pattern,
        multiLine: multiLine ?? false,
        caseSensitive: caseSensitive ?? false,
      );

  /// [regExp] matches value by utilizing [RegExp] through building it via
  /// [RegExp] typed regular expression.
  static RegExpMatcher regExp(RegExp regExp) => RegExpMatcher(regExp: regExp);

  /// [formData] matches against the expected [FormData]
  /// by comparing filename, contentType and length.
  ///
  /// Does NOT compare file contents.
  static FormDataMatcher formData(FormData expected) => FormDataMatcher(
        expected: expected,
      );

  /// [listParam] matches against the expected [ListParam]
  /// by comparing values and [ListFormat].
  static ListParamMatcher<T> listParam<T>(ListParam<T> expected) =>
      ListParamMatcher(
        expected: expected,
      );
}

/// [StrictMatchers] is an interface for various strict [Matcher] types.
class StrictMatchers {
  /// [boolean] matches any pure [bool] value.
  final BooleanMatcher boolean = const BooleanMatcher(strict: true);

  /// [integer] matches any pure [int] value.
  final IntegerMatcher integer = const IntegerMatcher(strict: true);

  /// [decimal] matches any pure [double] value.
  final DecimalMatcher decimal = const DecimalMatcher(strict: true);

  /// [number] matches any pure [int] or [double] value.
  final NumberMatcher number = const NumberMatcher(strict: true);

  const StrictMatchers();
}
