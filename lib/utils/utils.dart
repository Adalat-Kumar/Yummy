import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yummy/API/firebase_api.dart';

class Utils {
  Stream<QuerySnapshot> allFoodData() {
    Stream<QuerySnapshot> foodData = FirebaseFirestore.instance
        .collection('resturent')
        .doc('items')
        .collection('foods')
        .snapshots();
    return foodData;
  }

  Stream<QuerySnapshot> cartFoodData() {
    Stream<QuerySnapshot> cartData = FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('cart')
        .doc('foods')
        .collection('items')
        .snapshots();
    return cartData;
  }

  Stream<QuerySnapshot> ordersFoodData() {
    Stream<QuerySnapshot> ordersData = FirebaseFirestore.instance
        .collection('orders')
        .doc(auth.currentUser!.email)
        .collection('foods')
        .snapshots();
    return ordersData;
  }

  DocumentReference currentFoodSales(String id) {
    DocumentReference document = FirebaseFirestore.instance
        .collection('resturent')
        .doc('items')
        .collection('foods')
        .doc(id);
    return document;
  }
	 CollectionReference userAddressData() {
    CollectionReference ordersData = FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('address');
    return ordersData;
  }

	 sendFeedBack(String id, String feedback, BuildContext context, double ratingValue){
		 FirebaseFirestore.instance
				 .collection('resturent')
				 .doc('feedback')
				 .collection('foods')
				 .doc(auth.currentUser!.email)
				 .set({
					 'id': id,
					 'Email': auth.currentUser!.email,
					 'Feedback': feedback,
					 'Rating': ratingValue
				 })

		 .then((value) => showSnackBar(context, 'Feedback Sended'))
				 .catchError((error) => showSnackBar(context, error.toString()));
	 }

 }
