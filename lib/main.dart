import 'package:flutter/material.dart';
import 'package:opazar/models/Dealer.dart';
import 'package:opazar/models/Product.dart';
import 'package:opazar/screens/home_page.dart';
import 'package:opazar/screens/login_page.dart';
import 'package:opazar/screens/product_page.dart';
import 'package:opazar/services/auth.dart';
import 'package:opazar/widgets/products_grid_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: TempPage()
    );
  }
}

class TempPage extends StatelessWidget {
  final auth = AuthService();

  @override
  Widget build(BuildContext context) {
    auth.currentUser().then((value) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    }).catchError((_) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    });

    return Scaffold(
      body: Center(
        child: Container(
          width: 150,
          height: 150,
          color: Colors.black,
        ),
      ),
    );
  }
}
