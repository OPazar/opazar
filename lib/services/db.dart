import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:opazar/models/Comment.dart';
import 'package:opazar/models/Dealer.dart';
import 'package:opazar/models/Product.dart';

class DatabaseService {
  final Firestore _db = Firestore.instance;

  //get product
  Stream<Product> streamProduct(String dealerId, String productId) {
    return _db
        .collection('dealers')
        .document(dealerId)
        .collection('products')
        .document(productId)
        .snapshots()
        .map((snapshot) => Product.fromSnapshot(snapshot));
  }

  //get products
  Stream<List<Product>> streamProducts(String dealerId) {
    var ref = _db.collection('dealers').document(dealerId).collection('products');
    return ref.snapshots().map((list) => 
        list.documents.map((snapshot) => Product.fromSnapshot(snapshot)).toList());
  }

  //get dealer
  Stream<Dealer> streamDealer(String dealerId) {
    return _db
        .collection('dealers')
        .document(dealerId)
        .snapshots()
        .map((snapshot) => Dealer.fromSnapshot(snapshot));
  }

  //get dealers
  Stream<List<Dealer>> streamDealers() {
    var ref = _db.collection('dealers');
    return ref.snapshots().map((list) => 
        list.documents.map((snapshot) => Dealer.fromSnapshot(snapshot)).toList());
  }

  //get comments in dealer
  Stream<List<Comment>> streamDealerComments(String dealerId) {
    var ref = _db.collection('dealers').document(dealerId).collection('comments');
    return ref.snapshots().map((list) => 
        list.documents.map((snapshot) => Comment.fromSnapshot(snapshot)).toList());
  }

  //get comments in product
  Stream<List<Comment>> streamProductComments(String dealerId, String productId) {
    var ref = _db
    .collection('dealers')
    .document(dealerId)
    .collection('products')
    .document(productId)
    .collection('comments');
    return ref.snapshots().map((list) => 
        list.documents.map((snapshot) => Comment.fromSnapshot(snapshot)).toList());
  }
}
