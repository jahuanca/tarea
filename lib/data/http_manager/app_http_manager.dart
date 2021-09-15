import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';


import 'package:flutter_tareo/core/strings.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_tareo/data/http_manager/http_manager.dart';
import 'package:flutter_tareo/domain/exceptions/app_exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

const timeout = Duration(seconds: 5);

class AppHttpManager implements HttpManager {
  @override
  Future get({
    String url,
    Map<String, dynamic> query,
    Map<String, String> headers,
  }) async {
    try {
      print('Api Get request url $url');
      log(query.toString());
      final response = await http
          .get(Uri.parse(_queryBuilder(url, query)), headers: await _headerBuilder(headers));
          /* .timeout(timeout, onTimeout: () => throw TimeoutException()); */
      return _returnResponse(response);
    
    } on Exception catch (_) {
      throw NetworkException();
    }
  }

  @override
  Future<dynamic> post({
    String url,
    Map body,
    Map<String, dynamic> query,
    Map<String, String> headers,
  }) async {
    try {
      print('Api Post request url $url, with $body');
      final response = await http
          .post(Uri.parse(_queryBuilder(url, query)),
              body: body != null ? json.encode(body) : null,
              headers: await _headerBuilder(headers));
          /* .timeout(timeout, onTimeout: () => throw TimeoutException()); */
      return _returnResponse(response);
    } on Exception catch (_) {
      print(_.toString());
      throw NetworkException();
    }
  }

  @override
  Future<dynamic> put({
    String url,
    Map body,
    Map<String, dynamic> query,
    Map<String, String> headers,
  }) async {
    try {
      print('Api Put request url $url, with $body');
      final response = await http
          .put(Uri.parse(_queryBuilder(url, query)),
              body: json.encode(body), headers: await _headerBuilder(headers))
          .timeout(timeout, onTimeout: () => throw TimeoutException());
      return _returnResponse(response);
    } on Exception catch (_) {
      throw NetworkException();
    }
  }

  @override
  Future<dynamic> delete({
    String url,
    Map<String, dynamic> query,
    Map<String, String> headers,
  }) async {
    try {
      print('Api Delete request url $url');
      final response = await http
          .delete(Uri.parse(_queryBuilder(url, query)) , headers: await _headerBuilder(headers))
          .timeout(timeout, onTimeout: () => throw TimeoutException());
      return _returnResponse(response);
    } on Exception catch (_) {
      throw NetworkException();
    }
  }

  

  Future<Map<String, String>> _headerBuilder(Map<String, String> headers) async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    String token=sharedPreferences.getString('TOKEN') ?? '';
    final headers = <String, String>{};
    headers[HttpHeaders.acceptHeader] = 'application/json';
    headers[HttpHeaders.contentTypeHeader] = 'application/json';
    if(token!=null){
      headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    }
    if (headers.isNotEmpty) {
      headers.forEach((key, value) {
        headers[key] = value;
      });
    }
    return headers;
  }

  String _queryBuilder(String path, Map<String, dynamic> query) {
    final buffer = StringBuffer()..write(serverUrl + (path ?? ''));
    if (query != null) {
      if (query.isNotEmpty) {
        buffer.write('?');
      }
      query.forEach((key, value) {
        buffer.write('$key=$value&');
      });
    }
    print(buffer.toString());
    return buffer.toString();
  }

  dynamic _returnResponse(http.Response response) {
    /* final responseJson = json.decode(response.body); */
    final responseJson = response.body;
    /* if (response.statusCode >= 200 && response.statusCode <= 299) { */
      print('Api response success with ');
      log(responseJson);
      return responseJson;
    /* } */
    /* print('Api response error with ${response.statusCode} + ${response.body}');
    switch (response.statusCode) {
      case 400:
        throw BadRequestException();
      case 401:
      case 403:
        throw UnauthorisedException();
      case 500:
      default:      
        throw ServerException();
    } */
  }
}