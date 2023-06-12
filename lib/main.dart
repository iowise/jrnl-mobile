import 'package:flutter/material.dart';

import './home.dart';

void main() {
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'jrnl',
      home: Home(),
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0x604385),
      ),
    );
  }
}
