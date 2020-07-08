import 'package:cloud_firestore/cloud_firestore.dart';

class Dealer {
  String get uid => _uid;
  String _uid;

  String name;
  String imageUrl;
  DocumentReference referance;

  Dealer({uid, this.name, this.imageUrl}) : this._uid = uid;

  factory Dealer.fromMap(Map data) {
    data = data ?? {};
    return Dealer(
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }

  factory Dealer.fromSnapshot(DocumentSnapshot snapshot){
    var data = snapshot.data;
    return Dealer(
      uid: snapshot.documentID ?? '',
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
    };
  }
}
