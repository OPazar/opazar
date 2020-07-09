import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:opazar/screens/product_page.dart';

class DealerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen,
      appBar: AppBar(
        title: Text("ÇiftlikName"),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: "https://www.bakarafarm.com/upload/makale/ciftlik-nedir42398608.jpg",
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  CircularProgressIndicator(value: downloadProgress.progress),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  "Çiftlik Adı",
                  style: TextStyle(fontSize: 40),
                ),
                Row(
                  children: <Widget>[
                    Text("5"),
                    Icon(
                      Icons.star,
                      color: Colors.black12,
                    ),
                  ],
                ),
              ],
            ),
            Text("slogan"),
            Observer(
              name: " Foto ",
              builder: (_) => SizedBox(
                height: 150,
                child: ListView.builder(
                  shrinkWrap: false,
                  padding: const EdgeInsets.only(left: 32.0),
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        margin: EdgeInsets.all(5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            FotoCard(),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              width: 10,
              height: 20,
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Ürünler"),
                ),
                Icon(MaterialCommunityIcons.store)
              ],
            ),
            SizedBox(
              width: 10,
              height: 10,
            ),
            Observer(
              name: " Fotoürün ",
              builder: (_) => SizedBox(
                height: 250,
                child: GridView.count(
                  shrinkWrap: true,
                  primary: false,
                  padding: EdgeInsets.all(4.0),
                  crossAxisCount: 2,
                  childAspectRatio: (4 / 3),
                  children: List.generate(10, (index) => ProductCard()),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    _settingModalBottomSheet(context);
                  },
                  color: Colors.greenAccent,
                  shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Container(
                    child: Text("Yorumlar"),
                  ),
                ),
                IconButton(icon: Icon(MaterialCommunityIcons.heart_off), onPressed: () {}),
                IconButton(icon: Icon(MaterialCommunityIcons.heart_multiple), onPressed: () {})
              ],
            ),
          ],
        ),
      ),
    );
  }

// burdaki yorumları hallettikten sonra üründekine bakarıs
  void _settingModalBottomSheet(context) {
    List<Comment> comments = List<Comment>();
    comments.add(Comment(
        buyerName: 'hazal',
        content: "güzel deyil",
        buyerImageUrl: "https://i.pinimg.com/736x/9b/3d/e7/9b3de7b0ccb90881dbb5c213bb47cec1.jpg"));
    comments.add(Comment(
        buyerName: 'lale',
        content: "güzel lan gevşek karı biz yaptık    ",
        buyerImageUrl: "https://i.pinimg.com/736x/9b/3d/e7/9b3de7b0ccb90881dbb5c213bb47cec1.jpg"));
    comments.add(Comment(
        buyerName: 'arzu',
        content: "olum üşendim pp koymaya kb ",
        buyerImageUrl: "https://i.pinimg.com/736x/9b/3d/e7/9b3de7b0ccb90881dbb5c213bb47cec1.jpg"));
    comments.add(Comment(
        buyerName: 'merokmen',
        content: "fazla karakterde aşağı inmiyo düz devam ediyo !!! ",
        buyerImageUrl: "https://i.pinimg.com/736x/9b/3d/e7/9b3de7b0ccb90881dbb5c213bb47cec1.jpg"));
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Wrap(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(2),
                child: TextFormField(
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(30),
                  ],
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    icon: Icon(Icons.comment),
                    hintText: '',
                    labelText: 'Yorum Yap',
                  ),
                  onSaved: (String value) {},
                ),
              ),
              Container(
                margin: EdgeInsets.all(5),
                height: 300,
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.greenAccent, width: 2.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListView(
                  children: List.generate(comments.length, (index) => CommitCard(comments[index])),
                ),
              ),
            ],
          );
        });
  }
}

class ProductCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: Stack(
        children: <Widget>[
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductPage()),
                );
              },
              child: Column(
                children: <Widget>[
                  CachedNetworkImage(
                    width: 150,
                    imageUrl: "https://i.sozcu.com.tr/wp-content/uploads/2017/02/yumurta-sari.jpg",
                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                        CircularProgressIndicator(value: downloadProgress.progress),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  SizedBox(width: 5, height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text("Product name"),
                      Text("₺price"),
                    ],
                  ),
                  Text(
                    "Satın Al",
                    style: TextStyle(color: Colors.blue),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FotoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //_showSecondPage(context); //heroAnimation
      },
      child: Container(
        width: 150,
        height: 100,
        child: CachedNetworkImage(
          width: 100,
          imageUrl: "https://i.sozcu.com.tr/wp-content/uploads/2017/02/yumurta-sari.jpg",
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              CircularProgressIndicator(value: downloadProgress.progress),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }
}

class CommitCard extends StatelessWidget {
  Comment comment;

  CommitCard(this.comment);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        Row(
          children: <Widget>[
            CircleAvatar(
              radius: 15,
              backgroundColor: Color(0xffFDCF09),
              child: CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(comment.buyerImageUrl),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              child: Text(
                comment.content,
                maxLines: 2,
              ),
              decoration: BoxDecoration(
                  color: Colors.greenAccent, borderRadius: BorderRadius.all(Radius.circular(10))),
            )
          ],
        )
      ],
    );
  }
}

class Comment {
  String content;
  double rate;
  String buyerName;
  String buyerImageUrl;

  Comment({this.content, this.rate, this.buyerName, this.buyerImageUrl});
}
/*void _showSecondPage(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (ctx) => Scaffold(
        body: Center(
          child: Hero(
            tag: 'current foto',
            child: CachedNetworkImage(
              width: 100,
              imageUrl:
              "https://i.sozcu.com.tr/wp-content/uploads/2017/02/yumurta-sari.jpg",
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  CircularProgressIndicator(value: downloadProgress.progress),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        ),
      ),
    ),
  );
}*/
