// ignore_for_file: unnecessary_null_comparison
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:yummy/utils/utils.dart';
import 'package:yummy/widgets/alert_dialog.dart';

// I am using global variable and methods becouse it save much more time and it can will accessable from anywhere

FirebaseAuth auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instance;
CollectionReference cart = FirebaseFirestore.instance.collection('cart');
ShowAlert alert = ShowAlert();

Future createUser(
    String email, String name, String password, BuildContext context) async {
  alert.loadingDialog(context, 'Creating Account');
  await auth
      .createUserWithEmailAndPassword(email: email, password: password)
      .then((value) => showSnackBar(context, 'Sign up Successfully'))
      .then((value) => auth.currentUser!.updateDisplayName(name))
      .then((value) => auth.currentUser!
          .sendEmailVerification()
          .then((value) => showSnackBar(context,
              'Verifiacation Email sended to ${auth.currentUser!.email}'))
          .catchError((error) => showSnackBar(context, error.toString())));
}

Future signInWithEmailPassword(
    BuildContext context, String email, String password) async {
  alert.loadingDialog(context, 'Signning In');
  final UserCredential userCredential = await auth
      .signInWithEmailAndPassword(email: email, password: password)
      .catchError((error) => showSnackBar(context, error.toString()));

  final User? user = userCredential.user;

  if (user != null) {
    final User? currentUser = auth.currentUser;
    assert(user.uid == currentUser!.uid);
    return 'Successfully logged in, User UID: ${user.email}';
  }
}

Future<UserCredential> signInWithGoogle() async {
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  return await FirebaseAuth.instance.signInWithCredential(credential);
}

Future signOutGoogle(BuildContext context) async {
  ShowAlert alert = ShowAlert();
  alert.showLogOutDialog(context);
  try {
    await googleSignIn.signOut();
    await auth.signOut();

    showSnackBar(context, 'User Sign Out Successfully');
  } catch (e, st) {
    showSnackBar(context, e.toString());
  }
  Navigator.pop(context);
}

showSnackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(msg),
    backgroundColor: Colors.black,
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.all(10),
    shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    dismissDirection: DismissDirection.startToEnd,
    action: SnackBarAction(
      label: 'Ok',
      onPressed: () {},
    ),
  ));
}

// This code will add foods on cart
addToCart(BuildContext context, int qty, String foodName, String id, int price,
    String foodImage, String discription, bool placeOrder) {
  FirebaseFirestore.instance
      .collection('users')
      .doc(auth.currentUser!.uid)
      .collection('cart')
      .doc('foods')
      .collection('items')
      .doc(id)
      .set({
        'foodName': foodName,
        'Qty': qty,
        'id': id,
        'Email': auth.currentUser!.email,
        'Dis': discription,
        'Price': price,
        'foodImage': foodImage
      })
      .then((value) => showSnackBar(context, 'Item add to cart'))
      .catchError((error) => showSnackBar(context, error.toString()));
}

// this code removes food from cart
removeFromCart(BuildContext context, String id) {
  FirebaseFirestore.instance
      .collection('users')
      .doc(auth.currentUser!.uid)
      .collection('cart')
      .doc('foods')
      .collection('items')
      .doc(id)
      .delete()
      .catchError((error) => showSnackBar(context, error.toString()));
}

// This code add sales from current food sales
addToSale(BuildContext context, Map<String, dynamic> cartData) async {
  Utils utils = Utils();
  DocumentSnapshot foodData =
      await utils.currentFoodSales(cartData['id']).get();
  var foodMapData = foodData.data() as Map<String, dynamic>;
  int sales = foodMapData['Sales'];
  FirebaseFirestore.instance
      .collection('resturent')
      .doc('items')
      .collection('foods')
      .doc(cartData['id'])
      .update({'Sales': cartData['Qty'] + sales});
}

//This code cancel order from placed Order
cancelOrder(BuildContext context, String id) async {
  FirebaseFirestore.instance
      .collection('orders')
      .doc(auth.currentUser!.email)
      .collection('foods')
      .doc(id)
      .delete()
      .catchError((error) => showSnackBar(context, error.toString()));
}

// This code decrease sales from you current sale
removeFromSale(String id, BuildContext context, int qty) async {
  DocumentSnapshot<Map<String, dynamic>> salesData = await FirebaseFirestore
      .instance
      .collection('resturent')
      .doc('items')
      .collection('foods')
      .doc(id)
      .get();
  Map<String, dynamic> currentSales = salesData.data() as Map<String, dynamic>;
  int addSale = currentSales['Sales'] - qty;
  await FirebaseFirestore.instance
      .collection('resturent')
      .doc('items')
      .collection('foods')
      .doc(id)
      .update({'Sales': addSale}).catchError(
          (error) => showSnackBar(context, error.toString()));
}

placeOrder(
    BuildContext context, Map<String, dynamic> cartData, String pin) async {
  // This code will check that the food is now ordering the same food, then it will add its amount to the amount of earlier earlier.
  DocumentSnapshot<Map<String, dynamic>> placedOrders = await FirebaseFirestore
      .instance
      .collection('orders')
      .doc(auth.currentUser!.email)
      .collection('foods')
      .doc(cartData['id'])
      .get();
  cartData.addAll({'PIN': pin});
  // This code will check that the food is still ordered, the same food has not been ordered earlier, if food has not been ordered, then the cart will upload the food data into firestore, otherwise this code increase quantity of the ordered food
  if (placedOrders.exists) {
    Map<String, dynamic> odersData =
        placedOrders.data() as Map<String, dynamic>;
    int orderedFoodQty = odersData['Qty'];
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(auth.currentUser!.email)
        .collection('foods')
        .doc(cartData['id'])
        .update({'Qty': cartData['Qty'] + orderedFoodQty});
  } else {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(auth.currentUser!.email)
        .collection('foods')
        .doc(cartData['id'])
        .set(cartData);
  }
}
