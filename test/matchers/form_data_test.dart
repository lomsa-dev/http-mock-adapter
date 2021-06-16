import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:http_parser/http_parser.dart';
import 'package:test/test.dart';

void main() {
  group('FormDataMatcher', () {
    test('matches empty', () {
      expect(Matchers.formData(FormData()).matches(FormData()), true);
    });

    test('matches fields correctly', () {
      expect(
        Matchers.formData(FormData.fromMap({
          'foo': 'bar',
          'bar': 2,
        })).matches(FormData.fromMap({
          'foo': 'bar',
          'bar': 2,
        })),
        true,
      );
      expect(
        Matchers.formData(FormData.fromMap({
          'foo': 'bar',
          'bar': 'foo',
        })).matches(FormData.fromMap({
          'foo': 'foo',
          'bar': 3,
        })),
        false,
      );
    });

    test('matches files correctly', () {
      expect(
        Matchers.formData(FormData.fromMap({
          'file': MultipartFile.fromBytes([0, 1, 2], filename: 'test.txt'),
        })).matches(FormData.fromMap({
          'file': MultipartFile.fromBytes([0, 1, 2], filename: 'test.txt'),
        })),
        true,
      );
      expect(
        Matchers.formData(FormData.fromMap({
          'file': MultipartFile.fromBytes([0, 1, 2], filename: 'test.txt'),
        })).matches(FormData.fromMap({
          'file': MultipartFile.fromBytes([0, 1, 2], filename: 'test.png'),
        })),
        false,
      );
      expect(
        Matchers.formData(FormData.fromMap({
          'file': MultipartFile.fromBytes([0, 1, 2], filename: 'test.txt'),
        })).matches(FormData.fromMap({
          'file1': MultipartFile.fromBytes([0, 1, 2], filename: 'test.txt'),
        })),
        false,
      );
      expect(
        Matchers.formData(FormData.fromMap({
          'file': MultipartFile.fromBytes(
            [0, 1, 2],
            filename: 'test.png',
            contentType: MediaType.parse('image/png'),
          ),
        })).matches(FormData.fromMap({
          'file': MultipartFile.fromBytes(
            [0, 1, 2],
            filename: 'test.png',
            contentType: MediaType.parse('image/png'),
          ),
        })),
        true,
      );
      expect(
        Matchers.formData(FormData.fromMap({
          'file': MultipartFile.fromBytes(
            [0, 1, 2],
            filename: 'test.png',
            contentType: MediaType.parse('image/png'),
          ),
        })).matches(FormData.fromMap({
          'file': MultipartFile.fromBytes(
            [0, 1, 2, 3],
            filename: 'test.ppg',
            contentType: MediaType.parse('image/jpeg'),
          ),
        })),
        false,
      );
    });

    test('matches complex correctly', () {
      expect(
        Matchers.formData(FormData.fromMap({
          'foo': 'bar',
          'bar': 2,
          'file': MultipartFile.fromBytes([0, 1, 2], filename: 'test.txt'),
          'file2': MultipartFile.fromBytes(
            [0, 1, 2],
            filename: 'test.png',
            contentType: MediaType.parse('image/png'),
          ),
        })).matches(FormData.fromMap({
          'foo': 'bar',
          'bar': 2,
          'file': MultipartFile.fromBytes([0, 1, 2], filename: 'test.txt'),
          'file2': MultipartFile.fromBytes(
            [0, 1, 2],
            filename: 'test.png',
            contentType: MediaType.parse('image/png'),
          ),
        })),
        true,
      );
    });

    test('converts to string as defined', () {
      final formData = FormData();

      expect(
        Matchers.formData(formData).toString(),
        'FormDataMatcher { fields: ${formData.fields.length}, files ${formData.files.length} }',
      );
    });
  });
}
