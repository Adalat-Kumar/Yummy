// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../API/firebase_api.dart';
import 'item_details.dart';

class GiftItem extends StatefulWidget {
  String? giftCode;
  String? highlight;
  GiftItem({Key? key, this.giftCode, this.highlight}) : super(key: key);

  @override
  State<GiftItem> createState() => _GiftItemState();
}

class _GiftItemState extends State<GiftItem> {
  @override
  Widget build(BuildContext context) {
    var giftCode = FirebaseFirestore.instance
        .collection('resturent')
        .doc('items')
        .collection('foods')
        .where('Gift', isEqualTo: widget.giftCode.toString())
        .snapshots();
    Stream<QuerySnapshot> highlight = FirebaseFirestore.instance
        .collection('resturent')
        .doc('items')
        .collection('foods')
        .snapshots();
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
            stream: widget.highlight == null ? giftCode : highlight,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('This gift card is not applicable for any food'),
                );
              }
              return GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return Padding(
                      padding: const EdgeInsets.all(10),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ItemDetail(
                                        foodname: data['foodName'],
                                        foodimage: data['foodImage'],
                                        discription: data['Dis'],
                                        price: data['Price'],
                                        id: data['id'])));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color:
                                          Colors.orange[500]!.withOpacity(0.5),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10))
                                ]),
                            child: GridTile(
                                child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: SizedBox(
                                      height: double.infinity,
                                      width: double.infinity,
                                      child: data['foodImage'] == null
                                          ? const Center(
                                              child: Icon(
                                                Icons.food_bank,
                                                color: Colors.orange,
                                              ),
                                            )
                                          : Hero(
                                              tag: data['foodImage'],
                                              child: Image.network(
                                                data['foodImage'],
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                    ),
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                        width: double.infinity,
                                        child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        data['foodName']
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black),
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                      Text(
                                                        "₹ ${data['Price'].toString()}",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey[600]!),
                                                        textAlign:
                                                            TextAlign.start,
                                                      )
                                                    ],
                                                  ),
                                                  IconButton(
                                                      onPressed: () {
                                                        auth.currentUser == null
                                                            ? showSnackBar(
                                                                context,
                                                                'Please Sign In')
                                                            : addToCart(
                                                                context,
                                                                1,
                                                                data[
                                                                    'foodName'],
                                                                data['id'],
                                                                data['Price'],
                                                                data[
                                                                    'foodImage'],
                                                                data['Dis'],
                                                                false);
                                                      },
                                                      icon: const Icon(
                                                        Icons.add_shopping_cart,
                                                        color: Colors.orange,
                                                      ))
                                                ]))),
                                  )
                                ],
                              ),
                            )),
                          )));
                }).toList(),
              );
            }),
      ),
    );
  }
}
