import 'package:http_mock_adapter/src/matchers/matcher.dart';

/// Subclass of [Matcher] that only returns true upon calling
/// [matches] if provided a [String].
class StringMatcher extends Matcher {
  const StringMatcher();

  @override
  bool matches(dynamic actual) => actual is String;

  @override
  String toString() => 'StringMatcher {}';
}
