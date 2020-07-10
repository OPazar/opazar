import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:opazar/models/User.dart';
import 'package:opazar/services/db.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final db = DatabaseService();

  Future<FirebaseUser> register({
    @required String email,
    @required String password,
    @required String name,
    @required String sureName,
  }) async {
    try {
      AuthResult result =
          await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final FirebaseUser user = result.user;
      assert(user != null);
      assert(await user.getIdToken() != null);

      try {
        String defaultImage = 'https://i.hizliresim.com/RU8rCT.png';
        await db.setUserDetails(
            user.uid, User(email: email, name: name, sureName: sureName, imageUrl: defaultImage));
        return user;
      } catch (_e) {
        return Future.error(_e);
      }
    } catch (e) {
      return Future.error(getAuthProblemType(e));
    }
  }

  Future<FirebaseUser> login({
    @required String email,
    @required String password,
  }) async {
    try {
      
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return user;

    } catch (e) {
      return Future.error(getAuthProblemType(e));
    }
  }

  Future<FirebaseUser> currentUser() async {
    try {
      FirebaseUser _currentUser = await _auth.currentUser();
      if (_currentUser != null) {
        return _currentUser;
      } else {
        return Future.error(AuthError.NotSignedIn);
      }
    } catch (e) {
      return Future.error(AuthError.NotSignedIn);
    }
  }

  Future<User> currentUserDetails() async {
    try {
      FirebaseUser _currentUser = await _auth.currentUser();
      if (_currentUser != null) {
        User userDetails = await db.getUser(_currentUser.uid);
        return userDetails;
      } else {
        return Future.error(AuthError.NotSignedIn);
      }
    } catch (e) {
      return Future.error(AuthError.NotSignedIn);
    }
  }

  Future<void> signOut() {
    return _auth.signOut();
  }
}

enum AuthError { UserNotFound, PasswordNotValid, NetworkError, NotSignedIn, Other }
AuthError getAuthProblemType(dynamic e) {
  AuthError errorType;

  if (Platform.isAndroid) {
    switch (e.message) {
      case 'There is no user record corresponding to this identifier. The user may have been deleted.':
        errorType = AuthError.UserNotFound;
        break;
      case 'The password is invalid or the user does not have a password.':
        errorType = AuthError.PasswordNotValid;
        break;
      case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
        errorType = AuthError.NetworkError;
        break;
      default:
        errorType = AuthError.Other;
    }
  } else if (Platform.isIOS) {
    switch (e.code) {
      case 'Error 17011':
        errorType = AuthError.UserNotFound;
        break;
      case 'Error 17009':
        errorType = AuthError.PasswordNotValid;
        break;
      case 'Error 17020':
        errorType = AuthError.NetworkError;
        break;
      default:
        errorType = AuthError.Other;
    }
  }
  return errorType;
}
