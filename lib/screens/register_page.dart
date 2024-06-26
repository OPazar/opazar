import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:opazar/screens/home_page.dart';
import 'package:opazar/screens/login_page.dart';
import 'package:opazar/services/auth.dart';

class RegisterPage extends StatefulWidget {
  static String tag = 'login-page';

  @override
  _RegisterPageState createState() => new _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final auth = AuthService();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _agreedToTOS = false;
  bool _autoValidate = false;

  String nameValue;
  String sureNameValue;
  String emailValue;
  String passwordValue;

  @override
  Widget build(BuildContext context) {
    final name = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      initialValue: '',
      decoration: InputDecoration(
        hintText: 'Ad',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      // ignore: missing_return
      validator: (String value) {
        if (value.trim().isEmpty) {
          return 'Ad alanı boş olamaz';
        }
      },
      onSaved: (newValue) => nameValue = newValue,
    );
    final surename = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      initialValue: '',
      decoration: InputDecoration(
        hintText: 'Soyad',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      // ignore: missing_return
      validator: (String value) {
        if (value.trim().isEmpty) {
          return 'Soyad alanı boş olamaz';
        }
      },
      onSaved: (newValue) => sureNameValue = newValue,
    );

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
      // ignore: missing_return
      validator: (String value) {
        if (value.length < 6) {
          return 'En az 6 karakter';
        }
      },
      onSaved: (newValue) => passwordValue = newValue,
    );

    final checkBox = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: <Widget>[
          Checkbox(
            value: _agreedToTOS,
            onChanged: _setAgreedToTOS,
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => _setAgreedToTOS(!_agreedToTOS),
              child: const Text(
                'Hizmet Şartlarını ve Gizlilik Politikasını kabul ediyorum',
              ),
            ),
          ),
        ],
      ),
    );

    final submitButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Kayıt ol', style: TextStyle(color: Colors.white)),
        onPressed: _submittable() ? _validateInputs : null,
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
              name,
              SizedBox(height: 8.0),
              surename,
              SizedBox(height: 8.0),
              email,
              SizedBox(height: 8.0),
              password,
              SizedBox(height: 8.0),
              checkBox,
              SizedBox(height: 24.0),
              submitButton,
              SizedBox(height: 8.0),
              Center(
                  child: GestureDetector(
                child: Text('Buraya tıklayarak giriş yapabilirsin'),
                onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage())),
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
      register();
    } else {
      // print('unValidated');
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void register() {
    AlertDialog successAlert = AlertDialog(
      title: Text('Kayıt Başarılı'),
      content: Text('Kayıt oldunuz giriş yapabilirsiniz.'),
      actions: <Widget>[
        FlatButton(
          child: Text('Giriş Yap'),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
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

    showDialog(
      context: context,
      builder: (context) => EnhancedFutureBuilder(
        future: auth.register(email: emailValue, password: passwordValue, name: nameValue, sureName: sureNameValue),
        rememberFutureResult: false,
        whenDone: (snapshotData) => successAlert,
        whenNotDone: waitingAlert,
        whenError: (error) => buildErrorAlert(error),
      ),
    );
  }

  AlertDialog buildErrorAlert(authError) {
    String errorContent;

    switch (authError) {
      case AuthError.NetworkError:
        errorContent = 'İnternet bağlantınızı kontrol ediniz.';
        break;
      case AuthError.ExistingEmail:
        errorContent = 'Hesap zaten kayıtlı.';
        break;
      default:
        errorContent = 'Bir hatta oluştu. Lütfen tekrar deneyin.';
    }

    AlertDialog errorAlert = AlertDialog(
      title: Text('Kayıt Başarısız'),
      content: Text(errorContent),
      actions: <Widget>[
        FlatButton(
          child: Text('Kapat'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
    return errorAlert;
  }

  bool _submittable() {
    return _agreedToTOS;
  }

  void _setAgreedToTOS(bool newValue) {
    setState(() {
      _agreedToTOS = newValue;
    });
  }
}
