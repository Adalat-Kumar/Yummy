// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yummy/API/firebase_api.dart';
import 'package:yummy/screens/item_details.dart';

class ItemList extends StatefulWidget {
  final itemQuery;
  final catogaryKeyword;
  final String? giftCode;
  const ItemList(
      {Key? key, this.itemQuery, this.catogaryKeyword, this.giftCode})
      : super(key: key);

  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  @override
  Widget build(BuildContext context) {
    var catogary = FirebaseFirestore.instance
        .collection('resturent')
        .doc('items')
        .collection('foods')
        .where('Catogary', isEqualTo: widget.catogaryKeyword.toString())
        .snapshots();
    var searchQuery = FirebaseFirestore.instance
        .collection('resturent')
        .doc('items')
        .collection('foods')
        .where('foodName', isGreaterThanOrEqualTo: widget.itemQuery.toString())
        .snapshots();
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: widget.catogaryKeyword == null ? searchQuery : catogary,
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(widget.catogaryKeyword == null
                    ? 'Oops, Sorry this item is unavailable'
                    : 'This catogary have not any item'),
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
                                    color: Colors.orange[500]!.withOpacity(0.5),
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
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      data['foodName']
                                                          .toString(),
                                                      style: const TextStyle(
                                                          color: Colors.black),
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
                                                              data['foodName'],
                                                              data['id'],
                                                              data['Price'],
                                                              data['foodImage'],
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
          },
        ),
      ),
    );
  }
}
