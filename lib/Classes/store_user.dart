import 'package:cloud_firestore/cloud_firestore.dart';

class SaveUserData {
  FirebaseFirestore reference = FirebaseFirestore.instance;
  SaveUserData({this.uid});
  final String uid;
  Future saveUserData(String name, String email, String photoUrl, String address, String contact, String pin) async {
    return await reference.collection('users').doc(uid).set(
      {
        'name': name,
        'email': email,
        'photoUrl': photoUrl,
        'address': address,
        'contact': contact,
        'pin': pin,
      }
    );
  }
}