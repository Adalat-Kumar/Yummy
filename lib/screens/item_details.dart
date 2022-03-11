// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:yummy/API/firebase_api.dart';

class ItemDetail extends StatefulWidget {
  final String foodname;
  final int price;
  final String discription;
  final String foodimage;
  final String id;
  int? qty = 1;
  ItemDetail(
      {Key? key,
      required this.foodname,
      required this.foodimage,
      required this.discription,
      required this.price,
      required this.id,
      this.qty})
      : super(key: key);

  @override
  _ItemDetailState createState() => _ItemDetailState();
}

int itemQty = 1;

class _ItemDetailState extends State<ItemDetail> {
  double ratingValue = 3.0;

  @override
  Widget build(BuildContext context) {
    widget.qty == null ? widget.qty = 1 : widget.qty = widget.qty;
    return Scaffold(
        body: SafeArea(
          child: ListView(
							shrinkWrap: true,
            children: [
              SizedBox(
									height: MediaQuery.of(context).size.height/2,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                          height: double.infinity,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(200),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10))),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(200),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                            child: Hero(
                                tag: widget.foodimage,
                                child: Image(
                                  image: CachedNetworkImageProvider(
                                      widget.foodimage),
                                  fit: BoxFit.cover,
                                )),
                          )),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(15),
                      child: CustomIconButton(),
                    ),
                  ],
                ),
              ),
              SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(
                        widget.foodname,
                        style: const TextStyle(fontSize: 18),
                      ),
                      subtitle: Text('₹ ' + widget.price.toString()),
                      trailing: FittedBox(
                          child: RatingBar.builder(
                              itemBuilder: (context, index) {
                                return const Icon(
                                  Icons.star,
                                  color: Colors.orange,
                                );
                              },
                              initialRating: 4,
                              allowHalfRating: true,
                              ignoreGestures: true,
                              itemSize: 20,
                              onRatingUpdate: (rating) {})),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Discription :-',
                            style: TextStyle(fontSize: 18),
                          ),
                          // ignore: unnecessary_const
                          const SizedBox(
                            height: 7,
                          ),
                          Text(widget.discription)
                        ],
                      ),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  const Text(
                                    'Rating',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(ratingValue.toString())
                                ],
                              )),
                          RatingBar.builder(
                            itemBuilder: (BuildContext context, int index) {
                              return const Icon(
                                Icons.star,
                                color: Colors.orange,
                              );
                            },
                            initialRating: 3,
                            allowHalfRating: true,
                            onRatingUpdate: (rating) {
																alert.showRatingDialog(context, rating, widget.id );
                            },
                          ),
                        ]),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            children: [
              Qty(
                qty: widget.qty!.toInt(),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: FloatingActionButton.extended(
                        label: const Text('Add To Cart',
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)),
                        onPressed: () {
                          addToCart(
                              context,
                              itemQty,
                              widget.foodname,
                              widget.id,
                              widget.price,
                              widget.foodimage,
                              widget.discription,
                              false);
                        },
                        icon: const Icon(
                          Icons.add_shopping_cart,
                          color: Colors.white,
                        ),
                      )))
            ],
          ),
        ));
  }
}

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      child: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back),
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
                color: Colors.orange[500]!.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 10))
          ]),
    );
  }
}

class Qty extends StatefulWidget {
  int qty;

  Qty({Key? key, required this.qty}) : super(key: key);

  @override
  _QtyState createState() => _QtyState();
}

class _QtyState extends State<Qty> {
  add() {
    setState(() {
      widget.qty++;
    });
  }

  remove() {
    setState(() {
      widget.qty--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 20,
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.orange[500]!.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 10,
                    offset: const Offset(0, 10))
              ]),
          child: IconButton(
              onPressed: () {
                if (widget.qty != 1) {
                  remove();
                  itemQty = widget.qty;
                }
              },
              icon: const Icon(Icons.remove)),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          'Qty: ${widget.qty}',
          style: const TextStyle(fontSize: 17),
        ),
        const SizedBox(
          width: 10,
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.orange[500]!.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 10,
                    offset: const Offset(0, 10))
              ]),
          child: IconButton(
            onPressed: () {
              add();
              itemQty = widget.qty;
            },
            icon: const Icon(Icons.add),
          ),
        )
      ],
    );
  }
}
