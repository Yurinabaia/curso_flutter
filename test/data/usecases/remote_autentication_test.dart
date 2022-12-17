// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:curso_flutter/domain/usercases/usercases.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  auth(AuthenticationParams authenticationParams) async {
    final body = {
      'email': authenticationParams.email,
      'password': authenticationParams.password,
    };
    await httpClient.request(url: url, method: 'post', body: body);
  }
}

abstract class HttpClient {
  request({required String url, required String method, Map body});
}

//Mockar classe concreta para classe abstrata
class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  var aut;
  var httpClient;
  var url;

  //Separando Arange Act Assert
  setUp(() {
    // Arrange global
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    aut = RemoteAuthentication(httpClient: httpClient, url: url);
  });

  test('Should call HttpClient with current values', () async {
    //Arrange
    final email = faker.internet.email();
    final password = faker.internet.password();

    // act
    await aut.auth(AuthenticationParams(email: email, password: password));
    // assert
    verify(httpClient.request(
      url: url,
      method: 'post',
      body: {
        'email': email,
        'password': password,
      },
    ));
  });
}
