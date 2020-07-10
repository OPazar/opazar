import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:opazar/models/Dealer.dart';
import 'package:opazar/models/Product.dart';

class ProductsGridView extends StatelessWidget {
  final List<DaP> dapList;

  ProductsGridView({@required this.dapList});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: (4/5),
      children: List.generate(dapList.length, (index) => dapList[index].getWidget()),
    );
  }
}

class DaP {
  Dealer dealer;
  Product product;

  DaP({@required this.dealer, @required this.product});

  Widget getWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.grey[300],
      ),
      height: 250.0,
      margin: EdgeInsets.all(8.0),
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
//                        Text('${product.unit} ${product.price} ₺'),
                        Text('${product.price} ₺'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(dealer.name),
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
    );
  }
}
