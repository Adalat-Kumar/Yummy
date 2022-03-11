// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yummy/API/firebase_api.dart';
import 'package:yummy/screens/cart.dart';
import 'package:yummy/screens/gift_card.dart';
import 'package:yummy/screens/orders.dart';
import 'package:yummy/screens/update_profile.dart';
import 'package:yummy/widgets/alert_dialog.dart';
import 'package:yummy/widgets/custom_options.dart';

class Profile extends StatefulWidget {
  final goTologin;
  const Profile({Key? key, this.goTologin}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

// ignore: non_constant_identifier_names
String? name;
ShowAlert alert = ShowAlert();
var photoURL = '';

class _ProfileState extends State<Profile> {
  Future<void> showLogOutDialog() async {
    return showDialog<void>(
      context: context,
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
              onPressed: () async {
                await signOutGoogle(context)
                    .then((value) => widget.goTologin(2));
                Navigator.pop(context);
              },
              child: const Text('Logout'),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Colors.orange[900]!,
                Colors.orange[600]!,
                Colors.orange[400]!
              ],
            )),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(
                height: 80,
              ),
              Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: 100,
                          width: 100,
                          child: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                                auth.currentUser!.photoURL.toString()),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Welcome ${auth.currentUser!.displayName} ',
                        style:
                            const TextStyle(fontSize: 25, color: Colors.white),
                      )
                    ],
                  )),
              const SizedBox(
                height: 40,
              ),
              Expanded(
                  child: Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30)),
                          color: Colors.white),
                      child: SingleChildScrollView(
                          child: Padding(
                              padding: const EdgeInsets.all(30),
                              child: Column(children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      CustomOptions(
                                        icon: Icons.shopping_cart,
                                        title: 'My Cart',
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const Cart()));
                                        },
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      CustomOptions(
                                          icon: Icons.fastfood,
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: ((context) =>
                                                        const Orders())));
                                          },
                                          title: 'My Orders'),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      CustomOptions(
                                          icon: Icons.wallet_giftcard,
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: ((context) =>
                                                        const GiftCard())));
                                          },
                                          title: 'My Gift Card'),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      CustomOptions(
                                          icon: Icons.settings,
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: ((context) =>
                                                        const UpdateProfile())));
                                          },
                                          title: 'Setting'),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      CustomOptions(
                                          icon: Icons.info,
                                          onTap: () {
                                            showAboutDialog(
                                              context: context,
                                              applicationName: 'Yummy',
                                              applicationVersion: '1.0',
                                              applicationLegalese:
                                                  'Yummy food ordering app',
                                            );
                                          },
                                          title: 'About us'),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      CustomOptions(
                                          icon: Icons.logout,
                                          onTap: () {
                                            showLogOutDialog();
                                          },
                                          title: 'Log out'),
                                    ]),
                              ])))))
            ])));
  }
}
