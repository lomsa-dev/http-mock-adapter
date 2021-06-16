import 'package:http_mock_adapter/src/request.dart';

/// [ToUpperCaseString] extension method grants [RequestMethods] enumeration
/// the ability to obtain [String] type depictions of enumeration's values.
extension ToUpperCaseString on RequestMethods {
  /// Gets the [String] depiction of the current value.
  String get toUpperCaseString => toString().split('.').last.toUpperCase();
}
