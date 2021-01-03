import 'package:http_mock_adapter/src/matchers/matcher.dart';

/// Subclass of [Matcher] that only returns true upon calling
/// [matches] if provided a [double] or pseudo [double] based on [strict].
class DecimalMatcher extends Matcher {
  /// [strict] affirms that the provided value for [matches] is a [double]
  /// or pseudo [double] (converted to [double] from [String]).
  final bool strict;

  const DecimalMatcher({this.strict = false});

  @override
  bool matches(dynamic actual) =>
      actual is double ||
      (!strict &&
          actual != null &&
          actual is String &&
          (double.tryParse(actual) is double));

  @override
  String toString() => 'DecimalMatcher { strict: $strict }';
}
