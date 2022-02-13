import 'package:agro_hatch/shopping/productdetails.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agro_hatch/constants.dart';
import 'package:flutter/rendering.dart';

class Shop extends StatefulWidget {
  static String id = "Shop";
  @override
  _ShopState createState() => _ShopState();
}

String selectedCategory = 'all';

class _ShopState extends State<Shop> {
  String category = 'all';
  getWishList() async {
    final _auth = FirebaseAuth.instance;
    String uid = _auth.currentUser.uid;
    // ignore: await_only_futures
    Stream<QuerySnapshot> snapshot = await FirebaseFirestore.instance.collection('users').doc(uid).collection('wishlist').snapshots();
    print(snapshot);
    return snapshot;
  }
  void refresh() {
    setState(() {
      if (current == 0) {
        selectedCategory = 'all';
      } else if (current == 1) {
        selectedCategory = 'hatchery';
      } else if (current == 2) {
        selectedCategory = 'flower plants';
      } else if (current == 3) {
        selectedCategory = 'fruit plants';
      } else if (current == 4) {
        selectedCategory = 'vegetable plants';
      }
      category = selectedCategory;
    });
  }
  final _store = FirebaseFirestore.instance;
  Future getProducts() async {
    if (category == 'all') {
      QuerySnapshot snapshot = await _store.collection("products").get();
      return snapshot.docs;
    } else {
      QuerySnapshot snapshot = await _store.collection("products").where('category', isEqualTo: category).get();
      return snapshot.docs;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Text('flex'),
        backgroundColor: kAppBarColor,
        title: Text('Shop'),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: kBodyBackground,
        ),
        padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
        child: Scrollbar(
          radius: Radius.circular(10.0),
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Banner(),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20.0),
                padding: EdgeInsets.all(5.0),
                height: 46,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    CategoryIndicator(text: 'All', index: 0, notifyParent: refresh,),
                    CategoryIndicator(text: 'Hatchery', index: 1, notifyParent: refresh,),
                    CategoryIndicator(text: 'Flower Plants', index: 2, notifyParent: refresh,),
                    CategoryIndicator(text: 'Fruit Plants', index: 3, notifyParent: refresh,),
                    CategoryIndicator(text: 'Vegetable Plants',index: 4, notifyParent: refresh,),
                  ],
                ),
              ),
              FutureBuilder(
                future: getProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      height: 100,
                      child: Center(
                        child: Text(
                        'Loading...',
                        style: TextStyle(fontSize: 23.0),
                        ),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                            context,
                            CupertinoPageRoute(
                            builder: (context) => ProductDetails(
                              url: snapshot.data[index]['img'],
                              snap: snapshot.data[index],
                              tag: 'item$index',
                            ),),);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(17.0),
                              color: Colors.white38,
                            ),
                            margin: EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 5.0),
                            height: 130,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Hero(
                                  tag: 'item$index',
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(17.0),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            snapshot.data[index]['img']),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        snapshot.data[index]['name'],
                                        style: TextStyle(
                                            fontSize: 24.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                            ),
                     );
                  });
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}

int current = 0;

class CategoryIndicator extends StatefulWidget {
  final Function notifyParent;
  CategoryIndicator({Key key, this.text, this.index, this.notifyParent});
  final String text;
  final int index;
  @override
  _CategoryIndicatorState createState() => _CategoryIndicatorState();
}

class _CategoryIndicatorState extends State<CategoryIndicator> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          current = widget.index;
          widget.notifyParent();
        });
        print('a');
      },
      child: Container(
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              spreadRadius: 0.0,
              blurRadius: 1,
              color: Colors.white60,
            ),
          ],
          borderRadius: BorderRadius.circular(15),
          color: current == widget.index ? Colors.white60 : Colors.black26,
        ),
        child: Center(child: Text(widget.text, style: TextStyle(fontSize: 17.0),)),
      ),
    );
  }
}

class Banner extends StatefulWidget {
  @override
  _BannerState createState() => _BannerState();
}

class _BannerState extends State<Banner> {
  List<Widget> indicators = [];
  int _currentIndex = 0;
  Widget buildIndicators() {
    indicators.clear();
    for (int i = 0; i < 3; i++) {
      indicators.add(
        Container(
          margin: EdgeInsets.fromLTRB(4, 12, 4, 6),
          height: 10.0,
          width: 10.0,
          decoration: BoxDecoration(
              color: _currentIndex == i ? Colors.white : Colors.black26,
              shape: BoxShape.circle
          ),
        ),);
    }
    return Builder(
      builder: (context) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: indicators,
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        children: [
          CarouselSlider(
              items: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      image: AssetImage('assets/drawerImage.jpg'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      image: AssetImage('assets/drawerImage.jpg'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      image: AssetImage('assets/drawerImage.jpg'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ],
              options: CarouselOptions(
                onPageChanged: (value, reason) {
                  setState(() {
                    _currentIndex = value;
                  });
                },
                height: 200,
                enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: 16 / 9,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: Duration(milliseconds: 500),
                viewportFraction: 0.85,
              )),
          buildIndicators(),
        ],
      ),
    );
  }
}
