import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usercases/usercases.dart';

import '../models/remote_account_model.dart';
import '../http/http.dart';

class RemoteAuthentication implements Authentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  @override
  Future<AccountEntity> auth(AuthenticationParams? authenticationParams) async {
    final body =
        RemoteAuthenticationParams.fromDomain(authenticationParams!).toJson();
    try {
      final httpResponse =
          await httpClient.request(url: url, method: 'post', body: body);
      return RemoteAccountModel.fromJson(httpResponse).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.unauthorized
          ? DomainError.invalidCredentials
          : DomainError.unexpected;
    }
  }
}

class RemoteAuthenticationParams {
  final String? email;
  final String? password;

  RemoteAuthenticationParams({required this.email, required this.password});

  factory RemoteAuthenticationParams.fromDomain(
          AuthenticationParams authenticationParams) =>
      RemoteAuthenticationParams(
          email: authenticationParams.email,
          password: authenticationParams.password);

  Map toJson() => {'email': email, 'password': password};
}
