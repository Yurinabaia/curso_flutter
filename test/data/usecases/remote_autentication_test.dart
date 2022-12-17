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
  test('Should call HttpClient with current values', () async {
    // arrange
    final httpClient = HttpClientSpy();
    final url = faker.internet.httpUrl();
    final aut = RemoteAuthentication(httpClient: httpClient, url: url);
    // act
    await aut.auth();
    // assert
    verify(httpClient.request(url: url, method: 'post'));
  });
}
