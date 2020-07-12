import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String uid;

  String name;
  String imageUrl;
  double price;
  String unit;
  String dealerUid;
  String categoryUid;
  DocumentReference referance;

  String get priceText => price.toStringAsFixed(2).replaceAll('.', ',') + ' TL';

  Product({this.uid, this.name, this.imageUrl, this.price, this.unit, this.categoryUid,this.dealerUid});

  factory Product.fromMap(Map data) {
    data = data ?? {};
    return Product(
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      price: data['price'].toDouble() ?? 0,
      unit: data['unit'] ?? '',
      categoryUid: data['categoryUid'] ?? '',
      dealerUid: data['dealerUid'] ?? '',
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
      categoryUid: data['categoryUid'] ?? '',
      dealerUid: data['dealerUid'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'unit': unit,
      'categoryUid': categoryUid,
      'dealerUid': dealerUid,
    };
  }
}
