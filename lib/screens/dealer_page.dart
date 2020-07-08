import 'package:async_builder/async_builder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:opazar/models/Comment.dart';
import 'package:provider/provider.dart';

import 'package:opazar/models/Dealer.dart';
import 'package:opazar/models/Product.dart';
import 'package:opazar/services/db.dart';

class DealerPage extends StatefulWidget {
  @override
  _DealerPageState createState() => _DealerPageState();
}

var db = DatabaseService();
final dealerId = 'QFvm25W7Zrtj25Tj3DR2';

class _DealerPageState extends State<DealerPage> {
  @override
  Widget build(BuildContext context) {
    var dealerStream = db.streamDealer(dealerId);
    var detailProvider = StreamProvider<Dealer>.value(
      value: dealerStream,
      child: AsyncBuilder<Dealer>(
        stream: dealerStream,
        waiting: (context) => Text('Loading...'),
        builder: (context, value) => DealerDetails(dealer: value),
        error: (context, error, stackTrace) => Text('Error! $error'),
        closed: (context, value) => Text('$value (closed)'),
      ),
    );

    var showcaseProvider = StreamProvider<Dealer>.value(
      value: dealerStream,
      child: AsyncBuilder<Dealer>(
        stream: dealerStream,
        waiting: (context) => Text('Loading...'),
        builder: (context, value) => DealerShowcase(images: value.showcaseImageUrls),
        error: (context, error, stackTrace) => Text('Error! $error'),
        closed: (context, value) => Text('$value (closed)'),
      ),
    );

    var productsStream = db.streamProducts(dealerId);
    var productsProvider = StreamProvider<List<Product>>.value(
      value: productsStream,
      child: AsyncBuilder<List<Product>>(
        stream: productsStream,
        waiting: (context) => Text('Loading...'),
        builder: (context, value) => DealerProducts(products: value),
        error: (context, error, stackTrace) => Text('Error! $error'),
        closed: (context, value) => Text('$value (closed)'),
      ),
    );

    return Scaffold(
        body: Container(
      child: ListView(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[
          detailProvider,
          showcaseProvider,
          productsProvider,
        ],
      ),
    ));
  }
}

class DealerDetails extends StatelessWidget {
  final Dealer dealer;

  DealerDetails({
    Key key,
    this.dealer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var dealerImage = CachedNetworkImage(
      imageUrl: dealer.imageUrl,
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
      dealer.name,
      style: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.w600,
      ),
    );
    var dealerSlogan = Text(
      dealer.slogan,
      style: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w400,
      ),
    );

    var dealerRate = RawMaterialButton(
      onPressed: () {
        var commentsStream = db.streamDealerComments(dealerId);
        return StreamProvider<List<Comment>>.value(
          value: commentsStream,
          child: AsyncBuilder<List<Comment>>(
            stream: commentsStream,
            waiting: (context) => Text('Loading...'),
            builder: (context, value) => _commentsBottomSheet(context, value),
            error: (context, error, stackTrace) => Text('Error! $error'),
            closed: (context, value) => Text('$value (closed)'),
          ),
        );
      },
      child: Container(
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
}

class DealerShowcase extends StatelessWidget {
  final List<dynamic> images;

  const DealerShowcase({
    Key key,
    this.images,
  }) : super(key: key);

  Widget gridViewItem(String imageUrl) {
    return Container(
      height: 150,
      width: 150,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var showcase = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      primary: true,
      physics: ScrollPhysics(),
      child: Row(
        children: List.generate(
            images.length,
            (index) => Container(
                child: gridViewItem(images[index]), padding: EdgeInsets.only(right: 8.0))),
      ),
    );

    return Container(
      child: showcase,
      padding: EdgeInsets.all(8.0),
    );
  }
}

class DealerProducts extends StatelessWidget {
  final List<Product> products;

  const DealerProducts({
    this.products,
  });
  @override
  Widget build(BuildContext context) {
    Widget productItem(Product product) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.lightGreen[400],
        ),
        height: 250.0,
        margin: EdgeInsets.all(8.0),
        child: RawMaterialButton(
          onPressed: () {},
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  height: 130,
                  child: CachedNetworkImage(
                    imageUrl: product.imageUrl,
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
                            Text(product.name),
                            Text('${product.unit} ${product.price} ₺'),
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
    }

    if (products != null && products.length > 0) {
      return GridView.count(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        primary: false,
        padding: EdgeInsets.all(4.0),
        crossAxisCount: 2,
        childAspectRatio: (8 / 9),
        children: List.generate(products.length, (index) => productItem(products[index])),
      );
    } else {
      return Text('enought product');
    }
  }
}

_commentsBottomSheet(context, List<Comment> comments) {
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

class CommitCard extends StatelessWidget {
  final Comment comment;

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
                backgroundImage: NetworkImage(
                    'https://i.pinimg.com/736x/9b/3d/e7/9b3de7b0ccb90881dbb5c213bb47cec1.jpg'),
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
