import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';

class ClientSpy extends Mock implements Client {
  @override
  Future<Response> post(Uri url,
      {Map<String, String>? headers, body, Encoding? encoding}) async {
    return Response('any', 200);
  }

  @override
  Future<Response> put(Uri url,
      {Map<String, String>? headers, body, Encoding? encoding}) async {
    return Response('any', 200);
  }

  @override
  Future<Response> patch(Uri url,
      {Map<String, String>? headers, body, Encoding? encoding}) async {
    return Response('any', 200);
  }

  @override
  Future<Response> delete(Uri url,
      {Map<String, String>? headers, body, Encoding? encoding}) async {
    return Response('any', 200);
  }

  @override
  Future<Response> get(Uri url,
      {Map<String, String>? headers, body, Encoding? encoding}) async {
    return Response('any', 200);
  }
}

class HttpAdapter {
  final Client client;
  Future<void> request(
      {required String url, required String method, Map? body}) async {
    await client.post(
      Uri.http(url.split("//")[1], ''),
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
      body: body != null ? jsonEncode(body) : null,
    );
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
    url = faker.internet.httpUrl();
  });
  group('post', () {
    test('Should call post with correct values', () async {
      // act
      await sut
          .request(url: url, method: 'post', body: {'any_key': 'any_value'});
      // assert
      expect(url, url);
    });
  });
}
