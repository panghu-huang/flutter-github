import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';

class ApiService {

  static String baseUrl;
  static config({ String baseUrl }) {
    ApiService.baseUrl = baseUrl;
  }

  String _baseUrl;
  String _routeName;
  ApiService({ @required String routeName, String baseUrl }) {
    _routeName = routeName;
    _baseUrl = baseUrl;
  }

  Future<dynamic> get({ String path, Map<String, dynamic> params }) async {
    HttpClient client = HttpClient();
    Uri url = Uri.parse(_makeUrl(path, params));
    HttpClientRequest request = await client.getUrl(url);
    HttpClientResponse response = await request.close();
    String responseBody = await response.transform(Utf8Decoder()).join();
    return jsonDecode(responseBody);
  }

  String _makeUrl(String path, Map<String, dynamic> params) {
    String baseUrl = _getBaseUrl();
    path = _composePath(path);
    String url = '$baseUrl/$path';
    if (params != null) {
      url += '?';
      for (var key in params.keys) {
        url += '$key=${params[key]}&';
      }
    }
    return url;
  }

  String _getBaseUrl() {
    return _baseUrl ?? ApiService.baseUrl;
  }

  String _composePath(String path) {
    if (path == null) {
      return _routeName;
    }
    return '$_routeName/$path';
  }

}