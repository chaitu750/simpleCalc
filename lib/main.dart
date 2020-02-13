import 'package:flutter/material.dart';
import 'calculator/calc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      // home: MyHomePage(title: 'My First Flutter Page'),
      initialRoute: '/',
      routes: {
        '/':(context) => CalculatorPage(),
      },
    );
  }
}

