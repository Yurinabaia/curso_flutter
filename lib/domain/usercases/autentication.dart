import '../entities/account_entity.dart';

abstract class Authentication {
  Future<AccountEntity> auth({required String email, required String password});
}

class AuthenticationParams {
  final String email;
  final String password;

  AuthenticationParams({required this.email, required this.password});
}
