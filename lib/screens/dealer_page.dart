import 'package:cached_network_image/cached_network_image.dart';
import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:opazar/enums/status.dart';
import 'package:opazar/models/Comment.dart';
import 'package:opazar/models/DaP.dart';
import 'package:opazar/models/Dealer.dart';
import 'package:opazar/services/auth.dart';
import 'package:opazar/services/db.dart';
import 'package:opazar/widgets/comment_bottom_sheet.dart';
import 'package:opazar/widgets/products_list_view.dart';

class DealerPage extends StatefulWidget {
  final Dealer dealer;

  DealerPage({@required this.dealer});

  @override
  _DealerPageState createState() => _DealerPageState();
}

var db = DatabaseService();
var auth = AuthService();

class _DealerPageState extends State<DealerPage> {
  @override
  Widget build(BuildContext context) {

    var productsBuilder = EnhancedFutureBuilder<List<DaP>>(
      future: db.getProducts(widget.dealer),
      rememberFutureResult: false,
      whenDone: (snapshotData) => ProductsListView(dapList: snapshotData,status: Status.done),
      whenNotDone: ProductsListView(dapList: null,status:Status.waiting),
      whenError: (error) => ProductsListView(dapList: null,status:Status.error),
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
          showModalBottomSheet(
            context: context,
            builder: (BuildContext bc) {
              return Column(children: <Widget>[
                EnhancedFutureBuilder<List<Comment>>(
                  future: db.getDealerComments(dealer.uid),
                  rememberFutureResult: true,
                  whenDone: (snapshotData) => CommentBottomSheet(comments: snapshotData, status: Status.done),
                  whenNotDone: CommentBottomSheet(status: Status.waiting),
                  whenError: (error) => CommentBottomSheet(status: Status.error),
                )
              ]);
            });
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