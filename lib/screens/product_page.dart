import 'package:cached_network_image/cached_network_image.dart';
import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:opazar/models/Comment.dart';
import 'package:opazar/models/User.dart';
import 'package:opazar/screens/dealer_page.dart';
import 'package:opazar/services/db.dart';
import 'package:opazar/widgets/products_grid_view.dart';

DaP _dap;

class ProductPage extends StatefulWidget {
  ProductPage({@required dap}) {
    _dap = dap;
  }

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_dap.product.name)),
      body: ProductDetails(),
    );
  }
}

class ProductDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var productImage = CachedNetworkImage(
      imageUrl: _dap.product.imageUrl,
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

    var productName = Text(
      _dap.product.name,
      style: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.w600,
      ),
    );

    var productRate = RawMaterialButton(
      onPressed: () {
        _settingModalBottomSheet(context);
      },
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
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

    var productDealer = RawMaterialButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => DealerPage(dealer: _dap.dealer)));
      },
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 32,
              width: 32,
              child: CachedNetworkImage(
                imageUrl: _dap.dealer.imageUrl,
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
            SizedBox(width: 5.0),
            Text(
              '${_dap.dealer.name}',
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );

    var productPrice = Text(
      '${_dap.product.price} ₺/${_dap.product.unit}',
      style: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.normal,
      ),
    );

    var productCategory = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '${_dap.category.name}',
            style: TextStyle(fontSize: 18.0),
          ),
        ],
      ),
    );

    return Column(
      children: <Widget>[
        Container(height: 250.0, width: double.infinity, color: Colors.blue, child: productImage),
        Container(
          margin: EdgeInsets.only(top: 8.0),
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[productName, productCategory],
              ),
              productPrice
            ],
          ),
        ),
        Container(width: double.infinity, padding: EdgeInsets.all(8.0), child: productRate),
//        Container(
//            width: double.infinity, alignment: Alignment.center, padding: EdgeInsets.all(8.0), child: productPrice),
        Container(width: double.infinity, padding: EdgeInsets.all(8.0), child: productDealer),
      ],
    );
  }
}

var db = DatabaseService();

_settingModalBottomSheet(context) {
  var commentsBuilder = EnhancedFutureBuilder<List<Comment>>(
      future: db.getProductComments(_dap.dealer.uid, _dap.product.uid),
      rememberFutureResult: false,
      whenDone: (snapshotData) => CommentCardList(comments: snapshotData),
      whenNotDone: Center(child: CircularProgressIndicator()),
      whenError: (error) => Text('Henüz yorum yok aq'));
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
          commentsBuilder
        ]);
      });
}

class CommentCard extends StatelessWidget {
  final Comment comment;
  final User user;

  CommentCard({this.comment, this.user});

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
                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
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
                child: Text('${user.name} ${user.sureName}:\n${comment.content}\npuanım: ${comment.rate}'),
              ),
              decoration: BoxDecoration(color: Colors.greenAccent, borderRadius: BorderRadius.all(Radius.circular(10))),
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
        return EnhancedFutureBuilder<User>(
          future: db.getUser(currentComment.buyerUid),
          rememberFutureResult: false,
          whenDone: (snapshotData) => CommentCard(comment: currentComment, user: snapshotData),
          whenNotDone: Text('Loading...'),
          whenError: (error) => Text('Error! $error'),
        );
      }),
    );
  }
}
