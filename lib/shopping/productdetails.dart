import 'package:agro_hatch/Classes/wishlist.dart';
import 'package:agro_hatch/constants.dart';
import 'package:agro_hatch/shopping/user_cart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Classes/cart.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

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
  bool inCart = false;
  @override
  void initState() {
    initWishlist();
    initCheckIfAdded();
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
  initCheckIfAdded() async {
    bool inThere = await Cart().returnCheck(widget.snap.id);
    setState(() {
      inCart = inThere;
    });
  }
  bool spin = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBarColor,
        title: Text(widget.snap.get('name')),
      ),
      body: ModalProgressHUD(
        progressIndicator: CircularProgressIndicator(backgroundColor: kAppBarColor,),
        inAsyncCall: spin,
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: kBodyBackground,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: EdgeInsets.all(14.0),
                    margin: EdgeInsets.fromLTRB(14, 14, 14, 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.white38,
                    ),
                    child: Hero(
                      tag: widget.tag,
                      child: Image.network(widget.url),
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
                          flex: 1,
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 14.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.white38
                              ),
                              padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Description', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                                  GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        spin = true;
                                      });
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
                                      setState(() {
                                        spin = false;
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
                            decoration: BoxDecoration(
                              color: Colors.white38,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            margin: EdgeInsets.all(14.0),
                            padding: EdgeInsets.all(14.0),
                            child: Scrollbar(
                              child: ListView(
                                children: [
                                  Text(widget.snap.get('name'),),
                                  // Text(widget.snap.id, style: TextStyle(fontSize: 30.0),),
                                ],
                              ),
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
                          onTap: () async {
                            if (inCart) {
                              Navigator.push(context, CupertinoPageRoute(builder: (context) => CartScreen()));
                            } else {
                              Cart cart = Cart();
                              cart.addToCart(widget.snap.id, 3, widget.snap.get('price'), widget.snap.get('name'), widget.url);
                              await initCheckIfAdded();
                            }
                          },

                          child: Container(
                            margin: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: kAppBarColor,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Center(
                              child: inCart ? Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.done),
                                  Text('Already Added'),
                                ],
                              ) : Text(
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
      ),
    );
  }
}
