import 'package:agro_hatch/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AllOrders extends StatefulWidget {
  AllOrders({Key key}) : super(key: key);
  @override
  _AllOrdersState createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> {
  getOrders() async {
    final snap = await FirebaseFirestore.instance.collection('orders').get();
    return snap.docs;
  }
  refresh() async {
    await getOrders();
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
        backgroundColor: kAppBarColor,
      ),
      body: SafeArea(
        child: Container(
          color: kBodyBackground,
          child: ListView(
            children: [
              FutureBuilder(
                future: getOrders(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(height: MediaQuery.of(context).size.height / 1.2, child: Center(child: Text('loading...',),),);
                  } else {
                    if (snapshot.data.length == 0) {
                      return Column(
                        children: <Widget>[
                          SizedBox(height: MediaQuery.of(context).size.height / 2.5,),
                          Text('No items here'),
                        ],
                      );
                    } else {
                      return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(context, CupertinoPageRoute(builder: (context) => OrderDetails(snap: snapshot.data[index], url: snapshot.data[index]['url'],),),);
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                              decoration: BoxDecoration(
                                color: Colors.white38,
                                borderRadius: BorderRadius.circular(14.0),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(snapshot.data[index]['url']),
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius: BorderRadius.circular(14.0),
                                            ),
                                            margin: EdgeInsets.zero,
                                            height: 110,
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            child: Column(
                                              children: [
                                                Text(snapshot.data[index].id),
                                                Text(snapshot.data[index]['name']),
                                                Text(snapshot.data[index]['dateOrdered']),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(snapshot.data[index]['uid']),
                                          Text(snapshot.data[index]['status']),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  }
                }),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderDetails extends StatefulWidget {
  OrderDetails({this.snap, this.url});
  final QueryDocumentSnapshot snap;
  final String url;
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  bool updated = true;
  bool errorThere = false;
  SnackBar snackBar = SnackBar(
    content: Text('Try again'),
  );
  GlobalKey<_OrderStatusState> _key = GlobalKey<_OrderStatusState>();
  updateOrderStatus(String status) async {
    setState(() {
      updated = false;
    });
    final reference = FirebaseFirestore.instance.collection('orders').doc(widget.snap.id);
    await reference.update({
      'status': status,
    }).catchError((error) {
      errorThere = errorThere || true;
    });
    final ref = FirebaseFirestore.instance.collection('users').doc(widget.snap.get('uid')).collection('orders').doc(widget.snap.id);
    await ref.update({
      'status': status,
    }).catchError((error) {
      errorThere = errorThere || true;
    });
    if (errorThere) {
      Scaffold.of(context).showSnackBar(snackBar);
    }
    setState(() {
      updated = true;
    });
    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Text('save'),
        onPressed: () async {
          await updateOrderStatus(_key.currentState.selectedValue);
        },
      ),
      appBar: AppBar(
        title: Text(widget.snap.id),
        backgroundColor: kAppBarColor,
      ),
      body: ModalProgressHUD(
        inAsyncCall: !updated,
        child: SafeArea(
          child: Container(
            color: kBodyBackground,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                          DetailsContainer(text1: 'Product Name', text2: widget.snap.get('name'),),
                          DetailsContainer(text1: 'DateOrdered', text2: widget.snap.get('dateOrdered'),),
                          OrderStatus(snap: widget.snap, key: _key,),
                          DetailsContainer(text1: 'price', text2: widget.snap.get('price'),),
                          DetailsContainer(text1: 'Price', text2: widget.snap.get('paymentMethod'),),
                          DetailsContainer(text1: 'no', text2: widget.snap.get('item'),),
                        ],
                      ),
                    ),
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

class DetailsContainer extends StatelessWidget {
  DetailsContainer({this.text1, this.text2});
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

class OrderStatus extends StatefulWidget {
  OrderStatus({Key key, this.snap}) : super(key: key);
  final QueryDocumentSnapshot snap;
  @override
  _OrderStatusState createState() => _OrderStatusState();
}

class _OrderStatusState extends State<OrderStatus> {
  String selectedValue;
  @override
  void initState() {
    switch (widget.snap.get('status')) {
      case 'pending':
        selectedValue = 'pending';
        break;
      case 'accepted':
        selectedValue = 'accepted';
        break;
      case 'rejected':
        selectedValue = 'rejected';
        break;
      case 'on the way':
        selectedValue = 'on the way';
        break;
      case 'delivered':
        selectedValue = 'delivered';
        break;
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.0),
        color: Colors.white38,
      ),
      padding: EdgeInsets.all(0.0),
      margin: EdgeInsets.all(4.0),
      child: ListTile(
        title: DropdownButton(
          value: selectedValue,
          items: <String>['pending', 'accepted', 'rejected', 'on the way', 'delivered'].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem(
              value: value,
              child: Text(value,),
            );
          }).toList(),
          onChanged: (String value) {
            setState(() {
              selectedValue = value;
            });
          },
        ),
      ),
    );
  }
}

