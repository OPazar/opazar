import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:opazar/screens/dealer_page.dart';
import 'package:opazar/screens/product_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HomePage"),
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Center(
                  child: Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 58,
                    backgroundColor: Colors.greenAccent,
                    backgroundImage: NetworkImage(
                        "https://i.pinimg.com/originals/fd/e0/b2/fde0b24c55a7e84bdbf5d5a89fa9607c.jpg"),
                  ),
                  Container(margin: EdgeInsets.all(8.0),child: Text("meric setan"))
                ],
              )),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('selam'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/messages');
              },
            ),
            ListTile(
              title: Text('ayarlar'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ],
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 100.0,
                floating: false,
                pinned: false,
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    background: Image.network(
                      "https://logos.flamingtext.com/City-Logos/Logo-Design-Pazar.png",
                      fit: BoxFit.cover,
                    )),
              ),
              //çok fazla kaydırma var aga ya aklıma bir şey gelmedi
              //bende yatıyom artık
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    labelColor: Colors.black87,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(
                          icon: Icon(
                            FlutterIcons.earlybirds_faw5d,
                          ),
                          text: "Kümes"),
                      Tab(
                        icon: Icon(FlutterIcons.cow_mco),
                        text: "Süt ve Süt Ürünleri",
                      ),
                      //KATEGORİLERİ BİZ SEÇECEİĞİMİZ İÇİN EKLERİZ DİYE DÜŞÜNDÜM
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            children: [
              DealerPage(),
              ProductPage(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
//dsadas
