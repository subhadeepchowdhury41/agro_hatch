import 'package:agro_hatch/Classes/get_uid.dart';
import 'package:agro_hatch/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserOrders extends StatefulWidget {
  @override
  _UserOrdersState createState() => _UserOrdersState();
}

class _UserOrdersState extends State<UserOrders> {
  bool isKilled = false;
  List<String> url = [];
  List<String> status = [];
  Future<QuerySnapshot> getOrders() async {
    return FirebaseFirestore.instance.collection('users').doc(GetUid().getId()).collection('orders').get();
  }
  getOrderDetails(String orderId, int index) async {
    final snap = await FirebaseFirestore.instance.collection('orders').doc(orderId).get();
    if (!isKilled) {
      setState(() {
        status[index] = snap.get('status');
      });
    }
  }
  getProductdetails(String pID, int index) async {
    DocumentSnapshot snap = await FirebaseFirestore.instance.collection('products').doc(pID).get();
    if (!isKilled) {
      setState(() {
        url[index] = snap.get('img');
      });
    }
  }
  @override
  void dispose() {
    isKilled = false;
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        setState(() {
          isKilled = true;
        });
        Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
            isKilled = true;
            Navigator.pop(context);
          }),
          backgroundColor: kAppBarColor,
          title: Text('Your Orders'),
        ),
        body: SafeArea(
          child: Container(
            color: kBodyBackground,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: FutureBuilder(
                    future: getOrders(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: Text('loading...'));
                        } else {
                          if (url.length != snapshot.data.docs.length) {
                            for (int i = 0; i < snapshot.data.docs.length; i++) {
                              url.add('null');
                            }
                          }
                          if (status.length != snapshot.data.docs.length) {
                            for (int i = 0; i < snapshot.data.docs.length; i++) {
                              status.add('null');
                            }
                          }
                          return ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              getOrderDetails(snapshot.data.docs[index].id, index);
                              getProductdetails(snapshot.data.docs[index]['productID'], index);
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ViewOrder(url: url[index], orderId: snapshot.data.docs[index].id,)));
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10.0),
                                  margin: EdgeInsets.fromLTRB(7, 10, 7, 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.0),
                                    color: Colors.white38,
                                  ),
                                  child: ListTile(
                                    trailing: status[index] != 'null' ? Text(status[index]) : Text('null'),
                                    leading: url[index] != 'null' ? Image.network(url[index]) : Text('null'),
                                    title: Text(snapshot.data.docs[index]['name'],),
                                    subtitle: Text(snapshot.data.docs[index].id),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ViewOrder extends StatefulWidget {
  ViewOrder({this.orderId, this.url});
  final String url;
  final String orderId;
  @override
  _ViewOrderState createState() => _ViewOrderState();
}

class _ViewOrderState extends State<ViewOrder> {
  String name;
  String item;
  String dateOrdered;
  String price;
  String productID;
  String status;
  String paymentMethod;
  getOrder() async {
    final snap = await FirebaseFirestore.instance.collection('orders').doc(widget.orderId).get();
    setState(() {
      name = snap.get('name');
      item = snap.get('item');
      status = snap.get('status');
      productID = snap.get('productID');
      dateOrdered = snap.get('dateOrdered');
      paymentMethod = snap.get('paymentMethod');
      price = snap.get('price');
    });
  }
  @override
  void initState() {
    getOrder();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.orderId),
        backgroundColor: kAppBarColor,
      ),
      body: SafeArea(
        child: Container(
          color: kBodyBackground,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: Container(
                  child: widget.url != 'null' ? Image.network(widget.url) : Center(
                      child: Text('loading..'),),
                  padding: EdgeInsets.all(14.0),
                  margin: EdgeInsets.fromLTRB(14, 14, 14, 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white38,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                child: Divider(
                  color: Colors.black26,
                ),
              ),
              Expanded(
                child: Container(
                  child: Scrollbar(
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      children: <Widget>[
                        dateOrdered != null ? DetailContainer(text1: 'Product Name', text2: name,) : Container(),
                        name != null ? DetailContainer(text1: 'DateOrdered', text2: dateOrdered,) : Container(),
                        status != null ? DetailContainer(text1: 'status', text2: status,) : Container(),
                        item != null ? DetailContainer(text1: 'price', text2: price,) : Container(),
                        paymentMethod != null ? DetailContainer(text1: 'Price', text2: paymentMethod,) : Container(),
                      ],
                    ),
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

class DetailContainer extends StatelessWidget {
  DetailContainer({this.text1, this.text2});
  final String text1;
  final String text2;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.0),
        color: Colors.white38,
      ),
      padding: EdgeInsets.all(0.0),
      margin: EdgeInsets.all(4.0),
      child: ListTile(
        title: Text(text2),
        leading: Text(text1),
      ),
    );
  }
}
