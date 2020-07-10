import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:opazar/screens/home_page.dart';
import 'package:opazar/screens/register_page.dart';
import 'package:opazar/services/auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final auth = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  String emailValue;
  String passwordValue;

  BuildContext baseContext;

  @override
  Widget build(BuildContext context) {
    baseContext = context;
    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      initialValue: '',
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      // ignore: missing_return
      validator: (String value) {
        Pattern pattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regex = new RegExp(pattern);
        if (!regex.hasMatch(value)) {
          return 'Geçersiz email adresi';
        }
      },
      onSaved: (newValue) => emailValue = newValue,
    );
    final password = TextFormField(
      autofocus: false,
      initialValue: '',
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Şifre',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      onSaved: (newValue) => passwordValue = newValue,
    );

    final submitButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Giriş', style: TextStyle(color: Colors.white)),
        onPressed: () => _validateInputs(),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Form(
          key: _formKey,
          autovalidate: _autoValidate,
          child: ListView(
            shrinkWrap: true,
            primary: false,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
              email,
              SizedBox(height: 8.0),
              password,
              SizedBox(height: 24.0),
              submitButton,
              SizedBox(height: 8.0),
              Center(
                  child: GestureDetector(
                child: Text('Buraya tıklayarak kayıt olabilirsin'),
                onTap: () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => RegisterPage())),
              )),
            ],
          ),
        ),
      ),
    );
  }

  void _validateInputs() {
    if (_formKey.currentState.validate()) {
      // print('validated');
      _formKey.currentState.save();
      //onayla
      login();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void login() {
    AlertDialog successAlert = AlertDialog(
      title: Text('Giriş Başarılı'),
      content: Text('Email adresiniz ve parolanız doğru'),
      actions: <Widget>[
        FlatButton(
          child: Text('Devam'),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => HomePage()));
          },
        ),
      ],
    );

    Dialog waitingAlert = Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 32.0),
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );

    AlertDialog errorAlert = AlertDialog(
      title: Text('Giriş Başarısız'),
      content: Text('Email adresiniz veya parolanız yanlış'),
      actions: <Widget>[
        FlatButton(
          child: Text('Kapat'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (context) => EnhancedFutureBuilder(
          future: auth.login(email: emailValue, password: passwordValue),
          rememberFutureResult: false,
          whenDone: (snapshotData) => successAlert,
          whenNotDone: waitingAlert,
          whenError: (error) {
            print(error);
            return errorAlert;
          }),
    );
  }
}
