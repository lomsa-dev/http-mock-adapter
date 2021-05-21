import 'package:http_mock_adapter/src/matchers/matcher.dart';

/// Subclass of [Matcher] that always returns true when calling [matches].
class IsAMatcher<T> extends Matcher {
  const IsAMatcher();

  @override
  bool matches(dynamic actual) => actual is T;

  @override
  String toString() => 'IsAMatcher<$T>';
}
