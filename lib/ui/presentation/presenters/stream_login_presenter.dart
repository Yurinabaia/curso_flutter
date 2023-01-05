import 'dart:async';

import '../protocols/protocols.dart';

class LoginState {
  String? emailError;
  String? passwordError;
  String? mainError;
  String? navigateTo;
  bool? isLoading;
}

class StreamLoginPresenter {
  final Validation validation;
  //broadcast permite que mais de um listener possa ouvir o mesmo stream
  final _controller = StreamController<LoginState>.broadcast();
  Stream<String?> get emailErrorStream =>
      _controller.stream.map((state) => state.emailError).distinct();

  final _state = LoginState();

  StreamLoginPresenter({required this.validation});
  void validateEmail(String email) {
    _state.emailError = validation.validate(field: 'email', value: email);
    _controller.add(_state);
  }
}
