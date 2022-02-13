import 'package:agro_hatch/admin/add_product.dart';
import 'package:agro_hatch/admin/all_orders.dart';
import 'package:agro_hatch/authentication/login_page.dart';
import 'package:agro_hatch/payment.dart';
import 'package:agro_hatch/shopping/user_cart.dart';
import 'package:agro_hatch/shopping/user_orders.dart';
import 'package:agro_hatch/shopping/view_wishlist.dart';
import 'package:agro_hatch/shopping/search.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:agro_hatch/shopping/shop.dart';
import 'package:agro_hatch/update_details.dart';
import 'package:agro_hatch/utilities/settings.dart';
import 'package:agro_hatch/weather/weather.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:agro_hatch/constants.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class HomePage extends StatefulWidget {
  static String id = "HomePage";
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = FirebaseAuth.instance;
  User loggedinUser;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedinUser = user;
        print(loggedinUser);
      }
    } catch (e) {
      print(e);
    }
  }
  static const url = 'https://www.youtube.com/c/BanglarBanijjikKrishi/videos';
  void launchYT() async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  void callNumber() async{
    const number = '8768715527'; //set the number here
    bool res = await FlutterPhoneDirectCaller.callNumber(number);
    print(res);
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: kAppBarColor,
    ));
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          actions: [
            IconButton(icon: Icon(Icons.shopping_cart_rounded), onPressed: () {
              Navigator.push(context, CupertinoPageRoute(builder: (context) => CartScreen(),),);
            }),
          ],
          backgroundColor: kAppBarColor,
          title: Text('AgroHatch', style: TextStyle(fontFamily: 'DMSerifDisplay', fontSize: 26.0),),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/drawerImage.jpg'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 99.0,
                          ),
                          Image(
                            image: ResizeImage(
                              AssetImage('assets/agrohatch.jpg'),
                              height: 45,
                              width: 45,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'AgroHatch',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 50.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'DMSerifDisplay'),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.account_circle_outlined,
                          size: 30.0,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          loggedinUser.email,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ListTile(
                onTap: () {
                  // Navigator.pushNamed(context, Shop.id);
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => Shop(),
                    ),
                  );
                },
                leading: Icon(
                  Icons.store_mall_directory,
                  color: Colors.black,
                  size: 30.0,
                ),
                title: Text(
                  'Shop',
                  style: TextStyle(fontSize: 20, fontFamily: 'SignikaNegative'),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(context, CupertinoPageRoute(builder: (context) => UserOrders(),),);
                },
                leading: Icon(
                  Icons.moped_rounded,
                  size: 30.0,
                  color: Colors.black,
                ),
                title: Text(
                  'Your Orders',
                  style: TextStyle(fontSize: 20, fontFamily: 'SignikaNegative'),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(context, CupertinoPageRoute(
                    builder: (context) => WishListScreen(),
                  ),);
                },
                leading: Icon(
                  Icons.star,
                  size: 30.0,
                  color: Colors.black,
                ),
                title: Text(
                  'Your Wishlist',
                  style: TextStyle(fontSize: 20, fontFamily: 'SignikaNegative'),
                ),
              ),
              Divider(
                color: Colors.black45,
              ),
              ListTile(
                onTap: () {
                  _auth.signOut();
                  Navigator.push(
                    (context),
                    CupertinoPageRoute(
                      builder: (context) => LogIn(),
                    ),
                  );
                },
                leading: Icon(
                  Icons.exit_to_app,
                  size: 30.0,
                  color: Colors.black,
                ),
                title: Text(
                  'Log out',
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'SignikaNegative',
                      fontWeight: FontWeight.normal),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => AddDetails(),
                    ),
                  );
                },
                leading: Icon(
                  Icons.store_mall_directory,
                  color: Colors.black,
                  size: 30.0,
                ),
                title: Text(
                  'Add Details',
                  style: TextStyle(fontSize: 20, fontFamily: 'SignikaNegative'),
                ),
              ),
              ListTile(
                onTap: () {
                  _auth.signOut();
                  Navigator.push(
                    (context),
                    CupertinoPageRoute(
                      builder: (context) => Payment(),
                    ),
                  );
                },
                leading: Icon(
                  Icons.payment,
                  size: 30.0,
                  color: Colors.black,
                ),
                title: Text(
                  'Pay',
                  style: TextStyle(fontSize: 20, fontFamily: 'SignikaNegative'),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                    (context),
                    CupertinoPageRoute(
                      builder: (context) => Settings(),
                    ),
                  );
                },
                leading: Icon(
                  Icons.settings,
                  size: 30.0,
                  color: Colors.black,
                ),
                title: Text(
                  'Settings',
                  style: TextStyle(fontSize: 20, fontFamily: 'SignikaNegative'),
                ),
              ),
            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.green.shade900,
                Colors.green.shade600,
              ],
            ),
          ),
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    color: kAppBarColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, CupertinoPageRoute(builder: (context) => SearchPage(),),);
                          },
                          child: Container(
                            child: Text('Search Products', style: TextStyle(fontFamily: 'DMSerifDisplay', fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),),
                            decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            padding: EdgeInsets.all(18.0),
                            margin: EdgeInsets.all(30.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    children: <Widget>[
                      Container(
                        height: height * 0.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30.0),
                            bottomRight: Radius.circular(30.0),
                          ),
                          color: kAppBarColor,
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          // SizedBox(
                          //   height: height * 0.06,
                          // ),
                          GridItem(height: height, text1: 'Weather Information', icon1: Icon(Icons.cloud), icon2: Icon(Icons.store), onPress1: () {
                            Navigator.push(context, CupertinoPageRoute(builder: (context) => GetLocation(),),);
                          }, text2: 'Shop Now', onPress2: () {
                            Navigator.push(context, CupertinoPageRoute(builder: (context) => Shop(),),);
                          },),
                          GridItem(height: height, icon1: Icon(Icons.video_collection), icon2: Icon(Icons.agriculture), text1: 'Agriculture Videos', onPress1: () {
                            launchYT();
                          }, text2: 'Agricultural News', onPress2: () {
                            Navigator.push(context, CupertinoPageRoute(builder: (context) => AddProduct(),),);
                          },),
                          GridItem(height: height, icon1: Icon(Icons.bar_chart), icon2: Icon(Icons.call), text1: 'Agri-Market Information', onPress1: () {
                            Navigator.push(context, CupertinoPageRoute(builder: (context) => AllOrders(),),);
                          }, text2: 'Call Toll-free Kisaan Call Centre', onPress2: () {
                            callNumber();
                          },),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GridItem extends StatelessWidget {
  const GridItem({
    this.icon1,
    this.icon2,
    @required this.height,
    @required this.text1,
    @required this.onPress1,
    @required this.text2,
    @required this.onPress2,
  });
  final Icon icon1;
  final Icon icon2;
  final Function onPress1;
  final Function onPress2;
  final double height;
  final String text1;
  final String text2;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * 0.2,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onPress1,
                child: Container(
                margin: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: Offset(3, 4), // changes position of shadow
                    ),
                  ],
                  color: Colors.lightGreen[200],
                  borderRadius: BorderRadius.circular(17.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    icon1,
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Text(text1, style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        shadows: [
                          BoxShadow(
                            blurRadius: 1.0,
                            color: Colors.black.withOpacity(0.1),
                          ),
                        ],
                      ),),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: onPress2,
              child: Container(
                margin: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: Offset(3, 4), // changes position of shadow
                    ),
                  ],
                  color: Colors.lightGreen[200],
                  borderRadius: BorderRadius.circular(17.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    icon2,
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Text(text2, style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        shadows: [
                          BoxShadow(
                            blurRadius: 1.0,
                            color: Colors.black.withOpacity(0.1),
                          ),
                        ],
                      ),),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
