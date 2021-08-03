import 'package:flutter/material.dart';

import 'package:fluent_io/stateful_widgets/home.dart';

void main() => runApp(Root());

class Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fluent.io',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: Home(),
    );
  }
}
