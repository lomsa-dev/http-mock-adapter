String buildRequestSignature(
  final String? method,
  final Pattern? route,
  final dynamic data,
  final Map<String, dynamic>? queryParameters,
  final Map<String, dynamic>? headers,
) =>
    '$method $route { '
    'data: ${data is Map ? sortMap(data) : data}, '
    'query parameters: ${queryParameters is Map ? sortMap(queryParameters!) : queryParameters}, '
    'headers: $headers }';

/// [sortMap] sorts [Map] based on keys.
String sortMap(Map map) {
  final sortedKeys = map.keys.toList()..sort();

  final sortedMap = {
    for (final sortedKey in sortedKeys) sortedKey: map[sortedKey]
  };

  return sortedMap.toString();
}
