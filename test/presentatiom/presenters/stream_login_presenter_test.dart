import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:curso_flutter/ui/presentation/protocols/protocols.dart';
import 'package:curso_flutter/ui/presentation/presenters/presenters.dart';

class ValidationSpy extends Mock implements Validation {}

void main() {
  ValidationSpy validation = ValidationSpy();
  StreamLoginPresenter sut = StreamLoginPresenter(validation: validation);
  String email = "";
  String password = "";

  PostExpectation mockValidationCall(String? field) => when(validation.validate(
      field: field ?? anyNamed('field'), value: anyNamed('value')));

  void mockValidation({String? field, String? value}) {
    mockValidationCall(field).thenReturn(value);
  }

  setUp(() {
    validation = ValidationSpy();
    sut = StreamLoginPresenter(validation: validation);
    email = faker.internet.email();
    password = faker.internet.password();
    mockValidation();
  });

  test('Should call validate with correct email', () {
    sut.validateEmail(email);
    verify(validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit email error if validation fails', () {
    mockValidation(value: 'error');

    // Esperado o erro apenas uma vez aconteça
    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, 'error')));

    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit null if validation succeds', () {
    // Esperado o erro apenas uma vez aconteça
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));

    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should call validate with correct password', () {
    sut.validatePassword(password);
    verify(validation.validate(field: 'password', value: password)).called(1);
  });

  test('Should emit password error if validation fails', () {
    mockValidation(value: 'error');

    // Esperado o erro apenas uma vez aconteça
    sut.passwordErroStream
        .listen(expectAsync1((error) => expect(error, 'error')));

    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit null if password succeds', () {
    // Esperado o erro apenas uma vez aconteça
    sut.passwordErroStream.listen(expectAsync1((error) => expect(error, null)));

    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit password is email null validation', () {
    mockValidation(field: 'email', value: 'error');

    // Esperado o erro apenas uma vez aconteça
    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, 'error')));
    sut.passwordErroStream.listen(expectAsync1((error) => expect(error, null)));

    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validatePassword(password);
  });

  test('Should emit password is email null validation', () async {
    // Esperado o erro apenas uma vez aconteça
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.passwordErroStream.listen(expectAsync1((error) => expect(error, null)));

    //Quando preecher meu campo email incialmente
    //meu campo esta invalido e depois preecher passowrd meu form ficar valido
    expect(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validateEmail(email);
    //Esperar o delay para que o teste seja executado para dar true nos
    //dois email e password
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
  });
}
