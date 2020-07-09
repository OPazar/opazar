import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<FirebaseUser> register({
    @required String email,
    @required String password,
  }) async {
    AuthResult result =
        await _auth.createUserWithEmailAndPassword(email: email, password: password);
    final FirebaseUser user = result.user;

    assert(user != null);
    assert(await user.getIdToken() != null);

    return user;
  }

  Future<FirebaseUser> login({
    @required String email,
    @required String password,
  }) async {
    AuthProblems errorType;
    FirebaseUser user;

    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser _user = result.user;

      assert(_user != null);

      user = _user;
    } catch (e) {
      if (Platform.isAndroid) {
        switch (e.message) {
          case 'There is no user record corresponding to this identifier. The user may have been deleted.':
            errorType = AuthProblems.UserNotFound;
            break;
          case 'The password is invalid or the user does not have a password.':
            errorType = AuthProblems.PasswordNotValid;
            break;
          case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
            errorType = AuthProblems.NetworkError;
            break;
          default:
            print('Case ${e.message} is not yet implemented');
        }
      } else if (Platform.isIOS) {
        switch (e.code) {
          case 'Error 17011':
            errorType = AuthProblems.UserNotFound;
            break;
          case 'Error 17009':
            errorType = AuthProblems.PasswordNotValid;
            break;
          case 'Error 17020':
            errorType = AuthProblems.NetworkError;
            break;
          default:
            print('Case ${e.message} is not yet implemented');
        }
      }
    }

    if (errorType != null) {
      return Future.error(errorType);
    } else {
      return user;
    }
  }

  Future<FirebaseUser> currentUser() {
    return _auth.currentUser();
  }

  Future<void> signOut() {
    return _auth.signOut();
  }
}

enum AuthProblems { UserNotFound, PasswordNotValid, NetworkError }
