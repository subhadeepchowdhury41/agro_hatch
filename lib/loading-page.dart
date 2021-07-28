import 'package:agro_hatch/home.dart';
import 'package:agro_hatch/authentication/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'authentication/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

const spin = SpinKitCircle(
  color: Colors.white,
  size: 50.0,
);

class LoadingPage extends StatefulWidget {
  static String id = 'LoadingPage';
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    ifLoggedIn();
  }
  Future<void> ifLoggedIn() async {
    try {
      // ignore: await_only_futures
      final user = await _auth.currentUser;
      if (user != null) {
        Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => HomePage(),),);
      } else {
        Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => LogIn(),),);
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
          children: <Widget>[
            SizedBox(height: 40.0,),
            spin,
            SizedBox(height: 10.0,),
            Text('Loading', style: TextStyle(fontSize: 20.0, color: Colors.white),),
          ],
        ),
      ),
    );
  }
}
