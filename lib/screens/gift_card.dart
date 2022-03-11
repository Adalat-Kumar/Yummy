import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yummy/API/firebase_api.dart';

import 'gift_applied_item.dart';

class GiftCard extends StatefulWidget {
  const GiftCard({Key? key}) : super(key: key);

  @override
  _GiftCardState createState() => _GiftCardState();
}

class _GiftCardState extends State<GiftCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: auth.currentUser == null
            ? const Center(
                child: Text('Please Sign In'),
              )
            : StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(auth.currentUser!.uid)
                    .collection('gift_card')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text("You have'n any gift card"),
                    );
                  }
                  return ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot giftCardDoc) {
                      Map<String, dynamic> giftCard =
                          giftCardDoc.data()! as Map<String, dynamic>;
                      return Padding(
                        padding: const EdgeInsets.all(13),
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => GiftItem(
                                            giftCode: giftCard['title'],
                                          )));
                            },
                            child: Container(
                              height: 280,
                              decoration: BoxDecoration(
                                  image: const DecorationImage(
                                      image: AssetImage(
                                          'assets/gift_card_background.jpg'),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.orange[500]!
                                            .withOpacity(0.5),
                                        blurRadius: 20,
                                        offset: const Offset(0, 10))
                                  ]),
                              child: Align(
                                  alignment: Alignment.topRight,
                                  child: GestureDetector(
                                      child: SizedBox(
                                    height: 100,
                                    child: Column(
                                      children: [
                                        Text(
                                          giftCard['title'],
                                          style: GoogleFonts.pacifico(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                        Text(
                                          'End in ' + giftCard['endTime'],
                                          style: GoogleFonts.pacifico(
                                              color: Colors.white),
                                        )
                                      ],
                                    ),
                                  ))),
                            )),
                      );
                    }).toList(),
                  );
                },
              ),
      ),
    );
  }
}
