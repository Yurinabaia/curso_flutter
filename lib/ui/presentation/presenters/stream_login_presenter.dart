import 'dart:async';

import 'package:curso_flutter/domain/usercases/autentication.dart';

import '../../../domain/helpers/domain_error.dart';
import '../protocols/protocols.dart';

class LoginState {
  String? email;
  String? password;
  String? emailError;
  String? passwordError;
  String? mainError;
  String? navigateTo;
  bool? isLoading = false;
  bool? get isFormValid =>
      emailError == null &&
      passwordError == null &&
      email != null &&
      password != null;
}

class StreamLoginPresenter {
  final Validation validation;
  final Authentication authentication;
  //broadcast permite que mais de um listener possa ouvir o mesmo stream
  final _controller = StreamController<LoginState>.broadcast();
  //Distinc deixa apenas um valor passar e não dois iguais.
  Stream<String?> get emailErrorStream =>
      _controller.stream.map((state) => state.emailError).distinct();

  Stream<String?> get passwordErroStream =>
      _controller.stream.map((state) => state.passwordError).distinct();

  Stream<String?> get mainErrorStream =>
      _controller.stream.map((state) => state.mainError).distinct();

  Stream<bool> get isFormValidStream =>
      _controller.stream.map((state) => state.isFormValid == true).distinct();

  Stream<bool> get isLoadingStream =>
      _controller.stream.map((state) => state.isLoading == true).distinct();
  final _state = LoginState();

  StreamLoginPresenter(
      {required this.validation, required this.authentication});

  void update() => _controller.add(_state);

  void validateEmail(String email) {
    _state.email = email;
    _state.emailError = validation.validate(field: 'email', value: email);
    update();
  }

  void validatePassword(String password) {
    _state.password = password;
    _state.passwordError =
        validation.validate(field: 'password', value: password);
    update();
  }

  Future<void> auth() async {
    _state.isLoading = true;
    update();
    try {
      await authentication.auth(
          AuthenticationParams(email: _state.email, password: _state.password));
      _state.isLoading = false;
    } on DomainError catch (error) {
      _state.isLoading = false;
      _state.mainError = error.description;
    }
    update();
  }
}
