import 'package:agro_hatch/Classes/get_uid.dart';
import 'package:agro_hatch/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String img;
  Future<DocumentSnapshot> getProduct(String productId) async {
    final snap = await FirebaseFirestore.instance.collection('products').doc(productId).get();
    return snap;
  }
  getCart() async {
    final snap = await FirebaseFirestore.instance.collection('users').doc(GetUid().getId()).collection('cart').get();
    return snap.docs;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBarColor,
        title: Text('Cart'),
      ),
      body: SafeArea(
        child: Container(
          color: kBodyBackground,
          child: ListView(
            children: <Widget>[
              FutureBuilder(
                future: getCart(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(child: Center(child: Text('loading...'),),);
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        String img;
                        final snap = getProduct(snapshot.data[index].id);
                        snap.then((value) {
                          img = value.get('img');
                        });
                        print(img);
                        return Container(
                          padding: EdgeInsets.all(10.0),
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          decoration: BoxDecoration(
                            color: Colors.white38,
                            borderRadius: BorderRadius.circular(14.0),
                          ),
                          child: ListTile(
                            leading: img != null ? Image.network(img) : Text('null'),
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
