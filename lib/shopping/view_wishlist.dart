import 'package:agro_hatch/Classes/get_uid.dart';
import 'package:agro_hatch/constants.dart';
import 'package:agro_hatch/shopping/productdetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WishListScreen extends StatefulWidget {
  @override
  _WishListScreenState createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  getWishList() async {
    final snap = await FirebaseFirestore.instance.collection('users').doc(GetUid().getId()).collection('wishlist').get();
    return snap.docs;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: kBodyBackground,
          child: ListView(
            children: [
              FutureBuilder(
                future: getWishList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: Text('loading...'),);
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          padding: EdgeInsets.all(10.0),
                          margin: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Colors.white38,
                            borderRadius: BorderRadius.circular(14.0),
                          ),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(context, CupertinoPageRoute(builder: (context) => ProductDetails(url: snapshot.data[index]['url'], snap: snapshot.data[index], tag: 'image$index',),),);
                            },
                            leading: Hero(tag: 'image$index', child: Container(child: Image.network(snapshot.data[index]['url']))),
                            title: Text(snapshot.data[index]['name'], style: TextStyle(fontSize: 22.0),),
                            trailing: Text('${snapshot.data[index]['price']}.00 Rs-', style: TextStyle(fontSize: 20.0),),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
