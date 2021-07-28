import 'package:agro_hatch/Classes/get_uid.dart';
import 'package:agro_hatch/shopping/add_order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Cart {
  String uid;
  List cart = [];
  getUid() {
    uid = GetUid().getId();
  }
  FirebaseFirestore _store = FirebaseFirestore.instance;
  getCartItems() async {
    cart.clear();
    await getUid();
    final snapshot = await _store.collection('users').doc(uid).collection('cart').get();
    List<QueryDocumentSnapshot> snap = snapshot.docs;
    for (QueryDocumentSnapshot s in snap) {
      cart.add([s.id, s.get('price'), s.get('number'), s.get('name')]);
    }
  }
  addToCart(String pID, int number, String price, String name, String url) async {
    await getUid();
    await _store.collection('users').doc(uid).collection('cart').doc(pID).set(
      {
        'name': name,
        'number': number,
        'price': price,
        'url': url,
      }
    );
  }
  deleteItem(String pID) async {
    await getUid();
    await _store.collection('users').doc(uid).collection('cart').doc(pID).delete();
  }
  increaseItem(String pID, int number) async {
    await getUid();
    await _store.collection('users').doc(uid).collection('cart').doc(pID).update({
      'number': number,
    });
  }
  orderCartItems() async {
    getUid();
    await getCartItems();
    for (var c in cart) {
      await AddOrder(
        name: c[3].toString(),
        uid: uid,
        dateOrdered: '${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}',
        status: 'pending',
        productID: c[0],
        paymentMethod: 'COD',
        item: c[2].toString(),
        price: c[1].toString(),
      ).uploadOrder();
    }
  }
}