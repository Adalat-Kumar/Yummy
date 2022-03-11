import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:yummy/screens/gift_applied_item.dart';

class SlidingImage extends StatefulWidget {
  const SlidingImage({Key? key}) : super(key: key);

  @override
  State<SlidingImage> createState() => _SlidingImageState();
}

class _SlidingImageState extends State<SlidingImage> {
  Stream<QuerySnapshot> firestore = FirebaseFirestore.instance
      .collection('resturent')
      .doc('items')
      .collection('offers')
      .doc('Images')
      .collection('highlight')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: firestore,
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.data!.docs.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ImageSlideshow(
            isLoop: true,
            autoPlayInterval: 3000,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GiftItem(
                                  highlight: '',
                                )));
                  },
                  child: CachedNetworkImage(
                    imageUrl: data['Image'],
                    fit: BoxFit.cover,
                  ));
            }).toList());
      },
    );
  }
}
