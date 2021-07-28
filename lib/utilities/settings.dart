import 'package:agro_hatch/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String userId;
  String name;
  String imgUrl;
  String phoneNo;
  String email;
  getID() async {
    userId = FirebaseAuth.instance.currentUser.uid;
    print(userId);
    getUserInfo();
  }
  @override
  void initState() {
    getID();
    super.initState();
  }
  getUserInfo() async {
    // ignore: await_only_futures
    final document = await FirebaseFirestore.instance.collection('users').doc(userId);
    Future<DocumentSnapshot> snap = document.get();
    snap.then((value) {
      print(value.data());
      setState(() {
        email = value.get('email');
        phoneNo = value.get('contact');
        name = value.get('name');
        imgUrl = value.get('photoUrl');
      });
      print(imgUrl);
    });
  }
  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        color: kBodyBackground,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                title: name != null ? Text('Hello $name') : Text('Hello'),
                stretchModes: [
                  StretchMode.zoomBackground,
                ],
                centerTitle: true,
                background: imgUrl != null ? Container(
                    decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ), child: Image.network(imgUrl, fit: BoxFit.fill,)) : Text('Hello'),
              ),
              stretch: true,
              backgroundColor: kAppBarColor,
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  SettingsCard(
                    text: 'Your Account', onTap: () {
                    Navigator.push(context, CupertinoPageRoute(builder: (context) => YourAccount(name: name, email: email, phoneNo: phoneNo, url: imgUrl,),),);
                  },),
                  SettingsCard(text: 'Your Details',),
                  SettingsCard(text: 'About our App',),
                  SettingsCard(text: 'Refund Policy',),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SettingsCard extends StatelessWidget {
  SettingsCard({this.text, this.onTap});
  final String text;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
        child: Container(
          margin: EdgeInsets.all(10.0),
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white38,
          ),
          child: Text(text),
        )
    );
  }
}

class YourAccount extends StatelessWidget {
  YourAccount({this.name, this.phoneNo, this.email, this.url});
  final String name;
  final String url;
  final String phoneNo;
  final String email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBarColor,
        title: Text('Your Account'),
      ),
      body: SafeArea(
        child: Container(
          color: kBodyBackground,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.all(40.0),
                child: CircleAvatar(
                  radius: 70.0,
                  backgroundImage: url != null ? NetworkImage(url) : null,
                ),
              ),
              ShowInfo(text: name, icon: Icons.account_circle,),
              ShowInfo(text: phoneNo, icon: Icons.phone,),
              ShowInfo(text: email, icon: Icons.email,),
            ],
          ),
        ),
      ),
    );
  }
}

class ShowInfo extends StatelessWidget {
  ShowInfo({this.text, this.icon, this.action});
  final String text;
  final IconData icon;
  final Widget action;
  @override
  Widget build(BuildContext context) {
    return Container(margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 23.0), padding: EdgeInsets.all(0), decoration: BoxDecoration(borderRadius: BorderRadius.circular(27.0), color: Colors.white,), child: ListTile(leading: Icon(icon), title: Text(text), trailing: action,),);
  }
}



