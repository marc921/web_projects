import 'package:flutter/material.dart';

import './pages/home.dart';

void main() => runApp(Root());

class Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fluent.io',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Home(title: 'Home - Search'),
    );
  }
}


