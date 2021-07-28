import 'package:firebase_auth/firebase_auth.dart';

class GetUid {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String getId() {
    return _auth.currentUser.uid;
  }
}