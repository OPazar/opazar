import 'package:async_builder/async_builder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:opazar/main.dart';
import 'package:opazar/models/Comment.dart';
import 'package:opazar/models/Dealer.dart';
import 'package:opazar/models/Product.dart';
import 'package:opazar/models/User.dart';
import 'package:opazar/services/auth.dart';
import 'package:opazar/services/db.dart';

Dealer _dealer;

class DealerPage extends StatefulWidget {
  Dealer dealer;

  DealerPage({@required this.dealer});

  @override
  _DealerPageState createState() => _DealerPageState();
}

var db = DatabaseService();
var auth = AuthService();

class _DealerPageState extends State<DealerPage> {
  @override
  Widget build(BuildContext context) {
    _dealer = widget.dealer;

    var productsBuilder = EnhancedFutureBuilder<List<Product>>(
      future: db.getProducts(widget.dealer.uid),
      rememberFutureResult: false,
      whenDone: (snapshotData) => DealerProducts(products: snapshotData),
      whenNotDone: Text('Loading'),
      whenError: (error) => Text('Error! $error'),

    );

    return Scaffold(
        appBar: AppBar(title: Text(widget.dealer.name)),
        body: Container(
          child: ListView(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            children: <Widget>[
              Column(
                children: <Widget>[
                  DealerDetails(dealer: widget.dealer),
                  DealerShowcase(images: widget.dealer.showcaseImageUrls)
                ],
              ),
              productsBuilder,
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

    var dealerRate = Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
      child: RawMaterialButton(
        onPressed: () {
          _settingModalBottomSheet(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Yorumlar',
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
        Container(
            height: 250.0,
            width: double.infinity,
            color: Colors.blue,
            child: dealerImage),
        Container(
            width: double.infinity,
            padding: EdgeInsets.all(8.0),
            child: dealerName),
        Container(
            width: double.infinity,
            padding: EdgeInsets.all(8.0),
            child: dealerSlogan),
        Container(
            width: double.infinity,
            padding: EdgeInsets.all(8.0),
            child: dealerRate),
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
        placeholder: (context, url) =>
            Center(child: CircularProgressIndicator()),
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
                child: gridViewItem(images[index]),
                padding: EdgeInsets.only(right: 8.0))),
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
          color: Colors.grey[300],
        ),
        height: 250.0,
        margin: EdgeInsets.all(8.0),
        child: RawMaterialButton(
          onPressed: () {
            auth.signOut(); // deneme amaçlı yapıldı
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => TempPage())); // deneme amaçlı yapıldı
          },
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
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
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
                                Icon(Icons.star,
                                    size: 20, color: Colors.yellow[800]),
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
        children: List.generate(
            products.length, (index) => productItem(products[index])),
      );
    } else {
      return Text('enought product');
    }
  }
}

_settingModalBottomSheet(context) {
  var commentsBuilder = EnhancedFutureBuilder<List<Comment>>(
      future: db.getDealerComments(_dealer.uid),
      rememberFutureResult: false,
      whenDone: (snapshotData) => CommentCardList(comments: snapshotData),
      whenNotDone: null);

  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Column(children: <Widget>[
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
                labelText: 'Yorum Yap',
              ),
              onSaved: (String value) {},
            ),
          ),
          commentListBuilder,
        ]);
      });
}

class CommentCard extends StatelessWidget {
  final Comment comment;
  final User user;

  CommentCard(this.comment, this.user);

  @override
  Widget build(BuildContext context) {
    // print('user: ${user.toMap()}');
    return Container(
      child: Row(
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(left: 10.0),
              width: 50,
              height: 50,
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
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Icon(Icons.error),
              )),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 50.0,
                ),
                child: Text(
                    '${user.name}:\n${comment.content}\npuanım: ${comment.rate}'),
              ),
              decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
          )
        ],
      ),
    );
  }
}

class CommentCardList extends StatelessWidget {
  final List<Comment> comments;

  const CommentCardList({
    Key key,
    @required this.comments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: List.generate(comments.length, (index) {
        var currentComment = comments[index];
        return AsyncBuilder<User>(
          future: db.getUser(currentComment.buyerUid),
          waiting: (context) => Text('Loading...'),
          builder: (context, value) => CommentCard(currentComment, value),
          error: (context, error, stackTrace) => Text('Error! $error'),
          closed: (context, value) => Text('$value (closed)'),
        );
      }),
    );
  }
}
