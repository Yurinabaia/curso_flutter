import 'package:flutter/material.dart';

class HeadLineOneWidget extends StatelessWidget {
  final String text;
  const HeadLineOneWidget({
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headline1,
    );
  }
}
