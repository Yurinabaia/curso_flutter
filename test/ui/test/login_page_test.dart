import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:curso_flutter/ui/pages/pages.dart';
import 'package:mockito/mockito.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

void main() {
  LoginPresenter presenter = LoginPresenterSpy();
  StreamController<String>? emailErrorController = StreamController<String>();
  StreamController<String>? passwordErrorController =
      StreamController<String>();
  StreamController<String>? mainErrorController = StreamController<String>();
  StreamController<bool>? isFormValidController = StreamController<bool>();
  StreamController<bool>? isLoadingController = StreamController<bool>();

  void inicializedStreams() {
    //Criando stream para o emailErrorStream, passwordErrorStream, isFormValidStream isLoadingStream e mainErrorStream
    emailErrorController = StreamController<String>();
    passwordErrorController = StreamController<String>();
    mainErrorController = StreamController<String>();
    isFormValidController = StreamController<bool>();
    isLoadingController = StreamController<bool>();
  }

  void inicializedMocker() {
    //Mockando o emailErrorStream e passwordErrorController para retornar o stream criado
    when(presenter.emailErrorStream)
        .thenAnswer((_) => emailErrorController?.stream);

    when(presenter.passwordErrorStream)
        .thenAnswer((_) => passwordErrorController?.stream);

    //mockando o isFormValidStream para retornar true
    when(presenter.isFormValidStream)
        .thenAnswer((_) => isFormValidController?.stream);

    //mockando o isLoadingStream para retornar false
    when(presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController?.stream);

    //mockando o mainErrorStream para retornar o stream criado
    when(presenter.mainErrorStream)
        .thenAnswer((_) => mainErrorController?.stream);
  }

  void closeStreams() {
    emailErrorController?.close();
    passwordErrorController?.close();
    mainErrorController?.close();
    isFormValidController?.close();
    isLoadingController?.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    //Criando mocker para o presenter
    presenter = LoginPresenterSpy();
    inicializedStreams();
    inicializedMocker();

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

  tearDown(() {
    closeStreams();
  });

  testWidgets('Should load with correct initial state',
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

    //loading não deve ser exibido
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

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

  testWidgets('Should present error if email is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);

    //Act
    //Preenchendo o campo email com um email inválido
    emailErrorController?.add('Campo obrigatório');

    //PUMP é o método que faz o widget ser renderizado na tela
    await tester.pump();

    //Assert
    expect(
      find.text('Campo obrigatório'),
      findsOneWidget,
      reason:
          'Erro esperado deve ser apresentado na tela quando o email é inválido',
    );
  });

  testWidgets('Should present error if passoword is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);

    //Act
    //Preenchendo o campo email com um email inválido
    passwordErrorController?.add('Campo obrigatório');

    //PUMP é o método que faz o widget ser renderizado na tela
    await tester.pump();

    //Assert
    expect(
      find.text('Campo obrigatório'),
      findsOneWidget,
      reason:
          'Erro esperado deve ser apresentado na tela quando o email é inválido',
    );
  });
  testWidgets('Should enable button if form is valid',
      (WidgetTester tester) async {
    await loadPage(tester);

    //Act
    //Habilitando o botão do submit
    isFormValidController?.add(true);
    await tester.pump();

    //Assert
    final button = tester.widget<ElevatedButton>(
      find.byType(ElevatedButton),
    );

    expect(
      button.onPressed,
      isNotNull,
      reason: 'Botão deve ser habilitado quando o formulário for válido',
    );
  });
  testWidgets('Should disable button if form is not valid',
      (WidgetTester tester) async {
    await loadPage(tester);

    //Act
    //Desabilitando o botão do submit
    isFormValidController?.add(false);
    await tester.pump();

    //Assert
    final button = tester.widget<ElevatedButton>(
      find.byType(ElevatedButton),
    );

    expect(
      button.onPressed,
      null,
      reason: 'Botão deve ser desabilitado quando o formulário for inválido',
    );
  });
  testWidgets('Should call authentication on form submit',
      (WidgetTester tester) async {
    await loadPage(tester);

    //Act
    //Habilitando o botão do submit
    isFormValidController?.add(true);
    await tester.pump();

    //Assert
    final button = tester.widget<ElevatedButton>(
      find.byType(ElevatedButton),
    );

    await tester.pump();
    verifyNever(presenter.auth()).called(0);
  });

  testWidgets('Should present loading on form submit',
      (WidgetTester tester) async {
    await loadPage(tester);

    //Act
    //Habilitando o botão do submit
    isLoadingController?.add(true);
    await tester.pump();

    //Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
  testWidgets('Should hide loading', (WidgetTester tester) async {
    await loadPage(tester);

    //Act
    //Habilitando o botão do submit
    isLoadingController?.add(true);
    await tester.pump();
    isLoadingController?.add(false);
    await tester.pump();

    //Assert
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('main error', (WidgetTester tester) async {
    await loadPage(tester);

    //Act
    // exibindo o erro principal
    mainErrorController?.add('main error');
    await tester.pump();

    //Assert
    //Encontra algum componente com o texto main error
    expect(find.text('main error'), findsOneWidget);
  });

  testWidgets('Should close streams on dispose', (WidgetTester tester) async {
    await loadPage(tester);
    //Act
    //dispose é um método do presenter
    presenter.dispose();

    //Assert
    verify(presenter.dispose()).called(1);
    addTearDown(() {
      presenter.dispose();
    });
  });
}
