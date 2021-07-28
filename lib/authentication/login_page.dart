import 'package:agro_hatch/home.dart';
import 'package:agro_hatch/authentication/signup_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LogIn extends StatefulWidget {
  static String id = "LogIn";
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  bool spin = false;
  final _auth = FirebaseAuth.instance;
  String _email;
  String _password;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: spin,
      child: SafeArea(
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/loginback.jpg'),
                fit: BoxFit.fill,
              ),
            ),
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                SizedBox(height: 40.0,),
                Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Image(
                      image: ResizeImage(AssetImage('assets/agrohatch.jpg'), height: 150, width: 150),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
                    child: Center(
                      child: TextField(
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          _email = value;
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(15.0),
                          fillColor: Colors.white,
                          filled: true,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: new BorderSide(color: Colors.green),
                            borderRadius: new BorderRadius.circular(25.0),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: new BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          hintText: 'Email',
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
                    child: Center(
                      child: TextField(
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          _password = value;
                        },
                        style: TextStyle(fontSize: 17.0),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(15.0),
                          fillColor: Colors.white,
                          filled: true,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: new BorderSide(color: Colors.white),
                            borderRadius: new BorderRadius.circular(25.0),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: new BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          hintText: 'Password',
                        ),
                        obscureText: true,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(20.0),
                    height: 60.0,
                    width: 120.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    padding: EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      child: Center(
                        child: Text('Log In', style: TextStyle(fontSize: 17.0),),
                      ),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.red)
                          ),
                        ),
                      ),
                      onPressed: () async {
                        setState(() {
                          spin = true;
                        });
                        try {
                          final newUser = await _auth.signInWithEmailAndPassword(email: _email, password: _password);
                          if (newUser != null) {
                            setState(() {
                              spin = false;
                            });
                            Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => HomePage(),),);
                          }
                        }
                        catch (e) {
                          print(e);
                        }
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('-----or-----', style: TextStyle(fontSize: 20.0, color: Colors.white54),),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 14.0, 0.0, 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text('Create a new account', style: TextStyle(fontSize: 20.0, color: Colors.white70),)],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(20.0),
                    height: 60.0,
                    width: 120.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    padding: EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      child: Center(
                        child: Text('Sign Up', style: TextStyle(fontSize: 17.0),),
                      ),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.red)
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => SignUp(),),);
                      },
                    ),
                  ),
                ],
              ),],
            ),
          ),
        ),
      ),
    );
  }
}
