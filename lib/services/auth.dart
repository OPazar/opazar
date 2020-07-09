import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<AuthResult> register({
    @required String email,
    @required String password,
  }){
    return _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<AuthResult> login({
    @required String email,
    @required String password,
  }){
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<FirebaseUser> currentUser(){
    return _auth.currentUser();
  }
}
