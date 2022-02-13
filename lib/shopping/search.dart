import 'package:agro_hatch/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchString = '';
  List<String> products = [];
  List filteredProducts = [];
  FirebaseFirestore _instance = FirebaseFirestore.instance;
  Future getAllProducts() async {
    QuerySnapshot snapshot = await _instance.collection("products").get();
    for (int i = 0; i < snapshot.docs.length; i++) {
      products.add(snapshot.docs[i].get('name'));
      filteredProducts.add(snapshot.docs[i].get('name'));
    }
    print(products);
  }
  void getFilteredProducts() async {
    filteredProducts.clear();
    filteredProducts = products.where(
        (element) {
          return element.contains(searchString);
        }
    ).toList();
    print(filteredProducts);
  }
  @override
  void initState() {
    getAllProducts();
    super.initState();
  }
  Stream<QuerySnapshot> getSearchedProducts() async* {
    yield* _instance.collection('products').where('name', whereIn: filteredProducts).snapshots();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: kBodyBackground,
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      margin: EdgeInsets.all(12.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            searchString = value;
                            getSearchedProducts();
                            getFilteredProducts();
                          });
                        },
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: 'Search',
                          contentPadding: EdgeInsets.all(10.0),
                          fillColor: Colors.white,
                          filled: true,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: new BorderSide(color: Colors.green),
                            borderRadius: new BorderRadius.circular(25.0),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: new BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Icon(Icons.search),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 7,
              child: StreamBuilder(
                stream: getSearchedProducts(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text('loading');
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (snapshot.data.docs.length == 0) {
                          return Text('No results found');
                        }
                        return Container(
                          margin: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white38,
                          ),
                            child: ListTile(title: Text(snapshot.data.docs[index]['name'],),));
                      },
                    );
                  }     
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
