import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String get uid => _uid;
  String _uid;

  String name;
  String imageUrl;
  String email;

  DocumentReference referance;

  User({uid, this.name, this.imageUrl, this.email}) : this._uid = uid;

  factory User.fromMap(Map data) {
    data = data ?? {};
    return User(
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      email: data['email'] ?? 0,
    );
  }

  factory User.fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data;
    return User(
      uid: snapshot.documentID ?? '',
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      email: data['email'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'imageUrl': imageUrl,
    };
  }
}
