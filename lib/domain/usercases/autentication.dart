import '../entities/entities.dart';

abstract class Authentication {
  Future<AccountEntity> auth({required String email, required String password});
}

class AuthenticationParams {
  final String email;
  final String password;

  AuthenticationParams({required this.email, required this.password});
  Map toJson() => {'email': email, 'password': password};
}
