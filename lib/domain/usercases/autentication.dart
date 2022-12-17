import '../entities/entities.dart';

abstract class Authentication {
  Future<AccountEntity> auth(AuthenticationParams authenticationParam);
}

class AuthenticationParams {
  final String email;
  final String password;

  AuthenticationParams({required this.email, required this.password});
}
