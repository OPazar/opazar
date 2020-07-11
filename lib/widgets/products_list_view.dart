import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:opazar/models/DaP.dart';
import 'package:opazar/screens/product_page.dart';

class ProductsListView extends StatelessWidget {
  final List<DaP> dapList;

  ProductsListView({@required this.dapList});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(8.0),
      shrinkWrap: true,
      primary: false,
      children: List.generate(dapList.length, (index) => ListViewItem(dap: dapList[index])),
    );
  }
}

class ListViewItem extends StatelessWidget {
  final DaP dap;

  ListViewItem({this.dap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.grey[300],
      ),
      height: 130,
      margin: EdgeInsets.only(bottom: 8),
      child: RawMaterialButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ProductPage(dap: dap)));
        },
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 190,
                child: CachedNetworkImage(
                  imageUrl: dap.product.imageUrl,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                  ),
                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              Expanded(
                child: Container(
                  height: 130,
                  margin: EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(dap.product.name, style: TextStyle(fontSize: 22.0)),
                      Text(dap.category.name, style: TextStyle(fontSize: 16.0)),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(dap.product.unit, style: TextStyle(fontSize: 16.0)),
                          Text(dap.product.priceText, style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.w700)),
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
}
