import 'package:curso_flutter/ui/pages/pages.dart';
import 'package:flutter/material.dart';

import '../../components/components.dart';

class LoginPage extends StatelessWidget {
  final LoginPresenter? presenter;
  const LoginPage({super.key, this.presenter});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        presenter?.isLoadingStream?.listen((isLoading) {
          if (isLoading == true) {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => SimpleDialog(
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircularProgressIndicator(),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Loading",
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ],
                    ));
          } else {
            if (Navigator.canPop(context)) {
              Navigator.of(context).pop();
            }
          }
        });
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const LoginHeaderWidget(),
              const HeadLineOneWidget(text: "Login"),
              Form(
                key: null,
                child: Column(
                  children: <Widget>[
                    StreamBuilder<String>(
                        stream: presenter?.emailErrorStream,
                        builder: (context, snapshot) {
                          return TextFormField(
                            decoration: InputDecoration(
                              labelText: "Email",
                              icon: Icon(
                                Icons.email,
                                color: Theme.of(context).primaryColor,
                              ),
                              errorText: snapshot.data?.toString(),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            onChanged: presenter?.validateEmail,
                          );
                        }),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8,
                        bottom: 32,
                      ),
                      child: StreamBuilder<String>(
                          stream: presenter?.passwordErrorStream,
                          builder: (context, snapshot) {
                            return TextFormField(
                              decoration: InputDecoration(
                                labelText: "Senha",
                                icon: Icon(
                                  Icons.lock,
                                  color: Theme.of(context).primaryColor,
                                ),
                                errorText: snapshot.data?.toString(),
                              ),
                              keyboardType: TextInputType.visiblePassword,
                              onChanged: presenter?.validatePassword,
                              obscureText: true,
                            );
                          }),
                    ),
                    const SizedBox(height: 10),
                    StreamBuilder<bool>(
                        stream: presenter?.isFormValidStream,
                        builder: (context, snapshot) {
                          return ElevatedButton(
                            onPressed:
                                snapshot.data == true ? presenter?.auth : null,
                            child: const Text("ENTRAR"),
                          );
                        }),
                    TextButton.icon(
                      icon: const Icon(Icons.person),
                      onPressed: () {},
                      label: const Text("Criar conta"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
