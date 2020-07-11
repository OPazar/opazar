import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:opazar/screens/home_page.dart';
import 'package:opazar/screens/login_page.dart';
import 'package:opazar/services/auth.dart';
import 'package:opazar/services/initializer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, theme: ThemeData(primarySwatch: Colors.blueGrey), home: TempPage());
  }
}

class TempPage extends StatelessWidget {
  final auth = AuthService();

  @override
  Widget build(BuildContext context) {
    Connectivity().checkConnectivity().then((value) async {
      if (value == ConnectivityResult.none) {
        print('Bağlantı yok');
        showDialog(
          context: context,
          child: AlertDialog(
            title: Text('Bağlantı Yok'),
            content: Text('İnternet bağlantınızı kontrol edip tekrar deneyin.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Kapat'),
                onPressed: () => SystemNavigator.pop(),
              ),
            ],
          ),
        );
      } else {
        auth.currentUser().then((value) async {
          await Initializer().load();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
        }).catchError((_) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
        });
      }
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
