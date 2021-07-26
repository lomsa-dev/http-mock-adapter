import 'package:http_mock_adapter/src/request.dart';
import 'package:test/test.dart';

void main() {
  group('RequestMethods', () {
    test('has only certain allowed payload methods', () {
      const allowedRequestMethods = [
        RequestMethods.post,
        RequestMethods.put,
        RequestMethods.patch,
        RequestMethods.delete,
      ];

      const disallowedRequestMethods = [
        RequestMethods.get,
        RequestMethods.head,
      ];

      for (var allowedRequestMethod in allowedRequestMethods) {
        expect(allowedRequestMethod.isAllowedPayloadMethod, true);
      }

      for (var disallowedRequestMethod in disallowedRequestMethods) {
        expect(disallowedRequestMethod.isAllowedPayloadMethod, false);
      }
    });
  });
}
