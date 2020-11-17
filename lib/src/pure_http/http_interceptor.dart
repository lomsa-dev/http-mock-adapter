import 'dart:convert';
import 'dart:async';
import 'package:http/src/base_request.dart';
import 'package:http/src/client.dart';
import 'package:http/src/base_client.dart';
import 'package:http/src/streamed_response.dart';
import 'package:http_mock_adapter/src/Exceptions.dart';
import './http_response.dart';

@Deprecated("This adapter class is an experimental feature")
class ClientAdapter extends BaseClient {
  List<Map<String, dynamic>> responseMap = [{}];

  ClientAdapter(this.responseMap) {
    //assertion
    this.assertDuplicatedRoutes();
  }
  Stream<List<int>> response = Stream.value(utf8.encode("asf"));

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    StreamedResponse mockedResponse = searchResponse(request);
    return Future.value(mockedResponse);
  }

  StreamedResponse searchResponse(BaseRequest request) {
    String route = request.url.toString();
    for (Map<String, dynamic> response in responseMap) {
      if (response["route"] == route) {
        if (response["response"].onMethod == request.method) {
          return response["response"].buildResponse();
        }
      }
    }
  }

  bool assertDuplicatedRoutes() {
    this.responseMap.forEach((element) {
      int duplicationCoutner = 0;
      int index = this.responseMap.indexOf(element);
      for (Map<String, dynamic> response in this.responseMap) {
        print(response);
        if (this.responseMap[index]["route"] == response["route"] &&
            this.responseMap[index]["response"].onMethod ==
                response["response"].onMethod) {
          duplicationCoutner += 1;

          if (duplicationCoutner == 2) {
            return throw new DuplicatedException(
                "You have duplicated routes inside the responseMap");
          }
        }
      }
    });
    return true;
  }
}

void main(List<String> args) async {
  final adapter = ClientAdapter([
    {
      "route": "/route",
      "response": PureHttpResponse(200, "hello world babe", "GET",
          headers: {"user-agent": "google-chrome"}),
    },
    {
      "route": "/route",
      "response": PureHttpResponse(200, "hello world babe", "GET",
          headers: {"user-agent": "google-chrome"}),
    },
    {
      "route": "/route3",
      "response": PureHttpResponse(200, "hello world babe", "GET",
          headers: {"user-agent": "google-chrome"}),
    },
  ]);

  Client client = Client();

  client = adapter;
  // adapter.assertDuplicatedRoutes();
  var val = await client.get("/route");
  print(val.headers);

  // adapter.searchResponse();
}
