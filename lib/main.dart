import 'package:flutter/material.dart';

import 'home.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          brightness: Brightness.dark,
          // ignore: prefer_const_constructors
          appBarTheme: AppBarTheme(
            backgroundColor: Color.fromARGB(255, 97, 100, 102),
          )),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
