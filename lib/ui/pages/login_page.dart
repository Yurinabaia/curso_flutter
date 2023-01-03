import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image.asset("lib/ui/assets/logo.png"),
            Text("Login".toUpperCase()),
            Form(
              key: null,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Email",
                      icon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Senha",
                      icon: Icon(Icons.lock),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text("Entrar"),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.person),
                    onPressed: () {},
                    label: Text("Criar conta"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
