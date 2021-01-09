import 'package:http_mock_adapter/src/matchers/matcher.dart';

/// Subclass of [Matcher] that only returns true upon calling
/// [matches] if provided an [int] or pseudo [int] based on [strict].
class IntegerMatcher extends Matcher {
  /// [strict] affirms that the provided value for [matches] is an [int]
  /// or pseudo [int] (converted to [int] from [String]).
  final bool strict;

  const IntegerMatcher({this.strict = false});

  @override
  bool matches(dynamic actual) =>
      actual is int ||
      (!strict &&
          actual != null &&
          actual is String &&
          (int.tryParse(actual) is int));

  @override
  String toString() => 'IntegerMatcher { strict: $strict }';
}
