import 'dart:convert';

import 'package:curso_flutter/data/http/http.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';

class ClientSpy extends Mock implements Client {
  @override
  Future<Response> post(Uri url,
      {Map<String, String>? headers, body, Encoding? encoding}) async {
    return Response('{"any_key": "any_value"}', 200);
  }

  @override
  Future<Response> put(Uri url,
      {Map<String, String>? headers, body, Encoding? encoding}) async {
    return Response('{"any_key": "any_value"}', 200);
  }

  @override
  Future<Response> patch(Uri url,
      {Map<String, String>? headers, body, Encoding? encoding}) async {
    return Response('{"any_key": "any_value"}', 200);
  }

  @override
  Future<Response> delete(Uri url,
      {Map<String, String>? headers, body, Encoding? encoding}) async {
    return Response('{"any_key": "any_value"}', 200);
  }

  @override
  Future<Response> get(Uri url,
      {Map<String, String>? headers, body, Encoding? encoding}) async {
    return Response('{"any_key": "any_value"}', 200);
  }
}

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
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body.isEmpty ? {} : jsonDecode(response.body);
    } else {
      throw HttpError.serverError;
    }
  }

  HttpAdapter(this.client);
}

void main() {
  late ClientSpy client;
  late HttpAdapter sut;
  late String url;
  setUp(() {
    // arrange
    client = ClientSpy();
    sut = HttpAdapter(client);
    url = faker.internet.httpUrl().split("//")[1];
  });
  group('post', () {
    test('Should call post with correct values', () async {
      // act
      await sut
          .request(url: url, method: 'post', body: {'any_key': 'any_value'});
      // assert
      when(client.post(Uri.http(url, ''),
          headers: anyNamed('headers'), body: null));
    });

    test('Should call post with correct values with body', () async {
      // act
      await sut
          .request(url: url, method: 'post', body: {'any_key': 'any_value'});
      // assert
      when(client.post(Uri.http(url, ''),
          headers: anyNamed('headers'), body: anyNamed('body')));
    });

    test('Should call return data', () async {
      // arrange
      final Map map = {'any_key': 'any_value'};
      // act
      var response = await sut
          .request(url: url, method: 'post', body: {'any_key': 'any_value'});
      // assert
      expect(response, map);
    });
  });
}
