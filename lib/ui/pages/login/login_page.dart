import 'package:curso_flutter/ui/pages/pages.dart';
import 'package:flutter/material.dart';

import '../../components/components.dart';

class LoginPage extends StatefulWidget {
  final LoginPresenter? presenter;
  const LoginPage({super.key, this.presenter});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void dispose() {
    super.dispose();
    widget.presenter?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        widget.presenter?.isLoadingStream?.listen((isLoading) {
          if (isLoading == true) {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => SimpleDialog(
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
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

        widget.presenter?.mainErrorStream?.listen((error) {
          if (error.isNotEmpty == true) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                error,
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.red,
            ));
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
                        stream: widget.presenter?.emailErrorStream,
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
                            onChanged: widget.presenter?.validateEmail,
                          );
                        }),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8,
                        bottom: 32,
                      ),
                      child: StreamBuilder<String>(
                          stream: widget.presenter?.passwordErrorStream,
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
                              onChanged: widget.presenter?.validatePassword,
                              obscureText: true,
                            );
                          }),
                    ),
                    const SizedBox(height: 10),
                    StreamBuilder<bool>(
                        stream: widget.presenter?.isFormValidStream,
                        builder: (context, snapshot) {
                          return ElevatedButton(
                            onPressed: snapshot.data == true
                                ? widget.presenter?.auth
                                : null,
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
