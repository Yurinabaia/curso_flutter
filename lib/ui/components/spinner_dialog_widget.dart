import 'package:flutter/material.dart';

Future<dynamic> showLoading(BuildContext context) {
  return showDialog(
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
}

void hideLoadnig(BuildContext context) {
  Navigator.of(context).pop();
}
