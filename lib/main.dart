import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:opazar/screens/home_page.dart';
import 'package:opazar/screens/login_page.dart';
import 'package:opazar/services/auth.dart';

import 'screens/dealer_page.dart';

void main() => runApp(MyApp());

// deneme yeni123
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: TempPage(),
    );
  }
}

class TempPage extends StatelessWidget {
  final auth = AuthService();

  @override
  Widget build(BuildContext context) {
    auth.currentUser().then((value) {
      if (value != null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DealerPage()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    });

    var tempImage = CachedNetworkImage(
      imageUrl: 'https://seeklogo.net/wp-content/uploads/2020/03/new-bmw-logo-2020-512x512.png',
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );

    return Scaffold(
      body: Center(
        child: Container(
          width: 150,
          height: 150,
          child: tempImage,
        ),
      ),
    );
  }
}
