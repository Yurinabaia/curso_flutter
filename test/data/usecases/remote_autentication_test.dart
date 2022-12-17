// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  auth() async {
    await httpClient.request(url: url, method: 'post');
  }
}

abstract class HttpClient {
  request({required String url, required String method});
}

//Mockar classe concreta para classe abstrata
class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  var aut;
  var httpClient;
  var url;

  //Separando Arange Act Assert
  setUp(() {
    // arrange
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    aut = RemoteAuthentication(httpClient: httpClient, url: url);
  });

  test('Should call HttpClient with current values', () async {
    // act
    await aut.auth();
    // assert
    verify(httpClient.request(url: url, method: 'post'));
  });
}
