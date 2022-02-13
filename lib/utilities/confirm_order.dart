import 'package:agro_hatch/Classes/cart.dart';
import 'package:agro_hatch/Classes/get_uid.dart';
import 'package:agro_hatch/constants.dart';
import 'package:agro_hatch/payment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfirmOrder extends StatefulWidget {
  const ConfirmOrder({Key key}) : super(key: key);
  @override
  _ConfirmOrderState createState() => _ConfirmOrderState();
}

class _ConfirmOrderState extends State<ConfirmOrder> {
  int paymentIndex;
  int sum = 0;
  Cart _cart = Cart();
  @override
  void initState() {
    _cart.getCartItems();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBarColor,
        title: Text('Confirm Order'),
      ),
      body: SafeArea(
        child: Container(
          color: kBodyBackground,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 6,
                child: ListView(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          FutureBuilder(
                            future: getCartItems(),
                            builder: (context, snapshot) {
                              sum = 0;
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Container(
                                  child: Text('loading..'),
                                );
                              } else {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    sum += int.parse(snapshot.data[index]['price']) * snapshot.data[index]['number'];
                                    return Container(
                                      padding: EdgeInsets.all(14.0),
                                      margin: EdgeInsets.fromLTRB(14.0, 14.0, 14.0, 0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14.0),
                                        color: Colors.white38,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(snapshot.data[index]['name']),
                                          Text('Price: ${int.parse(snapshot.data[index]['price']) * snapshot.data[index]['number']} Rs-')
                                        ],
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
                    Container(
                      margin: EdgeInsets.all(14.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14.0),
                        color: Colors.white38,
                      ),
                      child: Column(
                        children: [
                          RadioListTile(title: Text('Pay Online'), value: 0, groupValue: paymentIndex, onChanged: (index) {
                            setState(() {
                              paymentIndex = index;
                              print(index);
                            });
                          }),
                          Divider(
                            color: kBodyBackground,
                            thickness: 1.5,
                          ),
                          RadioListTile(title: Text('Cash on Delivery'), value: 1, groupValue: paymentIndex, onChanged: (index) {
                            setState(() {
                              paymentIndex = index;
                              print(index);
                            });
                          }),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    _cart.orderCartItems();
                    if (paymentIndex == 0) {
                      Navigator.push(context, CupertinoPageRoute(builder: (context) => Payment(amount: sum,)));
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Center(
                      child: Text('Confirm Order'),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      )
    );
  }
  getCartItems() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').doc(GetUid().getId()).collection('cart').get();
    return snapshot.docs;
  }
}
