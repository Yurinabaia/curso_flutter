import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:curso_flutter/ui/presentation/protocols/protocols.dart';
import 'package:curso_flutter/ui/presentation/presenters/presenters.dart';

class ValidationSpy extends Mock implements Validation {}

void main() {
  ValidationSpy validation = ValidationSpy();
  StreamLoginPresenter sut = StreamLoginPresenter(validation: validation);
  String email = faker.internet.email();

  PostExpectation mockValidationCall(String? field) => when(validation.validate(
      field: field ?? anyNamed('field'), value: anyNamed('value')));

  void mockValidation({String? field, String? value}) {
    mockValidationCall(field).thenReturn(value);
  }

  setUp(() {
    validation = ValidationSpy();
    sut = StreamLoginPresenter(validation: validation);
    email = faker.internet.email();
    mockValidation();
  });

  test('Should call validate with correct email', () {
    sut.validateEmail(email);
    verify(validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit email error if validation fails', () {
    mockValidation(value: 'error');
    expectLater(sut.emailErrorStream, emits('error'));

    sut.validateEmail(email);
  });
}
