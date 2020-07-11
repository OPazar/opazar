import 'package:cloud_firestore/cloud_firestore.dart';

class Category {

  String uid;
  String name;

  DocumentReference referance;

  Category({this.uid, this.name});

  factory Category.fromMap(Map data) {
    data = data ?? {};
    return Category(
      name: data['name'] ?? '',
    );
  }

  factory Category.fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data;
    return Category(
      uid: snapshot.documentID ?? '',
      name: data['name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name
    };
  }
}
