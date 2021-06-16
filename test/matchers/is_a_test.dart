import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:test/test.dart';

void main() {
  group('IsAMatcher', () {
    test('matches correctly', () {
      expect(Matchers.isA<String>().matches('a'), true);
      expect(Matchers.isA<String>().matches(3), false);
      expect(Matchers.isA<Map<String, int>>().matches(<String, int>{}), true);
      expect(Matchers.isA<Map<String, int>>().matches({'foo': 2}), true);
      expect(Matchers.isA<Map<String, int>>().matches({'foo': 'bar'}), false);
      expect(Matchers.isA<FormData>().matches(FormData()), true);
      expect(Matchers.isA<FormData>().matches('foo'), false);
    });

    test('converts to string as defined', () {
      expect(
        Matchers.isA<String>().toString(),
        'IsAMatcher<$String> {}',
      );
    });
  });
}
