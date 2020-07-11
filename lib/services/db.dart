import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:opazar/models/Category.dart';
import 'package:opazar/models/Comment.dart';
import 'package:opazar/models/Dealer.dart';
import 'package:opazar/models/Product.dart';
import 'package:opazar/models/User.dart';
import 'package:opazar/services/initializer.dart';
import 'package:opazar/widgets/products_grid_view.dart';

class DatabaseService {
  static final DatabaseService _databaseService = DatabaseService._internal();

  factory DatabaseService(){
    return _databaseService;
  }

  DatabaseService._internal();

  final Firestore _db = Firestore.instance;

  //get product
  Future<Product> getProduct(String dealerId, String productId) async {
    try {
      var documentSnapshot =
          await _db.collection('dealers').document(dealerId).collection('products').document(productId).get();

      return Product.fromSnapshot(documentSnapshot);
    } catch (e) {
      return Future.error(e);
    }
  }

  //get products
  Future<List<Product>> getProducts(String dealerId) async {
    try {
      var querySnapshot = await _db.collection('dealers').document(dealerId).collection('products').getDocuments();

      var documentSnapshotList = querySnapshot.documents;

      if (documentSnapshotList.length > 0) {
        return List.generate(documentSnapshotList.length, (index) => Product.fromSnapshot(documentSnapshotList[index]));
      } else {
        return Future.error(DBError.noItems);
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  //get dealer
  Future<Dealer> getDealer(String dealerId) async {
    try {
      var documentSnapshot = await _db.collection('dealers').document(dealerId).get();
      return Dealer.fromSnapshot(documentSnapshot);
    } catch (e) {
      return Future.error(e);
    }
  }

  //get dealers
  Future<List<Dealer>> getDealers() async {
    try {
      var querySnapshot = await _db.collection('dealers').getDocuments();

      var documentSnapshotList = querySnapshot.documents;

      if (documentSnapshotList.length > 0) {
        return List.generate(documentSnapshotList.length, (index) => Dealer.fromSnapshot(documentSnapshotList[index]));
      } else {
        return Future.error(DBError.noItems);
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<DaP>> getAllProducts() async {
    List<DaP> dapList = List<DaP>();
    var categories = Initializer().categories;

    try {
      var dealers = await getDealers();
      if (dealers.length > 0) { // satıcı varsa
        for (Dealer dealer in dealers) {
          var products = await getProducts(dealer.uid);
          if (products.length > 0) { // satıcının ürünü varsa
            for (Product product in products) {
              for (var category in categories) {
                if (product.categoryUid == category.uid) { //ürün kategorisi kategorilerde varsa
                  var dap = DaP(dealer: dealer, product: product, category: category);
                  dapList.add(dap);
                  break;
                }
              }
            }
          } else {
            return Future.error(DBError.noItems);
          }
        }
        return dapList;
      } else {
        return Future.error(DBError.noItems);
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  //get comments in dealer
  Future<List<Comment>> getDealerComments(String dealerId) async {
    try {
      var querySnapshot = await _db.collection('dealers').document(dealerId).collection('comments').getDocuments();
      var documentSnapshotList = querySnapshot.documents;

      if (documentSnapshotList.length > 0) {
        return List.generate(documentSnapshotList.length, (index) => Comment.fromSnapshot(documentSnapshotList[index]));
      } else {
        return Future.error(DBError.noItems);
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  //get comments in product
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
        return List.generate(documentSnapshotList.length, (index) => Comment.fromSnapshot(documentSnapshotList[index]));
      } else {
        return Future.error(DBError.noItems);
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  //get user
  Future<User> getUser(String userId) async {
    try {
      var snapshot = await _db.collection('users').document(userId).get();
      return User.fromSnapshot(snapshot);
    } catch (e) {
      return Future.error(e);
    }
  }

  //create user details
  Future<bool> setUserDetails(String userId, User user) async {
    try {
      await _db.collection('users').document(userId).setData(user.toMap());
      return true;
    } catch (e) {
      return Future.error(e);
    }
  }

  //get categories
  Future<List<Category>> getCategories() async {
    try {
      var querySnapshot = await _db.collection('categories').getDocuments();

      var documentSnapshotList = querySnapshot.documents;

      if (documentSnapshotList.length > 0) {
        return List.generate(
            documentSnapshotList.length, (index) => Category.fromSnapshot(documentSnapshotList[index]));
      } else {
        return Future.error(DBError.noItems);
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}

enum DBError {
  noItems,
}
