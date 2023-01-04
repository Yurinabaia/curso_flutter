import 'package:flutter/material.dart';

void showErroMensager(context, String error) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      error,
      textAlign: TextAlign.center,
    ),
    backgroundColor: Colors.red,
  ));
}
