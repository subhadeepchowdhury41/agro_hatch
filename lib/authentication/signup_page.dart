import 'dart:async';
import 'package:agro_hatch/authentication/login_page.dart';
import 'package:agro_hatch/textinput.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../update_details.dart';

class SignUp extends StatefulWidget {
  static String id = "SignUp";
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool spin = false;
  final _auth = FirebaseAuth.instance;
  String _email;
  String _password;
  Future<void> showSnackBar(BuildContext context, FirebaseAuthException exception) async {
    return showMaterialModalBottomSheet(context: context,
        backgroundColor: Colors.redAccent,
        builder: (context) {
      return Container(
        padding: EdgeInsets.all(5.0),
          child: Text(exception.message, textAlign: TextAlign.center, style: TextStyle(color: Colors.white),),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: spin,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/loginback.jpg'),
                fit: BoxFit.fill,
              )
          ),
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 40.0,),
                  Container(
                    child: Image(
                      image: ResizeImage(AssetImage('assets/agrohatch.jpg'), height: 150, width: 150),
                    ),
                  ),
                  TextInput(
                    text: 'Email',
                    onChange: (value) {
                    _email = value;
                  },),
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
                  SizedBox(
                    height: 25.0,
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
                          ),
                        ),
                      ),
                      onPressed: () async {
                        try {
                          setState(() {
                            spin = true;
                          });
                          final newUser = await _auth.createUserWithEmailAndPassword(email: _email, password: _password);
                          if (newUser != null) {
                            setState(() {
                              spin = false;
                            });
                            Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => AddDetails(),),);
                          }
                        }
                        catch (e) {
                          print(e);
                          setState(() {
                            spin = false;
                            showSnackBar(context, e);
                            Timer(
                              Duration(seconds: 3),
                                () {
                                  Navigator.pop(context);
                                }
                            );
                          });
                        }
                      },
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
                      style: ButtonStyle(shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => LogIn(),),);
                      },
                    ),
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