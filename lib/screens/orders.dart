import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yummy/API/firebase_api.dart';
import 'package:yummy/utils/utils.dart';
import 'package:yummy/widgets/alert_dialog.dart';

import 'item_details.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  double totalPrice = 0.0;
  final _utils = Utils();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: auth.currentUser == null
            ? const Center(
                child: Text('Please sign in'),
              )
            : StreamBuilder(
                stream: _utils.ordersFoodData(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('You have not any odrers yet'),
                    );
                  }
                  return ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(10),
                    children: [
                      Column(
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                          totalPrice += data['Price'] * data['Qty'];
                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
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
                                    onTap: (() {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ItemDetail(
																									qty: data['Qty'],
                                                  foodname: data['foodName'],
                                                  foodimage: data['foodImage'],
                                                  discription: data['Dis'],
                                                  price: data['Price'],
                                                  id: data['id'])));
                                    }),
                                    leading: SizedBox(
                                      height: double.infinity,
                                      width: 100,
                                      child: Hero(
                                        tag: data['foodImage'],
                                        child: Image(
                                          image: CachedNetworkImageProvider(
                                              data['foodImage']),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    title: Text(data['foodName']),
                                    subtitle: Text('₹' +
                                        data['Price'].toString() +
                                        '   Qty:- ' +
                                        data['Qty'].toString()),
                                    trailing: PopupMenuButton(
                                      onSelected: ((value) {
                                        if (value == 'Edit') {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ItemDetail(
																													qty: data['Qty'],
                                                          foodname:
                                                              data['foodName'],
                                                          foodimage:
                                                              data['foodImage'],
                                                          discription:
                                                              data['Dis'],
                                                          price: data['Price'],
                                                          id: data['id'])));
                                        } else {
                                          ShowAlert alert = ShowAlert();
                                          alert.showConfirmationDialog(
                                              'Are You Sure',
                                              'Do you realy want to cancel this order',
                                              context, [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Dismiss')),
                                            TextButton(
                                                onPressed: (() async {
                                                  Navigator.pop(context);
                                                  totalPrice = 0;
                                                  await cancelOrder(
                                                      context, data['id']);
                                                  await removeFromSale(
                                                          data['id'],
                                                          context,
                                                          data['Qty'])
                                                      .then((value) =>
                                                          showSnackBar(
                                                              context, 'Done'));
                                                }),
                                                child:
                                                    const Text('Cancel Order'))
                                          ]);
                                        }
                                      }),
                                      shape: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      itemBuilder: ((context) => [
                                            const PopupMenuItem(
                                              child: Text('Edit'),
                                              value: 'Edit',
                                            ),
                                            const PopupMenuItem(
                                              child: Text('Cancel Order'),
                                              value: 'Cencle Order',
                                            )
                                          ]),
                                    )),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(
                        thickness: 1,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total price'),
                          Text('₹' + totalPrice.toString())
                        ],
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
