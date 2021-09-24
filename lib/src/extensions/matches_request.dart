import 'package:dio/dio.dart';
import 'package:http_mock_adapter/src/matchers/matchers.dart';
import 'package:http_mock_adapter/src/request.dart';
import 'package:http_mock_adapter/src/types.dart';

/// [MatchesRequest] enhances the [RequestOptions] by allowing different types
/// of matchers to validate the data and headers of the request.
extension MatchesRequest on RequestOptions {
  /// Check values against matchers.
  /// [request] is the configured [Request] which would contain the matchers if used.
  bool matchesRequest(Request request) {
    final routeMatched = doesRouteMatch(path, request.route);
    final requestBodyMatched = matches(data, request.data);
    final queryParametersMatched =
        matches(queryParameters, request.queryParameters ?? {});
    final headersMatched = matches(headers, request.headers ?? {});

    return routeMatched &&
        method == request.method?.name &&
        requestBodyMatched &&
        queryParametersMatched &&
        headersMatched;
  }

  /// Check to see if route matches the mock specification
  /// Allows user to specify route as they intend rather than assuming string
  /// is a pattern. Route will be dynamic.
  bool doesRouteMatch(dynamic actual, dynamic expected) {
    // If null then fail. The route should never be null... ever.
    if (actual == null || expected == null) {
      return false;
    }

    // Ff strings, just compare.
    if (actual is String && expected is String) {
      return actual == expected;
    }

    // Allow regex match of route, expected should be provided via the mocking.
    if (expected is RegExp) {
      return expected.hasMatch(actual);
    }

    // Default to no match.
    return false;
  }

  /// Check the map keys and values determined by the definition.
  bool matches(dynamic actual, dynamic expected) {
    if (actual == null && expected == null) {
      return true;
    }

    /// if data is MockDataCallback do not need to match;
    if (expected is MockDataCallback) return true;
    if (expected is Matcher) {
      /// Check the match here to bypass the fallthrough strict equality check
      /// at the end.
      if (!expected.matches(actual)) {
        return false;
      }
    } else if (actual is Map && expected is Map) {
      for (final key in expected.keys.toList()) {
        if (!actual.containsKey(key)) {
          return false;
        } else if (expected[key] is Matcher) {
          // Check matcher for the configured request.
          if (!expected[key].matches(actual[key])) {
            return false;
          }
        } else if (expected[key] != actual[key]) {
          // Exact match unless map.
          if (expected[key] is Map && actual[key] is Map) {
            if (!matches(actual[key], expected[key])) {
              // Allow maps to use matchers.
              return false;
            }
          } else if (expected[key].toString() != actual[key].toString()) {
            // If some other kind of object like list then rely on `toString`
            // to provide comparison value.
            return false;
          }
        }
      }
    } else if (actual is List && expected is List) {
      for (var index in Iterable.generate(actual.length)) {
        if (!matches(actual[index], expected[index])) {
          return false;
        }
      }
    } else if (actual is Set && expected is Set) {
      final exactMatch = !matches(actual.containsAll(expected), false);

      if (exactMatch) {
        return true;
      }

      for (var index in Iterable.generate(actual.length)) {
        if (!matches(actual.elementAt(index), expected.elementAt(index))) {
          return false;
        }
      }
    } else if (actual != expected) {
      // Fall back to original check.
      return false;
    }

    return true;
  }
}
