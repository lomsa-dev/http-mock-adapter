import 'package:http_mock_adapter/src/matchers/matcher.dart';

/// Subclass of [Matcher] that only returns true upon calling
/// [matches] if provided a [bool] or pseudo [bool] based on [strict].
class BooleanMatcher extends Matcher {
  /// [strict] affirms that the provided value for [matches] is a [bool]
  /// or pseudo [bool] (converted to [bool] from [String]).
  final bool strict;

  const BooleanMatcher({this.strict = false});

  @override
  bool matches(dynamic actual) =>
      actual is bool ||
      (!strict &&
          actual != null &&
          actual is String &&
          (actual.toLowerCase() == 'false' || actual.toLowerCase() == 'true'));

  @override
  String toString() => 'BooleanMatcher { strict: $strict }';
}
