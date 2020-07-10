import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:opazar/models/Comment.dart';
import 'package:opazar/models/Dealer.dart';
import 'package:opazar/models/Product.dart';
import 'package:opazar/models/User.dart';

class DatabaseService {
  final Firestore _db = Firestore.instance;

  //get product
  // ignore: missing_return
  Future<Product> getProduct(String dealerId, String productId) async {
    try {
      var documentSnapshot = await _db
          .collection('dealers')
          .document(dealerId)
          .collection('products')
          .document(productId)
          .get();

      return Product.fromSnapshot(documentSnapshot);
    } catch (e) {
      Future.error(e);
    }
  }

  //get products
  // ignore: missing_return
  Future<List<Product>> getProducts(String dealerId) async {
    try {
      var querySnapshot =
          await _db.collection('dealers').document(dealerId).collection('products').getDocuments();

      var documentSnapshotList = querySnapshot.documents;

      if (documentSnapshotList.length > 0) {
        return List.generate(documentSnapshotList.length,
            (index) => Product.fromSnapshot(documentSnapshotList[index]));
      } else {
        Future.error(DBError.noItems);
      }
    } catch (e) {
      Future.error(e);
    }
  }

  //get dealer
  // ignore: missing_return
  Future<Dealer> getDealer(String dealerId) async {
    try {
      var documentSnapshot = await _db.collection('dealers').document(dealerId).get();
      return Dealer.fromSnapshot(documentSnapshot);
    } catch (e) {
      Future.error(e);
    }
  }

  //get dealers
  // ignore: missing_return
  Future<List<Dealer>> getDealers() async {
    try {
      var querySnapshot = await _db.collection('dealers').getDocuments();

      var documentSnapshotList = querySnapshot.documents;

      if (documentSnapshotList.length > 0) {
        return List.generate(documentSnapshotList.length,
            (index) => Dealer.fromSnapshot(documentSnapshotList[index]));
      } else {
        Future.error(DBError.noItems);
      }
    } catch (e) {
      Future.error(e);
    }
  }

  //get comments in dealer
  // ignore: missing_return
  Future<List<Comment>> getDealerComments(String dealerId) async {
    try {
      var querySnapshot =
          await _db.collection('dealers').document(dealerId).collection('comments').getDocuments();
      var documentSnapshotList = querySnapshot.documents;

      if (documentSnapshotList.length > 0) {
        return List.generate(documentSnapshotList.length,
            (index) => Comment.fromSnapshot(documentSnapshotList[index]));
      } else {
        Future.error(DBError.noItems);
      }
    } catch (e) {
      Future.error(e);
    }
  }

  //get comments in product
  // ignore: missing_return
  Future<List<Comment>> getProductComments(String dealerId, String productId) async {
    try {
      var querySnapshot = await _db
          .collection('dealers')
          .document(dealerId)
          .collection('products')
          .document(productId)
          .collection('comments')
          .getDocuments();
      var documentSnapshotList = querySnapshot.documents;

      if (documentSnapshotList.length > 0) {
        return List.generate(documentSnapshotList.length,
            (index) => Comment.fromSnapshot(documentSnapshotList[index]));
      } else {
        Future.error(DBError.noItems);
      }
    } catch (e) {
      Future.error(e);
    }
  }

  //get user
  // ignore: missing_return
  Future<User> getUser(String userId) async {
    try {
      var snapshot = await _db.collection('users').document(userId).get();
      return User.fromSnapshot(snapshot);
    } catch (e) {
      Future.error(e);
    }
  }

  //create user details
  // ignore: missing_return
  Future<bool> setUserDetails(String userId, User user) async {
    try {
      await _db.collection('users').document(userId).setData(user.toMap());
      return true;
    } catch (e) {
      Future.error(e);
    }
  }
}

enum DBError {
  noItems,
}
