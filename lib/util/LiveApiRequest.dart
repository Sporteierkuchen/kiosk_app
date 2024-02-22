import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:developer';

import 'package:http/http.dart' as http;


typedef SuccessFunction = Function(String? response);
typedef ErrorFunction = Function(String error, int responseCode);
typedef ExceptionFunction = Function(Object e);
typedef FinishFunction = Function();

class LiveApiRequest<T> {
  String path;

  LiveApiRequest({
    required this.path,
  });

  Future<ApiResponse> executePost(Object? postObject) async {
    try {

      String serialized = "";
      if(postObject != null) {
        serialized = jsonEncode(postObject);
        print(serialized);
      }

      //String url = "http://10.100.5.76:8080/$path";
      String url = "http://localhost:8080/$path";

      http.Response response = await http.post(
          Uri.parse(
              url),
          headers: await getDefaultHeaders(),
          body: serialized,
          encoding: Encoding.getByName("utf-8"));

      return await _handleResult(response);
    } catch (e) {
      print(e);

      return ApiResponse(status: Status.EXCEPTION, exception: e);
    }
  }


  Future<ApiResponse> _handleResult(http.Response response) async {
    String responseBody = utf8.decode(response.bodyBytes);
    ApiResponse apiResponse = ApiResponse(
        status: Status.SUCCESS,
        statusCode: response.statusCode,
        body: responseBody);
    log(responseBody);

    if (response.statusCode > 299) {
      apiResponse.status = Status.ERROR;
    }

    return apiResponse;
  }



  Future<ApiResponse> executeGet() async {
    try {
      String url = "http://10.100.5.76:8080/$path";
      //String url = "http://localhost:8080/$path";

      http.Response response = await http.get(
          Uri.parse(url),
          headers: await getDefaultHeaders());
      return await _handleResult(response);
    } catch (e) {
      print(e);

      return ApiResponse(status: Status.EXCEPTION, exception: e);
    }
  }

  static Future<Map<String, String>> getDefaultHeaders() async {

    String datePart = DateFormat('dd.MM.yyyy').format(DateTime.now());


    Map<String, String> headers = <String, String>{
      "Content-Type": "application/json; charset=UTF-8",
      "Accept-Language": "de-DE",
      "Authorization": "Basic cnNFeHRlcm5hbFVuaXZlcnNlOlt3Lm5UVjUheCohbW1Cdjo="


    };

    return headers;
  }
}

class ApiResponse {
  int? statusCode;
  String? body;
  Object? exception;
  Status status;

  ApiResponse(
      {this.statusCode, this.body, this.exception, required this.status});
}

enum Status { SUCCESS, ERROR, EXCEPTION }
