import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String get uid => _uid;
  String _uid;

  String name;
  String sureName;
  String imageUrl;
  String email;

  DocumentReference referance;

  User({uid, this.name, this.sureName, this.imageUrl, this.email}) : this._uid = uid;

  factory User.fromMap(Map data) {
    data = data ?? {};
    return User(
      name: data['name'] ?? '',
      sureName: data['sureName'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      email: data['email'] ?? 0,
    );
  }

  factory User.fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data;
    return User(
      uid: snapshot.documentID ?? '',
      name: data['name'] ?? '',
      sureName: data['sureName'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      email: data['email'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name ?? '',
      'sureName': sureName ?? '',
      'email': email ?? '',
      'imageUrl': imageUrl ?? '',
    };
  }
}
