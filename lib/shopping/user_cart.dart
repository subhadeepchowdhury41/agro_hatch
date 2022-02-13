import 'package:agro_hatch/Classes/cart.dart';
import 'package:agro_hatch/Classes/get_uid.dart';
import 'package:agro_hatch/constants.dart';
import 'package:agro_hatch/shopping/productdetails.dart';
import 'package:agro_hatch/utilities/confirm_order.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  getCart() async {
    final snap = await FirebaseFirestore.instance.collection('users').doc(GetUid().getId()).collection('cart').get();
    return snap.docs;
  }
  void refresh() {
    setState(() {});
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
                    return Container(height: MediaQuery.of(context).size.height / 1.2, child: Center(child: Text('loading...',),),);
                  } else {
                    if (snapshot.data.length == 0) {
                      return Column(
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height / 2.5,),
                          Text('No items here'),
                        ],
                      );
                    } else {
                      return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            decoration: BoxDecoration(
                              color: Colors.white38,
                              borderRadius: BorderRadius.circular(14.0),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, CupertinoPageRoute(builder: (context) => ProductDetails(url: snapshot.data[index]['url'], snap: snapshot.data[index], tag: '$index',),),);
                                    },
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Hero(
                                            tag: index.toString(),
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
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Text(snapshot.data[index]['name']),
                                              Text(snapshot.data[index]['price']),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: That(startNumber: snapshot.data[index]['number'], snap: snapshot.data[index], notifyParent: refresh,),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  }
                },
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, CupertinoPageRoute(builder: (context) => ConfirmOrder(),),);
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  height: MediaQuery.of(context).size.height / 11,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14.0),
                    color: Colors.green
                  ),
                  child: Center(child: Text('Buy',style: TextStyle(fontSize: 20.0),),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class That extends StatefulWidget {
  That({Key key, this.snap, this.startNumber, this.notifyParent});
  final Function notifyParent;
  final int startNumber;
  final QueryDocumentSnapshot snap;
  @override
  _ThatState createState() => _ThatState();
}

class _ThatState extends State<That> {
  int number;
  @override
  void initState() {
    number = widget.startNumber;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          CircleAvatar(
            child: IconButton(icon: Icon(Icons.delete, color: Colors.red,), onPressed: () async {
              number += 1;
              await Cart().deleteItem(widget.snap.id,);
              setState(() {});
              widget.notifyParent();
            }),
            backgroundColor: Colors.white,
          ),
          Container(
            child: Column(
              children: <Widget>[
                Text(number.toString(), style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w300, color: Colors.black87),),
                SizedBox(height: 10.0,),
                Row(
                  children: [
                    CircleAvatar(child: IconButton(icon: Icon(Icons.horizontal_rule), onPressed: () async {
                      number += -1;
                      if (number == 0) {
                        await Cart().deleteItem(widget.snap.id,);
                        widget.notifyParent();
                      } else {
                        await Cart().increaseItem(widget.snap.id, number);
                      }
                      setState(() {});
                    }), backgroundColor: Colors.white,),
                    SizedBox(width: 5.0,),
                    CircleAvatar(child: IconButton(icon: Icon(Icons.add), onPressed: () async {
                      number += 1;
                      await Cart().increaseItem(widget.snap.id, number);
                      setState(() {});
                    }), backgroundColor: Colors.white,),
                  ],
                ),
              ],
            ),
            padding: EdgeInsets.all(15.0),
          ),
        ],
      ),
    );
  }
}
