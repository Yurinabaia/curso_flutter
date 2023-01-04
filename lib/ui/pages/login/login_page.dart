import 'package:curso_flutter/ui/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import 'components/component.dart';

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
            showLoading(context);
          } else {
            hideLoadnig(context);
          }
        });

        widget.presenter?.mainErrorStream?.listen((error) {
          if (error.isNotEmpty == true) {
            showErroMensager(context, error);
          }
        });

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const LoginHeaderWidget(),
              const HeadLineOneWidget(text: "Login"),
              Provider(
                create: (_) => widget.presenter,
                child: Form(
                  key: null,
                  child: Column(
                    children: <Widget>[
                      const EmailInputWidget(),
                      const Padding(
                        padding: EdgeInsets.only(
                          top: 8,
                          bottom: 32,
                        ),
                        child: PasswordInputWidget(),
                      ),
                      const SizedBox(height: 10),
                      const ButtonSubmitWidget(),
                      TextButton.icon(
                        icon: const Icon(Icons.person),
                        onPressed: () {},
                        label: const Text("Criar conta"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
