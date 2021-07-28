import 'package:agro_hatch/authentication/login_page.dart';
import 'package:agro_hatch/authentication/signup_page.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'loading-page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:agro_hatch/shopping/shop.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(AgroHatch());
}

class AgroHatch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: LoadingPage.id,
      routes: {
        LoadingPage.id: (context) => LoadingPage(),
        HomePage.id : (context) => HomePage(),
        LogIn.id: (context) => LogIn(),
        SignUp.id: (context) => SignUp(),
        Shop.id: (context) => Shop(),
      },
      home: HomePage(),
      theme: ThemeData(
        fontFamily: 'SignikaNegative',
      ),
    );
  }
}