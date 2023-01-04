import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:curso_flutter/ui/pages/pages.dart';
import 'package:mockito/mockito.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

void main() {
  LoginPresenter presenter = LoginPresenterSpy();

  Future<void> loadPage(WidgetTester tester) async {
    //Criando mocker para o presenter
    presenter = LoginPresenterSpy();

    //Primeiro devemos encapsular o widget que queremos testar em uma função
    //Neste caso usar o MaterialApp para que o widget seja renderizado
    //Avarage
    final loginPage = MaterialApp(
      home: LoginPage(presenter: presenter),
    );

    //Agora podemos usar o tester para renderizar o widget
    //Arange
    await tester.pumpWidget(loginPage);
  }

  testWidgets(
    'Should load with correct initial state',
    (WidgetTester tester) async {
      await loadPage(tester);

      //Act
      //Assert
      //Buscando os filhos do widget com o semanticsLabel 'Email'
      //Neste teste ele esta procurando todos os filhos de Email que seja Text
      final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel('Email'),
        matching: find.byType(Text),
      );

      //Verificando se o widget Text com o texto 'Email' está na tela
      //reason: é uma mensagem que será exibida caso o teste falhe
      expect(
        emailTextChildren,
        findsOneWidget,
        reason:
            'Quando um TextFormField possui apenas um filho texto, significa que não possui erros, pois um dos filhos é sempre o texto do rótulo',
      );

      //Verificando se widget Text com o texto passowrd está na tela
      expect(
        find.descendant(
          of: find.bySemanticsLabel('Senha'),
          matching: find.byType(Text),
        ),
        findsOneWidget,
        reason:
            'Quando um TextFormField possui apenas um filho texto, significa que não possui erros, pois um dos filhos é sempre o texto do rótulo',
      );

      final button = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      //Verificando se o widget ElevatedButton está na tela
      expect(
        button.onPressed,
        null,
      );
    },
  );

  testWidgets('Should call validate with correct values',
      (WidgetTester tester) async {
    await loadPage(tester);
    final email = faker.internet.email();
    final password = faker.internet.password();

    //Act
    //Preenchendo o campo email
    await tester.enterText(find.bySemanticsLabel('Email'), email);
    //Preenchendo o campo senha
    await tester.enterText(find.bySemanticsLabel('Senha'), password);
    //Clicando no botão
    await tester.tap(find.byType(ElevatedButton));

    //Assert
    verify(presenter.validateEmail(email));
    verify(presenter.validatePassword(password));
  });
}
