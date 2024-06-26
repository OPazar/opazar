import 'package:cloud_firestore/cloud_firestore.dart';

class Dealer {
  String uid;

  String name;
  String imageUrl;
  List<dynamic> showcaseImageUrls;
  String slogan;
  DocumentReference referance;

  Dealer({this.uid, this.name, this.imageUrl,this.showcaseImageUrls,this.slogan});

  factory Dealer.fromMap(Map data) {
    data = data ?? {};
    return Dealer(
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      showcaseImageUrls: data['showcaseImageUrls'] ?? [],
      slogan: data['slogan'] ?? '',
    );
  }

  factory Dealer.fromSnapshot(DocumentSnapshot snapshot){
    var data = snapshot.data;
    return Dealer(
      uid: snapshot.documentID ?? '',
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      showcaseImageUrls: data['showcaseImageUrls'] ?? [],
      slogan: data['slogan'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'showcaseImageUrls': showcaseImageUrls,
      'slogan': slogan,
    };
  }
}
