import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yummy/API/firebase_api.dart';
import 'package:yummy/models/catogary_images.dart';
import 'package:yummy/screens/item_details.dart';
import 'package:yummy/utils/utils.dart';
import 'package:yummy/widgets/catogary_view.dart';
import 'package:yummy/widgets/search_bar.dart';
import 'package:yummy/widgets/sliding_image.dart';

class FoodItem extends StatefulWidget {
  const FoodItem({Key? key}) : super(key: key);

  @override
  _FoodItemState createState() => _FoodItemState();
}

class _FoodItemState extends State<FoodItem> {
  // ignore: non_constant_identifier_names
  Utils utils = Utils();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: utils.allFoodData(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Somthing Went Wrong'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(shrinkWrap: true, children: [
            const SizedBox(
              height: 20,
            ),
            const SearchBar(),
            const SizedBox(
              height: 5,
            ),
            const SlidingImage(),
            const SizedBox(height: 5),
            SizedBox(
              height: MediaQuery.of(context).size.height / 6,
              child: ListView.builder(
                primary: false,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                // ignore: unnecessary_null_comparison
                itemCount: categories == null ? 0 : categories.length,
                itemBuilder: (BuildContext context, int index) {
                  Map cat = categories[index];

                  return CategoryItem(category: cat);
                },
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  'Recommemnded for you',
                  style: GoogleFonts.acme(fontSize: 18),
                )),
            const SizedBox(
              height: 15,
            ),
            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return data.isEmpty
                    ? const Text('This resturent have not uploaded any item')
                    : Padding(
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
                                        color: Colors.orange[500]!
                                            .withOpacity(0.5),
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
                                                child: CachedNetworkImage(
                                                  imageUrl: data['foodImage'],
                                                  fit: BoxFit.cover,
                                                )),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
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
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          data['foodName']
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black),
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
                                                          auth.currentUser ==
                                                                  null
                                                              ? showSnackBar(
                                                                  context,
                                                                  'Please Sign in')
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
                                                          Icons
                                                              .add_shopping_cart,
                                                          color: Colors.orange,
                                                        ))
                                                  ]))),
                                    )
                                  ],
                                ),
                              )),
                            )));
              }).toList(),
            ),
          ]);
        });
  }
}
