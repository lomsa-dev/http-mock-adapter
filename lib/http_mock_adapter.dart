/// A collection of different HTTP adapters intended to mock HTTP responses.
///
/// Set one of the HTTP adapters as your HTTP client, define request structure,
/// define mock data, invoke HTTP client and evaluate the result.
library http_mock_adapter;

export 'src/adapters/dio_adapter.dart';
export 'src/adapters/dio_adapter_mockito.dart';
export 'src/interceptors/dio_interceptor.dart';
export 'src/matchers/matchers.dart';
export 'src/request.dart' show MatchesRequest, Request, RequestMethods;
export 'src/exceptions.dart' show AdapterError;
