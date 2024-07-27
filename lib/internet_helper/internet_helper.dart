import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class InternetHelper {
  final http.Client client;
  InternetHelper(this.client);

  String baseUrl = 'https://nibrahim.pythonanywhere.com/';

  Future<http.Response> get(String url, {bool authorizedPost = true}) async {
    try {
      var header = {
        'Connection': 'keep-alive',
        'Content-Length': '32',
        'Content-Type': 'application/json',
        'Server': 'PythonAnywhere',
      };

      Uri uri = Uri.parse(baseUrl + url);
      final response = await client.get(uri, headers: header);

      return _response(response);
    } on SocketException {
      throw const SocketException('Internet service not found');
    } on TimeoutException {
      throw TimeoutException('Time out');
    }
  }

  Future<http.Response> post(String url, {required Map<String, dynamic> body}) async {
    try {
      var header = {
        'Connection': 'keep-alive',
        'Content-Length': '32',
        'Content-Type': 'application/json',
        'Server': 'PythonAnywhere',
      };

      var jsonData = jsonEncode(body);
      Uri uri = Uri.parse(baseUrl + url);
      final response = await client.post(uri, body: jsonData, headers: header);
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        return response;
      } else {
        return _response(response);
      }
    } on SocketException {
      throw const SocketException('Internet service not found');
    } on TimeoutException {
      throw TimeoutException('Time out');
    }
  }

  Future<http.Response> delete(String url, {required Map<String, dynamic> body}) async {
    try {
      var header = {
        'Connection': 'keep-alive',
        'Content-Length': '32',
        'Content-Type': 'application/json',
        'Server': 'PythonAnywhere',
      };

      var jsonData = jsonEncode(body);
      Uri uri = Uri.parse(baseUrl + url);
      final response = await client.delete(uri, body: jsonData, headers: header);
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        return response;
      } else {
        return _response(response);
      }
    } on SocketException {
      throw const SocketException('Internet service not found');
    } on TimeoutException {
      throw TimeoutException('Time out');
    }
  }

  http.Response _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return response;

      case 400:
        var errorResp = jsonDecode(response.body);
        throw errorResp['error'];

      default:
        throw response.body;
    }
  }
}
