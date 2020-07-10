import 'package:cached_network_image/cached_network_image.dart';
import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:opazar/models/User.dart';
import 'package:opazar/screens/dealer_page.dart';

import '../main.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('data'),
      ),
      drawer: DrawerBar(),
      body: Container(),
    );
  }
}

class DrawerBar extends StatelessWidget {
  Widget buildDrawerHeader({User user, bool done = true}) {
    if (!done) {
      user = User();
    }
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
                  user.name,
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
        color: Colors.blue,
      ),
    );
  }

  final Widget drawerContent = ListView(
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

  Widget buildDrawerBottomBar(BuildContext context, {bool isSignedId}) {
    return Container(
      padding: EdgeInsets.all(8.0),
      width: double.infinity,
      color: Colors.blue,
      child: RaisedButton.icon(
          onPressed: () {
            if (isSignedId) {
              auth.signOut(); // deneme amaçlı yapıldı
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => TempPage())); // deneme amaçlı yapıldı
            }
          },
          icon: Icon(FlutterIcons.exit_to_app_mdi),
          label: Text('Çıkış')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          EnhancedFutureBuilder(
            future: auth.currentUserDetails(),
            whenDone: (snapshotData) => buildDrawerHeader(user: snapshotData),
            whenNotDone: buildDrawerHeader(done: false),
            rememberFutureResult: true,
          ),
          Expanded(child: drawerContent),
          EnhancedFutureBuilder(
            future: auth.currentUser(),
            whenDone: (snapshotData) => buildDrawerBottomBar(context, isSignedId: true),
            whenNotDone: buildDrawerBottomBar(context, isSignedId: false),
            rememberFutureResult: true,
          ),
        ],
      ),
    );
  }
}
