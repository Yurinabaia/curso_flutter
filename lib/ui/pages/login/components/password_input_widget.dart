import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../login_presenter.dart';

class PasswordInputWidget extends StatelessWidget {
  const PasswordInputWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);
    return StreamBuilder<String>(
      stream: presenter.passwordErrorStream,
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
          onChanged: presenter.validatePassword,
          obscureText: true,
        );
      },
    );
  }
}
