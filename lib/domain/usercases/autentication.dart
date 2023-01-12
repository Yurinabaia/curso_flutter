import 'package:equatable/equatable.dart';

import '../entities/entities.dart';

abstract class Authentication {
  Future<AccountEntity>? auth(AuthenticationParams? authenticationParam);
}

class AuthenticationParams extends Equatable {
  final String? email;
  final String? password;

  //equatable permite comparar objetos de forma mais simples
  @override
  List get props => [email, password];

  const AuthenticationParams({required this.email, required this.password});
}
