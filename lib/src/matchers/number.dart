import 'package:http_mock_adapter/src/matchers/matcher.dart';

/// Subclass of [Matcher] that only returns true upon calling [matches]
/// if provided a numeric value or pseudo numeric value based on [strict].
class NumberMatcher extends Matcher {
  /// [strict] affirms that the provided value for [matches] is numeric
  /// or pseudo numeric (converted to [int] or [double] from [String]).
  final bool strict;

  const NumberMatcher({this.strict = false});

  @override
  bool matches(dynamic actual) =>
      actual is int ||
      actual is double ||
      (!strict &&
          actual != null &&
          actual is String &&
          (int.tryParse(actual) is int || double.tryParse(actual) is double));

  @override
  String toString() => 'NumberMatcher { strict: $strict }';
}
