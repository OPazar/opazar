import 'package:cached_network_image/cached_network_image.dart';
import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:opazar/enums/status.dart';
import 'package:opazar/models/Category.dart';
import 'package:opazar/screens/dealer_page.dart';
import 'package:opazar/services/db.dart';
import 'package:opazar/services/initializer.dart';
import 'package:opazar/widgets/products_list_view.dart';

import '../main.dart';

DatabaseService db = DatabaseService();
Initializer initializer = Initializer();

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var title = 'Tüm Ürünler';
  var productsFuture = db.getAllProducts();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      drawer: DrawerBar(setCategory: (category) {
        setState(() {
          if (category != null) {
            title = category.name;
            productsFuture = db.getProductsWithCategory(category.uid);
          } else {
            title = 'Tüm Ürünler';
            productsFuture = db.getAllProducts();
          }
          Navigator.pop(context);
        });
      }),
      body: EnhancedFutureBuilder(
        future: productsFuture,
        rememberFutureResult: false,
        whenNotDone: ProductsListView(status: Status.waiting),
        whenDone: (snapshotData) => ProductsListView(dapList: snapshotData, status: Status.done),
        whenError: (error) => ProductsListView(status: Status.error),
      ),
    );
  }
}

class DrawerBar extends StatelessWidget {
  final void Function(Category category) setCategory;

  DrawerBar({this.setCategory});

  Widget buildDrawerHeader() {
    var user = initializer.currentUser;
    return DrawerHeader(
      child: Row(
        children: <Widget>[
          Container(
            width: 75,
            height: 75,
            child: Center(
              child: CachedNetworkImage(
                imageUrl: user.imageUrl,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(8.0),
                child: Text(
                  '${user.name} ${user.sureName}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: EdgeInsets.all(8.0),
                child: Text(user.email),
              ),
            ],
          )
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.blueGrey,
      ),
    );
  }

  Widget buildDrawerContent() {
    var categories = initializer.categories;
    var categoriesWidget = List.generate(
        categories.length,
        (index) => ListTile(
              title: Text(categories[index].name),
              onTap: () => setCategory(categories[index]),
            ));
    categoriesWidget.insert(
        0,
        ListTile(
          title: Text('Tüm Ürünler'),
          onTap: () => setCategory(null),
        ));
    return Expanded(
      child: ListView(
        padding: EdgeInsets.zero,
        children: categoriesWidget,
      ),
    );
  }

  Widget buildDrawerBottomBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      width: double.infinity,
      color: Colors.blueGrey,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 2.0),
              child: RaisedButton.icon(
                onPressed: () {},
                icon: Icon(FlutterIcons.setting_ant),
                label: Text('Düzenle'),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 2.0),
              child: RaisedButton.icon(
                onPressed: () {
                  if (initializer.currentUser != null) {
                    auth.signOut(); // deneme amaçlı yapıldı
                  }
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => TempPage())); // deneme amaçlı yapıldı
                },
                icon: Icon(FlutterIcons.exit_to_app_mdi),
                label: Text('Çıkış'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          buildDrawerHeader(),
          buildDrawerContent(),
          buildDrawerBottomBar(context),
        ],
      ),
    );
  }
}
