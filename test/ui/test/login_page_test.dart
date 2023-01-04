import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:curso_flutter/ui/pages/pages.dart';

void main() {
  testWidgets(
    'Should load with correct initial state',
    (WidgetTester tester) async {
      //Primeiro devemos encapsular o widget que queremos testar em uma função
      //Neste caso usar o MaterialApp para que o widget seja renderizado
      //Avarage
      const loginPage = MaterialApp(home: LoginPage());

      //Agora podemos usar o tester para renderizar o widget
      //Arange
      await tester.pumpWidget(loginPage);

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
}
