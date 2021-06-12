import 'package:http_mock_adapter/src/matchers/matcher.dart';

/// Subclass of [Matcher] that only returns true upon calling
/// [matches] if provided with a instance having the same type [T].
class IsAMatcher<T> extends Matcher {
  const IsAMatcher();

  @override
  bool matches(dynamic actual) => actual is T;

  @override
  String toString() => 'IsAMatcher<$T> {}';
}
