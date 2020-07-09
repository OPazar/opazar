import 'package:flutter/material.dart';
import 'package:opazar/screens/home_page.dart';


void main() => runApp(MyApp());
// deneme yeni123
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: HomePage(),
    );
  }
}
