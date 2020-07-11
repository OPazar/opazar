import 'package:opazar/models/Category.dart';
import 'package:opazar/models/User.dart';
import 'package:opazar/services/auth.dart';
import 'package:opazar/services/db.dart';

class Initializer{
  static final Initializer _initializer = Initializer._internal();

  factory Initializer(){
    return _initializer;
  }

  Initializer._internal();

  User currentUser;
  List<Category> categories;

  AuthService _auth = AuthService();
  DatabaseService _db = DatabaseService();

  Future<void> load() async {
    currentUser = await _auth.currentUserDetails();
    categories = await _db.getCategories();
  }
}