import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Add extends StatefulWidget {
  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  User loggedinUser;
  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    getUID();
  }
  getUID() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedinUser = user;
        print(loggedinUser.uid);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RaisedButton(
              child: Text('Add'),
              onPressed: () {
                AddOrder order = AddOrder(uid: loggedinUser.uid, price: '30', paymentMethod: 'COD', productID: 'ID', dateOrdered: '1203201', status: 'accepted', item: '3');
                order.saveOrder();
              },
            ),
            RaisedButton(
              child: Text('Update'),
              onPressed: () {
                AddOrder order = AddOrder(uid: loggedinUser.uid, price: '30', paymentMethod: 'COD', productID: 'ID', dateOrdered: '1203201', status: 'accepted', item: '3');
                order.saveUserOrder();
              },
            ),
          ],
        ),
      ),
    );
  }
}



class AddOrder {
  AddOrder({this.uid, this.price, this.item, this.paymentMethod, this.status, this.dateOrdered, this.productID, this.name, this.url});
  final String uid;
  final String name;
  final String price;
  final String productID;
  final String dateOrdered;
  final String status;
  final String item;
  final String paymentMethod;
  final String url;
  void getTag() {
    var date = DateTime.now();
    int r = Random().nextInt(9999);
    orderID =  '${date.second}$r';
  }
  String orderID;
  FirebaseFirestore _instance = FirebaseFirestore.instance;
  uploadOrder() async {
    getTag();
    await saveOrder();
    await saveUserOrder();
  }
  Future saveOrder() async {
    return await _instance.collection('orders').doc(orderID).set(
      {
        'name': name,
        'uid': uid,
        'url': url,
        'price': price,
        'productID': productID,
        'dateOrdered': dateOrdered,
        'status': status,
        'item': item,
        'paymentMethod': paymentMethod,
      }
    ).catchError(
        (error) {
          print(error);
        }
    );
  }
  Future saveUserOrder() async {
    return await _instance.collection('users').doc('$uid').collection('orders').doc(orderID).set({
      'no': '3',
      'productID': productID,
      'url': url,
      'status': status,
      'name': name,
    }).catchError(
            (error) {
          print(error);
        }
    );
  }
}