// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:curso_flutter/data/http/http.dart';
import 'package:curso_flutter/domain/helpers/helpers.dart';
import 'package:curso_flutter/domain/usercases/usercases.dart';

import 'package:curso_flutter/data/usecases/usecases.dart';

//Mockar classe concreta para classe abstrata
class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  var aut;
  var httpClient;
  var url;
  var params;

  //Separando Arange Act Assert
  setUp(() {
    // Arrange global
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    aut = RemoteAuthentication(httpClient: httpClient, url: url);
    params = AuthenticationParams(
        email: faker.internet.email(), password: faker.internet.password());
  });

  test('Should call HttpClient with current values', () async {
    // act
    await aut.auth(params);
    // assert
    verify(httpClient.request(
      url: url,
      method: 'post',
      body: {
        'email': params.email,
        'password': params.password,
      },
    ));
  });

  test('Should throw UnexpectedErro if Http client return 400', () async {
    //Mocando uma exceção
    when(httpClient.request(
      url: url,
      method: 'post',
      body: {
        'email': params.email,
        'password': params.password,
      },
    )).thenThrow(HttpError.badRequest);

    // act
    final future = aut.auth(params);

    // assert
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedErro if Http client return 404', () async {
    //Mocando uma exceção
    when(httpClient.request(
      url: url,
      method: 'post',
      body: {
        'email': params.email,
        'password': params.password,
      },
    )).thenThrow(HttpError.notFound);

    // act
    final future = aut.auth(params);

    // assert
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedErro if Http client return 500', () async {
    //Mocando uma exceção
    when(httpClient.request(
      url: url,
      method: 'post',
      body: {
        'email': params.email,
        'password': params.password,
      },
    )).thenThrow(HttpError.serverError);

    // act
    final future = aut.auth(params);

    // assert
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw InvalidCrendicialsError if Http client return 401',
      () async {
    //Mocando uma exceção
    when(httpClient.request(
      url: url,
      method: 'post',
      body: {
        'email': params.email,
        'password': params.password,
      },
    )).thenThrow(HttpError.unauthorized);

    // act
    final future = aut.auth(params);

    // assert
    expect(future, throwsA(DomainError.invalidCredentials));
  });
}
