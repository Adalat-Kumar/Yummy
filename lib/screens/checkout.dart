// ignore_for_file: unnecessary_null_comparison

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yummy/API/firebase_api.dart';
import 'package:yummy/utils/utils.dart';
import 'package:yummy/widgets/alert_dialog.dart';

class Checkout extends StatefulWidget {
  const Checkout({Key? key}) : super(key: key);

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  double totalPrice = 0.0;
  // ignore: prefer_typing_uninitialized_variables
  var data;
  bool isVisibleFab = true;
  String error = '';

  ShowAlert alert = ShowAlert();
  bool showProgress = true;
  DocumentReference docs = FirebaseFirestore.instance
      .collection('users')
      .doc(auth.currentUser!.uid)
      .collection('cart')
      .doc('foods')
      .collection('items')
      .doc();
  Utils utils = Utils();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: auth.currentUser != null
            ? StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(auth.currentUser!.uid)
                    .collection('cart')
                    .doc('foods')
                    .collection('items')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('Your Cart Is Empty'),
                    );
                  }
                  return ListView(shrinkWrap: true, children: [
                    Column(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        data = document.data()! as Map<String, dynamic>;
                        totalPrice += data['Price'] * data['Qty'];
                        return Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.orange[500]!
                                              .withOpacity(0.5),
                                          blurRadius: 20,
                                          offset: const Offset(0, 10))
                                    ]),
                                child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: ListTile(
                                        title: Text(data['foodName']),
                                        subtitle: Text(
                                            'Qty:- ' + data['Qty'].toString()),
                                        trailing: Text(
                                            '₹ ' + data['Price'].toString()),
                                        leading: SizedBox(
                                            height: double.infinity,
                                            width: 100,
                                            child: Hero(
                                              tag: data['foodImage'],
                                              child: Image(
                                                image:
                                                    CachedNetworkImageProvider(
                                                        data['foodImage']),
                                                fit: BoxFit.cover,
                                              ),
                                            ))))));
                      }).toList(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Divider(
                      color: Colors.black,
                      thickness: 0.5,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total'),
                            Text('₹ ' + totalPrice.toString())
                          ],
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    CheckboxListTile(
                      value: false,
                      onChanged: (value) {
                        showSnackBar(
                            context, 'Only Cash on Delivery avialible');
                      },
                      title: const Text('Card'),
                    ),
                    CheckboxListTile(
                      value: false,
                      onChanged: (value) {
                        showSnackBar(
                            context, 'Only Cash on Delivery avialible');
                      },
                      title: const Text('Net Banking'),
                    ),
                    CheckboxListTile(
                      value: false,
                      onChanged: (value) {
                        showSnackBar(
                            context, 'Only Cash on Delivery avialible');
                      },
                      title: const Text('UPI'),
                    ),
                    CheckboxListTile(
                      value: false,
                      onChanged: (value) {
                        showSnackBar(
                            context, 'Only Cash on Delivery avialible');
                      },
                      title: const Text('GPay'),
                    ),
                    CheckboxListTile(
                      value: true,
                      title: const Text('Cash on Delivery'),
                      onChanged: (state) {},
                    ),
                  ]);
                })
            : Center(
                child: SizedBox(
                  height: 300,
                  child: Column(
                    children: [
                      const Text('Please Sign in'),
                      TextButton(
                          onPressed: (() {
                            Navigator.pop(context);
                          }),
                          child: const Text('Sign In'))
                    ],
                  ),
                ),
              ),
        floatingActionButton: Visibility(
          visible: auth.currentUser == null ? false : true,
          child: FloatingActionButton.extended(
            onPressed: () async {
							alert.showConformAddressDialog(context);
           },
            label: const Text(
              'Place Order',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ));
  }
}
