import 'dart:convert';
import 'package:http/http.dart';

import 'package:curso_flutter/data/http/http_client.dart';
import 'package:curso_flutter/data/http/http_error.dart';

class HttpAdapter implements HttpClient {
  final Client client;
  @override
  Future<Map> request(
      {required String url, required String method, Map? body}) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };
    final bodyFormat = body != null ? jsonEncode(body) : null;

    final response = await client.post(
      Uri.http(url, ''),
      headers: headers,
      body: bodyFormat,
    );
    return _handleResponse(response);
  }

  Map _handleResponse(Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body.isEmpty ? {} : jsonDecode(response.body);
    } else {
      throw HttpError.serverError;
    }
  }

  HttpAdapter(this.client);
}
