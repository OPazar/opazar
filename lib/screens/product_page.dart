
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'dealer_page.dart';



class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  double siparis = 0;
  double sonSiparis = 0;

  double adetFiyati = 3.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.lightBlueAccent, width: 5)),
            child: CachedNetworkImage(
              imageUrl:
                  "https://i.sozcu.com.tr/wp-content/uploads/2017/02/yumurta-sari.jpg",
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  CircularProgressIndicator(value: downloadProgress.progress),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          Container(
            color: Colors.lightBlueAccent,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 40,
                  child: Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          child: Text(
                            " Setan Çiftlik ",
                            style:
                                TextStyle(color: Colors.purple, fontSize: 30),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DealerPage()),
                            );
                          },
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        Row(
                          children: <Widget>[
                            Text("5"),
                            Icon(
                              Icons.star,
                              color: Colors.yellow,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text("Yumurta"),
                    RaisedButton(
                      onPressed: () {},
                      child: Text("₺3,5 Adet"),
                      color: Colors.greenAccent,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 12,
            child: Container(
              color: Colors.black26,
            ),
          ),
          Container(
            child: Text(
              "Sipariş Ver",
              style: TextStyle(color: Colors.purple, fontSize: 25),
            ),
            alignment: Alignment.centerLeft,
          ),
          SizedBox(
            height: 12,
            child: Container(
              color: Colors.black26,
            ),
          ),
          Container(
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              color: Colors.yellow,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                    iconSize: 36,
                    icon: Icon(FlutterIcons.minus_ant),
                    onPressed: () {
                      setState(() {
                        if (siparis > 0) siparis--;
                        if (sonSiparis > 0)
                          sonSiparis = sonSiparis - adetFiyati;
                      });
                    }),
                Text(
                  siparis.toString() + " adet",
                  style: TextStyle(fontSize: 30),
                ),
                IconButton(
                    iconSize: 36,
                    icon: Icon(Icons.add_circle),
                    onPressed: () {
                      setState(() {
                        if (siparis < 100) siparis++;
                        sonSiparis = siparis * adetFiyati;
                      });
                    }),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Text("Ücret"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(sonSiparis.toString() + " ₺"),
              ),
            ],
          ),
          RaisedButton(
            onPressed: () {
              //ödeme sayfası
            },
            color: Colors.red,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text("Alışverişi Tamamla"),
                Icon(Icons.shopping_cart),
              ],
            ),
          ),
          SizedBox(height: 60,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  _settingModalBottomSheet(context);
                },
                color: Colors.greenAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Container(
                  child: Text("Yorumlar"),
                ),
              ),


              Column(
                children: <Widget>[
                  IconButton(
                      icon: Icon(MaterialCommunityIcons.heart_multiple),
                      onPressed: () {}),
                  Text("(98)")
                ],
              )
            ],
          ),
        ],
      ),

    );
  }
  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: 300,
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue, width: 2.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ListView(
              children: <Widget>[
                ListTile(title: Text('yorumlar kısmı')),
              ],
            ),
          );
        });
  }
}
