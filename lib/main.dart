import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:opazar/screens/login_page.dart';
=======
import 'package:opazar/screens/dealer_page.dart';
>>>>>>> 849b1b4979221459fe70eba8452142aa77416be4


void main() => runApp(MyApp());
// deneme yeni123
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: DealerPage(),
    );
  }
}
