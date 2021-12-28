import 'package:flutter/material.dart';
// import 'package:tesmobile/crop.dart';
import 'package:tesmobile/profile.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: Profile(),
      home: Profile(),
    );
  }
}
