import 'dart:io';
import 'package:agro_hatch/constants.dart';
import 'package:agro_hatch/home.dart';
import 'package:agro_hatch/textinput.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path/path.dart';
import 'package:agro_hatch/Classes/store_user.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AddDetails extends StatefulWidget {
  @override
  _AddDetailsState createState() => _AddDetailsState();
}

class _AddDetailsState extends State<AddDetails> {
  String url;
  String name;
  String pin;
  String address;
  String contact;
  String uid;
  String email;
  final picker = ImagePicker();
  final _auth = FirebaseAuth.instance;
  File _imageFile;
  @override
  void initState() {
    super.initState();
    getUid();
  }

  ImageSource imageSource;
  Future pickImage(BuildContext context) async {
    final pickedFile =
        await picker.getImage(source: imageSource, imageQuality: 20);
    setState(() {
      _imageFile = File(pickedFile.path);
      uploadImage(context);
    });
  }

  bool uploaded = false;
  Future uploadImage(BuildContext context) async {
    String fileName = basename(_imageFile.path);
    Reference storageReference =
        FirebaseStorage.instance.ref().child('profilePics/$fileName');
    UploadTask uploadTask = storageReference.putFile(_imageFile);
    uploadTask.snapshotEvents.listen((event) async {
      print('state: ${event.state}');
      print('Progress: ${event.totalBytes / event.bytesTransferred}');
      if (event.state == TaskState.success) {
        await storageReference.getDownloadURL().then((fileURL) {
          setState(() {
            spin = false;
            uploaded = true;
            print(fileURL);
            url = fileURL;
          });
        });
      }
    }, onError: (e) {
      print(e);
    });
  }

  Future getUid() async {
    // ignore: await_only_futures
    uid = await _auth.currentUser.uid;
    // ignore: await_only_futures
    email = await _auth.currentUser.email;
  }

  Future<void> chooseDialog(BuildContext context) async {
    return showMaterialModalBottomSheet(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
              child: Wrap(
                children: [
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      setState(() {
                        imageSource = ImageSource.camera;
                        pickImage(context);
                        if (_imageFile != null) {
                          spin = true;
                        }
                        Navigator.pop(context);
                      });
                    },
                  ),
                  ListTile(
                    onTap: () {
                      setState(() {
                        imageSource = ImageSource.gallery;
                        pickImage(context);
                        if (_imageFile != null) {
                          spin = true;
                        }
                        Navigator.pop(context);
                      });
                    },
                    title: new Text('Gallery'),
                    leading: Icon(Icons.photo_library),
                  ),
                ],
              ),
            ),
          );
        });
  }

  bool spin = false;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBarColor,
        title: Text('Add your details'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: spin,
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    kAppBarColor,
                    Colors.lightGreenAccent,
                  ]),
            ),
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                SizedBox(
                  height: height / 18,
                ),
                GestureDetector(
                  onTap: () {
                    chooseDialog(context);
                  },
                  child: Container(
                    height: height / 7,
                    width: height / 7,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.withOpacity(0.4),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueGrey.withOpacity(0.4),
                          spreadRadius: 1,
                          blurRadius: 6,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Center(
                      child: uploaded
                          ? Image.file(_imageFile, fit: BoxFit.fill,)
                          : Icon(
                              Icons.add_a_photo_outlined,
                              color: Colors.black54,
                              size: 40.0,
                            ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height / 28,
                ),
                TextInput(
                  text: 'Name',
                  onChange: (value) {
                    name = value;
                  },
                ),
                TextInput(
                  text: 'Phone Number',
                  onChange: (value) {
                    contact = value;
                  },
                ),
                TextInput(
                  onChange: (value) {
                    address = value;
                  },
                  text: 'Address',
                ),
                TextInput(
                  text: 'Pin Code',
                  onChange: (value) {
                    pin = value;
                  },
                ),
                Container(
                  margin:
                      EdgeInsets.symmetric(vertical: 30.0, horizontal: 150.0),
                  child: ElevatedButton(
                    child: Center(
                      child: Text(
                        'Submit',
                        style: TextStyle(fontSize: 17.0),
                      ),
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    onPressed: () {
                      SaveUserData(uid: uid)
                        .saveUserData(name, email, url, address, contact, pin);
                      setState(() {
                        spin = true;
                      });
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => HomePage(),
                        ),
                      );
                    },
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
