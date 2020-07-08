import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DealerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.lightGreen,
        appBar: AppBar(
          title: Text("ÇiftlikName"),
        ),
        body: Container(
          child: ListView(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            children: <Widget>[
              buildDealerDetails(),
              buildDealerShowcase(),
              buildDealerProducts(),
            ],
          ),
        ));
  }

  Widget buildDealerDetails() {
    var dealerImage = CachedNetworkImage(
      imageUrl: "http://via.placeholder.com/200x150",
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );

    var dealerName = Text(
      'Çiftlik Adı',
      style: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.w600,
      ),
    );
    var dealerSlogan = Text(
      'Çiftlik Sloganı',
      style: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w400,
      ),
    );

    var dealerRate = Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Değerlendirmeler',
            style: TextStyle(fontSize: 18.0),
          ),
          Row(
            children: <Widget>[
              Text(
                '5',
                style: TextStyle(fontSize: 18.0),
              ),
              Icon(Icons.star, color: Colors.yellow[800], size: 32.0),
            ],
          ),
        ],
      ),
    );

    return Column(
      children: <Widget>[
        Container(height: 250.0, width: double.infinity, color: Colors.blue, child: dealerImage),
        Container(width: double.infinity, padding: EdgeInsets.all(8.0), child: dealerName),
        Container(width: double.infinity, padding: EdgeInsets.all(8.0), child: dealerSlogan),
        Container(width: double.infinity, padding: EdgeInsets.all(8.0), child: dealerRate),
      ],
    );
  }

  Widget buildDealerShowcase() {
    var tempImage = Container(
      height: 150,
      width: 150,
      color: Colors.blue,
    );

    var showcase = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      primary: true,
      physics: ScrollPhysics(),
      child: Row(
        children: List.generate(5, (_) => Container(child: tempImage,padding: EdgeInsets.only(right: 8.0))),
      ),
    );

    return Container(child: showcase,padding: EdgeInsets.all(8.0),);
  }

  Widget buildDealerProducts(){
    var productItem = Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.grey[350],
        ),
        height: 250.0,
        margin: EdgeInsets.all(8.0),
        child: RawMaterialButton(
          onPressed: () {  },
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  height: 130,
                  child: CachedNetworkImage(
                    imageUrl: 'http://via.placeholder.com/200x150',
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      // height: 130,
                    ),
                    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Ürün Adı'),
                            Text('kg 5₺'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            SizedBox(),
                            Row(
                              children: <Widget>[
                                Text('5'),
                                Icon(Icons.star, size: 20, color: Colors.yellow[800]),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    
    return GridView.count(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        primary: false,
        padding: EdgeInsets.all(4.0),
        crossAxisCount: 2,
        childAspectRatio: (8 / 9),
        children: List.generate(5, (index) => productItem),
      );
  }
}
