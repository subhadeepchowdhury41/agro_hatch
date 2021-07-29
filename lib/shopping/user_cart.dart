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
                              Expanded(
                                flex: 2,
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        child: IconButton(icon: Icon(Icons.delete, color: Colors.red,), onPressed: () {}),
                                        backgroundColor: Colors.white,
                                      ),
                                      Container(
                                          child: Column(
                                            children: [
                                              Text(snapshot.data[index]['number'].toString(), style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w300, color: Colors.black87),),
                                              SizedBox(height: 10.0,),
                                              Row(
                                                children: [
                                                  CircleAvatar(child: IconButton(icon: Icon(Icons.add), onPressed: null), backgroundColor: Colors.white,),
                                                  SizedBox(width: 5.0,),
                                                  CircleAvatar(child: IconButton(icon: Icon(Icons.horizontal_rule), onPressed: null), backgroundColor: Colors.white,),
                                                ],
                                              ),
                                            ],
                                          ),
                                        padding: EdgeInsets.all(15.0),
                                      ),
                                    ],
                                  ),
                              ),
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
      ),
    );
  }
}
