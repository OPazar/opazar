import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String get uid => _uid;
  String _uid;

  String name;
  String imageUrl;
  double price;
  String unit;
  DocumentReference referance;

  Product({uid, this.name, this.imageUrl, this.price, this.unit}) : this._uid = uid;

  factory Product.fromMap(Map data) {
    data = data ?? {};
    return Product(
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      price: data['price'].toDouble() ?? 0,
      unit: data['unit'] ?? '',
    );
  }

  factory Product.fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data;
    return Product(
      uid: snapshot.documentID,
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      price: data['price'].toDouble() ?? 0,
      unit: data['unit'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'unit': unit,
    };
  }
}
