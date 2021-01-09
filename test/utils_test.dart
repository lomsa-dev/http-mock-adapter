import 'package:http_mock_adapter/src/utils.dart';
import 'package:test/test.dart';

void main() {
  test('paths are parsed into mock filenames as intended', () {
    var actual = '-example';

    expect(actual, getMockFileName('example'));
    expect(actual, getMockFileName('/example'));
    expect(actual, getMockFileName('example.com'));
    expect(actual, getMockFileName('api.example.com'));
    expect(actual, getMockFileName('www.example.com'));
    expect(actual, getMockFileName('http://example.com'));
    expect(actual, getMockFileName('https://example.com'));

    actual = '-example/route';

    expect(actual, getMockFileName('example/route'));
    expect(actual, getMockFileName('/example/route'));
    expect(actual, getMockFileName('example/route.com'));
    expect(actual, getMockFileName('api.example/route.com'));
    expect(actual, getMockFileName('www.example/route.com'));
    expect(actual, getMockFileName('http://example/route.com'));
    expect(actual, getMockFileName('https://example/route.com'));
  });
}
