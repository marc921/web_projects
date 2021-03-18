import 'package:flutter/material.dart';
import 'package:path_maker/world.map.dart';
import 'package:path_maker/world.model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Path Maker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider<WorldModel>(
        create: (_) => WorldModel(),
        child: Builder(
          // Need a builder to access the context below
          builder: (BuildContext ctx) {
            return WorldMap();
          },
        ),
      ),
    );
  }
}
