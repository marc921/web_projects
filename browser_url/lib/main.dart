import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:browser_url/route/route.model.dart';
import 'package:browser_url/route/route_information_parser.dart';
import 'package:browser_url/route/router_delegate.dart';

Future<void> main() async {
  FlutterError.onError = FlutterError.dumpErrorToConsole;
  final url = 'localhost:3000';
  final app = RouteModel.providerWrapper(
    MyApp(),
  );
  runApp(app);
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final routeModel = context.watch<RouteModel>();
    final _routerDelegate = NvdRouterDelegate(routeModel);
    final  _routeInformationParser = NvdRouteInformationParser(routeModel);
    return MaterialApp.router(
      title: 'My App',
      routerDelegate: _routerDelegate,
      routeInformationParser: _routeInformationParser,
    );
  }
}