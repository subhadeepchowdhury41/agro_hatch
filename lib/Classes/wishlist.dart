import 'package:agro_hatch/Classes/get_uid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WishList {
  List<String> wishList = [];
  String uid;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  _getUid() {
    uid = GetUid().getId();
  }
  Future<bool> addWishlistItem(String productId, String url, String name, String price) async {
    _getUid();
    bool complete = false;
    print(productId);
    await _firestore.collection('users').doc('$uid').collection('wishlist').doc('$productId').set({
      'name': name,
      'url': url,
      'price': price,
    }).whenComplete(() {
      complete = true;
    }).catchError((e) {
      print(e);
    });
    return complete;
  }
  deleteWishlistItem(String id) async {
    _getUid();
    await _firestore.collection('users').doc(uid).collection('wishlist').doc(id).delete();
  }
  getWishlist() async {
    wishList.clear();
    await _getUid();
    final _snapshot = await _firestore.collection('users').doc(uid).collection('wishlist').get().catchError((error) {
      print(error);
    });
    List<QueryDocumentSnapshot> snap = _snapshot.docs;
    for (QueryDocumentSnapshot s in snap) {
      wishList.add(s.id);
    }
  }
  bool checkWishList(String givenId) {
    print('called');
    bool found = false;
    print('called 2');
    print(wishList);
    for (int i = 0; i < wishList.length; i++) {
      print('this is the id - ${wishList[i]}');
      print('this is the passed id - $givenId');
      if (wishList[i] == givenId) {
        print('found');
        found = found || true;
      }
    }
    return found;
  }
}