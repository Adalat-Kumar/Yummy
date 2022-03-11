import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:yummy/utils/utils.dart';
import 'package:yummy/widgets/seletable_card.dart';

import '../API/firebase_api.dart';
import '../screens/update_profile.dart';

class ShowAlert {
  Future<void> loadingDialog(BuildContext context, String title) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: Text(title),
            content: SingleChildScrollView(
                child: ListBody(
              children: [
                Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: CircularProgressIndicator(),
                    ),
                    Text(
                      'Please Wait',
                      style: TextStyle(fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    )
                  ],
                )
              ],
            )));
      },
    );
  }

  Future<void> showLogOutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text('Logout ?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const [
                Text('Do You realy Want to Logout'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancle'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              onPressed: () async {},
              child: const Text('Logout'),
            )
          ],
        );
      },
    );
  }

  Future<void> showinfoDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: const Text('Info'),
            content: ListBody(
              children: const [
                Center(
                  child: Icon(Icons.warning),
                ),
                Text('Please Verify Your Email')
              ],
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Dismiss'))
            ],
          );
        });
  }

  showConfirmationDialog(String title, String content, BuildContext context,
      List<Widget> actions) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text(title),
            content: Text(content),
            actions: actions,
          );
        });
  }

  showPlacedOrderDialog(BuildContext context, String error) {
    AwesomeDialog(
      context: context,
      title: error.isEmpty ? 'Sucess' : 'Failed',
      dialogType: error.isEmpty ? DialogType.SUCCES : DialogType.ERROR,
      desc: error.isEmpty ? 'Thank You for your order' : error.toString(),
      dismissOnTouchOutside: true,
      dismissOnBackKeyPress: true,
      autoHide: const Duration(seconds: 3),
      dialogBorderRadius: BorderRadius.circular(10),
      headerAnimationLoop: true,
      animType: AnimType.BOTTOMSLIDE,
    ).show();
  }

  showConformAddressDialog(BuildContext context) async {
    Utils _utils = Utils();
    String error = "";
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Select a address'),
            content: StreamBuilder(
              stream: _utils.userAddressData().snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: SizedBox(
                    height: 100,
                    child: Column(
                      children: const [
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Loading Address...')
                      ],
                    ),
                  ));
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                        "Somethig went wrong: ${snapshot.error.toString()}"),
                  );
                }
                if (snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(),
                        ),
                        const Text('No Address found \nPlease add address'),
                        ElevatedButton(
                            onPressed: (() {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          const UpdateProfile())));
                            }),
                            child: const Text('Add')),
                        Expanded(
                          child: Container(),
                        ),
                      ],
                    ),
                  );
                }
                return SingleChildScrollView(
                  child: Column(
                    children: snapshot.data!.docs.map(((e) {
                      Map<String, dynamic> addressData =
                          e.data() as Map<String, dynamic>;
                      return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: SelectableCard(
                          data: addressData,
                          opTap: () async {
                            await Future.delayed(
                                const Duration(milliseconds: 200));
                            Navigator.pop(context);
                            bool isAddressAvailable = await FirebaseFirestore
                                .instance
                                .collection('users')
                                .doc(auth.currentUser!.uid)
                                .collection('address')
                                .get()
                                .then(((value) {
                              return value.docs.first.exists;
                            }));
                            alert.loadingDialog(context, 'Placing Order');
                            // This code will check whether the user has uploaded his address or not
                            if (isAddressAvailable) {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(auth.currentUser!.uid)
                                  .collection('cart')
                                  .doc('foods')
                                  .collection('items')
                                  .get()
                                  .then((QuerySnapshot snapshot) async {
                                for (var element in snapshot.docs) {
                                  Map<String, dynamic> cartData =
                                      element.data()! as Map<String, dynamic>;
                                  placeOrder(
                                          context, cartData, addressData['PIN'])
                                      .catchError((trace) => error = trace);
                                  addToSale(context, addressData)
                                      .catchError((trace) => error = trace);
                                }
                                Navigator.pop(context);
                                alert.showPlacedOrderDialog(context, error);
                              });
                            } else {
                              Navigator.pop(context);
                              showSnackBar(context, 'Please add address first');
                            }
                          },
                        ),
                      );
                    })).toList(),
                  ),
                );
              },
            ),
          );
        });
  }

  showRatingDialog(BuildContext context, double rating, String foodID) {
    double ratingValue = 0.0;
    Utils _utils = Utils();
    TextEditingController feedback = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Feedback'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  RatingBar.builder(
                    itemBuilder: ((context, index) {
                      return const Icon(
                        Icons.favorite,
                        color: Colors.orange,
                      );
                    }),
                    onRatingUpdate: (rating) {
                      ratingValue = rating;
                    },
                    initialRating: rating,
                    updateOnDrag: true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                      height: 100,
                      child: TextFormField(
                        controller: feedback,
                        decoration: InputDecoration(
                            hintText: 'Write you Feedback here',
                            border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(10))),
                      ))
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: (() {
                    Navigator.pop(context);
                  }),
                  child: const Text('Cancel')),
              TextButton(
                onPressed: (() {
                  Navigator.pop(context);
                  _utils.sendFeedBack(
                      foodID, feedback.text, context, ratingValue);
                }),
                child: const Text('Send'),
              )
            ],
          );
        });
  }

  showSignInDialog(BuildContext context) async {
    TextEditingController _email = TextEditingController();
    TextEditingController _password = TextEditingController();
    ShowAlert alert = ShowAlert();
    final form = GlobalKey<FormState>();
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("You haven't signed in, Please sign in"),
            content: SingleChildScrollView(
              child: Form(
                key: form,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _email,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        hintText: 'Email',
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1.2)),
                      ),
											validator: (value) {
												if (value!.isEmpty) {
													return 'Please Enter Email';
												}
												return  null;
											},
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.password),
                        hintText: 'Password',
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1.2)),
                      ),
                      controller: _password,
											validator: (value){
												if (value!.isEmpty) {
													return 'Please Enter password';
												}
												return null;
											},
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton.icon(
                        onPressed: (() async {
                          if (form.currentState!.validate()) {
                            alert.loadingDialog(context, 'Signnig in');
                            await signInWithEmailPassword(
                                    context, _email.text, _password.text)
                                .then((value) => showSnackBar(
                                    context, 'Sign in Sucessfully'))
                                .then((value) => Navigator.pop(context))
                                .catchError((error) =>
                                    showSnackBar(context, error.toString()));
                          }
                        }),
                        icon: const Icon(Icons.login),
                        label: const Text('Sign in'))
                  ],
                ),
              ),
            ),
          );
        });
  }
}
