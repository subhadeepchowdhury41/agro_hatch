import 'package:agro_hatch/Classes/wishlist.dart';
import 'package:agro_hatch/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Classes/cart.dart';

class ProductDetails extends StatefulWidget {
  ProductDetails({this.url, this.snap, this.tag});
  final String url;
  final String tag;
  final QueryDocumentSnapshot snap;
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  WishList wishlist = WishList();
  bool inWishlist = false;
  bool tapped = false;
  @override
  void initState() {
    initWishlist();
    super.initState();
  }
  initWishlist() async {
    await wishlist.getWishlist();
    inWishlist = wishlist.checkWishList(widget.snap.id);
    if (inWishlist) {
      setState(() {
        tapped = true;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: kBodyBackground,
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Container(
                  decoration: BoxDecoration(
                    color: kBodyBackground,
                  ),
                  child: Hero(
                    tag: widget.tag,
                    child: Image(
                      image: NetworkImage(widget.url),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                          child: Container(
                          padding: EdgeInsets.all(30.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Description', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                              GestureDetector(
                                onTap: () async {
                                  if (tapped) {
                                    await wishlist.deleteWishlistItem(widget.snap.id);
                                    tapped = false;
                                  } else {
                                    await wishlist.addWishlistItem(widget.snap.id, widget.snap.get('img'), widget.snap.get('name'), widget.snap.get('price'));
                                    tapped = true;
                                  }
                                  await wishlist.getWishlist();
                                  setState(() {
                                    inWishlist = wishlist.checkWishList(widget.snap.id);
                                  });
                                },
                                  child: inWishlist ? Icon(Icons.favorite, color: Colors.red,) : Icon(Icons.favorite_outline),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          margin: EdgeInsets.all(20.0),
                          child: ListView(
                            children: [
                              Text(widget.snap.get('name'),),
                              // Text(widget.snap.id, style: TextStyle(fontSize: 30.0),),
                            ],
                          ),
                        ), 
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Cart cart = Cart();
                          cart.getCartItems();
                          cart.orderCartItems();
                        },
                        child: Container(
                          margin: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: kAppBarColor,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Center(
                            child: Text(
                              'Buy Now',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Cart cart = Cart();
                          cart.addToCart(widget.snap.id, 3, widget.snap.get('price'), widget.snap.get('name'), widget.url);
                        },
                        child: Container(
                          margin: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: kAppBarColor,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Center(
                            child: Text(
                              'Add to Cart',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
