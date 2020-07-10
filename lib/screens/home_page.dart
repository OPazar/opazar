import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../main.dart';
import '../services/auth.dart';
import '../services/db.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('data'),),
      drawer: _buildDrawer(context),
      body: Container(),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    var drawerHeader = DrawerHeader(
      child: Row(
        children: <Widget>[
          Container(
            width: 75,
            height: 75,
            child: Center(
              child: CachedNetworkImage(
                imageUrl:
                    "https://i.pinimg.com/originals/fd/e0/b2/fde0b24c55a7e84bdbf5d5a89fa9607c.jpg",
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
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(8.0),
                child: Text(
                  "User Name",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: EdgeInsets.all(8.0),
                child: Text("User Email"),
              ),
            ],
          )
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.blue,
      ),
    );

    var drawerContent = ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        ListTile(
          title: Text('Item 1'),
          onTap: () {
            // Update the state of the app.
            // ...
          },
        ),
        ListTile(
          title: Text('Item 2'),
          onTap: () {
            // Update the state of the app.
            // ...
          },
        ),
      ],
    );

    var drawerBottomBar = Container(
      padding: EdgeInsets.all(8.0),
      width: double.infinity,
      color: Colors.blue,
      child: RaisedButton.icon(
          onPressed: () {
            var auth = AuthService();
            var db = DatabaseService();
            var user = auth.currentUser().then((value) {
              db.getUser(value.uid).then((value) => value.imageUrl);
            });
            // auth.signOut(); // deneme amaçlı yapıldı
            // Navigator.pushReplacement(context,
            //     MaterialPageRoute(builder: (context) => TempPage())); // deneme amaçlı yapıldı
          },
          icon: Icon(FlutterIcons.exit_to_app_mdi),
          label: Text('Çıkış')),
    );

    return Drawer(
      child: Column(
        children: <Widget>[
          drawerHeader,
          Expanded(child: drawerContent),
          drawerBottomBar,
        ],
      ),
    );
  }
}
