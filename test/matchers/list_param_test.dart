import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:test/test.dart';

void main() {
  group('ListParamMatcher', () {
    test('matches empty value correctly', () {
      expect(
        Matchers.listParam(const ListParam<String>(
          [],
          ListFormat.pipes,
        )).matches(const ListParam<String>(
          [],
          ListFormat.pipes,
        )),
        true,
      );
      expect(
        Matchers.listParam(const ListParam<String>(
          [],
          ListFormat.pipes,
        )).matches(const ListParam<String>(
          [],
          ListFormat.csv,
        )),
        false,
      );
    });

    test('matches value correctly', () {
      expect(
        Matchers.listParam(const ListParam<String>(
          ['foo', 'bar'],
          ListFormat.pipes,
        )).matches(const ListParam<String>(
          ['foo', 'bar'],
          ListFormat.pipes,
        )),
        true,
      );
      expect(
        Matchers.listParam(const ListParam<String>(
          ['foo', 'bar'],
          ListFormat.pipes,
        )).matches(const ListParam<String>(
          ['foo', 'baz'],
          ListFormat.pipes,
        )),
        false,
      );
      expect(
        Matchers.listParam(const ListParam<String>(
          ['foo', 'bar'],
          ListFormat.pipes,
        )).matches(const ListParam<int>(
          [1, 2],
          ListFormat.pipes,
        )),
        false,
      );
    });

    test('converts to string as defined', () {
      const listParam = ListParam<String>(
        [],
        ListFormat.pipes,
      );

      expect(
        Matchers.listParam(listParam).toString(),
        'ListParamMatcher { values: ${listParam.value.length}, format ${listParam.format} }',
      );
    });
  });
}
