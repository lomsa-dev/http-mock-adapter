import 'package:http_mock_adapter/src/matchers/matcher.dart';

/// Subclass of [Matcher] that always returns true when calling [matches].
class Any extends Matcher {
  const Any();

  @override
  bool matches(dynamic actual) => true;

  @override
  String toString() => 'Any';
}

const anyValue = Any();
