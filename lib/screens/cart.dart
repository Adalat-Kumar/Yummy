import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yummy/API/firebase_api.dart';
import 'package:yummy/screens/checkout.dart';
import 'package:yummy/screens/item_details.dart';
import 'package:yummy/utils/utils.dart';

class Cart extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final goTologin;
  final bool? showSignInButton;
  const Cart({Key? key, this.goTologin, this.showSignInButton})
      : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  int itemQty = 1;
  final _utils = Utils();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: auth.currentUser != null
            ? StreamBuilder<QuerySnapshot>(
                stream: _utils.cartFoodData(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child:
                          Text('Oops, Your cart is Empty \nDo some shopping'),
                    );
                  }

                  return ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
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
                                  leading: data['foodImage'] == null
                                      ? const Icon(Icons.food_bank)
                                      : Hero(
                                          tag: data['foodImage'],
                                          child: SizedBox(
                                            height: double.infinity,
                                            width: 100,
                                            child: Image(
                                              image: CachedNetworkImageProvider(
                                                  data['foodImage']),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                  title: data['foodName'] == null
                                      ? const Text('Food Title')
                                      : Text(data['foodName']),
                                  subtitle: data['Price'] == null
                                      ? const Text('Sibtitle')
                                      : Text("₹ ${data['Price'].toString()}"),
                                  trailing: FittedBox(
                                    child: Column(children: [
                                      IconButton(
                                          onPressed: () {
                                            removeFromCart(context, data['id']);
                                          },
                                          icon: const Icon(Icons.delete)),
                                      Text("Qty: ${data['Qty'].toString()}")
                                    ]),
                                  ),
                                  onTap: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ItemDetail(
                                                  foodname: data['foodName'],
                                                  foodimage: data['foodImage'],
                                                  discription: data['Dis'],
                                                  price: data['Price'],
                                                  id: data['id'],
                                                  qty: data['Qty'],
                                                )));
                                  },
                                ),
                              )));
                    }).toList(),
                  );
                },
              )
            : Center(
                child: Column(
                  children: [
                    Expanded(child: Container()),
                    const Text('Please Sign In'),
                    widget.showSignInButton == true
                        ? ElevatedButton(
                            onPressed: () {
                              widget.goTologin(2);
                            },
                            child: const Text('Sign In'),
                          )
                        : Container(),
                    Expanded(child: Container())
                  ],
                ),
              ),
      ),
      floatingActionButton: Visibility(
        visible: auth.currentUser == null ? false : true,
        child: FloatingActionButton.extended(
          icon: const Icon(Icons.shopping_cart, color: Colors.white),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Checkout()));
          },
          label: const Text(
            'Checkout',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
