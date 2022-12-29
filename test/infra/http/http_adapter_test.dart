import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';

import 'package:curso_flutter/data/http/http.dart';
import 'package:curso_flutter/infra/http/http.dart';

class ClientSpy extends Mock implements Client {
  @override
  Future<Response> post(Uri url,
      {Map<String, String>? headers, body, Encoding? encoding}) async {
    var bodyResponse = jsonEncode(body);
    if (bodyResponse.contains("badRequest")) {
      return Response('{"any_key": "any_value"}', 400);
    } else if (bodyResponse.contains("unauthorized")) {
      return Response('{"any_key": "any_value"}', 401);
    } else if (bodyResponse.contains("forbidden")) {
      return Response('{"any_key": "any_value"}', 403);
    } else if (bodyResponse.contains("notFound")) {
      return Response('{"any_key": "any_value"}', 404);
    } else if (bodyResponse.contains("serverError")) {
      return Response('{"any_key": "any_value"}', 500);
    }
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

    test('Should call return erro 400', () async {
      // act
      final future = sut
          .request(url: url, method: 'post', body: {'any_key': 'badRequest'});
      // assert
      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should call return erro 401', () async {
      // act
      final future = sut
          .request(url: url, method: 'post', body: {'any_key': 'unauthorized'});
      // assert
      expect(future, throwsA(HttpError.unauthorized));
    });

    test('Should call return erro 403', () async {
      // act
      final future =
          sut.request(url: url, method: 'post', body: {'any_key': 'forbidden'});
      // assert
      expect(future, throwsA(HttpError.forbidden));
    });
    test('Should call return erro 404', () async {
      // act
      final future =
          sut.request(url: url, method: 'post', body: {'any_key': 'notFound'});
      // assert
      expect(future, throwsA(HttpError.notFound));
    });

    test('Should call return erro 500', () async {
      // act
      final future = sut
          .request(url: url, method: 'post', body: {'any_key': 'serverError'});
      // assert
      expect(future, throwsA(HttpError.serverError));
    });
  });
}
