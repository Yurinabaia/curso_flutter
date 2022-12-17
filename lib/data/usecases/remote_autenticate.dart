import '../../domain/usercases/usercases.dart';

import '../http/http.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  auth(AuthenticationParams authenticationParams) async {
    await httpClient.request(
        url: url, method: 'post', body: authenticationParams.toJson());
  }
}
