import 'dart:io';
import 'package:agro_hatch/constants.dart';
import 'package:agro_hatch/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path/path.dart';
import 'package:agro_hatch/textinput.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SaveProductData {
  FirebaseFirestore reference = FirebaseFirestore.instance;
  Future saveProductData(String name, String price, String tag, String img, String pricing, String availability, String unit) async {
    return await reference.collection('products').doc().set(
        {
          'name': name,
          'price': price,
          'tag': tag,
          'img': img,
          'pricing': pricing,
          'availability': availability,
          'unit': unit,
        }
    );
  }
}

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  String name;
  String availability;
  String extras;
  String pricing;
  String price;
  String img;
  String tag;
  String unit;
  String category;
  ImagePicker picker = ImagePicker();
  File _imageFile;
  bool uploaded = false;
  bool spin = false;
  ImageSource imageSource;
  Future pickImage(BuildContext context) async {
    final pickedFile =
    await picker.getImage(source: imageSource, imageQuality: 20);
    setState(() {
      _imageFile = File(pickedFile.path);
      uploadImage(context);
    });
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
  Future uploadImage(BuildContext context) async {
    String fileName = basename(_imageFile.path);
    Reference storageReference =
    FirebaseStorage.instance.ref().child('products/$fileName');
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
            img = fileURL;
          });
        });
      }
    }, onError: (e) {
      print(e);
    });
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return ModalProgressHUD(
      inAsyncCall: spin,
      child: Scaffold(
        body: SafeArea(
          child: Container(
            color: kBodyBackground,
            child: Scrollbar(
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      chooseDialog(context);
                    },
                    child: Container(
                      margin: EdgeInsets.all(20.0),
                      height: height / 4,
                      width: height / 4,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(10.0),
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
                  TextInput(onChange: (value) {
                    name = value;
                  },
                    text: 'name',
                  ),
                  TextInput(onChange: (value) {
                    price = value;
                  },
                    text: 'price',
                  ),
                  TextInput(onChange: (value) {
                    pricing = value;
                  },
                    text: 'pricing',
                  ),
                  TextInput(onChange: (value) {
                    availability = value;
                  },
                    text: 'availability',
                  ),
                  TextInput(onChange: (value) {
                    category = value;
                  },
                    text: 'category',
                  ),
                  TextInput(onChange: (value) {
                    extras = value;
                  },
                    text: 'extras',
                  ),
                  TextInput(onChange: (value) {
                    tag = value;
                  },
                    text: 'tag',
                  ),
                  TextInput(onChange: (value) {
                    unit = value;
                  },
                    text: 'unit',
                  ),
                  Container(
                    margin:
                      EdgeInsets.symmetric(vertical: 30.0, horizontal: 150.0),
                    child: ElevatedButton(
                      child: Center(
                        child: Text(
                          'Add',
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
                        SaveProductData()
                            .saveProductData(name, price, tag, img, pricing, availability, unit);
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
      ),
    );
  }
}
