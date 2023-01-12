import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:curso_flutter/domain/helpers/helpers.dart';
import 'package:curso_flutter/domain/usercases/usercases.dart';
import 'package:curso_flutter/domain/entities/entities.dart';

import 'package:curso_flutter/ui/presentation/protocols/protocols.dart';
import 'package:curso_flutter/ui/presentation/presenters/presenters.dart';

class ValidationSpy extends Mock implements Validation {}

class AuthenticationSpy extends Mock implements Authentication {}

void main() {
  ValidationSpy validation = ValidationSpy();
  AuthenticationSpy authentication = AuthenticationSpy();
  StreamLoginPresenter sut = StreamLoginPresenter(
      validation: validation, authentication: authentication);
  String email = "";
  String password = "";

  PostExpectation mockAuthenticationCall() => when(authentication.auth(null));

  PostExpectation mockValidationCall(String? field) => when(validation.validate(
      field: field ?? anyNamed('field'), value: anyNamed('value')));

  void mockValidation({String? field, String? value}) {
    mockValidationCall(field).thenReturn(value);
  }

  void mockAuthenticationError(DomainError error) {
    mockAuthenticationCall().thenThrow(error);
  }

  void mockAuthentication() {
    mockAuthenticationCall()
        .thenAnswer((_) async => AccountEntity(faker.guid.guid()));
  }

  setUp(() {
    validation = ValidationSpy();
    authentication = AuthenticationSpy();
    sut = StreamLoginPresenter(
        validation: validation, authentication: authentication);
    email = faker.internet.email();
    password = faker.internet.password();
    mockValidation();
    mockAuthentication();
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

  test('Should call Authentication with correct values', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);
    await sut.auth();

    verify(authentication
            .auth(AuthenticationParams(email: email, password: password)))
        .called(1);
  });

  test('Should emit correct event on Authentication InvalidCredential',
      () async {
    mockAuthenticationError(DomainError.invalidCredentials);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.mainErrorStream.listen(expectAsync1((error) => expect(error, null)));
    await sut.auth();
  });

  test('Should emit correct event on Authentication UnexpectedError', () async {
    mockAuthenticationError(DomainError.unexpected);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.mainErrorStream.listen(expectAsync1((error) => expect(error, null)));
    await sut.auth();
  });

  test('Should not emit after dispose', () async {
    expectLater(sut.emailErrorStream, neverEmits(null));
    sut.dispose();
    sut.validateEmail(email);
  });
}
